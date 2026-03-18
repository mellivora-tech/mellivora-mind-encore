import 'package:drift/drift.dart';

/// 1. audio_items — imported audio files
class AudioItems extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get filePath => text()();
  IntColumn get durationMs => integer().nullable()();
  TextColumn get transcriptionStatus =>
      text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// 2. chapters — segments of an audio file
class Chapters extends Table {
  TextColumn get id => text()();
  TextColumn get audioId =>
      text().references(AudioItems, #id)();
  IntColumn get index => integer()();
  TextColumn get title => text().withDefault(const Constant(''))();
  IntColumn get startMs => integer()();
  IntColumn get endMs => integer()();
  BoolColumn get isHeard =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 3. transcripts — transcription segments with offset adjustment
class Transcripts extends Table {
  TextColumn get id => text()();
  TextColumn get audioId =>
      text().references(AudioItems, #id)();
  IntColumn get segmentIndex => integer()();
  TextColumn get text_ => text().named('text')();
  IntColumn get startMs => integer()();
  IntColumn get endMs => integer()();
  IntColumn get offsetAdjust =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 4. words — individual words within a transcript segment
class Words extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get wordText => text()();
  IntColumn get startMs => integer()();
  IntColumn get endMs => integer()();
  TextColumn get transcriptId =>
      text().references(Transcripts, #id)();
}

/// 5. vocabulary — user's collected vocabulary
class Vocabulary extends Table {
  TextColumn get id => text()();
  TextColumn get word => text()();
  TextColumn get phonetic => text().withDefault(const Constant(''))();
  TextColumn get pos => text().withDefault(const Constant(''))();
  TextColumn get meaning => text().withDefault(const Constant(''))();
  TextColumn get definition => text().withDefault(const Constant(''))();
  TextColumn get audioId =>
      text().references(AudioItems, #id)();
  TextColumn get chapterId =>
      text().nullable().references(Chapters, #id)();
  IntColumn get sourceOffsetMs =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  IntColumn get reviewCount =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 6. playback_state — resume playback position
class PlaybackState extends Table {
  TextColumn get audioId =>
      text().references(AudioItems, #id)();
  TextColumn get lastChapterId => text().nullable()();
  IntColumn get lastPositionMs =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {audioId};
}

/// 7. word_memory — spaced repetition tracking per word
class WordMemory extends Table {
  TextColumn get wordId =>
      text().references(Vocabulary, #id)();
  IntColumn get queryCount =>
      integer().withDefault(const Constant(0))();
  IntColumn get quizAttempts =>
      integer().withDefault(const Constant(0))();
  IntColumn get quizCorrect =>
      integer().withDefault(const Constant(0))();
  RealColumn get masteryLevel =>
      real().withDefault(const Constant(0.0))();
  BoolColumn get weakFlag =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastQueriedAt => dateTime().nullable()();
  DateTimeColumn get lastQuizzedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {wordId};
}

/// 8. content_memory — per-audio learning progress
class ContentMemory extends Table {
  TextColumn get audioId =>
      text().references(AudioItems, #id)();
  IntColumn get chaptersHeard =>
      integer().withDefault(const Constant(0))();
  IntColumn get wordsQueried =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get lastHeardAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {audioId};
}

/// 9. agent_sessions — AI agent conversation sessions
class AgentSessions extends Table {
  TextColumn get id => text()();
  TextColumn get trigger => text()();
  TextColumn get audioId =>
      text().nullable().references(AudioItems, #id)();
  TextColumn get chapterId =>
      text().nullable().references(Chapters, #id)();
  TextColumn get messagesJson =>
      text().withDefault(const Constant('[]'))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// 10. review_schedule — spaced repetition scheduling
class ReviewSchedule extends Table {
  TextColumn get wordId =>
      text().references(Vocabulary, #id)();
  DateTimeColumn get nextReviewAt => dateTime()();
  IntColumn get reviewCount =>
      integer().withDefault(const Constant(0))();
  TextColumn get lastResult =>
      text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {wordId};
}

/// 11. weakness_profile — detected weak areas per word
class WeaknessProfile extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get wordId =>
      text().references(Vocabulary, #id)();
  TextColumn get weakType =>
      text().withDefault(const Constant('vocabulary'))();
  TextColumn get context_ => text().named('context').withDefault(const Constant(''))();
  DateTimeColumn get detectedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// 12. learning_patterns — user learning behavior analytics
class LearningPatterns extends Table {
  TextColumn get id => text()();
  TextColumn get estimatedLevel =>
      text().withDefault(const Constant('B1'))();
  TextColumn get levelBasis =>
      text().withDefault(const Constant(''))();
  TextColumn get activeHours =>
      text().withDefault(const Constant(''))();
  IntColumn get avgSessionMin =>
      integer().withDefault(const Constant(0))();
  TextColumn get preferredTopics =>
      text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
