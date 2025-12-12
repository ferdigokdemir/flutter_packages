import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:retry/retry.dart';
import 'ad_pool.dart';
import 'config.dart';
import 'models.dart';

class EasyAdsService {
  EasyAdsService(this.config) {
    _interstitialPool = AdPool<InterstitialAd>(
      type: AdType.interstitial,
      maxSize: config.interstitialPoolSize,
      loadAd: _loadInterstitialAd,
    );
    _rewardedPool = AdPool<RewardedAd>(
      type: AdType.rewarded,
      maxSize: config.rewardedPoolSize,
      loadAd: _loadRewardedAd,
    );
    _rewardedInterstitialPool = AdPool<RewardedInterstitialAd>(
      type: AdType.rewardedInterstitial,
      maxSize: config.rewardedInterstitialPoolSize,
      loadAd: _loadRewardedInterstitialAd,
    );
  }

  final EasyAdsConfig config;

  static bool _isInitialized = false;
  static bool _isLoadingInterstitial = false;
  static bool _isLoadingRewarded = false;
  static bool _isLoadingRewardedInterstitial = false;
  static bool _isLoadingAppOpen = false;

  late final AdPool<InterstitialAd> _interstitialPool;
  late final AdPool<RewardedAd> _rewardedPool;
  late final AdPool<RewardedInterstitialAd> _rewardedInterstitialPool;

  Future<void> initialize() async {
    if (_isInitialized) return;
    await MobileAds.instance.initialize();
    _isInitialized = true;
  }

  Future<void> warmUp() async {
    if (!config.adsEnabled) return;
    if (!_isInitialized) await initialize();
    await Future.wait([
      _interstitialPool.refill(),
      _rewardedPool.refill(),
      _rewardedInterstitialPool.refill(),
    ]);
  }

  void showAd(AdType type, {required AdResultCallback onResult}) {
    switch (type) {
      case AdType.interstitial:
        _showInterstitialInternal(onResult);
        break;
      case AdType.rewarded:
        _showRewardedInternal(onResult);
        break;
      case AdType.rewardedInterstitial:
        _showRewardedInterstitialInternal(onResult);
        break;
      case AdType.appOpen:
        _showAppOpenInternal(onResult);
        break;
    }
  }

  void _showInterstitialInternal(AdResultCallback onResult) async {
    if (!config.adsEnabled || !_isInitialized) {
      onResult(const AdResponse(
        type: AdType.interstitial,
        status: AdStatus.error,
        shown: false,
        dismissed: false,
        error: 'Service disabled',
        errorCode: AdErrorCode.serviceDisabled,
      ));
      return;
    }
    if (_isLoadingInterstitial) {
      onResult(const AdResponse(
        type: AdType.interstitial,
        status: AdStatus.error,
        shown: false,
        dismissed: false,
        error: 'Already loading',
        errorCode: AdErrorCode.alreadyLoading,
      ));
      return;
    }

    _isLoadingInterstitial = true;
    try {
      final ad = _interstitialPool.getAd() ?? await _loadInterstitialAd();
      if (ad == null) {
        _isLoadingInterstitial = false;
        onResult(const AdResponse(
          type: AdType.interstitial,
          status: AdStatus.error,
          shown: false,
          dismissed: false,
          error: 'Failed to load',
          errorCode: AdErrorCode.loadFailed,
        ));
        return;
      }

      var wasShown = false;

      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          wasShown = true;
        },
        onAdDismissedFullScreenContent: (ad) async {
          await ad.dispose();
          _isLoadingInterstitial = false;
          onResult(AdResponse(
            type: AdType.interstitial,
            status: AdStatus.success,
            shown: wasShown,
            dismissed: true,
          ));
        },
        onAdFailedToShowFullScreenContent: (ad, error) async {
          await ad.dispose();
          _isLoadingInterstitial = false;
          onResult(AdResponse(
            type: AdType.interstitial,
            status: AdStatus.error,
            shown: false,
            dismissed: false,
            error: error.toString(),
            errorCode: AdErrorCode.showFailed,
          ));
        },
      );

