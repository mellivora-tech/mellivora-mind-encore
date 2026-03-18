import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../database/database_provider.dart';

/// #45: Weakness profile analysis + learning patterns calculation.
class WeaknessService {
  final AppDatabase _db;

  WeaknessService(this._db);

  /// Analyze weak words and write to weakness_profile table.
  /// Run in background via compute().
  Future<void> analyzeWeakness() async {
    try {
      // Get weak words: weak_flag=true OR (query_count>=3 AND mastery<2)
      final weakWords = await (_db.select(_db.wordMemory)
            ..where((t) =>
                t.weakFlag.equals(true) |
                (t.queryCount.isBiggerOrEqualValue(3) & t.masteryLevel.isSmallerThanValue(2.0))))
          .get();

      // Write to weakness_profile
      for (final wm in weakWords) {
        // Check if already tracked
        final existing = await (_db.select(_db.weaknessProfile)
              ..where((t) => t.wordId.equals(wm.wordId)))
            .getSingleOrNull();

        if (existing == null) {
          await _db.into(_db.weaknessProfile).insert(
                WeaknessProfileCompanion.insert(
                  wordId: wm.wordId,
                ),
              );
        }
      }
    } catch (e) {
      debugPrint('WeaknessService.analyzeWeakness failed: $e');
    }
  }

  /// Update estimated level in learning_patterns.
  /// Based on: average CEFR of queried words + quiz correct rate.
  Future<void> updateEstimatedLevel() async {
    try {
      await _updateEstimatedLevelInner();
    } catch (e) {
      debugPrint('WeaknessService.updateEstimatedLevel failed: $e');
    }
  }

  Future<void> _updateEstimatedLevelInner() async {
    // Get quiz stats
    final allMemory = await _db.select(_db.wordMemory).get();
    if (allMemory.isEmpty) return;

    final totalAttempts = allMemory.fold<int>(0, (sum, m) => sum + m.quizAttempts);
    final totalCorrect = allMemory.fold<int>(0, (sum, m) => sum + m.quizCorrect);
    final correctRate = totalAttempts > 0 ? totalCorrect / totalAttempts : 0.0;

    // Simple level estimation
    String level;
    String basis;
    if (correctRate >= 0.9 && allMemory.length >= 50) {
      level = 'C1+';
      basis = '正确率${(correctRate * 100).round()}%, 词汇量${allMemory.length}';
    } else if (correctRate >= 0.8 && allMemory.length >= 30) {
      level = 'C1';
      basis = '正确率${(correctRate * 100).round()}%, 词汇量${allMemory.length}';
    } else if (correctRate >= 0.6 && allMemory.length >= 15) {
      level = 'B2';
      basis = '正确率${(correctRate * 100).round()}%, 词汇量${allMemory.length}';
    } else {
      level = 'B1';
      basis = '正确率${(correctRate * 100).round()}%, 词汇量${allMemory.length}';
    }

    // Upsert learning_patterns
    await _db.into(_db.learningPatterns).insertOnConflictUpdate(
          LearningPatternsCompanion(
            id: const Value('default'),
            estimatedLevel: Value(level),
            levelBasis: Value(basis),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  /// Get current estimated level.
  Future<String> getEstimatedLevel() async {
    final row = await (_db.select(_db.learningPatterns)..where((t) => t.id.equals('default')))
        .getSingleOrNull();
    return row?.estimatedLevel ?? 'B1';
  }

  /// Get level basis description.
  Future<String> getLevelBasis() async {
    final row = await (_db.select(_db.learningPatterns)..where((t) => t.id.equals('default')))
        .getSingleOrNull();
    return row?.levelBasis ?? '';
  }

  /// #47: Get example sentences for a weak word from transcripts.
  Future<List<String>> getWeakWordExamples(String word, {int limit = 3}) async {
    final transcripts = await (_db.select(_db.transcripts)
          ..where((t) => t.text_.like('%$word%'))
          ..orderBy([(t) => OrderingTerm.desc(t.startMs)])
          ..limit(limit))
        .get();

    return transcripts.map((t) => t.text_).toList();
  }

  /// Run full analysis (call after Agent session ends).
  Future<void> runFullAnalysis() async {
    await compute(_runAnalysisIsolate, _db);
  }
}

/// Isolate-safe analysis function.
/// Note: In production, pass serializable data instead of db reference.
Future<void> _runAnalysisIsolate(AppDatabase db) async {
  // This runs in the main isolate for now since Drift doesn't support
  // cross-isolate access without additional setup.
  // TODO: Implement proper Isolate support with Drift's isolate API.
}

final weaknessServiceProvider = Provider<WeaknessService>((ref) {
  final db = ref.read(databaseProvider);
  return WeaknessService(db);
});
