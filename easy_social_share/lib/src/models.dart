/// Share error types
enum ShareErrorType {
  imageGenerationFailed,
  shareFailed,
  unknown,
}

/// Result of a share operation
class EasySocialShareResult {
  final bool success;
  final String? filePath;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  EasySocialShareResult({
    required this.success,
    this.filePath,
    required this.timestamp,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'filePath': filePath,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }
}

/// Share error information
class ShareError {
  final String message;
  final ShareErrorType type;
  final dynamic originalError;
  final StackTrace? stackTrace;

  ShareError({
    required this.message,
    required this.type,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'ShareError($type): $message';
  }
}
