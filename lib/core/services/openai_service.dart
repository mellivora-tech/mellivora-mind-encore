import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../env/env_config.dart';

/// Shared OpenAI API client for word definitions and Agent chat.
class OpenAIService {
  final Dio _dio;

  OpenAIService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://api.openai.com/v1',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 60),
        ));

  String get _apiKey => EnvConfig.openaiApiKey;
  bool get isConfigured => _apiKey.isNotEmpty;

  /// Single-shot chat completion (for word definitions).
  Future<String> chatCompletion({
    required String systemPrompt,
    required String userMessage,
    String model = 'gpt-4o-mini',
    double temperature = 0.3,
  }) async {
    final response = await _dio.post(
      '/chat/completions',
      options: Options(headers: {'Authorization': 'Bearer $_apiKey'}),
      data: {
        'model': model,
        'temperature': temperature,
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': userMessage},
        ],
      },
    );

    final content = response.data['choices'][0]['message']['content'] as String;
    return content;
  }

  /// Streaming chat completion (for Agent conversations).
  /// Returns a Stream of content delta strings.
  Stream<String> chatCompletionStream({
    required List<Map<String, String>> messages,
    String model = 'gpt-4o-mini',
    double temperature = 0.7,
  }) async* {
    final response = await _dio.post(
      '/chat/completions',
      options: Options(
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Accept': 'text/event-stream',
        },
        responseType: ResponseType.stream,
      ),
      data: {
        'model': model,
        'temperature': temperature,
        'stream': true,
        'messages': messages,
      },
    );

    final stream = response.data.stream as Stream<List<int>>;
    String buffer = '';

    await for (final chunk in stream) {
      buffer += utf8.decode(chunk);
      final lines = buffer.split('\n');
      // Keep last potentially incomplete line in buffer
      buffer = lines.removeLast();

      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || !trimmed.startsWith('data: ')) continue;
        final data = trimmed.substring(6);
        if (data == '[DONE]') return;

        try {
          final json = jsonDecode(data) as Map<String, dynamic>;
          final delta = json['choices']?[0]?['delta']?['content'];
          if (delta != null && delta is String && delta.isNotEmpty) {
            yield delta;
          }
        } catch (_) {
          // Skip malformed JSON chunks
        }
      }
    }
  }

  /// Parse word definition JSON from OpenAI response.
  static Map<String, String>? parseWordDefinition(String response) {
    try {
      // Try to extract JSON from response
      String jsonStr = response.trim();
      final jsonStart = jsonStr.indexOf('{');
      final jsonEnd = jsonStr.lastIndexOf('}');
      if (jsonStart >= 0 && jsonEnd > jsonStart) {
        jsonStr = jsonStr.substring(jsonStart, jsonEnd + 1);
      }
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return {
        'phonetic': map['phonetic']?.toString() ?? '',
        'pos': map['pos']?.toString() ?? '',
        'meaning': map['meaning']?.toString() ?? '',
      };
    } catch (_) {
      return null;
    }
  }
}

final openAIServiceProvider = Provider<OpenAIService>((ref) {
  return OpenAIService();
});
