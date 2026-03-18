import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/services/audio_player_service.dart';
import '../../core/services/subtitle_service.dart';
import 'agent_context.dart';

/// #35: Riverpod provider for AgentContext.
/// Updates in real-time as player state and subtitle change.
final agentContextProvider = StateNotifierProvider<AgentContextNotifier, AgentContext>((ref) {
  return AgentContextNotifier(ref);
});

class AgentContextNotifier extends StateNotifier<AgentContext> {
  final Ref _ref;

  AgentContextNotifier(this._ref) : super(const AgentContext()) {
    // Listen to player state changes
    _ref.listen(audioPlayerProvider, (prev, next) {
      _updateFromPlayerState(next);
    });

    // Listen to subtitle changes
    _ref.listen(subtitleServiceProvider, (prev, next) {
      if (next.currentSegment != null) {
        state = state.copyWith(
          currentSentence: next.currentSegment!.text,
        );
      }
    });
  }

  void _updateFromPlayerState(PlayerState playerState) {
    String? chapterTitle;
    if (playerState.chapters.isNotEmpty &&
        playerState.currentChapterIndex < playerState.chapters.length) {
      final ch = playerState.chapters[playerState.currentChapterIndex];
      chapterTitle = ch.title.isNotEmpty ? ch.title : '第${playerState.currentChapterIndex + 1}章';
    }

    state = state.copyWith(
      audioTitle: playerState.audioTitle,
      chapterTitle: chapterTitle,
    );
  }

  /// Load chapter text from transcripts for current chapter.
  Future<void> loadChapterText(String audioId, int startMs, int endMs) async {
    final db = _ref.read(databaseProvider);
    final segments = await (db.select(db.transcripts)
          ..where((t) =>
              t.audioId.equals(audioId) &
              t.startMs.isBiggerOrEqualValue(startMs) &
              t.endMs.isSmallerOrEqualValue(endMs))
          ..orderBy([(t) => OrderingTerm.asc(t.startMs)]))
        .get();

    final text = segments.map((s) => s.text_).join(' ');
    state = state.copyWith(chapterText: text);
  }

  /// Add a word lookup to session.
  void addSessionLookup(String word) {
    state = state.addLookup(word);
  }

  /// Set context for word card trigger (#36).
  void setWordContext(String word, String sentence) {
    state = state.copyWith(
      currentWord: word,
      currentSentence: sentence,
      trigger: AgentTrigger.wordCard,
    );
  }

  /// Set trigger type.
  void setTrigger(AgentTrigger trigger) {
    state = state.copyWith(trigger: trigger);
  }

  /// Clear lookups on exit player.
  void clearSession() {
    state = state.clearLookups().copyWith(
          currentWord: null,
          currentSentence: null,
          trigger: AgentTrigger.manual,
        );
  }
}
