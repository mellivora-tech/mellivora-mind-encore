import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';
import '../database/database_provider.dart';

// ── Loop Mode (#22) ─────────────────────────────────────────
enum ChapterLoopMode { none, chapter, all }

// ── AudioHandler (audio_service integration) ─────────────────
class EncoreAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player;
  final void Function()? onSkipToPrevious;
  final void Function()? onSkipToNext;

  EncoreAudioHandler({
    required AudioPlayer player,
    this.onSkipToPrevious,
    this.onSkipToNext,
  }) : _player = player {
    // Broadcast playback state changes to lock screen / notification
    _player.playbackEventStream.listen(_broadcastState);

    // Broadcast current media item duration
    _player.durationStream.listen((duration) {
      final item = mediaItem.value;
      if (item != null && duration != null) {
        mediaItem.add(item.copyWith(duration: duration));
      }
    });
  }

  void _broadcastState(PlaybackEvent event) {
    final playing = _player.playing;
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: switch (_player.processingState) {
        ProcessingState.idle => AudioProcessingState.idle,
        ProcessingState.loading => AudioProcessingState.loading,
        ProcessingState.buffering => AudioProcessingState.buffering,
        ProcessingState.ready => AudioProcessingState.ready,
        ProcessingState.completed => AudioProcessingState.completed,
      },
      playing: playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    ));
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToPrevious() async {
    onSkipToPrevious?.call();
  }

  @override
  Future<void> skipToNext() async {
    onSkipToNext?.call();
  }

  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  void updateMediaItem(MediaItem item) {
    mediaItem.add(item);
  }
}

// ── Player State ─────────────────────────────────────────────
class PlayerState {
  final String? audioId;
  final String audioTitle;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final int currentChapterIndex;
  final List<Chapter> chapters;
  final double speed;
  final ChapterLoopMode loopMode;
  final int? loopingChapterIndex; // which chapter is set to loop (for chapter mode)
  final bool isCompleted; // #23: all chapters played

  const PlayerState({
    this.audioId,
    this.audioTitle = '',
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.currentChapterIndex = 0,
    this.chapters = const [],
    this.speed = 1.0,
    this.loopMode = ChapterLoopMode.none,
    this.loopingChapterIndex,
    this.isCompleted = false,
  });

  /// Helper: is the current chapter in single-chapter loop mode
  bool get isCurrentChapterLooping =>
      loopMode == ChapterLoopMode.chapter &&
      loopingChapterIndex == currentChapterIndex;

