import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dialogs/update_required_dialog.dart';
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

  /// SharedPreferences anahtarları
  static const String _remindCountKey = 'easy_update_remind_count';
  static const String _remindVersionKey = 'easy_update_remind_version';

  late VersionCheckService _service;
  VersionCheckStatus? _lastStatus;
  EasyUpdatePlatformConfig? _currentConfig;
  String _locale = 'en';

  /// "Daha Sonra Hatırlat" ertelemesi: kullanıcı butona bastıktan sonra
  /// opsiyonel güncelleme dialog'u kaç [check] çağrısı boyunca gizlenir.
  int _remindInterval = 3;

  EasyUpdate._internal();

  static EasyUpdate get instance => _instance;

  /// "Daha Sonra Hatırlat" erteleme aralığı (varsayılan 3 kontrol)
  int get remindInterval => _remindInterval;

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
    int remindInterval = 3,
  }) async {
    _remindInterval = remindInterval < 1 ? 1 : remindInterval;

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
  /// Kullanıcı opsiyonel güncellemede "Daha Sonra Hatırlat" dediyse, dialog
  /// sonraki [remindInterval] kontrol boyunca gizlenir; ardından tekrar gösterilir.
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
      final prefs = await SharedPreferences.getInstance();

      _lastStatus = await _service.checkForUpdates();

      // "Daha Sonra Hatırlat" ertelemesi yalnızca opsiyonel güncellemeler için
      if (_lastStatus!.updateRequired && !_lastStatus!.force) {
        final remindVersion = prefs.getString(_remindVersionKey);
        var remindCount = prefs.getInt(_remindCountKey) ?? 0;

        // Ertelenen sürüm ile mevcut sürüm farklıysa sayacı sıfırla
        // (yeni bir sürüm çıktıysa hemen gösterilmeli)
        if (remindVersion != _lastStatus!.version) {
          remindCount = 0;
          await prefs.remove(_remindCountKey);
          await prefs.remove(_remindVersionKey);
        }

        if (remindCount > 0) {
          // Erteleme aktif: bu kontrolü atla ve sayacı bir azalt
          await prefs.setInt(_remindCountKey, remindCount - 1);
          debugPrint(
            '⏭️ [EasyUpdate] Reminder snoozed, ${remindCount - 1} check(s) left',
          );
          _lastStatus = VersionCheckStatus(
            updateRequired: false,
            force: false,
            storeUrl: _lastStatus!.storeUrl,
            currentVersion: _lastStatus!.currentVersion,
            version: _lastStatus!.version,
          );
        }
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
    int? remindInterval,
    bool closeAppOnAndroidUpdate = true,
  }) async {
    // Yeni config verildiyse veya henüz init edilmediyse init et;
    // aksi halde startup'ta yapılan init korunur.
    if (android != null || ios != null || _currentConfig == null) {
      await init(
        android: android,
        ios: ios,
        remindInterval: remindInterval ?? _remindInterval,
      );
    } else if (remindInterval != null) {
      _remindInterval = remindInterval < 1 ? 1 : remindInterval;
    }

    final status = await check();
    if (status.updateRequired && context.mounted) {
      await showUpdateDialog(
        context,
        closeAppOnAndroidUpdate: closeAppOnAndroidUpdate,
      );
    }
  }

  ///  Update dialog'unu göster
  ///
  /// Status'a göre zorunlu/opsiyonel update dialog'u gösterir.
  /// "Daha Sonra Hatırlat" ertelemesi ve (Android'de) store'a yönlendirdikten
  /// sonra uygulamayı kapatma davranışı paket içinde yönetilir.
  Future<void> showUpdateDialog(
    BuildContext context, {
    bool closeAppOnAndroidUpdate = true,
  }) async {
    final status = _lastStatus ?? await check();

    if (!status.updateRequired) {
      debugPrint('⚠️ [EasyUpdate] Update not required, skipping dialog');
      return;
    }

    if (!context.mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: !status.force,
      builder: (ctx) => UpdateRequiredDialog(
        force: status.force,
        storeUrl: status.storeUrl,
        locale: _locale,
        // Store'a yönlendirdikten sonra Android'de uygulamayı kapat: eski proses
        // ölür, Play güncellemeyi temiz kurar ve kullanıcı tekrar açtığında
        // doğrudan yeni sürüm gelir (elle "force close" gerekmez).
        onUpdate: () {
          if (closeAppOnAndroidUpdate && Platform.isAndroid) {
            SystemNavigator.pop();
          }
        },
        // Opsiyonel güncellemede "Daha Sonra Hatırlat" → ertele.
        onLater: remindLater,
      ),
    );
  }

  /// ⏰ "Daha Sonra Hatırlat" ertelemesini kaydet.
  ///
  /// Opsiyonel güncelleme dialog'u sonraki [remindInterval] [check] çağrısı
  /// boyunca gizlenir, ardından tekrar gösterilir.
  Future<void> remindLater() async {
    final version = _lastStatus?.version ?? _currentConfig?.version;
    if (version == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_remindCountKey, _remindInterval);
    await prefs.setString(_remindVersionKey, version);
    debugPrint(
      '⏰ [EasyUpdate] Reminder snoozed for $_remindInterval check(s) (v$version)',
    );
  }
}
