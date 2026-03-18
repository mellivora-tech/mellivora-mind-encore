import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';
import '../database/database_provider.dart';
import 'notification_service.dart';
import 'whisper_service.dart';

/// Progress info for a transcription task.
class TranscriptionProgress {
  final String audioId;
  final int percent; // 0-100
  final String status; // 'queued' | 'transcribing' | 'done' | 'error'

  const TranscriptionProgress({
    required this.audioId,
    required this.percent,
    required this.status,
  });
}

/// Serial transcription task queue.
/// Only one transcription runs at a time. Queue persists across app restarts.
class TranscriptionQueue {
  final AppDatabase _db;
  final WhisperService _whisperService;
  final NotificationService _notificationService;

  final Queue<String> _pending = Queue<String>();
  String? _currentAudioId;
  bool _isProcessing = false;
  bool _cancelRequested = false;

  final _progressController = StreamController<TranscriptionProgress>.broadcast();

  /// Stream of transcription progress updates.
  Stream<TranscriptionProgress> get progressStream => _progressController.stream;

  /// Current queue state: pending IDs + currently processing ID.
  List<String> get pendingIds => _pending.toList();
  String? get currentAudioId => _currentAudioId;

  static const _prefsKey = 'transcription_queue';

  TranscriptionQueue({
    required AppDatabase db,
    required WhisperService whisperService,
    NotificationService? notificationService,
  })  : _db = db,
        _whisperService = whisperService,
        _notificationService = notificationService ?? NotificationService();

  /// Restore queue from SharedPreferences on app startup.
  Future<void> restoreQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_prefsKey);
    if (json != null) {
      final list = (jsonDecode(json) as List).cast<String>();
      for (final id in list) {
        if (!_pending.contains(id) && id != _currentAudioId) {
          _pending.add(id);
        }
      }
    }
    _processNext();
  }

  /// Add an audio item to the transcription queue.
  Future<void> enqueue(String audioId) async {
    if (_pending.contains(audioId) || _currentAudioId == audioId) {
      return; // Already queued or processing
    }
    _pending.add(audioId);
    _emitProgress(audioId, 0, 'queued');
    await _persistQueue();
    _processNext();
  }

  /// Cancel a pending or in-progress transcription.
  Future<void> cancelTask(String audioId) async {
    if (_pending.contains(audioId)) {
      _pending.remove(audioId);
      await _persistQueue();
      return;
    }
    if (_currentAudioId == audioId) {
      _cancelRequested = true;
    }
  }

  /// Process the next item in the queue.
  void _processNext() {
    if (_isProcessing || _pending.isEmpty) return;
    _isProcessing = true;
    _cancelRequested = false;

    final audioId = _pending.removeFirst();
    _currentAudioId = audioId;
    _persistQueue();

    _runTranscription(audioId);
  }

  Future<void> _runTranscription(String audioId) async {
    _emitProgress(audioId, 0, 'transcribing');

    final success = await _whisperService.transcribe(
      audioId,
      onChunkProgress: (completed, total) {
        if (_cancelRequested) return;
        final pct = total > 0 ? (completed * 100 ~/ total).clamp(0, 99) : 0;
        _emitProgress(audioId, pct, 'transcribing');
      },
    );

    if (_cancelRequested) {
      // Task was cancelled mid-flight
      _emitProgress(audioId, 0, 'error');
      _finishCurrent();
      return;
    }

    if (success) {
      _emitProgress(audioId, 100, 'done');
      await _notifyCompletion(audioId);
    } else {
      _emitProgress(audioId, 0, 'error');
      await _notifyFailure(audioId);
    }

    _finishCurrent();
  }

  void _finishCurrent() {
    _currentAudioId = null;
    _isProcessing = false;
    _cancelRequested = false;
    _persistQueue();
    _processNext();
  }

  /// Send push notification on transcription completion.
  Future<void> _notifyCompletion(String audioId) async {
    try {
      final item =
          await (_db.select(_db.audioItems)..where((t) => t.id.equals(audioId))).getSingleOrNull();
      if (item == null) return;

      // Count segments as proxy for chapters
      final segments =
          await (_db.select(_db.transcripts)..where((t) => t.audioId.equals(audioId))).get();

      await _notificationService.showTranscriptionComplete(
        audioId: audioId,
        audioTitle: item.title,
        chapterCount: segments.length,
      );
    } catch (e) {
      WhisperService.debugPrintMasked('Notification failed: $e');
    }
  }

  /// Send push notification on transcription failure.
  Future<void> _notifyFailure(String audioId) async {
    try {
      final item =
          await (_db.select(_db.audioItems)..where((t) => t.id.equals(audioId))).getSingleOrNull();
      if (item == null) return;

      await _notificationService.showTranscriptionFailed(
        audioId: audioId,
        audioTitle: item.title,
      );
    } catch (e) {
      WhisperService.debugPrintMasked('Failure notification failed: $e');
    }
  }

  void _emitProgress(String audioId, int percent, String status) {
    _progressController.add(TranscriptionProgress(
      audioId: audioId,
      percent: percent,
      status: status,
    ));
  }

  Future<void> _persistQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = <String>[
      if (_currentAudioId != null) _currentAudioId!,
      ..._pending,
    ];
    await prefs.setString(_prefsKey, jsonEncode(ids));
  }

  void dispose() {
    _progressController.close();
  }
}

/// Riverpod provider for TranscriptionQueue.
final transcriptionQueueProvider = Provider<TranscriptionQueue>((ref) {
  final db = ref.read(databaseProvider);
  final whisper = ref.read(whisperServiceProvider);
  final queue = TranscriptionQueue(db: db, whisperService: whisper);
  ref.onDispose(() => queue.dispose());
  return queue;
});

/// Stream provider for transcription progress.
final transcriptionProgressProvider = StreamProvider<TranscriptionProgress>((ref) {
  final queue = ref.read(transcriptionQueueProvider);
  return queue.progressStream;
});
