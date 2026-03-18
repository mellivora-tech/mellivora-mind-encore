import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';

/// #34: Ebbinghaus forgetting curve scheduling.
/// Intervals: [1, 2, 4, 7, 15, 30] days.
class ReviewRepository {
  final AppDatabase _db;

  static const _intervals = [1, 2, 4, 7, 15, 30];

  ReviewRepository(this._db);

  /// Get today's review queue (words due for review).
  Future<List<ReviewItem>> getTodayReviewQueue() async {
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final schedules = await (_db.select(_db.reviewSchedule)
          ..where((t) => t.nextReviewAt.isSmallerOrEqualValue(endOfDay))
          ..orderBy([(t) => OrderingTerm.asc(t.nextReviewAt)]))
        .get();

    final items = <ReviewItem>[];
    for (final schedule in schedules) {
      final vocab = await (_db.select(_db.vocabulary)
            ..where((t) => t.id.equals(schedule.wordId)))
          .getSingleOrNull();
      if (vocab == null) continue;

      // Get source sentence from transcripts
      String sourceSentence = '';
      if (vocab.sourceOffsetMs > 0) {
        final transcript = await (_db.select(_db.transcripts)
              ..where((t) =>
                  t.audioId.equals(vocab.audioId) &
                  t.startMs.isSmallerOrEqualValue(vocab.sourceOffsetMs) &
                  t.endMs.isBiggerOrEqualValue(vocab.sourceOffsetMs)))
            .getSingleOrNull();
        sourceSentence = transcript?.text_ ?? '';
      }

      items.add(ReviewItem(
        vocab: vocab,
        schedule: schedule,
        sourceSentence: sourceSentence,
      ));
    }
    return items;
  }

  /// Mark word as "remembered" — advance review schedule.
  Future<void> markRemembered(String wordId) async {
    final schedule = await (_db.select(_db.reviewSchedule)
          ..where((t) => t.wordId.equals(wordId)))
        .getSingleOrNull();

    if (schedule == null) return;

    final newCount = schedule.reviewCount + 1;
    final intervalIdx =
        (newCount - 1).clamp(0, _intervals.length - 1);
    final nextDays = _intervals[intervalIdx];
    final nextReview = DateTime.now().add(Duration(days: nextDays));

    await (_db.update(_db.reviewSchedule)
          ..where((t) => t.wordId.equals(wordId)))
        .write(ReviewScheduleCompanion(
      reviewCount: Value(newCount),
      nextReviewAt: Value(nextReview),
      lastResult: const Value('correct'),
    ));

    // Update word_memory: quiz_correct + 1, quiz_attempts + 1
    await _updateWordMemoryOnQuiz(wordId, correct: true);
  }

  /// Mark word as "forgotten" — schedule for end of today, review again tomorrow.
  Future<void> markForgotten(String wordId) async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    await (_db.update(_db.reviewSchedule)
          ..where((t) => t.wordId.equals(wordId)))
        .write(ReviewScheduleCompanion(
      nextReviewAt: Value(tomorrow),
      lastResult: const Value('incorrect'),
    ));

    // Update word_memory: quiz_attempts + 1 (no correct increment)
    await _updateWordMemoryOnQuiz(wordId, correct: false);
  }

  /// Update word_memory stats after a quiz attempt.
  Future<void> _updateWordMemoryOnQuiz(String wordId,
      {required bool correct}) async {
    final existing = await (_db.select(_db.wordMemory)
          ..where((t) => t.wordId.equals(wordId)))
        .getSingleOrNull();

    if (existing == null) return;

    final newAttempts = existing.quizAttempts + 1;
    final newCorrect = existing.quizCorrect + (correct ? 1 : 0);

    // Mastery level calculation:
    // correct >= 1 → level 2
    // correct >= 3 → level 3
    // correct >= 5 and last quiz > 7 days ago → level 4
    double mastery = existing.masteryLevel;
    if (correct) {
      if (newCorrect >= 5) {
        final daysSinceLastQuiz = existing.lastQuizzedAt != null
            ? DateTime.now().difference(existing.lastQuizzedAt!).inDays
            : 0;
        mastery = daysSinceLastQuiz >= 7 ? 4.0 : 3.0;
      } else if (newCorrect >= 3) {
        mastery = 3.0;
      } else if (newCorrect >= 1) {
        mastery = 2.0;
      }
    }

    // weak_flag: queried 3+ times but mastery < 2
    final weak = existing.queryCount >= 3 && mastery < 2;

    await (_db.update(_db.wordMemory)
          ..where((t) => t.wordId.equals(wordId)))
        .write(WordMemoryCompanion(
      quizAttempts: Value(newAttempts),
      quizCorrect: Value(newCorrect),
      masteryLevel: Value(mastery),
      weakFlag: Value(weak),
      lastQuizzedAt: Value(DateTime.now()),
    ));
  }

  /// Get review count for today.
  Future<int> getTodayReviewCount() async {
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final query = _db.selectOnly(_db.reviewSchedule)
      ..addColumns([_db.reviewSchedule.wordId.count()])
      ..where(_db.reviewSchedule.nextReviewAt.isSmallerOrEqualValue(endOfDay));
    final result = await query.getSingle();
    return result.read(_db.reviewSchedule.wordId.count()) ?? 0;
  }
}

class ReviewItem {
  final VocabularyData vocab;
  final ReviewScheduleData schedule;
  final String sourceSentence;

  ReviewItem({
    required this.vocab,
    required this.schedule,
    this.sourceSentence = '',
  });
}

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  final db = ref.read(databaseProvider);
  return ReviewRepository(db);
});
