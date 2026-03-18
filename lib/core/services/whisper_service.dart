import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import '../database/database_provider.dart';

/// Callback for chunk progress: (completedChunks, totalChunks)
typedef ChunkProgressCallback = void Function(int completed, int total);

/// Whisper API transcription service.
/// Handles verbose_json response, segments + words writing, and chunked upload for large files.
class WhisperService {
  final AppDatabase _db;
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final _uuid = const Uuid();

  static const _apiUrl = 'https://api.openai.com/v1/audio/transcriptions';
  static const _maxChunkBytes = 24 * 1024 * 1024; // 24 MB

  WhisperService({
    required AppDatabase db,
    Dio? dio,
    FlutterSecureStorage? secureStorage,
  })  : _db = db,
        _dio = dio ?? Dio(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Transcribe an audio file and write results to DB.
  /// Returns true on success, false on failure.
  /// [onChunkProgress] receives chunk-level progress (completedChunks, totalChunks).
  Future<bool> transcribe(
    String audioId, {
    ChunkProgressCallback? onChunkProgress,
  }) async {
    try {
      // 1. Get API key
      final apiKey = await _secureStorage.read(key: 'openai_api_key');
      if (apiKey == null || apiKey.isEmpty) {
        debugPrintMasked('Whisper: API key not found');
        await _setStatus(audioId, 'error');
        return false;
      }

      // 2. Get audio item
      final item =
          await (_db.select(_db.audioItems)..where((t) => t.id.equals(audioId))).getSingleOrNull();
      if (item == null) return false;

      // 3. Update status
      await _setStatus(audioId, 'transcribing');

      final file = File(item.filePath);
      final fileSize = await file.length();

      if (fileSize > 25 * 1024 * 1024) {
        // Large file: chunked transcription
        await _transcribeChunked(
          audioId: audioId,
          file: file,
          fileSize: fileSize,
          apiKey: apiKey,
          onChunkProgress: onChunkProgress,
        );
      } else {
        // Single request (1 chunk)
        onChunkProgress?.call(0, 1);
        await _transcribeSingle(
          audioId: audioId,
          file: file,
          fileSize: fileSize,
          apiKey: apiKey,
          offsetMs: 0,
        );
        onChunkProgress?.call(1, 1);
      }

      await _setStatus(audioId, 'done');
      return true;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 0;
      final errorMsg = _mapHttpError(statusCode, e);
      debugPrintMasked('Whisper API error ($statusCode): $errorMsg');
      await _setStatus(audioId, 'error');
      return false;
    } catch (e) {
      debugPrintMasked('Whisper transcription failed: $e');
      await _setStatus(audioId, 'error');
      return false;
    }
  }

  /// Map HTTP status code to user-friendly error message.
  String _mapHttpError(int statusCode, DioException e) {
    return switch (statusCode) {
      401 => 'API Key 无效或已过期，请在设置中更新',
      429 => 'API 请求频率超限，请稍后重试',
      413 => '文件过大，请确保单个文件小于 25MB',
      >= 500 => 'OpenAI 服务器错误 ($statusCode)，请稍后重试',
      _ => e.response?.data?.toString() ?? e.message ?? '未知网络错误',
    };
  }

  /// Single-file transcription (< 25 MB).
  Future<void> _transcribeSingle({
    required String audioId,
    required File file,
    required int fileSize,
    required String apiKey,
    required int offsetMs,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      'model': 'whisper-1',
      'response_format': 'verbose_json',
      'timestamp_granularities[]': ['word', 'segment'],
    });

    final response = await _dio.post(
      _apiUrl,
      data: formData,
      options: Options(
        headers: {'Authorization': 'Bearer $apiKey'},
        receiveTimeout: const Duration(minutes: 5),
        sendTimeout: const Duration(minutes: 5),
      ),
    );

    final data = response.data as Map<String, dynamic>;
    await _writeSegmentsAndWords(audioId, data, offsetMs);
  }

