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
///   version: '2.0.0',
///   force: true,
///   playStoreUrl: 'https://play.google.com/store/apps/details?id=...',
///   appStoreUrl: 'https://apps.apple.com/app/...',
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
  String _version = '0.0.0';
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
  /// RemoteConfig değerlerini iletilir.
  /// [playStoreUrl] - Play Store URL
  /// [appStoreUrl] - App Store URL
  /// [locale] - Dil kodu: tr, en, es, pt, de (varsayılan: en)
  Future<void> init({
    required String version,
    bool force = false,
    String? playStoreUrl,
    String? appStoreUrl,
    String locale = 'en',
  }) async {
    _version = version;
    this.locale = locale;

    _service = VersionCheckService(
      version: version,
      force: force,
      storeUrl: _getStoreUrl(playStoreUrl, appStoreUrl),
    );

    debugPrint(
      '✅ [EasyUpdate] Initialized: v$version (force: $force, locale: $_locale)',
    );
  }

  /// Platforma göre store URL döndür
  String _getStoreUrl(String? playStoreUrl, String? appStoreUrl) {
    if (Platform.isAndroid) {
      return playStoreUrl ?? '';
    }
    if (Platform.isIOS) {
      return appStoreUrl ?? '';
    }
    return '';
  }

  /// 🔍 Version check yap
  ///
  /// Status'u döndürür ve cache'e kaydeder.
  /// Eğer kullanıcı "Hatırlatma" skiplediyse, o sürümü check etmez.
  Future<VersionCheckStatus> check() async {
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
        version: _version,
      );
    }
  }

  /// 📱 Son status'u getir (cache'den)
  VersionCheckStatus? getLastStatus() => _lastStatus;

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
