import 'package:equatable/equatable.dart';
import 'prompt_model.dart';
import 'test_result.dart';

/// Represents a complete test report for a prompt across multiple models
class TestReport extends Equatable {
  /// The prompt that was tested
  final Prompt prompt;

  /// List of results for each model
  final List<TestResult> results;

  /// When the test was started
  final DateTime startedAt;

  /// When the test was completed
  final DateTime completedAt;

  /// Creates a test report
  const TestReport({
    required this.prompt,
    required this.results,
    required this.startedAt,
    required this.completedAt,
  });

  /// Total duration of all tests
  Duration get totalDuration => completedAt.difference(startedAt);

  /// Number of successful tests
  int get successCount => results.where((r) => r.isSuccess).length;

  /// Number of failed tests
  int get failureCount => results.where((r) => !r.isSuccess).length;

  /// Total number of tests
  int get totalCount => results.length;

  /// Success rate as a percentage (0-100)
  double get successRate =>
      totalCount > 0 ? (successCount / totalCount) * 100 : 0;

  /// Average response duration for successful tests
  Duration get averageDuration {
    final successfulResults = results.where((r) => r.isSuccess).toList();
    if (successfulResults.isEmpty) return Duration.zero;
    final totalMs = successfulResults.fold<int>(
      0,
      (sum, r) => sum + r.duration.inMilliseconds,
    );
    return Duration(milliseconds: totalMs ~/ successfulResults.length);
  }

  /// Total estimated cost in USD
  double get totalEstimatedCost => results.fold<double>(
        0.0,
        (sum, r) => sum + r.estimatedCost,
      );

  /// Fastest successful result
  TestResult? get fastestResult {
    final successfulResults = results.where((r) => r.isSuccess).toList();
    if (successfulResults.isEmpty) return null;
    return successfulResults.reduce(
      (a, b) => a.duration < b.duration ? a : b,
    );
  }

  /// Slowest successful result
  TestResult? get slowestResult {
    final successfulResults = results.where((r) => r.isSuccess).toList();
    if (successfulResults.isEmpty) return null;
    return successfulResults.reduce(
      (a, b) => a.duration > b.duration ? a : b,
    );
  }

  @override
  List<Object?> get props => [prompt, results, startedAt, completedAt];

  /// Converts the report to a Map
  Map<String, dynamic> toMap() => {
        'prompt': {
          'systemPrompt': prompt.systemPrompt,
          'userPrompt': prompt.userPrompt,
        },
        'startedAt': startedAt.toIso8601String(),
        'completedAt': completedAt.toIso8601String(),
        'totalDurationMs': totalDuration.inMilliseconds,
        'successCount': successCount,
        'failureCount': failureCount,
        'successRate': successRate,
        'averageDurationMs': averageDuration.inMilliseconds,
        'totalEstimatedCostUsd': totalEstimatedCost,
        'results': results.map((r) => r.toMap()).toList(),
      };

  /// Generates a summary string
  String get summary => '''
═══════════════════════════════════════════════════════
                    TEST REPORT SUMMARY
═══════════════════════════════════════════════════════
Prompt: "${prompt.userPrompt.length > 50 ? '${prompt.userPrompt.substring(0, 50)}...' : prompt.userPrompt}"
───────────────────────────────────────────────────────
Total Models Tested: $totalCount
✅ Successful: $successCount
❌ Failed: $failureCount
📊 Success Rate: ${successRate.toStringAsFixed(1)}%
───────────────────────────────────────────────────────
⏱️  Total Duration: ${totalDuration.inMilliseconds}ms
⏱️  Average Duration: ${averageDuration.inMilliseconds}ms
🚀 Fastest: ${fastestResult?.model.displayName ?? 'N/A'} (${fastestResult?.duration.inMilliseconds ?? 0}ms)
🐢 Slowest: ${slowestResult?.model.displayName ?? 'N/A'} (${slowestResult?.duration.inMilliseconds ?? 0}ms)
───────────────────────────────────────────────────────
💰 Total Estimated Cost: \$${totalEstimatedCost.toStringAsFixed(6)}
═══════════════════════════════════════════════════════
''';
}
