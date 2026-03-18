import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';
import '../database/database_provider.dart';

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
  final bool isLooping;

  const PlayerState({
    this.audioId,
    this.audioTitle = '',
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.currentChapterIndex = 0,
    this.chapters = const [],
    this.speed = 1.0,
    this.isLooping = false,
  });

  PlayerState copyWith({
    String? audioId,
    String? audioTitle,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    int? currentChapterIndex,
    List<Chapter>? chapters,
    double? speed,
    bool? isLooping,
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
      isLooping: isLooping ?? this.isLooping,
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
      await _player.play();
      state = state.copyWith(isPlaying: true);
    }
  }

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
    state = state.copyWith(position: position);
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
    );

    if (!_player.playing) {
      await _player.play();
      state = state.copyWith(isPlaying: true);
    }
  }

  void skipToNextChapter() {
    if (state.currentChapterIndex < state.chapters.length - 1) {
      seekToChapter(state.currentChapterIndex + 1);
    } else if (state.isLooping) {
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

  // ── Loop Control ──

  void toggleLoop() {
    final newLooping = !state.isLooping;
    _player.setLoopMode(newLooping ? LoopMode.all : LoopMode.off);
    state = state.copyWith(isLooping: newLooping);
  }

  // ── Position Tracking & Chapter Detection ──

  void _startPositionListener() {
    _positionSub = _player.positionStream.listen((position) {
      state = state.copyWith(position: position);
      _updateCurrentChapterFromPosition(position);
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
            (_db.update(_db.chapters)
                  ..where((t) => t.id.equals(prevChapter.id)))
                .write(const ChaptersCompanion(isHeard: Value(true)));
          }
          state = state.copyWith(currentChapterIndex: i);
        }
        return;
      }
    }
  }

  // ── Processing State (auto-advance / completion) ──

  void _startProcessingStateListener() {
    _processingStateSub =
        _player.processingStateStream.listen((processingState) {
      if (processingState == ProcessingState.completed) {
        // Mark last chapter as heard
        if (state.chapters.isNotEmpty) {
          final lastChapter = state.chapters[state.currentChapterIndex];
          (_db.update(_db.chapters)
                ..where((t) => t.id.equals(lastChapter.id)))
              .write(const ChaptersCompanion(isHeard: Value(true)));
        }

        if (state.isLooping) {
          seekToChapter(0);
        } else {
          state = state.copyWith(isPlaying: false);
        }
      }
    });
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