  PlayerState copyWith({
    String? audioId,
    String? audioTitle,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    int? currentChapterIndex,
    List<Chapter>? chapters,
    double? speed,
    ChapterLoopMode? loopMode,
    int? Function()? loopingChapterIndex,
    bool? isCompleted,
  }) {
    return PlayerState(
      audioId: audioId ?? this.audioId,
      audioTitle: audioTitle ?? this.audioTitle,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      currentChapterIndex: currentChapterIndex ?? this.currentChapterIndex,
      chapters: chapters ?? this.chapters,
      speed: speed ?? this.speed,
      loopMode: loopMode ?? this.loopMode,
      loopingChapterIndex: loopingChapterIndex != null
          ? loopingChapterIndex()
          : this.loopingChapterIndex,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// ── AudioPlayerNotifier ──────────────────────────────────────
class AudioPlayerNotifier extends StateNotifier<PlayerState> {
  final AudioPlayer _player = AudioPlayer();
  late final EncoreAudioHandler _handler;
  final AppDatabase _db;

  Timer? _saveTimer;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<ProcessingState>? _processingStateSub;

  AudioPlayerNotifier(this._db) : super(const PlayerState()) {
    _initHandler();
    _loadSavedSpeed();
    _startPositionListener();
    _startProcessingStateListener();
    _startPeriodicSave();
  }

  AudioPlayer get player => _player;

  Future<void> _initHandler() async {
    _handler = await AudioService.init(
      builder: () => EncoreAudioHandler(
        player: _player,
        onSkipToPrevious: skipToPreviousChapter,
        onSkipToNext: skipToNextChapter,
      ),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.mellivora.encore.audio',
        androidNotificationChannelName: 'Encore Audio',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
    );
  }

  // ── Load & Play ──

  Future<void> loadAndPlay({
    required String audioId,
    required String filePath,
    required String title,
    int startChapterIndex = 0,
    Duration startPosition = Duration.zero,
  }) async {
    // Load chapters from DB
    final chapters = await (_db.select(_db.chapters)
          ..where((t) => t.audioId.equals(audioId))
          ..orderBy([(t) => OrderingTerm.asc(t.index)]))
        .get();

    // Load audio
    final duration = await _player.setFilePath(filePath);

    state = state.copyWith(
      audioId: audioId,
      audioTitle: title,
      chapters: chapters,
      duration: duration ?? Duration.zero,
      currentChapterIndex: startChapterIndex,
      position: startPosition,
      isCompleted: false,
    );

    // Update media item for lock screen
    _handler.updateMediaItem(MediaItem(
      id: audioId,
      title: title,
      duration: duration,
    ));

    // Seek to start position
    if (startPosition > Duration.zero) {
      await _player.seek(startPosition);
    }

    await _player.play();
    state = state.copyWith(isPlaying: true);
  }

  // ── Playback Controls ──

  Future<void> playPause() async {
    if (_player.playing) {
      await _player.pause();
      state = state.copyWith(isPlaying: false);
    } else {
      // If completed, restart from beginning
      if (state.isCompleted) {
        await _player.seek(Duration.zero);
        state = state.copyWith(
          isCompleted: false,
          currentChapterIndex: 0,
          position: Duration.zero,
        );
      }
      await _player.play();
      state = state.copyWith(isPlaying: true);
    }
  }

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
    state = state.copyWith(position: position, isCompleted: false);
    _updateCurrentChapterFromPosition(position);
  }

  Future<void> seekRelative(Duration offset) async {
    final newPos = _player.position + offset;
    final clamped = Duration(
      milliseconds: newPos.inMilliseconds
          .clamp(0, state.duration.inMilliseconds),
    );
    await seekTo(clamped);
  }

  // ── Chapter Navigation ──

  Future<void> seekToChapter(int index) async {
    if (index < 0 || index >= state.chapters.length) return;

    // Mark previous chapter as heard
    if (state.chapters.isNotEmpty) {
      final prevChapter = state.chapters[state.currentChapterIndex];
      await (_db.update(_db.chapters)
            ..where((t) => t.id.equals(prevChapter.id)))
          .write(const ChaptersCompanion(isHeard: Value(true)));
    }

    final chapter = state.chapters[index];
    final position = Duration(milliseconds: chapter.startMs);
    await _player.seek(position);

    state = state.copyWith(
      currentChapterIndex: index,
      position: position,
      isCompleted: false,
    );

    if (!_player.playing) {
      await _player.play();
      state = state.copyWith(isPlaying: true);
    }
  }

  void skipToNextChapter() {
    if (state.currentChapterIndex < state.chapters.length - 1) {
      seekToChapter(state.currentChapterIndex + 1);
    } else if (state.loopMode == ChapterLoopMode.all) {
      seekToChapter(0);
    }
  }

  void skipToPreviousChapter() {
    // If more than 3s into chapter, restart it; otherwise go to previous
    if (_player.position.inSeconds > 3 && state.currentChapterIndex > 0) {
      seekToChapter(state.currentChapterIndex);
    } else if (state.currentChapterIndex > 0) {
      seekToChapter(state.currentChapterIndex - 1);
    } else {
      seekToChapter(0);
    }
  }

  // ── Speed Control (#17) ──

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
    state = state.copyWith(speed: speed);
    // Persist to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('playback_speed', speed);
  }

  Future<void> _loadSavedSpeed() async {
    final prefs = await SharedPreferences.getInstance();
    final speed = prefs.getDouble('playback_speed') ?? 1.0;
    await _player.setSpeed(speed);
    state = state.copyWith(speed: speed);
  }

  // ── Loop Control (#22) ──

  /// Cycle loop mode: none → chapter → all → none
  void cycleLoopMode() {
    switch (state.loopMode) {
      case ChapterLoopMode.none:
        // Switch to chapter loop for current chapter
        state = state.copyWith(
          loopMode: ChapterLoopMode.chapter,
          loopingChapterIndex: () => state.currentChapterIndex,
        );
        break;
      case ChapterLoopMode.chapter:
        // Switch to all loop
        state = state.copyWith(
          loopMode: ChapterLoopMode.all,
          loopingChapterIndex: () => null,
        );
        break;
      case ChapterLoopMode.all:
        // Switch to none
        state = state.copyWith(
          loopMode: ChapterLoopMode.none,
          loopingChapterIndex: () => null,
        );
        break;
    }
  }

  /// Set single chapter loop for a specific chapter (#21 long-press menu)
  void setChapterLoop(int chapterIndex) {
    state = state.copyWith(
      loopMode: ChapterLoopMode.chapter,
      loopingChapterIndex: () => chapterIndex,
    );
  }

  /// Clear loop mode
  void clearLoop() {
    state = state.copyWith(
      loopMode: ChapterLoopMode.none,
      loopingChapterIndex: () => null,
    );
  }

  // ── Position Tracking & Chapter Detection ──

  void _startPositionListener() {
    _positionSub = _player.positionStream.listen((position) {
      state = state.copyWith(position: position);
      _updateCurrentChapterFromPosition(position);
      _handleChapterBoundary(position);
    });
  }

  void _updateCurrentChapterFromPosition(Duration position) {
    if (state.chapters.isEmpty) return;
    final posMs = position.inMilliseconds;

    for (int i = 0; i < state.chapters.length; i++) {
      final ch = state.chapters[i];
      if (posMs >= ch.startMs && posMs < ch.endMs) {
        if (i != state.currentChapterIndex) {
          // Mark previous chapter as heard
          if (i > state.currentChapterIndex) {
            final prevChapter = state.chapters[state.currentChapterIndex];
            try {
              (_db.update(_db.chapters)
                    ..where((t) => t.id.equals(prevChapter.id)))
                  .write(const ChaptersCompanion(isHeard: Value(true)));
            } catch (e) {
              debugPrint('Failed to mark chapter heard: $e');
            }
          }
          state = state.copyWith(currentChapterIndex: i);
        }
        return;
      }
    }
  }

  /// #22: Handle chapter boundary for single-chapter loop
  void _handleChapterBoundary(Duration position) {
    if (state.loopMode != ChapterLoopMode.chapter) return;
    if (state.chapters.isEmpty) return;

    final loopIdx = state.loopingChapterIndex;
    if (loopIdx == null || loopIdx >= state.chapters.length) return;

    final chapter = state.chapters[loopIdx];
    final posMs = position.inMilliseconds;

    // If we've reached the end of the looping chapter, seek back to start
    if (posMs >= chapter.endMs - 200) {
      // 200ms tolerance
      _player.seek(Duration(milliseconds: chapter.startMs));
    }
  }

  // ── Processing State (#23: auto-advance / completion) ──

  void _startProcessingStateListener() {
    _processingStateSub =
        _player.processingStateStream.listen((processingState) {
      if (processingState == ProcessingState.completed) {
        _onPlaybackCompleted();
      }
    });
  }

  void _onPlaybackCompleted() {
    // Mark current/last chapter as heard
    if (state.chapters.isNotEmpty) {
      final lastChapter = state.chapters[state.currentChapterIndex];
      try {
        (_db.update(_db.chapters)
              ..where((t) => t.id.equals(lastChapter.id)))
            .write(const ChaptersCompanion(isHeard: Value(true)));
      } catch (e) {
        debugPrint('Failed to mark chapter heard: $e');
      }
    }

    if (state.loopMode == ChapterLoopMode.all) {
      // Loop all: restart from chapter 0
      seekToChapter(0);
    } else if (state.loopMode == ChapterLoopMode.chapter) {
      // Single chapter loop: seek back to looping chapter start
      final loopIdx = state.loopingChapterIndex ?? state.currentChapterIndex;
      if (loopIdx < state.chapters.length) {
        _player.seek(Duration(milliseconds: state.chapters[loopIdx].startMs));
        _player.play();
      }
    } else {
      // #23: Mark as completed, update playback_state
      state = state.copyWith(isPlaying: false, isCompleted: true);
      _markAudioCompleted();
    }
  }

  /// #23: Mark playback_state.completed = true in DB
  Future<void> _markAudioCompleted() async {
    final audioId = state.audioId;
    if (audioId == null) return;

    await _db.into(_db.playbackState).insertOnConflictUpdate(
          PlaybackStateCompanion(
            audioId: Value(audioId),
            lastPositionMs: Value(state.duration.inMilliseconds),
            lastChapterId: Value(state.chapters.isNotEmpty
                ? state.chapters.last.id
                : null),
          ),
        );
  }

  // ── Playback Persistence (#18) — save every 5 seconds ──

  void _startPeriodicSave() {
    _saveTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _savePlaybackState();
    });
  }

  Future<void> _savePlaybackState() async {
    final audioId = state.audioId;
    if (audioId == null) return;

    String? chapterId;
    if (state.chapters.isNotEmpty &&
        state.currentChapterIndex < state.chapters.length) {
      chapterId = state.chapters[state.currentChapterIndex].id;
    }

    await _db.into(_db.playbackState).insertOnConflictUpdate(
          PlaybackStateCompanion(
            audioId: Value(audioId),
            lastChapterId: Value(chapterId),
            lastPositionMs: Value(_player.position.inMilliseconds),
          ),
        );
  }

  // ── Restore Playback State (#18) ──

  static Future<PlaybackStateData?> getPlaybackState(
      AppDatabase db, String audioId) async {
    return (db.select(db.playbackState)
          ..where((t) => t.audioId.equals(audioId)))
        .getSingleOrNull();
  }

  // ── Cleanup ──

  @override
  void dispose() {
    _savePlaybackState(); // Final save
    _saveTimer?.cancel();
    _positionSub?.cancel();
    _playerStateSub?.cancel();
    _processingStateSub?.cancel();
    _player.dispose();
    super.dispose();
  }
}

// ── Riverpod Provider ────────────────────────────────────────
final audioPlayerProvider =
    StateNotifierProvider<AudioPlayerNotifier, PlayerState>((ref) {
  final db = ref.read(databaseProvider);
  return AudioPlayerNotifier(db);
});
