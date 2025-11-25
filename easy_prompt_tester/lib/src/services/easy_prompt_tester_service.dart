import '../config/easy_prompt_tester_config.dart';
import '../models/ai_model.dart';
import '../models/model_provider.dart';
import '../models/prompt_model.dart';
import '../models/test_report.dart';
import '../models/test_result.dart';
import 'providers/anthropic_provider.dart';
import 'providers/base_provider.dart';
import 'providers/google_provider.dart';
import 'providers/openai_provider.dart';
import 'providers/openrouter_provider.dart';

/// Main service for testing prompts across multiple AI models
class EasyPromptTester {
  static EasyPromptTester? _instance;
  late EasyPromptTesterConfig _config;

  EasyPromptTester._();

  /// Initialize the prompt tester with configuration
  static void init({required EasyPromptTesterConfig config}) {
    _instance ??= EasyPromptTester._();
    _instance!._config = config;
  }

  /// Get the singleton instance
  static EasyPromptTester get instance {
    if (_instance == null) {
      throw StateError(
        'EasyPromptTester has not been initialized. Call EasyPromptTester.init() first.',
      );
    }
    return _instance!;
  }

  /// Current configuration
  EasyPromptTesterConfig get config => _config;

  /// Update configuration
  void updateConfig(EasyPromptTesterConfig config) {
    _config = config;
  }

  /// Test a prompt across multiple models
  Future<TestReport> testPrompt({
    required Prompt prompt,
    required List<AIModel> models,
  }) async {
    final startedAt = DateTime.now();
    final List<TestResult> results;

    if (_config.runInParallel) {
      // Run all tests in parallel
      results = await Future.wait(
        models.map((model) => _testSingleModel(model: model, prompt: prompt)),
      );
    } else {
      // Run tests sequentially
      results = [];
      for (final model in models) {
        final result = await _testSingleModel(model: model, prompt: prompt);
        results.add(result);
      }
    }

    final completedAt = DateTime.now();

    return TestReport(
      prompt: prompt,
      results: results,
      startedAt: startedAt,
      completedAt: completedAt,
    );
  }

  /// Test a single model
  Future<TestResult> _testSingleModel({
    required AIModel model,
    required Prompt prompt,
  }) async {
    final provider = _getProvider(model);

    if (provider == null) {
      return TestResult.failure(
        model: model,
        error: 'No API key configured for ${model.provider.displayName}',
        duration: Duration.zero,
      );
    }

    return provider.sendPrompt(
      model: model,
      prompt: prompt,
      timeout: _config.timeout,
    );
  }

  /// Get the appropriate provider for a model
  BaseProvider? _getProvider(AIModel model) {
    // If OpenRouter is configured, use it for all models
    if (_config.useOpenRouter) {
      return OpenRouterProvider(
        apiKey: _config.openRouterApiKey!,
        appName: _config.appName,
        siteUrl: _config.siteUrl,
      );
    }

    // Otherwise, use direct provider based on model type
    switch (model.provider) {
      case ModelProvider.openAI:
        if (_config.hasOpenAiKey) {
          return OpenAIProvider(apiKey: _config.openAiApiKey!);
        }
        break;
      case ModelProvider.anthropic:
        if (_config.hasAnthropicKey) {
          return AnthropicProvider(apiKey: _config.anthropicApiKey!);
        }
        break;
      case ModelProvider.google:
        if (_config.hasGoogleKey) {
          return GoogleProvider(apiKey: _config.googleApiKey!);
        }
        break;
      case ModelProvider.openRouter:
        // OpenRouter provider explicitly requested but no key
        break;
    }

    return null;
  }

  /// Get all available pre-defined models
  static List<AIModel> get allModels => [
        AIModel.gpt4o(),
        AIModel.gpt4oMini(),
        AIModel.gpt4Turbo(),
        AIModel.gpt35Turbo(),
        AIModel.claude35Sonnet(),
        AIModel.claude3Opus(),
        AIModel.claude3Haiku(),
        AIModel.geminiPro(),
        AIModel.geminiFlash(),
        AIModel.gemini15Pro(),
      ];

  /// Get models filtered by provider
  static List<AIModel> modelsByProvider(ModelProvider provider) =>
      allModels.where((m) => m.provider == provider).toList();
}
