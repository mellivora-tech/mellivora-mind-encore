import 'dart:io';

import 'package:drift/drift.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import '../../core/database/app_database.dart';
import '../../core/database/tables.dart';

class AudioRepository {
  final AppDatabase _db;

  AudioRepository(this._db);

  /// Get all audio items, ordered by creation date descending
  Future<List<AudioItem>> getAllAudioItems() async {
    return (_db.select(_db.audioItems)
          ..orderBy([
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .get();
  }

  /// Stream all audio items for reactive UI
  Stream<List<AudioItem>> watchAllAudioItems() {
    return (_db.select(_db.audioItems)
          ..orderBy([
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch();
  }

  /// Add a new audio item after import.
  /// Parses duration using just_audio.
  Future<AudioItem> addAudioItem({
    required String id,
    required String title,
    required String filePath,
  }) async {
    int? durationMs;
    try {
      final player = AudioPlayer();
      final duration = await player.setFilePath(filePath);
      durationMs = duration?.inMilliseconds;
      await player.dispose();
    } catch (_) {
      // Duration parsing failed; leave null
    }

    final companion = AudioItemsCompanion.insert(
      id: id,
      title: title,
      filePath: filePath,
      durationMs: Value(durationMs),
      transcriptionStatus: const Value('pending'),
    );

    await _db.into(_db.audioItems).insert(companion);

    return (_db.select(_db.audioItems)..where((t) => t.id.equals(id))).getSingle();
  }

  /// Delete an audio item with full cascade cleanup.
  ///
  /// Deletes in order:
  /// 1. Words (linked via transcripts)
  /// 2. Transcripts
  /// 3. Vocabulary
  /// 4. Chapters
  /// 5. PlaybackState
  /// 6. ContentMemory
  /// 7. AgentSessions
  /// 8. ReviewSchedule (linked via vocabulary)
  /// 9. WordMemory (linked via vocabulary)
  /// 10. Audio file on disk
  /// 11. AudioItems DB record
  Future<void> deleteAudio(String id) async {
    final item =
        await (_db.select(_db.audioItems)..where((t) => t.id.equals(id))).getSingleOrNull();

    if (item == null) return;

    await _db.transaction(() async {
      // 1. Get all transcript IDs for this audio to delete linked words
      final transcriptIds = await (_db.selectOnly(_db.transcripts)
            ..addColumns([_db.transcripts.id])
            ..where(_db.transcripts.audioId.equals(id)))
          .map((row) => row.read(_db.transcripts.id)!)
          .get();

      if (transcriptIds.isNotEmpty) {
        // Delete words linked to these transcripts
        await (_db.delete(_db.words)..where((t) => t.transcriptId.isIn(transcriptIds))).go();
      }

      // 2. Delete transcripts
      await (_db.delete(_db.transcripts)..where((t) => t.audioId.equals(id))).go();

      // 3. Get vocabulary IDs to delete linked review_schedule + word_memory
      final vocabIds = await (_db.selectOnly(_db.vocabulary)
            ..addColumns([_db.vocabulary.id])
            ..where(_db.vocabulary.audioId.equals(id)))
          .map((row) => row.read(_db.vocabulary.id)!)
          .get();

      if (vocabIds.isNotEmpty) {
        // Delete word memory entries
        await (_db.delete(_db.wordMemory)..where((t) => t.wordId.isIn(vocabIds))).go();

        // Delete review schedule entries
        await (_db.delete(_db.reviewSchedule)..where((t) => t.wordId.isIn(vocabIds))).go();
      }

      // 4. Delete vocabulary
      await (_db.delete(_db.vocabulary)..where((t) => t.audioId.equals(id))).go();

      // 5. Delete chapters
      await (_db.delete(_db.chapters)..where((t) => t.audioId.equals(id))).go();

      // 6. Delete playback state
      await (_db.delete(_db.playbackState)..where((t) => t.audioId.equals(id))).go();

      // 7. Delete content memory
      await (_db.delete(_db.contentMemory)..where((t) => t.audioId.equals(id))).go();

      // 8. Delete agent sessions
      await (_db.delete(_db.agentSessions)..where((t) => t.audioId.equals(id))).go();

      // 9. Delete audio item from DB
      await (_db.delete(_db.audioItems)..where((t) => t.id.equals(id))).go();
    });

    // 10. Delete the physical file (outside transaction — file I/O)
    try {
      final file = File(item.filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // File deletion failure is non-critical; DB is already clean
    }
  }

  /// Get a single audio item by ID
  Future<AudioItem?> getAudioItem(String id) async {
    return (_db.select(_db.audioItems)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Update transcription status
  Future<void> updateTranscriptionStatus(String id, String status) async {
    await (_db.update(_db.audioItems)..where((t) => t.id.equals(id))).write(AudioItemsCompanion(
      transcriptionStatus: Value(status),
    ));
  }
}
