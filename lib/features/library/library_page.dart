import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/services/transcription_queue.dart';
import 'library_provider.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioItemsAsync = ref.watch(audioItemsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '导入音频',
            onPressed: () => _importFromFilePicker(context, ref),
          ),
        ],
      ),
      body: audioItemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
        data: (items) {
          if (items.isEmpty) {
            return _EmptyState(
              onImport: () => _importFromFilePicker(context, ref),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(audioItemsStreamProvider);
            },
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _AudioItemTile(item: items[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _importFromFilePicker(
      BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final path = result.files.single.path;
      if (path != null) {
        try {
          final actions = ref.read(libraryActionsProvider);
          final importResult = await actions.importFromPath(path);

          if (context.mounted && importResult.isLargeFile) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('文件较大（>25MB），导入可能需要较长时间'),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('导入失败: $e')),
            );
          }
        }
      }
    }
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onImport;

  const _EmptyState({required this.onImport});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.headphones,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              '导入你的第一个英文音频',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onImport,
              icon: const Icon(Icons.add),
              label: const Text('导入音频'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioItemTile extends ConsumerWidget {
  final AudioItem item;

  const _AudioItemTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(transcriptionProgressProvider);

    // Check if this item has active progress
    final progress = progressAsync.whenOrNull(
      data: (p) => p.audioId == item.id ? p : null,
    );

    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.audiotrack,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: _buildSubtitle(progress),
      trailing: _buildTrailing(context, ref, progress),
      onTap: () {
        if (item.transcriptionStatus == 'error') {
          // Retry: re-enqueue
          ref.read(transcriptionQueueProvider).enqueue(item.id);
        } else {
          // ignore: avoid_print
          print('TODO: open player for ${item.id}');
        }
      },
    );
  }

  Widget _buildSubtitle(TranscriptionProgress? progress) {
    if (progress != null && progress.status == 'transcribing') {
      return Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: progress.percent / 100.0,
            ),
          ),
          const SizedBox(width: 8),
          Text('转录中 ${progress.percent}%',
              style: const TextStyle(fontSize: 12)),
        ],
      );
    }
    return Text(_formatDuration(item.durationMs));
  }

  Widget _buildTrailing(
      BuildContext context, WidgetRef ref, TranscriptionProgress? progress) {
    if (item.transcriptionStatus == 'error') {
      return GestureDetector(
        onTap: () {
          ref.read(transcriptionQueueProvider).enqueue(item.id);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withOpacity(0.5)),
          ),
          child: const Text(
            '转录失败，点击重试',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    if (progress != null && progress.status == 'transcribing') {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return _StatusLabel(status: item.transcriptionStatus);
  }

  String _formatDuration(int? ms) {
    if (ms == null) return '--:--';
    final duration = Duration(milliseconds: ms);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class _StatusLabel extends StatelessWidget {
  final String status;

  const _StatusLabel({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'pending' => ('待转录', Colors.orange),
      'transcribing' => ('转录中', Colors.blue),
      'done' => ('已完成', Colors.green),
      'error' => ('转录失败', Colors.red),
      _ => (status, Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
