import 'models.dart';

/// Main configuration for EasySocialShare
class EasySocialShareConfig {
  /// Error callback
  final Function(ShareError)? onError;

  EasySocialShareConfig({
    this.onError,
  });
}
