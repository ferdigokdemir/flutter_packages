import 'dart:async';

import 'package:flutter/widgets.dart';

import 'config.dart';
import 'easy_ads_service.dart';
import 'models.dart';

class EasyAds with WidgetsBindingObserver {
  EasyAds._internal();

  static final EasyAds _instance = EasyAds._internal();
  static EasyAds get instance => _instance;

  EasyAdsService? _service;
  EasyAdsConfig? _config;
  Timer? _warmUpTimer;

  static bool get isConfigured => instance._service != null;

  static Future<void> configure(EasyAdsConfig config) async {
    instance._config = config;
    instance._service = EasyAdsService(config);
    await instance._service!.initialize();

    // App lifecycle observer'ı başlat
    WidgetsBinding.instance.addObserver(instance);
  }

  static void startPeriodicWarmUp() {
    final config = instance._config;
    if (config == null || config.warmUpInterval == null) return;

    instance._warmUpTimer?.cancel();
    instance._warmUpTimer = Timer.periodic(
      config.warmUpInterval!,
      (_) async {
        try {
          print('EasyAds: Performing periodic warm-up.');
          await warmUp();
        } catch (_) {
          // Silent fail
        }
      },
    );
  }

  static void stopPeriodicWarmUp() {
    instance._warmUpTimer?.cancel();
    instance._warmUpTimer = null;
  }

  static EasyAdsConfig? get config => instance._config;

  static Future<void> applyRequestConfiguration() async {
    if (instance._service == null && instance._config != null) {
      // Lazy configure if not configured yet
      await configure(instance._config!);
    }
    await instance._service?.applyRequestConfiguration();
  }

  static Future<void> warmUp() async {
    await instance._service?.warmUp();
  }

  static void showAd(AdType type, {required AdResultCallback onResult}) {
    if (instance._service == null) {
      throw StateError(
          'EasyAds is not configured. Call EasyAds.configure(...) first.');
    }
    instance._service!.showAd(type, onResult: onResult);
  }

  static Future<void> showConsentForm() async {
    if (instance._service == null) {
      throw StateError(
          'EasyAds is not configured. Call EasyAds.configure(...) first.');
    }
    await instance._service!.showConsentForm();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Background'dan dönüşte fresh reklam yükle
      warmUp();
    }
  }

  /// Lifecycle observer'ı temizle
  static void dispose() {
    stopPeriodicWarmUp();
    WidgetsBinding.instance.removeObserver(instance);
  }
}
