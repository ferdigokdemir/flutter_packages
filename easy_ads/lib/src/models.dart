import 'package:google_mobile_ads/google_mobile_ads.dart';

enum AdType { interstitial, rewarded, rewardedInterstitial, appOpen }

enum AdStatus { success, error }

/// Callback type for ad result
typedef AdResultCallback = void Function(AdResponse response);

enum AdErrorCode {
  serviceDisabled,
  alreadyLoading,
  loadTimeout,
  showTimeout,
  loadFailed,
  showFailed,
}

class AdResponse {
  final AdType type;
  final AdStatus status;
  final bool shown;
  final bool dismissed;
  final String? error;
  final AdErrorCode? errorCode;
  final RewardItem? reward;

  const AdResponse({
    required this.type,
    required this.status,
    required this.shown,
    required this.dismissed,
    this.error,
    this.errorCode,
    this.reward,
  });

  bool get isSuccess => status == AdStatus.success;

  @override
  String toString() =>
      'AdResponse(type: $type, status: $status, shown: $shown, dismissed: $dismissed, error: $error, errorCode: $errorCode, reward: $reward)';
}
