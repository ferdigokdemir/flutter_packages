import 'package:equatable/equatable.dart';

/// Represents a prompt to be tested
class Prompt extends Equatable {
  /// System prompt (instructions for the AI)
  final String? systemPrompt;

  /// User prompt (the actual question/task)
  final String userPrompt;

  /// Optional temperature setting (0.0 - 2.0)
  final double? temperature;

  /// Optional max tokens for the response
  final int? maxTokens;

  /// Creates a prompt
  const Prompt({
    this.systemPrompt,
    required this.userPrompt,
    this.temperature,
    this.maxTokens,
  });

  @override
  List<Object?> get props => [systemPrompt, userPrompt, temperature, maxTokens];
}
