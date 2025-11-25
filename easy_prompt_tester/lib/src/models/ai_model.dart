import 'package:equatable/equatable.dart';
import 'model_provider.dart';

/// Represents an AI model configuration
class AIModel extends Equatable {
  /// Unique identifier for the model (e.g., 'gpt-4o', 'claude-3-5-sonnet-20241022')
  final String id;

  /// Human-readable display name
  final String displayName;

  /// The provider of this model
  final ModelProvider provider;

  /// OpenRouter model ID (if different from id)
  final String? openRouterId;

  /// Cost per 1K input tokens in USD
  final double inputCostPer1kTokens;

  /// Cost per 1K output tokens in USD
  final double outputCostPer1kTokens;

  /// Maximum context length
  final int maxContextLength;

  /// Creates an AI model configuration
  const AIModel({
    required this.id,
    required this.displayName,
    required this.provider,
    this.openRouterId,
    this.inputCostPer1kTokens = 0.0,
    this.outputCostPer1kTokens = 0.0,
    this.maxContextLength = 4096,
  });

  // ============ OpenAI Models ============

  /// GPT-4o
  factory AIModel.gpt4o() => const AIModel(
        id: 'gpt-4o',
        displayName: 'GPT-4o',
        provider: ModelProvider.openAI,
        openRouterId: 'openai/gpt-4o',
        inputCostPer1kTokens: 0.005,
        outputCostPer1kTokens: 0.015,
        maxContextLength: 128000,
      );

  /// GPT-4o Mini
  factory AIModel.gpt4oMini() => const AIModel(
        id: 'gpt-4o-mini',
        displayName: 'GPT-4o Mini',
        provider: ModelProvider.openAI,
        openRouterId: 'openai/gpt-4o-mini',
        inputCostPer1kTokens: 0.00015,
        outputCostPer1kTokens: 0.0006,
        maxContextLength: 128000,
      );

  /// GPT-4 Turbo
  factory AIModel.gpt4Turbo() => const AIModel(
        id: 'gpt-4-turbo',
        displayName: 'GPT-4 Turbo',
        provider: ModelProvider.openAI,
        openRouterId: 'openai/gpt-4-turbo',
        inputCostPer1kTokens: 0.01,
        outputCostPer1kTokens: 0.03,
        maxContextLength: 128000,
      );

  /// GPT-3.5 Turbo
  factory AIModel.gpt35Turbo() => const AIModel(
        id: 'gpt-3.5-turbo',
        displayName: 'GPT-3.5 Turbo',
        provider: ModelProvider.openAI,
        openRouterId: 'openai/gpt-3.5-turbo',
        inputCostPer1kTokens: 0.0005,
        outputCostPer1kTokens: 0.0015,
        maxContextLength: 16385,
      );

  // ============ Anthropic Models ============

  /// Claude 3.5 Sonnet
  factory AIModel.claude35Sonnet() => const AIModel(
        id: 'claude-3-5-sonnet-20241022',
        displayName: 'Claude 3.5 Sonnet',
        provider: ModelProvider.anthropic,
        openRouterId: 'anthropic/claude-3.5-sonnet',
        inputCostPer1kTokens: 0.003,
        outputCostPer1kTokens: 0.015,
        maxContextLength: 200000,
      );

  /// Claude 3 Opus
  factory AIModel.claude3Opus() => const AIModel(
        id: 'claude-3-opus-20240229',
        displayName: 'Claude 3 Opus',
        provider: ModelProvider.anthropic,
        openRouterId: 'anthropic/claude-3-opus',
        inputCostPer1kTokens: 0.015,
        outputCostPer1kTokens: 0.075,
        maxContextLength: 200000,
      );

  /// Claude 3 Haiku
  factory AIModel.claude3Haiku() => const AIModel(
        id: 'claude-3-haiku-20240307',
        displayName: 'Claude 3 Haiku',
        provider: ModelProvider.anthropic,
        openRouterId: 'anthropic/claude-3-haiku',
        inputCostPer1kTokens: 0.00025,
        outputCostPer1kTokens: 0.00125,
        maxContextLength: 200000,
      );

  // ============ Google Models ============

  /// Gemini Pro
  factory AIModel.geminiPro() => const AIModel(
        id: 'gemini-pro',
        displayName: 'Gemini Pro',
        provider: ModelProvider.google,
        openRouterId: 'google/gemini-pro',
        inputCostPer1kTokens: 0.00025,
        outputCostPer1kTokens: 0.0005,
        maxContextLength: 32760,
      );

  /// Gemini Flash
  factory AIModel.geminiFlash() => const AIModel(
        id: 'gemini-1.5-flash',
        displayName: 'Gemini 1.5 Flash',
        provider: ModelProvider.google,
        openRouterId: 'google/gemini-flash-1.5',
        inputCostPer1kTokens: 0.000075,
        outputCostPer1kTokens: 0.0003,
        maxContextLength: 1000000,
      );

  /// Gemini 1.5 Pro
  factory AIModel.gemini15Pro() => const AIModel(
        id: 'gemini-1.5-pro',
        displayName: 'Gemini 1.5 Pro',
        provider: ModelProvider.google,
        openRouterId: 'google/gemini-pro-1.5',
        inputCostPer1kTokens: 0.00125,
        outputCostPer1kTokens: 0.005,
        maxContextLength: 2000000,
      );

  /// Gets the model ID to use with OpenRouter
  String get effectiveOpenRouterId => openRouterId ?? id;

  @override
  List<Object?> get props => [id, provider];
}
