import 'dart:async';

import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'audio_import_service.dart';

/// Handles incoming share intents (iOS Share Extension / Android Intent Filter).
/// Should be initialized once in the app lifecycle.
class ShareIntentHandler {
  final AudioImportService _importService;
  final void Function(String filePath) onFileReceived;
  final void Function(String error)? onError;

  StreamSubscription? _subscription;

  ShareIntentHandler({
    required AudioImportService importService,
    required this.onFileReceived,
    this.onError,
  }) : _importService = importService;

  /// Start listening for shared files
  void init() {
    // Handle files shared while app is running
    _subscription = _importService.sharedFilesStream.listen(
      (files) => _handleSharedFiles(files),
      onError: (error) => onError?.call(error.toString()),
    );

    // Handle files shared when app was closed
    _importService.getInitialSharedFiles().then(
          (files) => _handleSharedFiles(files),
          onError: (error) => onError?.call(error.toString()),
        );
  }

  void _handleSharedFiles(List<SharedMediaFile> files) {
    for (final file in files) {
      if (_isAudioFile(file.path)) {
        onFileReceived(file.path);
      }
    }
  }

  bool _isAudioFile(String path) {
    final ext = path.toLowerCase().split('.').last;
    return ['mp3', 'wav', 'aac', 'm4a', 'ogg', 'flac', 'wma'].contains(ext);
  }

  void dispose() {
    _subscription?.cancel();
  }
}
