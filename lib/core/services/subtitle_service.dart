import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../database/app_database.dart';
import '../database/database_provider.dart';
import 'audio_player_service.dart';

/// In-memory transcript segment for fast lookup.
class TranscriptSegment {
  final String id;
  final int segmentIndex;
  final String text;
  final int startMs;
  final int endMs;
  final int offsetAdjust;

  /// Effective start/end after offset adjustment
  int get effectiveStartMs => startMs + offsetAdjust;
  int get effectiveEndMs => endMs + offsetAdjust;

  const TranscriptSegment({
    required this.id,
    required this.segmentIndex,
    required this.text,
    required this.startMs,
    required this.endMs,
    this.offsetAdjust = 0,
  });
}

/// #27: Subtitle data layer — memory preload + binary search + offset adjust.
class SubtitleService extends StateNotifier<SubtitleState> {
  final AppDatabase _db;
  final AudioPlayer _player;
  StreamSubscription<Duration>? _positionSub;
  int _globalOffsetMs = 0;

  SubtitleService(this._db, this._player) : super(const SubtitleState());

  /// Load all transcript segments for a given audio+chapter into memory.
  Future<void> loadSubtitles(String audioId, {String? chapterId}) async {
    final query = _db.select(_db.transcripts)
      ..where((t) => t.audioId.equals(audioId))
      ..orderBy([(t) => OrderingTerm.asc(t.startMs)]);

    late final List<Transcript> rows;
    try {
      rows = await query.get();
    } catch (e) {
      debugPrint('Failed to load subtitles: $e');
      return;
    }

    final segments = rows.map((r) => TranscriptSegment(
      id: r.id,
      segmentIndex: r.segmentIndex,
      text: r.text_,
      startMs: r.startMs,
      endMs: r.endMs,
      offsetAdjust: r.offsetAdjust,
    )).toList();

    state = state.copyWith(
      segments: segments,
      audioId: audioId,
      currentIndex: -1,
    );

    _startListening();
  }

  /// Binary search: O(log n) to find segment index for a given position.
  int getCurrentSegmentIndex(int positionMs) {
    final segments = state.segments;
    if (segments.isEmpty) return -1;

    final adjustedPos = positionMs - _globalOffsetMs;

    int lo = 0;
    int hi = segments.length - 1;
    int result = -1;

    while (lo <= hi) {
      final mid = (lo + hi) ~/ 2;
      final seg = segments[mid];
      if (adjustedPos >= seg.effectiveStartMs) {
        if (adjustedPos < seg.effectiveEndMs) {
          return mid;
        }
        result = mid;
        lo = mid + 1;
      } else {
        hi = mid - 1;
      }
    }

    // If no exact match, check the closest result
    if (result >= 0) {
      final seg = segments[result];
      if (adjustedPos >= seg.effectiveStartMs &&
          adjustedPos < seg.effectiveEndMs) {
        return result;
      }
    }

    return -1;
  }

  /// Adjust global offset for subtitle sync correction.
  void adjustOffset(int ms) {
    _globalOffsetMs += ms;
    // Force re-evaluate current position
    _updateFromPosition(_player.position);
  }

  /// Reset offset to zero.
  void resetOffset() {
    _globalOffsetMs = 0;
  }

  /// Listen to position stream for real-time subtitle updates.
  /// #40: Use distinct() on segment index to reduce unnecessary setState calls.
  void _startListening() {
    _positionSub?.cancel();
    _positionSub = _player.positionStream
        .map((pos) => getCurrentSegmentIndex(pos.inMilliseconds))
        .distinct()
        .listen((idx) {
      if (idx != state.currentIndex) {
        state = state.copyWith(currentIndex: idx);
      }
    });
  }

  void _updateFromPosition(Duration position) {
    final idx = getCurrentSegmentIndex(position.inMilliseconds);
    if (idx != state.currentIndex) {
      state = state.copyWith(currentIndex: idx);
    }
  }

  /// Force update after seek (don't wait for next emit).
  void forceUpdate(Duration position) {
    _updateFromPosition(position);
  }

  /// Get segments within a chapter's time range.
  List<TranscriptSegment> getSegmentsForChapter(int startMs, int endMs) {
    return state.segments.where((s) {
      return s.effectiveStartMs >= startMs && s.effectiveStartMs < endMs;
    }).toList();
  }

  /// Get the current segment text (or null).
  TranscriptSegment? get currentSegment {
    final idx = state.currentIndex;
    if (idx < 0 || idx >= state.segments.length) return null;
    return state.segments[idx];
  }

  void clear() {
    _positionSub?.cancel();
    state = const SubtitleState();
    _globalOffsetMs = 0;
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }
}

class SubtitleState {
  final List<TranscriptSegment> segments;
  final String? audioId;
  final int currentIndex;

  const SubtitleState({
    this.segments = const [],
    this.audioId,
    this.currentIndex = -1,
  });

  TranscriptSegment? get currentSegment {
    if (currentIndex < 0 || currentIndex >= segments.length) return null;
    return segments[currentIndex];
  }

  SubtitleState copyWith({
    List<TranscriptSegment>? segments,
    String? audioId,
    int? currentIndex,
  }) {
    return SubtitleState(
      segments: segments ?? this.segments,
      audioId: audioId ?? this.audioId,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

/// Riverpod provider for SubtitleService.
final subtitleServiceProvider =
    StateNotifierProvider<SubtitleService, SubtitleState>((ref) {
  final db = ref.read(databaseProvider);
  final player = ref.read(audioPlayerProvider.notifier).player;
  return SubtitleService(db, player);
});
