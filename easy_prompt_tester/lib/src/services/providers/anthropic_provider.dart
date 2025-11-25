import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/ai_model.dart';
import '../../models/prompt_model.dart';
import '../../models/test_result.dart';
import 'base_provider.dart';

/// Provider for direct Anthropic API calls
class AnthropicProvider extends BaseProvider {
  final String apiKey;

  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';
  static const String _apiVersion = '2023-06-01';

  AnthropicProvider({required this.apiKey});

  @override
  Future<TestResult> sendPrompt({
    required AIModel model,
    required Prompt prompt,
    required Duration timeout,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final messages = <Map<String, String>>[
        {
          'role': 'user',
          'content': prompt.userPrompt,
        },
      ];

      final body = <String, dynamic>{
        'model': model.id,
        'messages': messages,
        'max_tokens': prompt.maxTokens ?? 4096,
      };

      if (prompt.systemPrompt != null && prompt.systemPrompt!.isNotEmpty) {
        body['system'] = prompt.systemPrompt;
      }

      if (prompt.temperature != null) {
        body['temperature'] = prompt.temperature;
      }

      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {
              'x-api-key': apiKey,
              'anthropic-version': _apiVersion,
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(timeout);

      stopwatch.stop();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final content = data['content'] as List<dynamic>?;
        final usage = data['usage'] as Map<String, dynamic>?;

        if (content != null && content.isNotEmpty) {
          final textBlock = content.firstWhere(
            (block) => block['type'] == 'text',
            orElse: () => null,
          );

          if (textBlock != null) {
            return TestResult.success(
              model: model,
              response: textBlock['text'] as String? ?? '',
              duration: stopwatch.elapsed,
              inputTokens: usage?['input_tokens'] as int?,
              outputTokens: usage?['output_tokens'] as int?,
            );
          }
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
