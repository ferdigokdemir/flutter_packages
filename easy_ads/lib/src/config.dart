class EasyAdsConfig {
  final bool adsEnabled;
  final String interstitialAdUnitId;
  final String rewardedAdUnitId;
  final String appOpenAdUnitId;
  final String bannerAdUnitId;
  final List<String> testDeviceIds;
  final int adLoadTimeoutSeconds;
  final int showTimeoutSeconds;
  final int maxRetryAttempts;
  final int interstitialPoolSize;
  final int rewardedPoolSize;

  const EasyAdsConfig({
    required this.adsEnabled,
    required this.interstitialAdUnitId,
    required this.rewardedAdUnitId,
    required this.appOpenAdUnitId,
    required this.bannerAdUnitId,
    this.testDeviceIds = const <String>[],
    this.adLoadTimeoutSeconds = 10,
    this.showTimeoutSeconds = 15,
    this.maxRetryAttempts = 3,
    this.interstitialPoolSize = 3,
    this.rewardedPoolSize = 3,
  });
}
