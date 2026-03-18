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

    return (_db.select(_db.audioItems)
          ..where((t) => t.id.equals(id)))
        .getSingle();
  }

  /// Delete an audio item and its file.
  /// TODO: Cascade delete chapters, transcripts, words, vocabulary, etc.
  Future<void> deleteAudio(String id) async {
    final item = await (_db.select(_db.audioItems)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();

    if (item != null) {
      // Delete the physical file
      final file = File(item.filePath);
      if (await file.exists()) {
        await file.delete();
      }

      // Delete from DB
      await (_db.delete(_db.audioItems)
            ..where((t) => t.id.equals(id)))
          .go();

      // TODO: Cascade delete related records (chapters, transcripts, words, etc.)
    }
  }

  /// Get a single audio item by ID
  Future<AudioItem?> getAudioItem(String id) async {
    return (_db.select(_db.audioItems)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Update transcription status
  Future<void> updateTranscriptionStatus(
      String id, String status) async {
    await (_db.update(_db.audioItems)
          ..where((t) => t.id.equals(id)))
        .write(AudioItemsCompanion(
      transcriptionStatus: Value(status),
    ));
  }
}