  /// Chunked transcription for files > 25 MB.
  /// Splits file into chunks < 24 MB each, adjusting timestamps.
  Future<void> _transcribeChunked({
    required String audioId,
    required File file,
    required int fileSize,
    required String apiKey,
    ChunkProgressCallback? onChunkProgress,
  }) async {
    final bytes = await file.readAsBytes();
    final chunkCount = (fileSize / _maxChunkBytes).ceil();
    final chunkSize = _maxChunkBytes;
    int cumulativeOffsetMs = 0;

    onChunkProgress?.call(0, chunkCount);

    for (int i = 0; i < chunkCount; i++) {
      final start = i * chunkSize;
      final end = min(start + chunkSize, fileSize);
      final chunkBytes = bytes.sublist(start, end);

      // Write chunk to temp file
      final tempDir = Directory.systemTemp;
      final chunkFile =
          File('${tempDir.path}/whisper_chunk_${audioId}_$i${_fileExtension(file.path)}');
      await chunkFile.writeAsBytes(chunkBytes);

      try {
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(chunkFile.path,
              filename: chunkFile.path.split('/').last),
          'model': 'whisper-1',
          'response_format': 'verbose_json',
          'timestamp_granularities[]': ['word', 'segment'],
        });

        final response = await _dio.post(
          _apiUrl,
          data: formData,
          options: Options(
            headers: {'Authorization': 'Bearer $apiKey'},
            receiveTimeout: const Duration(minutes: 5),
            sendTimeout: const Duration(minutes: 5),
          ),
        );

        final data = response.data as Map<String, dynamic>;
        await _writeSegmentsAndWords(audioId, data, cumulativeOffsetMs);

        // Update cumulative offset with this chunk's duration
        final durationSec = (data['duration'] as num?)?.toDouble() ?? 0.0;
        cumulativeOffsetMs += (durationSec * 1000).round();

        onChunkProgress?.call(i + 1, chunkCount);
      } finally {
        if (await chunkFile.exists()) {
          await chunkFile.delete();
        }
      }
    }
  }

  /// Parse verbose_json response and write segments + words to DB.
  Future<void> _writeSegmentsAndWords(
    String audioId,
    Map<String, dynamic> data,
    int offsetMs,
  ) async {
    final segments = data['segments'] as List<dynamic>? ?? [];
    final words = data['words'] as List<dynamic>? ?? [];

    // Get current max segment index for this audio
    final existingTranscripts = await (_db.select(_db.transcripts)
          ..where((t) => t.audioId.equals(audioId))
          ..orderBy([(t) => OrderingTerm.desc(t.segmentIndex)])
          ..limit(1))
        .getSingleOrNull();
    int segmentOffset = existingTranscripts != null ? existingTranscripts.segmentIndex + 1 : 0;

    // Map of segment index → transcript ID for word linking
    final segmentTranscriptIds = <int, String>{};

    // Write segments
    for (int i = 0; i < segments.length; i++) {
      final seg = segments[i] as Map<String, dynamic>;
      final transcriptId = _uuid.v4();
      final startMs = ((seg['start'] as num).toDouble() * 1000).round() + offsetMs;
      final endMs = ((seg['end'] as num).toDouble() * 1000).round() + offsetMs;

      await _db.into(_db.transcripts).insert(
            TranscriptsCompanion.insert(
              id: transcriptId,
              audioId: audioId,
              segmentIndex: segmentOffset + i,
              text_: seg['text'] as String? ?? '',
              startMs: startMs,
              endMs: endMs,
              offsetAdjust: Value(offsetMs),
            ),
          );

      segmentTranscriptIds[seg['id'] as int? ?? i] = transcriptId;
    }

    // Write words — link each word to the nearest segment by time
    for (final w in words) {
      final word = w as Map<String, dynamic>;
      final wordStartMs = ((word['start'] as num).toDouble() * 1000).round() + offsetMs;
      final wordEndMs = ((word['end'] as num).toDouble() * 1000).round() + offsetMs;

      // Find the transcript this word belongs to (by time overlap)
      String? transcriptId;
      for (int i = 0; i < segments.length; i++) {
        final seg = segments[i] as Map<String, dynamic>;
        final segStart = ((seg['start'] as num).toDouble() * 1000).round() + offsetMs;
        final segEnd = ((seg['end'] as num).toDouble() * 1000).round() + offsetMs;
        if (wordStartMs >= segStart && wordStartMs <= segEnd) {
          transcriptId = segmentTranscriptIds[seg['id'] as int? ?? i];
          break;
        }
      }

      // Fallback: use last segment
      transcriptId ??= segmentTranscriptIds.values.lastOrNull;
      if (transcriptId == null) continue;

      await _db.into(_db.words).insert(
            WordsCompanion.insert(
              wordText: word['word'] as String? ?? '',
              startMs: wordStartMs,
              endMs: wordEndMs,
              transcriptId: transcriptId,
            ),
          );
    }
  }

  Future<void> _setStatus(String audioId, String status) async {
    await (_db.update(_db.audioItems)..where((t) => t.id.equals(audioId)))
        .write(AudioItemsCompanion(
      transcriptionStatus: Value(status),
    ));
  }

  String _fileExtension(String path) {
    final dot = path.lastIndexOf('.');
    return dot >= 0 ? path.substring(dot) : '.bin';
  }

  /// Print debug info with API key masked.
  static void debugPrintMasked(String message) {
    // Mask anything that looks like an API key (sk-...)
    final masked = message.replaceAll(
      RegExp(r'sk-[A-Za-z0-9_-]{10,}'),
      'sk-***MASKED***',
    );
    // ignore: avoid_print
    print(masked);
  }
}

/// Riverpod provider for WhisperService
final whisperServiceProvider = Provider<WhisperService>((ref) {
  final db = ref.read(databaseProvider);
  return WhisperService(db: db);
});
