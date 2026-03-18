/// #35: AgentContext — data class holding context for Agent conversations.
class AgentContext {
  final String? chapterText;
  final String? currentWord;
  final String? currentSentence;
  final List<String> sessionLookups;
  final String? audioTitle;
  final String? chapterTitle;
  final AgentTrigger trigger;

  const AgentContext({
    this.chapterText,
    this.currentWord,
    this.currentSentence,
    this.sessionLookups = const [],
    this.audioTitle,
    this.chapterTitle,
    this.trigger = AgentTrigger.manual,
  });

  AgentContext copyWith({
    String? chapterText,
    String? currentWord,
    String? currentSentence,
    List<String>? sessionLookups,
    String? audioTitle,
    String? chapterTitle,
    AgentTrigger? trigger,
  }) {
    return AgentContext(
      chapterText: chapterText ?? this.chapterText,
      currentWord: currentWord ?? this.currentWord,
      currentSentence: currentSentence ?? this.currentSentence,
      sessionLookups: sessionLookups ?? this.sessionLookups,
      audioTitle: audioTitle ?? this.audioTitle,
      chapterTitle: chapterTitle ?? this.chapterTitle,
      trigger: trigger ?? this.trigger,
    );
  }

  /// Add a looked-up word to session lookups.
  AgentContext addLookup(String word) {
    final updated = List<String>.from(sessionLookups);
    if (!updated.contains(word)) updated.add(word);
    return copyWith(sessionLookups: updated);
  }

  /// Clear session lookups (on exit player).
  AgentContext clearLookups() {
    return copyWith(sessionLookups: []);
  }
}

enum AgentTrigger {
  manual,
  wordCard,
  chapterEnd,
  sessionOpen,
}

/// Agent conversation mode.
enum AgentMode {
  quiz,
  explain,
  freeChat,
}
