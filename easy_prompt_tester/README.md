# Easy Prompt Tester

A Flutter package to test prompts across multiple AI models and compare their responses for quality and compatibility analysis.

## Features

- 🤖 Support for multiple AI providers (OpenAI, Anthropic, Google)
- 🌐 OpenRouter support (use one API key for all models)
- ⏱️ Response time measurement
- 📊 Token usage tracking
- 💰 Cost estimation
- 📝 Detailed test reports

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  easy_prompt_tester: ^0.0.1
```

## Usage

### Basic Setup

```dart
import 'package:easy_prompt_tester/easy_prompt_tester.dart';

// Option 1: Using OpenRouter (recommended - one key for all models)
EasyPromptTester.init(
  config: EasyPromptTesterConfig(
    openRouterApiKey: 'your-openrouter-key',
  ),
);

// Option 2: Using individual provider keys
EasyPromptTester.init(
  config: EasyPromptTesterConfig(
    openAiApiKey: 'sk-xxx',
    anthropicApiKey: 'sk-ant-xxx',
    googleApiKey: 'xxx',
  ),
);
```

### Testing a Prompt

```dart
// Define models to test
final models = [
  AIModel.gpt4o(),
  AIModel.claude35Sonnet(),
  AIModel.geminiPro(),
];

// Create a prompt
final prompt = Prompt(
  systemPrompt: 'You are a helpful assistant.',
  userPrompt: 'What is Flutter? Explain briefly.',
);

// Run the test
final report = await EasyPromptTester.instance.testPrompt(
  prompt: prompt,
  models: models,
);

// Analyze results
for (final result in report.results) {
  print('Model: ${result.model.displayName}');
  print('Duration: ${result.duration.inMilliseconds}ms');
  print('Response: ${result.response}');
  print('---');
}
```

### Available Models

#### OpenAI
- `AIModel.gpt4o()` - GPT-4o
- `AIModel.gpt4oMini()` - GPT-4o Mini
- `AIModel.gpt4Turbo()` - GPT-4 Turbo
- `AIModel.gpt35Turbo()` - GPT-3.5 Turbo

#### Anthropic
- `AIModel.claude35Sonnet()` - Claude 3.5 Sonnet
- `AIModel.claude3Opus()` - Claude 3 Opus
- `AIModel.claude3Haiku()` - Claude 3 Haiku

#### Google
- `AIModel.geminiPro()` - Gemini Pro
- `AIModel.geminiFlash()` - Gemini Flash

### Custom Models

```dart
final customModel = AIModel(
  id: 'custom-model-id',
  displayName: 'My Custom Model',
  provider: ModelProvider.openRouter,
  inputCostPer1kTokens: 0.001,
  outputCostPer1kTokens: 0.002,
);
```

## Test Report

The `TestReport` contains:

- `results` - List of individual test results
- `totalDuration` - Total time taken for all tests
- `successCount` - Number of successful tests
- `failureCount` - Number of failed tests
- `averageDuration` - Average response time

Each `TestResult` contains:

- `model` - The AI model used
- `response` - The model's response (null if failed)
- `error` - Error message (null if successful)
- `duration` - Response time
- `inputTokens` - Number of input tokens
- `outputTokens` - Number of output tokens
- `estimatedCost` - Estimated cost in USD

## License

MIT License
