import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/easy_update_localizations.dart';
import '../models/version_check_status.dart';
import 'version_check_service.dart';

/// 🎯 EasyUpdate Singleton Service
///
/// Version check ve dialog yönetimini merkezi olarak yönetir.
///
/// **Kullanım:**
/// ```dart
/// // 1️⃣ Başlangıçta init et
/// await EasyUpdate.instance.init(
///   android: EasyUpdatePlatformConfig(
///     version: '2.0.0',
///     storeUrl: 'https://play.google.com/store/apps/details?id=...',
///     force: true,
///     locale: 'tr',
///   ),
///   ios: EasyUpdatePlatformConfig(
///     version: '2.1.0',
///     storeUrl: 'https://apps.apple.com/app/...',
///     force: false,
///     locale: 'en',
///   ),
/// );
///
/// // 2️⃣ Status kontrol et
/// final status = await EasyUpdate.instance.check();
///
/// // 3️⃣ Dialog göster (gerekiyorsa)
/// if (status.updateRequired) {
///   await EasyUpdate.instance.showUpdateDialog(context);
/// }
/// ```
class EasyUpdate {
  static final EasyUpdate _instance = EasyUpdate._internal();

  late VersionCheckService _service;
  VersionCheckStatus? _lastStatus;
  EasyUpdatePlatformConfig? _currentConfig;
  String _locale = 'en';

  EasyUpdate._internal();

  static EasyUpdate get instance => _instance;

  /// Mevcut locale
  String get locale => _locale;

  /// Locale'i değiştir
  set locale(String value) {
    if (EasyUpdateLocalizations.supportedLocales.contains(
      value.toLowerCase(),
    )) {
      _locale = value.toLowerCase();
    } else {
      _locale = EasyUpdateLocalizations.defaultLocale;
    }
  }

  /// 🔧 Servisi initialize et
  ///
  /// Platform bazlı konfigürasyonları alır.
  /// [android] - Android için EasyUpdatePlatformConfig
  /// [ios] - iOS için EasyUpdatePlatformConfig
  Future<void> init({
    EasyUpdatePlatformConfig? android,
    EasyUpdatePlatformConfig? ios,
  }) async {
    // Platforma göre config seç
    _currentConfig = _getPlatformConfig(android, ios);

    if (_currentConfig == null) {
      debugPrint('⚠️ [EasyUpdate] No config for current platform');
      return;
    }

    this.locale = _currentConfig!.locale;

    _service = VersionCheckService(
      version: _currentConfig!.version,
      force: _currentConfig!.force,
      storeUrl: _currentConfig!.storeUrl,
    );

    debugPrint(
      '✅ [EasyUpdate] Initialized: v${_currentConfig!.version} (force: ${_currentConfig!.force}, locale: $_locale)',
    );
  }

  /// Platforma göre config döndür
  EasyUpdatePlatformConfig? _getPlatformConfig(
    EasyUpdatePlatformConfig? android,
    EasyUpdatePlatformConfig? ios,
  ) {
    if (Platform.isAndroid) {
      return android;
    }
    if (Platform.isIOS) {
      return ios;
    }
    return null;
  }

  /// 🔍 Version check yap
  ///
  /// Status'u döndürür ve cache'e kaydeder.
  /// Eğer kullanıcı "Hatırlatma" skiplediyse, o sürümü check etmez.
  Future<VersionCheckStatus> check() async {
    if (_currentConfig == null) {
      debugPrint('⚠️ [EasyUpdate] Not initialized for current platform');
      return VersionCheckStatus(
        updateRequired: false,
        force: false,
        storeUrl: '',
        currentVersion: '0.0.0',
        version: '0.0.0',
      );
    }

    try {
      // SharedPreferences'ten skip edilen versiyonu al
      final prefs = await SharedPreferences.getInstance();
      final skippedVersion = prefs.getString('easy_update_skipped_version');

      _lastStatus = await _service.checkForUpdates();

      // Eğer kullanıcı bu versiyonu skip ettiyse, updateRequired = false yap
      if (skippedVersion == _lastStatus!.version) {
        debugPrint(
          '⏭️ [EasyUpdate] Version $skippedVersion skipped by user, hiding dialog',
        );
        _lastStatus = VersionCheckStatus(
          updateRequired: false,
          force: false,
          storeUrl: _lastStatus!.storeUrl,
          currentVersion: _lastStatus!.currentVersion,
          version: _lastStatus!.version,
        );
      }

      debugPrint('✅ [EasyUpdate] Check completed: $_lastStatus');
      return _lastStatus!;
    } catch (e) {
      debugPrint('❌ [EasyUpdate] Check error: $e');
      return VersionCheckStatus(
        updateRequired: false,
        force: false,
        storeUrl: '',
        currentVersion: '0.0.0',
        version: _currentConfig!.version,
      );
    }
  }

  /// 📱 Son status'u getir (cache'den)
  VersionCheckStatus? getLastStatus() => _lastStatus;

  /// ⚡ Tek adımda versiyon kontrolü yap ve gerekirse dialog göster.
  ///
  /// `init`, `check` ve `showUpdateDialog` adımlarını tek metotta birleştirir.
  ///
  /// **Kullanım:**
  /// ```dart
  /// await EasyUpdate.instance.run(
  ///   context,
  ///   android: EasyUpdatePlatformConfig(
  ///     version: '2.0.0',
  ///     storeUrl: 'https://play.google.com/store/apps/details?id=...',
  ///     force: true,
  ///     locale: 'tr',
  ///   ),
  ///   ios: EasyUpdatePlatformConfig(
  ///     version: '2.0.0',
  ///     storeUrl: 'https://apps.apple.com/app/id123456789',
  ///     force: true,
  ///     locale: 'tr',
  ///   ),
  /// );
  /// ```
  Future<void> run(
    BuildContext context, {
    EasyUpdatePlatformConfig? android,
    EasyUpdatePlatformConfig? ios,
  }) async {
    await init(android: android, ios: ios);
    final status = await check();
    if (status.updateRequired && context.mounted) {
      await showUpdateDialog(context);
    }
  }

  ///  Update dialog'unu göster
  ///
  /// Status'a göre zorunlu/opsiyonel update dialog'u gösterir.
  Future<void> showUpdateDialog(BuildContext context) async {
    final status = _lastStatus ?? await check();

    if (!status.updateRequired) {
      debugPrint('⚠️ [EasyUpdate] Update not required, skipping dialog');
      return;
    }

    if (!context.mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: status.force ? false : true,
      builder: (ctx) => _buildUpdateDialog(ctx, status),
    );
  }

  /// 🏗️ Update dialog widget'ını oluştur
  Widget _buildUpdateDialog(BuildContext context, VersionCheckStatus status) {
    final l10n = EasyUpdateLocalizations.of(_locale);

    return PopScope(
      canPop: !status.force,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          status.force ? l10n.updateRequired : l10n.updateAvailable,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.system_update, size: 48, color: Colors.blue),
              const SizedBox(height: 16),
              Text(
                status.force ? l10n.updateMessage : l10n.optionalUpdateMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () async {
                  final url = Uri.parse(status.storeUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(l10n.updateButton),
              ),

              if (!status.force)
                TextButton(
                  onPressed: () async {
                    // Bu sürümü hatırlatma - SharedPreferences'e kaydet
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString(
                      'easy_update_skipped_version',
                      status.version,
                    );
                    debugPrint(
                      '✅ [EasyUpdate] Version ${status.version} marked as skipped',
                    );
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    l10n.laterButton,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
