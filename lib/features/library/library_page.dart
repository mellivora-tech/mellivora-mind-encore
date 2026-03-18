import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/services/transcription_queue.dart';
import '../../shared/providers/app_providers.dart';
import 'library_provider.dart';

// ── Design tokens (小美原型) ──────────────────────────────────
const _kBgLayer1 = Color(0xFF1A1814);
const _kBgLayer2 = Color(0xFF242018);
const _kAccent = Color(0xFFF5A623);
const _kTextPrimary = Color(0xFFF0EBE0);
const _kTextSecondary = Color(0x8CF0EBE0); // rgba(240,235,224,0.55)
const _kSpring = Duration(milliseconds: 300); // simplified spring equivalent

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioItemsAsync = ref.watch(audioItemsStreamProvider);

    return Scaffold(
      backgroundColor: _kBgLayer1,
      appBar: AppBar(
        backgroundColor: _kBgLayer1,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Library',
          style: TextStyle(
            color: _kTextPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: _kAccent),
            tooltip: '导入音频',
            onPressed: () => _importFromFilePicker(context, ref),
          ),
        ],
      ),
      body: audioItemsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: _kAccent),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: _kTextSecondary),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return _EmptyState(
              onImport: () => _importFromFilePicker(context, ref),
            );
          }
          return RefreshIndicator(
            color: _kAccent,
            backgroundColor: _kBgLayer2,
            onRefresh: () async {
              ref.invalidate(audioItemsStreamProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _AudioItemTile(
                  item: items[index],
                  onDelete: () => _confirmDelete(context, ref, items[index]),
                );
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
              SnackBar(
                content: const Text('文件较大（>25MB），导入可能需要较长时间'),
                backgroundColor: _kBgLayer2,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('导入失败: $e'),
                backgroundColor: Colors.red.shade900,
              ),
            );
          }
        }
      }
    }
  }

  /// Show platform-appropriate delete confirmation.
  void _confirmDelete(BuildContext context, WidgetRef ref, AudioItem item) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (ctx) => CupertinoActionSheet(
          title: Text('删除「${item.title}」？'),
          message: const Text('音频文件及所有相关数据将被永久删除'),
          actions: [
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(ctx).pop();
                _showDeleteConfirmDialog(context, ref, item);
              },
              child: const Text('删除'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
        ),
      );
    } else {
      // Android: context menu style
      showModalBottomSheet(
        context: context,
        backgroundColor: _kBgLayer2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  '删除音频',
                  style: TextStyle(color: Colors.red),
                ),
                subtitle: Text(
                  '「${item.title}」及所有相关数据',
                  style: const TextStyle(color: _kTextSecondary, fontSize: 12),
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _showDeleteConfirmDialog(context, ref, item);
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showDeleteConfirmDialog(
      BuildContext context, WidgetRef ref, AudioItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _kBgLayer2,
        title: const Text('确认删除', style: TextStyle(color: _kTextPrimary)),
        content: Text(
          '确定要删除「${item.title}」吗？\n此操作不可撤销。',
          style: const TextStyle(color: _kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消', style: TextStyle(color: _kTextSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _performDelete(context, ref, item.id);
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _performDelete(
      BuildContext context, WidgetRef ref, String audioId) async {
    try {
      final repo = ref.read(audioRepositoryProvider);
      await repo.deleteAudio(audioId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('已删除'),
            backgroundColor: _kBgLayer2,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('删除失败: $e'),
            backgroundColor: Colors.red.shade900,
          ),
        );
      }
    }
  }
}

// ── Empty State ──────────────────────────────────────────────
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
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _kBgLayer2,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.headphones,
                size: 40,
                color: _kAccent,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '导入你的第一个英文音频',
              style: TextStyle(
                color: _kTextSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onImport,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: _kAccent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: _kBgLayer1, size: 18),
                    SizedBox(width: 6),
                    Text(
                      '导入音频',
                      style: TextStyle(
                        color: _kBgLayer1,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Audio Item Tile ──────────────────────────────────────────
class _AudioItemTile extends ConsumerStatefulWidget {
  final AudioItem item;
  final VoidCallback onDelete;

  const _AudioItemTile({required this.item, required this.onDelete});

  @override
  ConsumerState<_AudioItemTile> createState() => _AudioItemTileState();
}

class _AudioItemTileState extends ConsumerState<_AudioItemTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _dismissController;
  late final Animation<Offset> _slideAnimation;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _dismissController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _dismissController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _dismissController.dispose();
    super.dispose();
  }

  /// Animate slide-out then trigger delete
  Future<void> _animateAndDelete() async {
    if (_dismissed) return;
    _dismissed = true;
    await _dismissController.forward();
    widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final progressAsync = ref.watch(transcriptionProgressProvider);
    final chapterCountAsync = ref.watch(chapterCountProvider(item.id));
    final heardCountAsync = ref.watch(heardChapterCountProvider(item.id));

    final progress = progressAsync.whenOrNull(
      data: (p) => p.audioId == item.id ? p : null,
    );

    final chapterCount = chapterCountAsync.valueOrNull ?? 0;
    final heardCount = heardCountAsync.valueOrNull ?? 0;
    final isFullyHeard = chapterCount > 0 && heardCount >= chapterCount;
    final progressFraction =
        chapterCount > 0 ? heardCount / chapterCount : 0.0;

    return SlideTransition(
      position: _slideAnimation,
      child: GestureDetector(
        onLongPress: () => _confirmDeleteViaLongPress(),
        onTap: () {
          if (item.transcriptionStatus == 'error') {
            ref.read(transcriptionQueueProvider).enqueue(item.id);
          } else {
            // Set current audio and open player overlay (#24)
            ref.read(currentAudioIdProvider.notifier).state = item.id;
            ref.read(miniPlayerVisibleProvider.notifier).state = true;
            ref.read(playerOverlayVisibleProvider.notifier).state = true;
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: _kBgLayer1,
          child: Row(
            children: [
              // ── Cover placeholder (56×56) ──
              Stack(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _kBgLayer2,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        _formatDuration(item.durationMs),
                        style: const TextStyle(
                          color: _kTextSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  // #23: Fully heard green checkmark badge
                  if (isFullyHeard)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              // ── Text + progress ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _kTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Subtitle: transcription progress or chapter info
                    if (progress != null &&
                        progress.status == 'transcribing') ...[
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1),
                              child: LinearProgressIndicator(
                                value: progress.percent / 100.0,
                                backgroundColor: _kBgLayer2,
                                color: _kAccent,
                                minHeight: 2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '转录中 ${progress.percent}%',
                            style: const TextStyle(
                              color: _kTextSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      _buildSubtitleRow(
                        item: item,
                        chapterCount: chapterCount,
                        heardCount: heardCount,
                      ),
                      if (chapterCount > 0) ...[
                        const SizedBox(height: 6),
                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(1),
                          child: LinearProgressIndicator(
                            value: progressFraction,
                            backgroundColor: _kBgLayer2,
                            color: _kAccent,
                            minHeight: 2,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // ── Status badge for non-done items ──
              if (item.transcriptionStatus != 'done')
                _StatusBadge(status: item.transcriptionStatus),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitleRow({
    required AudioItem item,
    required int chapterCount,
    required int heardCount,
  }) {
    final parts = <String>[];
    if (chapterCount > 0) {
      parts.add('$chapterCount 章');
      if (heardCount > 0) {
        parts.add('已听 $heardCount');
      }
    }
    final duration = _formatDurationLong(item.durationMs);
    if (duration.isNotEmpty) {
      parts.add(duration);
    }

    return Text(
      parts.isEmpty ? '--' : parts.join(' · '),
      style: const TextStyle(
        color: _kTextSecondary,
        fontSize: 13,
      ),
    );
  }

  void _confirmDeleteViaLongPress() {
    // Trigger the delete flow passed from parent
    widget.onDelete();
  }

  String _formatDuration(int? ms) {
    if (ms == null) return '--:--';
    final d = Duration(milliseconds: ms);
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _formatDurationLong(int? ms) {
    if (ms == null) return '';
    final d = Duration(milliseconds: ms);
    if (d.inHours > 0) {
      return '${d.inHours}h ${d.inMinutes % 60}m';
    }
    return '${d.inMinutes}m';
  }
}

// ── Status Badge ─────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'pending' => ('待转录', _kAccent),
      'transcribing' => ('转录中', const Color(0xFF4FC3F7)),
      'error' => ('失败', Colors.red),
      _ => (status, _kTextSecondary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
