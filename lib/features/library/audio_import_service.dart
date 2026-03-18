import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

/// Handles audio file import from Share Extension / Intent Filter
/// and file picker.
class AudioImportService {
  static const int _largeSizeThreshold = 25 * 1024 * 1024; // 25 MB

  /// Listen for shared files from other apps (iOS Share Extension / Android Intent)
  Stream<List<SharedMediaFile>> get sharedFilesStream {
    return ReceiveSharingIntent.instance.getMediaStream();
  }

  /// Get initial shared files (when app is opened via share)
  Future<List<SharedMediaFile>> getInitialSharedFiles() async {
    return ReceiveSharingIntent.instance.getInitialMedia();
  }

  /// Import an audio file to app's local storage.
  /// Returns the destination path and whether the file is large (>25MB).
  Future<ImportResult> importAudioFile(String sourcePath) async {
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      throw FileSystemException('Source file does not exist', sourcePath);
    }

    final fileSize = await sourceFile.length();
    final isLargeFile = fileSize > _largeSizeThreshold;

    final appDir = await getApplicationDocumentsDirectory();
    final audioDir = Directory(p.join(appDir.path, 'audio'));
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }

    final sanitizedName = _sanitizeFileName(p.basename(sourcePath));
    final destPath = p.join(audioDir.path, sanitizedName);

    // Avoid overwriting: append timestamp if file exists
    final destFile = File(destPath);
    String finalPath = destPath;
    if (await destFile.exists()) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ext = p.extension(sanitizedName);
      final nameWithoutExt = p.basenameWithoutExtension(sanitizedName);
      finalPath = p.join(audioDir.path, '${nameWithoutExt}_$timestamp$ext');
    }

    await sourceFile.copy(finalPath);

    return ImportResult(
      filePath: finalPath,
      fileName: p.basenameWithoutExtension(finalPath),
      isLargeFile: isLargeFile,
      fileSizeBytes: fileSize,
    );
  }

  /// Sanitize a file name: replace spaces and special characters
  String _sanitizeFileName(String fileName) {
    return fileName
        .replaceAll(RegExp(r'[^\w\d\-_.]'), '_')
        .replaceAll(RegExp(r'_+'), '_');
  }
}

class ImportResult {
  final String filePath;
  final String fileName;
  final bool isLargeFile;
  final int fileSizeBytes;

  ImportResult({
    required this.filePath,
    required this.fileName,
    required this.isLargeFile,
    required this.fileSizeBytes,
  });
}
