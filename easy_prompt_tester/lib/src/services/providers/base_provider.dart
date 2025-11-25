import '../../models/ai_model.dart';
import '../../models/prompt_model.dart';
import '../../models/test_result.dart';

/// Base class for AI providers
abstract class BaseProvider {
  /// Send a prompt to the model and get a response
  Future<TestResult> sendPrompt({
    required AIModel model,
    required Prompt prompt,
    required Duration timeout,
  });
}
