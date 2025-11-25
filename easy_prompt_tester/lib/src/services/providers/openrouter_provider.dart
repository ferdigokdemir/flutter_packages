import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/ai_model.dart';
import '../../models/prompt_model.dart';
import '../../models/test_result.dart';
import 'base_provider.dart';

/// Provider for OpenRouter API (supports all models through one endpoint)
class OpenRouterProvider extends BaseProvider {
  final String apiKey;
  final String? appName;
  final String? siteUrl;

  static const String _baseUrl =
      'https://openrouter.ai/api/v1/chat/completions';

  OpenRouterProvider({
    required this.apiKey,
    this.appName,
    this.siteUrl,
  });

  @override
  Future<TestResult> sendPrompt({
    required AIModel model,
    required Prompt prompt,
    required Duration timeout,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final messages = <Map<String, String>>[];

      if (prompt.systemPrompt != null && prompt.systemPrompt!.isNotEmpty) {
        messages.add({
          'role': 'system',
          'content': prompt.systemPrompt!,
        });
      }

      messages.add({
        'role': 'user',
        'content': prompt.userPrompt,
      });

      final body = <String, dynamic>{
        'model': model.effectiveOpenRouterId,
        'messages': messages,
      };

      if (prompt.temperature != null) {
        body['temperature'] = prompt.temperature;
      }

      if (prompt.maxTokens != null) {
        body['max_tokens'] = prompt.maxTokens;
      }

      final headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      };

      if (appName != null) {
        headers['X-Title'] = appName!;
      }

      if (siteUrl != null) {
        headers['HTTP-Referer'] = siteUrl!;
      }

      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(timeout);

      stopwatch.stop();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final choices = data['choices'] as List<dynamic>?;
        final usage = data['usage'] as Map<String, dynamic>?;

        if (choices != null && choices.isNotEmpty) {
          final message = choices[0]['message'] as Map<String, dynamic>?;
          final content = message?['content'] as String?;

          return TestResult.success(
            model: model,
            response: content ?? '',
            duration: stopwatch.elapsed,
            inputTokens: usage?['prompt_tokens'] as int?,
            outputTokens: usage?['completion_tokens'] as int?,
          );
        }

        return TestResult.failure(
          model: model,
          error: 'No response content received',
          duration: stopwatch.elapsed,
        );
      } else {
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>?;
        final errorMessage = errorBody?['error']?['message'] ?? 'Unknown error';

        return TestResult.failure(
          model: model,
          error: 'HTTP ${response.statusCode}: $errorMessage',
          duration: stopwatch.elapsed,
        );
      }
    } catch (e) {
      stopwatch.stop();
      return TestResult.failure(
        model: model,
        error: e.toString(),
        duration: stopwatch.elapsed,
      );
    }
  }
}
