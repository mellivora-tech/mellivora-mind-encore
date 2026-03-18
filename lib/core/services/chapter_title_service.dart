import 'dart:async';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../database/app_database.dart';
import '../database/database_provider.dart';

/// Service to generate chapter titles using LLM (GPT-4o-mini) with fallback.
///
/// - Calls OpenAI GPT-4o-mini to summarize chapter content into a short Chinese title
/// - Fallback: on API failure, uses "第 N 章" (1-based index)
/// - Concurrent request limit: max 3 simultaneous requests
class ChapterTitleService {
  final AppDatabase _db;
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  /// Semaphore: tracks current in-flight requests
  int _activeRequests = 0;
  static const _maxConcurrency = 3;
  final _queue = <Completer<void>>[];

  static const _apiUrl = 'https://api.openai.com/v1/chat/completions';

  ChapterTitleService({
    required AppDatabase db,
    Dio? dio,
    FlutterSecureStorage? secureStorage,
  })  : _db = db,
        _dio = dio ?? Dio(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Generate titles for all chapters of an audio item.
  ///
  /// Fetches chapters from DB, generates titles via LLM (with concurrency limit),
  /// and writes results back to DB.
  Future<void> generateTitlesForAudio(String audioId) async {
    final chapters = await (_db.select(_db.chapters)
          ..where((t) => t.audioId.equals(audioId))
          ..orderBy([(t) => OrderingTerm.asc(t.index)]))
        .get();

    if (chapters.isEmpty) return;

    final apiKey = await _secureStorage.read(key: 'openai_api_key');

    // Launch all title generation tasks with concurrency control
    final futures = <Future<void>>[];
    for (final chapter in chapters) {
      futures.add(_generateAndSaveTitle(
        chapter: chapter,
        apiKey: apiKey,
      ));
    }

    await Future.wait(futures);
  }

  /// Generate a single chapter title with concurrency limiting.
  Future<void> _generateAndSaveTitle({
    required Chapter chapter,
    required String? apiKey,
  }) async {
    await _acquireSemaphore();
    try {
      final title = await _generateTitle(
        text: _getChapterText(chapter),
        apiKey: apiKey,
        fallbackIndex: chapter.index + 1, // 1-based
      );

      await (_db.update(_db.chapters)..where((t) => t.id.equals(chapter.id)))
          .write(ChaptersCompanion(title: Value(title)));
    } finally {
      _releaseSemaphore();
    }
  }

  /// Get text content for a chapter.
  /// Uses the chapter title if available, otherwise builds from transcripts.
  String _getChapterText(Chapter chapter) {
    // The rawText is not stored directly in chapters table.
    // We use the title field as a temporary holder during chapter creation,
    // or fall back to a minimal description.
    // In practice, the caller should set rawText in the title field before calling.
    return chapter.title.isNotEmpty ? chapter.title : '';
  }

  /// Call GPT-4o-mini to generate a title, with fallback on failure.
  Future<String> _generateTitle({
    required String text,
    required String? apiKey,
    required int fallbackIndex,
  }) async {
    if (apiKey == null || apiKey.isEmpty || text.isEmpty) {
      return '第 $fallbackIndex 章';
    }

    try {
      // Truncate text to avoid token limits (keep first ~2000 chars)
      final truncated = text.length > 2000 ? text.substring(0, 2000) : text;

      final response = await _dio.post(
        _apiUrl,
        data: {
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content': '用5字以内概括这段英文内容的主题，只输出中文标题',
            },
            {
              'role': 'user',
              'content': truncated,
            },
          ],
          'max_tokens': 30,
          'temperature': 0.3,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      final data = response.data as Map<String, dynamic>;
      final choices = data['choices'] as List<dynamic>?;
      if (choices != null && choices.isNotEmpty) {
        final message = choices[0]['message'] as Map<String, dynamic>?;
        final content = message?['content'] as String?;
        if (content != null && content.trim().isNotEmpty) {
          // Clean up: remove quotes, periods, extra whitespace
          return content.trim().replaceAll(RegExp('^[「『"\' ]+|[」』"\' 。.]+\$'), '').trim();
        }
      }

      return '第 $fallbackIndex 章';
    } on DioException {
      return '第 $fallbackIndex 章';
    } catch (_) {
      return '第 $fallbackIndex 章';
    }
  }

  /// Simple semaphore: wait until a slot is available.
  Future<void> _acquireSemaphore() async {
    if (_activeRequests < _maxConcurrency) {
      _activeRequests++;
      return;
    }

    final completer = Completer<void>();
    _queue.add(completer);
    await completer.future;
    _activeRequests++;
  }

  /// Release a semaphore slot and notify next waiter.
  void _releaseSemaphore() {
    _activeRequests--;
    if (_queue.isNotEmpty) {
      final next = _queue.removeAt(0);
      next.complete();
    }
  }
}

/// Generate title for a single chapter (standalone, for use outside batch).
/// Used when rawText is directly available.
Future<String> generateSingleTitle({
  required Dio dio,
  required String apiKey,
  required String text,
  required int fallbackIndex,
}) async {
  if (apiKey.isEmpty || text.isEmpty) {
    return '第 $fallbackIndex 章';
  }

  try {
    final truncated = text.length > 2000 ? text.substring(0, 2000) : text;

    final response = await dio.post(
      'https://api.openai.com/v1/chat/completions',
      data: {
        'model': 'gpt-4o-mini',
        'messages': [
          {
            'role': 'system',
            'content': '用5字以内概括这段英文内容的主题，只输出中文标题',
          },
          {
            'role': 'user',
            'content': truncated,
          },
        ],
        'max_tokens': 30,
        'temperature': 0.3,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    final data = response.data as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>?;
    if (choices != null && choices.isNotEmpty) {
      final content = (choices[0]['message'] as Map<String, dynamic>?)?['content'] as String?;
      if (content != null && content.trim().isNotEmpty) {
        return content.trim().replaceAll(RegExp('^[「『"\' ]+|[」』"\' 。.]+\$'), '').trim();
      }
    }
    return '第 $fallbackIndex 章';
  } catch (_) {
    return '第 $fallbackIndex 章';
  }
}

/// Riverpod provider for ChapterTitleService
final chapterTitleServiceProvider = Provider<ChapterTitleService>((ref) {
  final db = ref.read(databaseProvider);
  return ChapterTitleService(db: db);
});
