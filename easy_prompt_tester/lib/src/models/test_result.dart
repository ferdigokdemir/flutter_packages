import 'package:equatable/equatable.dart';
import 'ai_model.dart';

/// Represents the result of testing a prompt with a specific model
class TestResult extends Equatable {
  /// The AI model used for this test
  final AIModel model;

  /// The model's response (null if failed)
  final String? response;

  /// Error message if the test failed (null if successful)
  final String? error;

  /// Time taken to get the response
  final Duration duration;

  /// Number of input tokens used
  final int? inputTokens;

  /// Number of output tokens generated
  final int? outputTokens;

  /// Whether the test was successful
  bool get isSuccess => error == null && response != null;

  /// Estimated cost in USD
  double get estimatedCost {
    if (inputTokens == null || outputTokens == null) return 0.0;
    final inputCost = (inputTokens! / 1000) * model.inputCostPer1kTokens;
    final outputCost = (outputTokens! / 1000) * model.outputCostPer1kTokens;
    return inputCost + outputCost;
  }

  /// Creates a test result
  const TestResult({
    required this.model,
    this.response,
    this.error,
    required this.duration,
    this.inputTokens,
    this.outputTokens,
  });

  /// Creates a successful test result
  factory TestResult.success({
    required AIModel model,
    required String response,
    required Duration duration,
    int? inputTokens,
    int? outputTokens,
  }) =>
      TestResult(
        model: model,
        response: response,
        duration: duration,
        inputTokens: inputTokens,
        outputTokens: outputTokens,
      );

  /// Creates a failed test result
  factory TestResult.failure({
    required AIModel model,
    required String error,
    required Duration duration,
  }) =>
      TestResult(
        model: model,
        error: error,
        duration: duration,
      );

  @override
  List<Object?> get props =>
      [model, response, error, duration, inputTokens, outputTokens];

  /// Converts the test result to a Map
  Map<String, dynamic> toMap() => {
        'model': model.displayName,
        'modelId': model.id,
        'provider': model.provider.displayName,
        'isSuccess': isSuccess,
        'response': response,
        'error': error,
        'durationMs': duration.inMilliseconds,
        'inputTokens': inputTokens,
        'outputTokens': outputTokens,
        'estimatedCostUsd': estimatedCost,
      };
}
