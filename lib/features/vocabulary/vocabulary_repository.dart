import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';

/// Repository for vocabulary CRUD + word_memory operations.
class VocabularyRepository {
  final AppDatabase _db;
  static const _uuid = Uuid();

  VocabularyRepository(this._db);

  /// Add word to vocabulary. If already exists, update created_at.
  Future<String> addToVocabulary({
    required String word,
    required String phonetic,
    required String pos,
    required String meaning,
    required String audioId,
    String? chapterId,
    int sourceOffsetMs = 0,
  }) async {
    // Check if word already collected from same audio
    final existing = await (_db.select(_db.vocabulary)
          ..where((t) => t.word.equals(word) & t.audioId.equals(audioId)))
        .getSingleOrNull();

    if (existing != null) {
      // Update created_at to refresh
      await (_db.update(_db.vocabulary)
            ..where((t) => t.id.equals(existing.id)))
          .write(VocabularyCompanion(
        createdAt: Value(DateTime.now()),
        phonetic: Value(phonetic),
        pos: Value(pos),
        meaning: Value(meaning),
      ));
      return existing.id;
    }

    final id = _uuid.v4();
    await _db.into(_db.vocabulary).insert(VocabularyCompanion.insert(
      id: id,
      word: word,
      phonetic: Value(phonetic),
      pos: Value(pos),
      meaning: Value(meaning),
      audioId: audioId,
      chapterId: Value(chapterId),
      sourceOffsetMs: Value(sourceOffsetMs),
    ));

    // Ensure word_memory row exists
    await _db.into(_db.wordMemory).insertOnConflictUpdate(
      WordMemoryCompanion.insert(wordId: id),
    );

    // Ensure review_schedule row — first review tomorrow
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    await _db.into(_db.reviewSchedule).insertOnConflictUpdate(
      ReviewScheduleCompanion.insert(
        wordId: id,
        nextReviewAt: tomorrow,
      ),
    );

    return id;
  }

  /// Check if a word is already in vocabulary for the given audio.
  Future<bool> isWordCollected(String word, String audioId) async {
    final row = await (_db.select(_db.vocabulary)
          ..where((t) => t.word.equals(word) & t.audioId.equals(audioId)))
        .getSingleOrNull();
    return row != null;
  }

  /// Increment query_count in word_memory, set last_queried_at, check weak_flag.
  Future<void> updateWordMemoryOnQuery(String vocabId) async {
    final existing = await (_db.select(_db.wordMemory)
          ..where((t) => t.wordId.equals(vocabId)))
        .getSingleOrNull();

    if (existing != null) {
      final newCount = existing.queryCount + 1;
      // weak_flag: queried 3+ times but mastery < 2
      final weak = newCount >= 3 && existing.masteryLevel < 2;
      await (_db.update(_db.wordMemory)
            ..where((t) => t.wordId.equals(vocabId)))
          .write(WordMemoryCompanion(
        queryCount: Value(newCount),
        lastQueriedAt: Value(DateTime.now()),
        weakFlag: Value(weak),
      ));
    } else {
      await _db.into(_db.wordMemory).insert(WordMemoryCompanion.insert(
        wordId: vocabId,
        queryCount: const Value(1),
        lastQueriedAt: Value(DateTime.now()),
      ));
    }
  }

  /// Get all vocabulary items sorted by created_at desc.
  Future<List<VocabularyItem>> getAllVocabulary() async {
    final rows = await (_db.select(_db.vocabulary)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();

    final items = <VocabularyItem>[];
    for (final row in rows) {
      // Get audio title
      final audio = await (_db.select(_db.audioItems)
            ..where((t) => t.id.equals(row.audioId)))
          .getSingleOrNull();

      items.add(VocabularyItem(
        vocab: row,
        audioTitle: audio?.title ?? '',
      ));
    }
    return items;
  }

  /// Watch all vocabulary items as stream.
  Stream<List<VocabularyData>> watchAllVocabulary() {
    return (_db.select(_db.vocabulary)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Get vocabulary items added this week.
  Future<List<VocabularyData>> getThisWeekVocabulary() async {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return (_db.select(_db.vocabulary)
          ..where((t) => t.createdAt.isBiggerOrEqualValue(weekAgo))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Get vocabulary items due for review.
  Future<List<VocabularyData>> getReviewDueVocabulary() async {
    final now = DateTime.now();
    final dueWordIds = await (_db.select(_db.reviewSchedule)
          ..where((t) => t.nextReviewAt.isSmallerOrEqualValue(now)))
        .get();

    if (dueWordIds.isEmpty) return [];

    final ids = dueWordIds.map((r) => r.wordId).toList();
    return (_db.select(_db.vocabulary)
          ..where((t) => t.id.isIn(ids))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Delete a vocabulary item and its related records.
  Future<void> deleteVocabulary(String id) async {
    await (_db.delete(_db.wordMemory)..where((t) => t.wordId.equals(id))).go();
    await (_db.delete(_db.reviewSchedule)..where((t) => t.wordId.equals(id)))
        .go();
    await (_db.delete(_db.weaknessProfile)..where((t) => t.wordId.equals(id)))
        .go();
    await (_db.delete(_db.vocabulary)..where((t) => t.id.equals(id))).go();
  }

  /// Search vocabulary by word or meaning.
  Future<List<VocabularyData>> searchVocabulary(String query) async {
    final pattern = '%$query%';
    return (_db.select(_db.vocabulary)
          ..where(
              (t) => t.word.like(pattern) | t.meaning.like(pattern))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }
}

/// Enriched vocabulary item with audio title.
class VocabularyItem {
  final VocabularyData vocab;
  final String audioTitle;

  VocabularyItem({required this.vocab, required this.audioTitle});
}

final vocabularyRepositoryProvider = Provider<VocabularyRepository>((ref) {
  final db = ref.read(databaseProvider);
  return VocabularyRepository(db);
});
