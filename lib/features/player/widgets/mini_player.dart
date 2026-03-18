import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/audio_player_service.dart';
import '../../../shared/providers/app_providers.dart';

// ── Design tokens (小美原型) ──────────────────────────────────
const _kBgLayer2 = Color(0xFF242018);
const _kAccent = Color(0xFFF5A623);
const _kTextPrimary = Color(0xFFF0EBE0);
const _kText40 = Color(0x66F0EBE0);
const _kText10 = Color(0x1AF0EBE0);
const _kSpringCurve = Cubic(0.16, 1, 0.3, 1);

/// Mini Player height: 38px cover + 8px padding top/bottom = 54px + 2px progress = 56px
const kMiniPlayerHeight = 56.0;

class MiniPlayer extends ConsumerWidget {
  final VoidCallback onTap;

  const MiniPlayer({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(audioPlayerProvider);
    final isVisible = ref.watch(miniPlayerVisibleProvider);

    if (!isVisible || playerState.audioId == null) {
      return const SizedBox.shrink();
    }

    // Build subtitle text
    String subtitle = '';
    if (playerState.loopMode == ChapterLoopMode.chapter) {
      subtitle = '↺ 循环中';
    } else if (playerState.chapters.isNotEmpty &&
        playerState.currentChapterIndex < playerState.chapters.length) {
      final ch = playerState.chapters[playerState.currentChapterIndex];
      subtitle = ch.title.isNotEmpty ? ch.title : '第${playerState.currentChapterIndex + 1}章';
    }

    // Progress fraction
    final totalMs = playerState.duration.inMilliseconds;
    final currentMs = playerState.position.inMilliseconds;
    final progress = totalMs > 0 ? (currentMs / totalMs).clamp(0.0, 1.0) : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: kMiniPlayerHeight,
        decoration: BoxDecoration(
          color: _kBgLayer2,
          border: Border(
            top: BorderSide(
              color: _kText10,
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            // Main content row
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // 38×38 cover with gradient placeholder
                    _buildCover(playerState),
                    const SizedBox(width: 12),
                    // Title + subtitle
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playerState.audioTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _kTextPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (subtitle.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _kText40,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Play/Pause button (32px)
                    GestureDetector(
                      onTap: () {
                        ref.read(audioPlayerProvider.notifier).playPause();
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          playerState.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: _kTextPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 2px orange progress bar at bottom
            SizedBox(
              height: 2,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: _kText10,
                color: _kAccent,
                minHeight: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Cover placeholder with gradient (matches Library list)
  Widget _buildCover(PlayerState playerState) {
    // Generate a consistent gradient based on audioId hash
    final hash = (playerState.audioId ?? '').hashCode;
    final hue1 = (hash % 360).abs().toDouble();
    final hue2 = ((hash ~/ 360) % 360).abs().toDouble();

    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HSLColor.fromAHSL(1, hue1, 0.3, 0.25).toColor(),
            HSLColor.fromAHSL(1, hue2, 0.3, 0.18).toColor(),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.music_note_rounded,
          color: _kText40,
          size: 18,
        ),
      ),
    );
  }
}
