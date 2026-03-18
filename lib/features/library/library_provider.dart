import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import 'audio_import_service.dart';
import 'audio_repository.dart';

final audioImportServiceProvider = Provider<AudioImportService>((ref) {
  return AudioImportService();
});

final audioRepositoryProvider = Provider<AudioRepository>((ref) {
  final db = ref.read(databaseProvider);
  return AudioRepository(db);
});

final audioItemsStreamProvider = StreamProvider<List<AudioItem>>((ref) {
  final repo = ref.read(audioRepositoryProvider);
  return repo.watchAllAudioItems();
});

final libraryActionsProvider = Provider<LibraryActions>((ref) {
  return LibraryActions(
    repository: ref.read(audioRepositoryProvider),
    importService: ref.read(audioImportServiceProvider),
  );
});

class LibraryActions {
  final AudioRepository repository;
  final AudioImportService importService;
  final _uuid = const Uuid();

  LibraryActions({
    required this.repository,
    required this.importService,
  });

  /// Import a file from a given path
  Future<ImportActionResult> importFromPath(String sourcePath) async {
    final result = await importService.importAudioFile(sourcePath);
    final id = _uuid.v4();

    final audioItem = await repository.addAudioItem(
      id: id,
      title: result.fileName,
      filePath: result.filePath,
    );

    return ImportActionResult(
      audioItem: audioItem,
      isLargeFile: result.isLargeFile,
    );
  }
}

class ImportActionResult {
  final AudioItem audioItem;
  final bool isLargeFile;

  ImportActionResult({
    required this.audioItem,
    required this.isLargeFile,
  });
}
