import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/ai_model.dart';
import '../../models/prompt_model.dart';
import '../../models/test_result.dart';
import 'base_provider.dart';

/// Provider for direct Google Gemini API calls
class GoogleProvider extends BaseProvider {
  final String apiKey;

  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  GoogleProvider({required this.apiKey});

  @override
  Future<TestResult> sendPrompt({
    required AIModel model,
    required Prompt prompt,
    required Duration timeout,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final contents = <Map<String, dynamic>>[];

      // Add system instruction if provided
      final systemInstruction =
          prompt.systemPrompt != null && prompt.systemPrompt!.isNotEmpty
              ? {
                  'parts': [
                    {'text': prompt.systemPrompt}
                  ]
                }
              : null;

      // Add user message
      contents.add({
        'role': 'user',
        'parts': [
          {'text': prompt.userPrompt}
        ],
      });

      final body = <String, dynamic>{
        'contents': contents,
      };

      if (systemInstruction != null) {
        body['systemInstruction'] = systemInstruction;
      }

      // Generation config
      final generationConfig = <String, dynamic>{};

      if (prompt.temperature != null) {
        generationConfig['temperature'] = prompt.temperature;
      }

      if (prompt.maxTokens != null) {
        generationConfig['maxOutputTokens'] = prompt.maxTokens;
      }

      if (generationConfig.isNotEmpty) {
        body['generationConfig'] = generationConfig;
      }

      final url = '$_baseUrl/${model.id}:generateContent?key=$apiKey';

      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(timeout);

      stopwatch.stop();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final candidates = data['candidates'] as List<dynamic>?;
        final usageMetadata = data['usageMetadata'] as Map<String, dynamic>?;

        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'] as Map<String, dynamic>?;
          final parts = content?['parts'] as List<dynamic>?;

          if (parts != null && parts.isNotEmpty) {
            final text = parts[0]['text'] as String?;

            return TestResult.success(
              model: model,
              response: text ?? '',
              duration: stopwatch.elapsed,
              inputTokens: usageMetadata?['promptTokenCount'] as int?,
              outputTokens: usageMetadata?['candidatesTokenCount'] as int?,
            );
          }
        }

        // Check for blocked content
        final promptFeedback = data['promptFeedback'] as Map<String, dynamic>?;
        if (promptFeedback != null) {
          final blockReason = promptFeedback['blockReason'] as String?;
          if (blockReason != null) {
            return TestResult.failure(
              model: model,
              error: 'Content blocked: $blockReason',
              duration: stopwatch.elapsed,
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
        final error = errorBody?['error'] as Map<String, dynamic>?;
        final errorMessage = error?['message'] ?? 'Unknown error';

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
