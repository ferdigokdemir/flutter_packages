import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'config.dart';
import 'models.dart';

/// Main singleton for EasySocialShare
class EasySocialShare {
  static final EasySocialShare _instance = EasySocialShare._internal();
  static EasySocialShare get instance => _instance;

  EasySocialShare._internal();

  /// Configuration
  EasySocialShareConfig? _config;

  /// Screenshot controller
  final ScreenshotController _screenshotController = ScreenshotController();

  /// Is initialized
  bool get isInitialized => _config != null;

  /// Initialize the package
  void initialize(EasySocialShareConfig config) {
    _config = config;
    developer.log(
      'EasySocialShare initialized',
      name: 'EasySocialShare',
    );
  }

  /// Get current configuration
  EasySocialShareConfig get config {
    if (_config == null) {
      throw StateError(
          'EasySocialShare is not initialized. Call initialize() first.');
    }
    return _config!;
  }

  /// Capture widget as image and share
  Future<EasySocialShareResult> shareWidget({
    required Widget widget,
    String? content,
    Rect? sharePositionOrigin,
    double pixelRatio = 3.0,
  }) async {
    try {
      // Capture screenshot
      final imageBytes = await _screenshotController.captureFromWidget(
        widget,
        pixelRatio: pixelRatio,
      );

      // Save to temp file
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${tempDir.path}/share_$timestamp.png';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      developer.log(
        'Widget captured as image',
        name: 'EasySocialShare',
        error: {'path': filePath, 'size': imageBytes.length},
      );

      // Share - only pass text if it's not empty
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(filePath)],
          text: content?.isNotEmpty == true ? content : null,
          sharePositionOrigin: sharePositionOrigin,
        ),
      );

      // Cleanup
      try {
        await file.delete();
      } catch (_) {}

      final shareResult = EasySocialShareResult(
        success: result.status == ShareResultStatus.success,
        filePath: filePath,
        timestamp: DateTime.now(),
        metadata: {
          'status': result.status.name,
          'raw': result.raw,
          'image_size': imageBytes.length,
        },
      );

      return shareResult;
    } catch (e, stackTrace) {
      final error = ShareError(
        message: 'Failed to share widget: $e',
        type: ShareErrorType.imageGenerationFailed,
        originalError: e,
        stackTrace: stackTrace,
      );
      _handleError(error);
      rethrow;
    }
  }

  /// Handle error
  void _handleError(ShareError error) {
    developer.log(
      error.message,
      name: 'EasySocialShare',
      error: error.originalError,
      stackTrace: error.stackTrace,
    );

    config.onError?.call(error);
  }

  /// Reset singleton (for testing)
  @visibleForTesting
  void reset() {
    _config = null;
  }
}