      ad.show();
    } catch (e) {
      _isLoadingInterstitial = false;
      onResult(AdResponse(
        type: AdType.interstitial,
        status: AdStatus.error,
        shown: false,
        dismissed: false,
        error: e.toString(),
        errorCode: AdErrorCode.showFailed,
      ));
    }
  }

  void _showRewardedInternal(AdResultCallback onResult) async {
    if (!config.adsEnabled || !_isInitialized) {
      onResult(const AdResponse(
        type: AdType.rewarded,
        status: AdStatus.error,
        shown: false,
        dismissed: false,
        error: 'Service disabled',
        errorCode: AdErrorCode.serviceDisabled,
      ));
      return;
    }
    if (_isLoadingRewarded) {
      onResult(const AdResponse(
        type: AdType.rewarded,
        status: AdStatus.error,
        shown: false,
        dismissed: false,
        error: 'Already loading',
        errorCode: AdErrorCode.alreadyLoading,
      ));
      return;
    }

    _isLoadingRewarded = true;
    try {
      final ad = _rewardedPool.getAd() ?? await _loadRewardedAd();
      if (ad == null) {
        _isLoadingRewarded = false;
        onResult(const AdResponse(
          type: AdType.rewarded,
          status: AdStatus.error,
          shown: false,
          dismissed: false,
          error: 'Failed to load',
          errorCode: AdErrorCode.loadFailed,
        ));
        return;
      }

      var wasShown = false;
      RewardItem? earned;

      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          wasShown = true;
        },
        onAdDismissedFullScreenContent: (ad) async {
          await ad.dispose();
          _isLoadingRewarded = false;
          // Sadece ödül alındıysa success döndür
          onResult(AdResponse(
            type: AdType.rewarded,
            status: earned != null ? AdStatus.success : AdStatus.error,
            shown: wasShown,
            dismissed: true,
            reward: earned,
            error: earned == null ? 'Reward not earned' : null,
            errorCode: earned == null ? AdErrorCode.showFailed : null,
          ));
        },
        onAdFailedToShowFullScreenContent: (ad, error) async {
          await ad.dispose();
          _isLoadingRewarded = false;
          onResult(AdResponse(
            type: AdType.rewarded,
            status: AdStatus.error,
            shown: false,
            dismissed: false,
            error: error.toString(),
            errorCode: AdErrorCode.showFailed,
          ));
        },
      );

      ad.show(onUserEarnedReward: (ad, reward) {
        earned = reward;
      });
    } catch (e) {
      _isLoadingRewarded = false;
      onResult(AdResponse(
        type: AdType.rewarded,
        status: AdStatus.error,
        shown: false,
        dismissed: false,
        error: e.toString(),
        errorCode: AdErrorCode.showFailed,
      ));
    }
  }

  void _showRewardedInterstitialInternal(AdResultCallback onResult) async {
    if (!config.adsEnabled || !_isInitialized) {
      onResult(const AdResponse(
        type: AdType.rewardedInterstitial,
        status: AdStatus.error,
        shown: false,
        dismissed: false,
        error: 'Service disabled',
        errorCode: AdErrorCode.serviceDisabled,
      ));
      return;
    }
    if (_isLoadingRewardedInterstitial) {
      onResult(const AdResponse(
        type: AdType.rewardedInterstitial,
        status: AdStatus.error,
        shown: false,
        dismissed: false,
        error: 'Already loading',
        errorCode: AdErrorCode.alreadyLoading,
      ));
      return;
    }

    _isLoadingRewardedInterstitial = true;
    try {
      final ad = _rewardedInterstitialPool.getAd() ??
          await _loadRewardedInterstitialAd();
      if (ad == null) {
        _isLoadingRewardedInterstitial = false;
        onResult(const AdResponse(
          type: AdType.rewardedInterstitial,
          status: AdStatus.error,
          shown: false,
          dismissed: false,
          error: 'Failed to load',
          errorCode: AdErrorCode.loadFailed,
        ));
        return;
      }

      var wasShown = false;
      RewardItem? earned;

      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          wasShown = true;
        },
        onAdDismissedFullScreenContent: (ad) async {
          await ad.dispose();
          _isLoadingRewardedInterstitial = false;
          // Sadece ödül alındıysa success döndür
          onResult(AdResponse(
            type: AdType.rewardedInterstitial,
            status: earned != null ? AdStatus.success : AdStatus.error,
            shown: wasShown,
            dismissed: true,
            reward: earned,
            error: earned == null ? 'Reward not earned' : null,
            errorCode: earned == null ? AdErrorCode.showFailed : null,
          ));
        },
        onAdFailedToShowFullScreenContent: (ad, error) async {
          await ad.dispose();
          _isLoadingRewardedInterstitial = false;
          onResult(AdResponse(
            type: AdType.rewardedInterstitial,
            status: AdStatus.error,
            shown: false,
            dismissed: false,
            error: error.toString(),
            errorCode: AdErrorCode.showFailed,
          ));
        },
      );

      ad.show(onUserEarnedReward: (ad, reward) {
        earned = reward;
      });
    } catch (e) {
      _isLoadingRewardedInterstitial = false;
      onResult(AdResponse(
        type: AdType.rewardedInterstitial,
        status: AdStatus.error,
        shown: false,
        dismissed: false,
        error: e.toString(),
        errorCode: AdErrorCode.showFailed,
      ));
    }
  }

  void _showAppOpenInternal(AdResultCallback onResult) async {
    if (!config.adsEnabled || !_isInitialized) {
      onResult(const AdResponse(
        type: AdType.appOpen,
        status: AdStatus.error,
        shown: false,
        dismissed: false,
        error: 'Service disabled',
        errorCode: AdErrorCode.serviceDisabled,
      ));
      return;
    }
    if (_isLoadingAppOpen) {
      onResult(const AdResponse(
        type: AdType.appOpen,
        status: AdStatus.error,
        shown: false,
        dismissed: false,
        error: 'Already loading',
        errorCode: AdErrorCode.alreadyLoading,
      ));
      return;
    }

    _isLoadingAppOpen = true;
    try {
      final ad = await _loadAppOpenAd();
      if (ad == null) {
        _isLoadingAppOpen = false;
        onResult(const AdResponse(
          type: AdType.appOpen,
          status: AdStatus.error,
          shown: false,
          dismissed: false,
          error: 'Failed to load',
          errorCode: AdErrorCode.loadFailed,
        ));
        return;
      }

      var wasShown = false;

      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          wasShown = true;
        },
        onAdDismissedFullScreenContent: (ad) async {
          await ad.dispose();
          _isLoadingAppOpen = false;
          onResult(AdResponse(
            type: AdType.appOpen,
            status: AdStatus.success,
            shown: wasShown,
            dismissed: true,
          ));
        },
        onAdFailedToShowFullScreenContent: (ad, error) async {
          await ad.dispose();
          _isLoadingAppOpen = false;
          onResult(AdResponse(
            type: AdType.appOpen,
            status: AdStatus.error,
            shown: false,
            dismissed: false,
            error: error.toString(),
            errorCode: AdErrorCode.showFailed,
          ));
        },
      );

      ad.show();
    } catch (e) {
      _isLoadingAppOpen = false;
      onResult(AdResponse(
        type: AdType.appOpen,
        status: AdStatus.error,
        shown: false,
        dismissed: false,
        error: e.toString(),
        errorCode: AdErrorCode.showFailed,
      ));
    }
  }

  Future<InterstitialAd?> _loadInterstitialAd() async {
    try {
      return await retry(
        () async {
          final completer = Completer<InterstitialAd?>();

          InterstitialAd.load(
            adUnitId: config.interstitialAdUnitId,
            request: const AdRequest(),
            adLoadCallback: InterstitialAdLoadCallback(
              onAdLoaded: (ad) => completer.complete(ad),
              onAdFailedToLoad: (error) => completer.completeError(error),
            ),
          );

          return await completer.future;
        },
        retryIf: (e) => true,
        maxAttempts: config.maxRetryAttempts,
      ).timeout(
        Duration(seconds: config.adLoadTimeoutSeconds),
        onTimeout: () => null,
      );
    } catch (e) {
      return null;
    }
  }

  Future<RewardedAd?> _loadRewardedAd() async {
    try {
      return await retry(
        () async {
          final completer = Completer<RewardedAd?>();

          RewardedAd.load(
            adUnitId: config.rewardedAdUnitId,
            request: const AdRequest(),
            rewardedAdLoadCallback: RewardedAdLoadCallback(
              onAdLoaded: (ad) => completer.complete(ad),
              onAdFailedToLoad: (error) => completer.completeError(error),
            ),
          );

          return await completer.future;
        },
        retryIf: (e) => true,
        maxAttempts: config.maxRetryAttempts,
      ).timeout(
        Duration(seconds: config.adLoadTimeoutSeconds),
        onTimeout: () => null,
      );
    } catch (e) {
      return null;
    }
  }

  Future<RewardedInterstitialAd?> _loadRewardedInterstitialAd() async {
    try {
      return await retry(
        () async {
          final completer = Completer<RewardedInterstitialAd?>();

          RewardedInterstitialAd.load(
            adUnitId: config.rewardedInterstitialAdUnitId,
            request: const AdRequest(),
            rewardedInterstitialAdLoadCallback:
                RewardedInterstitialAdLoadCallback(
              onAdLoaded: (ad) => completer.complete(ad),
              onAdFailedToLoad: (error) => completer.completeError(error),
            ),
          );

          return await completer.future;
        },
        retryIf: (e) => true,
        maxAttempts: config.maxRetryAttempts,
      ).timeout(
        Duration(seconds: config.adLoadTimeoutSeconds),
        onTimeout: () => null,
      );
    } catch (e) {
      return null;
    }
  }

  Future<AppOpenAd?> _loadAppOpenAd() async {
    try {
      return await retry(
        () async {
          final completer = Completer<AppOpenAd?>();

          AppOpenAd.load(
            adUnitId: config.appOpenAdUnitId,
            request: const AdRequest(),
            adLoadCallback: AppOpenAdLoadCallback(
              onAdLoaded: (ad) => completer.complete(ad),
              onAdFailedToLoad: (error) => completer.completeError(error),
            ),
          );

          return await completer.future;
        },
        retryIf: (e) => true,
        maxAttempts: config.maxRetryAttempts,
      ).timeout(
        Duration(seconds: config.adLoadTimeoutSeconds),
        onTimeout: () => null,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> applyRequestConfiguration() async {
    final configuration = RequestConfiguration(
      testDeviceIds: config.testDeviceIds,
      maxAdContentRating: MaxAdContentRating.pg,
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.no,
      tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.no,
    );
    await MobileAds.instance.updateRequestConfiguration(configuration);
  }

  /// Shows the consent form for GDPR/privacy compliance
  /// This method loads and displays the user consent form if needed
  Future<void> showConsentForm() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Request consent information update
      final params = ConsentRequestParameters();
      final info = ConsentInformation.instance;

      info.requestConsentInfoUpdate(
        params,
        () async {
          // Consent info updated successfully
          if (await info.isConsentFormAvailable()) {
            // Load and show the consent form
            ConsentForm.loadAndShowConsentFormIfRequired((loadError) {
              if (loadError != null) {
                debugPrint('Consent form load error: $loadError');
              }
            });
          }
        },
        (error) {
          // Error updating consent info
          debugPrint('Consent info update error: $error');
        },
      );
    } catch (e) {
      // Silently fail - consent form is optional and shouldn't block app
      debugPrint('Consent form error: $e');
    }
  }
}
