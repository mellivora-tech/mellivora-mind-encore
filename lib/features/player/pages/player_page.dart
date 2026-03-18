import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/services/audio_player_service.dart';
import '../../../shared/providers/app_providers.dart';

// ── Design tokens (小美原型 — pixel-perfect) ──────────────────
const _kBgLayer1 = Color(0xFF1A1814);
const _kBgLayer2 = Color(0xFF242018);
const _kAccent = Color(0xFFF5A623);
const _kTextPrimary = Color(0xFFF0EBE0);
const _kText70 = Color(0xB3F0EBE0); // 70% opacity
const _kText40 = Color(0x66F0EBE0); // 40% opacity
const _kText30 = Color(0x4DF0EBE0); // 30% opacity
const _kText20 = Color(0x33F0EBE0); // 20% opacity
const _kText13 = Color(0x21F0EBE0); // 13% opacity
const _kGreen = Color(0xFF4CAF50);
const _kSpringCurve = Cubic(0.16, 1, 0.3, 1);

class PlayerPage extends ConsumerStatefulWidget {
  final String audioId;

  const PlayerPage({super.key, required this.audioId});

  @override
  ConsumerState<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends ConsumerState<PlayerPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;
  final ScrollController _chapterScrollController = ScrollController();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 440),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: _kSpringCurve,
    ));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _chapterScrollController.dispose();
    super.dispose();
  }

  Future<void> _initPlayer() async {
    if (_initialized) return;
    _initialized = true;

    final db = ref.read(databaseProvider);
    final playerNotifier = ref.read(audioPlayerProvider.notifier);
    final currentState = ref.read(audioPlayerProvider);

    // Already playing this audio
    if (currentState.audioId == widget.audioId && currentState.isPlaying) {
      // Just make sure mini player is visible
      ref.read(miniPlayerVisibleProvider.notifier).state = true;
      ref.read(currentAudioIdProvider.notifier).state = widget.audioId;
      return;
    }

    // Fetch audio item
    final audioItem = await (db.select(db.audioItems)
          ..where((t) => t.id.equals(widget.audioId)))
        .getSingleOrNull();

    if (audioItem == null) return;

    // Check for saved playback state (#18)
    final savedState =
        await AudioPlayerNotifier.getPlaybackState(db, widget.audioId);

    if (savedState != null && savedState.lastPositionMs > 0 && mounted) {
      // Show resume ActionSheet
      final shouldResume = await _showResumeDialog(savedState.lastPositionMs);
      if (!mounted) return;

      if (shouldResume == true) {
        // Find chapter index from saved chapter ID
        int startChapter = 0;
        if (savedState.lastChapterId != null) {
          final chapters = await (db.select(db.chapters)
                ..where((t) => t.audioId.equals(widget.audioId))
                ..orderBy([(t) => OrderingTerm.asc(t.index)]))
              .get();
          startChapter = chapters
              .indexWhere((c) => c.id == savedState.lastChapterId);
          if (startChapter < 0) startChapter = 0;
        }

        await playerNotifier.loadAndPlay(
          audioId: widget.audioId,
          filePath: audioItem.filePath,
          title: audioItem.title,
          startChapterIndex: startChapter,
          startPosition: Duration(milliseconds: savedState.lastPositionMs),
        );
      } else {
        await playerNotifier.loadAndPlay(
          audioId: widget.audioId,
          filePath: audioItem.filePath,
          title: audioItem.title,
        );
      }
    } else {
      await playerNotifier.loadAndPlay(
        audioId: widget.audioId,
        filePath: audioItem.filePath,
        title: audioItem.title,
      );
    }

    // Mark mini player visible
    if (mounted) {
      ref.read(miniPlayerVisibleProvider.notifier).state = true;
      ref.read(currentAudioIdProvider.notifier).state = widget.audioId;
    }
  }

  Future<bool?> _showResumeDialog(int lastPositionMs) async {
    final formattedTime = _formatDuration(Duration(milliseconds: lastPositionMs));

    if (Platform.isIOS) {
      return showCupertinoModalPopup<bool>(
        context: context,
        builder: (ctx) => CupertinoActionSheet(
          title: const Text('继续播放？'),
          message: Text('上次播放到 $formattedTime'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('继续播放'),
            ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('从头播放'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: const Text('取消'),
          ),
        ),
      );
    } else {
      return showModalBottomSheet<bool>(
        context: context,
        backgroundColor: _kBgLayer2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                '上次播放到 $formattedTime',
                style: const TextStyle(color: _kText70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.play_arrow, color: _kAccent),
                title: const Text('继续播放',
                    style: TextStyle(color: _kTextPrimary)),
                onTap: () => Navigator.of(ctx).pop(true),
              ),
              ListTile(
                leading: const Icon(Icons.replay, color: _kText40),
                title: const Text('从头播放',
                    style: TextStyle(color: _kTextPrimary)),
                onTap: () => Navigator.of(ctx).pop(false),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(audioPlayerProvider);

    // Initialize player on first build
    WidgetsBinding.instance.addPostFrameCallback((_) => _initPlayer());

    // Auto-scroll chapter chip into view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentChapter(playerState.currentChapterIndex);
    });

    return SlideTransition(
      position: _slideAnimation,
      child: Scaffold(
        backgroundColor: _kBgLayer1,
        body: SafeArea(
          child: Column(
            children: [
              // ── NavBar (52px) ──
              _buildNavBar(playerState),

              // ── Chapter Navigation (#20) ──
              _buildChapterNav(playerState),

              // ── Subtitle Area (flex:1) ──
              Expanded(child: _buildSubtitleArea(playerState)),

              // ── Control Area ──
              _buildControlArea(playerState),
            ],
          ),
        ),
      ),
    );
  }

  // ── NavBar ─────────────────────────────────────────────────
  Widget _buildNavBar(PlayerState playerState) {
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          // Back button — close overlay or pop route
          GestureDetector(
            onTap: () {
              final overlayVisible = ref.read(playerOverlayVisibleProvider);
              if (overlayVisible) {
                ref.read(playerOverlayVisibleProvider.notifier).state = false;
              } else {
                context.pop();
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chevron_left, color: _kAccent, size: 24),
                  Text(
                    'Library',
                    style: TextStyle(
                      color: _kAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Center title
          Expanded(
            child: Text(
              playerState.audioTitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _kText70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Playlist button
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.queue_music, color: _kText40, size: 24),
          ),
        ],
      ),
    );
  }

  // ── Chapter Navigation (#20 + #21 long-press) ──────────────
  Widget _buildChapterNav(PlayerState playerState) {
    if (playerState.chapters.isEmpty) {
      return const SizedBox(height: 74);
    }

    return SizedBox(
      height: 74,
      child: ListView.builder(
        controller: _chapterScrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: playerState.chapters.length,
        itemBuilder: (context, index) {
          final isLoopingThis = playerState.loopMode == ChapterLoopMode.chapter &&
              playerState.loopingChapterIndex == index;
          return _ChapterChip(
            chapter: playerState.chapters[index],
            index: index,
            isCurrent: index == playerState.currentChapterIndex,
            isDone: playerState.chapters[index].isHeard,
            isLooping: isLoopingThis,
            currentPosition: playerState.position,
            onTap: () =>
                ref.read(audioPlayerProvider.notifier).seekToChapter(index),
            onLongPress: () => _showChapterContextMenu(context, index, playerState),
          );
        },
      ),
    );
  }

  // ── #21: Chapter Long-press Context Menu ────────────────────
  void _showChapterContextMenu(
      BuildContext context, int index, PlayerState playerState) {
    // Haptic feedback
    HapticFeedback.mediumImpact();

    final notifier = ref.read(audioPlayerProvider.notifier);
    final isLoopingThis = playerState.loopMode == ChapterLoopMode.chapter &&
        playerState.loopingChapterIndex == index;

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (ctx) => CupertinoActionSheet(
          title: Text('第${index + 1}章'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(ctx).pop();
                if (isLoopingThis) {
                  notifier.clearLoop();
                } else {
                  notifier.setChapterLoop(index);
                }
              },
              child: Text(isLoopingThis ? '取消循环' : '↺ 循环这段'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(ctx).pop();
                notifier.seekToChapter(index);
              },
              child: const Text('跳到这里'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(ctx).pop();
                // TODO: Open CC overlay
              },
              child: const Text('查看字幕'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
        ),
      );
    } else {
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
              const SizedBox(height: 12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: _kText20,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '第${index + 1}章',
                style: const TextStyle(
                  color: _kText70,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Icon(
                  Icons.repeat_one_rounded,
                  color: isLoopingThis ? _kAccent : _kText40,
                ),
                title: Text(
                  isLoopingThis ? '取消循环' : '↺ 循环这段',
                  style: const TextStyle(color: _kTextPrimary),
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  if (isLoopingThis) {
                    notifier.clearLoop();
                  } else {
                    notifier.setChapterLoop(index);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.skip_next_rounded, color: _kText40),
                title: const Text('跳到这里',
                    style: TextStyle(color: _kTextPrimary)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  notifier.seekToChapter(index);
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.closed_caption_rounded, color: _kText40),
                title: const Text('查看字幕',
                    style: TextStyle(color: _kTextPrimary)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  // TODO: Open CC overlay
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    }
  }

  void _scrollToCurrentChapter(int index) {
    if (!_chapterScrollController.hasClients) return;
    // Each chip is roughly 120px wide + 8px margin
    const chipWidth = 128.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final targetOffset =
        (chipWidth * index) - (screenWidth / 2) + (chipWidth / 2);
    final maxScroll = _chapterScrollController.position.maxScrollExtent;
    final clampedOffset = targetOffset.clamp(0.0, maxScroll);

    _chapterScrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 300),
      curve: _kSpringCurve,
    );
  }

  // ── Subtitle Area ──────────────────────────────────────────
  Widget _buildSubtitleArea(PlayerState playerState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Previous sentence (20% opacity)
          const Text(
            '',
            style: TextStyle(color: _kText20, fontSize: 16, height: 1.6),
          ),
          const SizedBox(height: 8),
          // Last sentence (40% opacity)
          const Text(
            '',
            style: TextStyle(color: _kText40, fontSize: 16, height: 1.6),
          ),
          const SizedBox(height: 8),
          // Current sentence (100% + orange indicator)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 3,
                height: 20,
                margin: const EdgeInsets.only(right: 10, top: 2),
                decoration: BoxDecoration(
                  color: _kAccent,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _kAccent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    playerState.chapters.isNotEmpty
                        ? playerState
                            .chapters[playerState.currentChapterIndex].title
                        : 'Loading...',
                    style: const TextStyle(
                      color: _kTextPrimary,
                      fontSize: 16,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Control Area ───────────────────────────────────────────
  Widget _buildControlArea(PlayerState playerState) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // CC Button (right-aligned)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 42,
              height: 28,
              decoration: BoxDecoration(
                border: Border.all(color: _kText30, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'CC',
                  style: TextStyle(
                    color: _kText40,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Global Progress Bar
          _buildProgressBar(playerState),
          const SizedBox(height: 4),

          // Time labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(playerState.position),
                style: const TextStyle(color: _kText30, fontSize: 11),
              ),
              Text(
                _formatDuration(playerState.duration),
                style: const TextStyle(color: _kText30, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Playback Controls Row
          _buildPlaybackControls(playerState),
          const SizedBox(height: 20),

          // Speed + Loop + Agent Row
          _buildSpeedAndExtras(playerState),
        ],
      ),
    );
  }

  // ── Progress Bar (3px, 13px thumb) ─────────────────────────
  Widget _buildProgressBar(PlayerState playerState) {
    final totalMs = playerState.duration.inMilliseconds;
    final currentMs = playerState.position.inMilliseconds;
    final progress = totalMs > 0 ? currentMs / totalMs : 0.0;

    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.5),
        thumbColor: _kAccent,
        activeTrackColor: _kAccent,
        inactiveTrackColor: _kText13,
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
        overlayColor: _kAccent.withOpacity(0.1),
      ),
      child: Slider(
        value: progress.clamp(0.0, 1.0),
        onChanged: (value) {
          final position = Duration(
              milliseconds: (value * totalMs).round());
          ref.read(audioPlayerProvider.notifier).seekTo(position);
        },
      ),
    );
  }

  // ── Playback Controls ──────────────────────────────────────
  Widget _buildPlaybackControls(PlayerState playerState) {
    final notifier = ref.read(audioPlayerProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous Chapter
        _controlButton(
          icon: Icons.skip_previous_rounded,
          size: 28,
          onTap: notifier.skipToPreviousChapter,
        ),
        const SizedBox(width: 24),

        // Rewind 15s
        _controlButton(
          icon: Icons.replay,
          size: 28,
          label: '15',
          onTap: () =>
              notifier.seekRelative(const Duration(seconds: -15)),
        ),
        const SizedBox(width: 24),

        // Play / Pause (52px)
        GestureDetector(
          onTap: notifier.playPause,
          child: Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: _kAccent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              playerState.isPlaying
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              color: _kBgLayer1,
              size: 32,
            ),
          ),
        ),
        const SizedBox(width: 24),

        // Forward 15s
        _controlButton(
          icon: Icons.forward_15,
          size: 28,
          onTap: () =>
              notifier.seekRelative(const Duration(seconds: 15)),
        ),
        const SizedBox(width: 24),

        // Next Chapter
        _controlButton(
          icon: Icons.skip_next_rounded,
          size: 28,
          onTap: notifier.skipToNextChapter,
        ),
      ],
    );
  }

  Widget _controlButton({
    required IconData icon,
    required double size,
    String? label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size + 8,
        height: size + 8,
        child: Center(
          child: Icon(icon, color: _kTextPrimary, size: size),
        ),
      ),
    );
  }

  // ── Speed + Loop + Agent (#22 loop mode UI) ────────────────
  Widget _buildSpeedAndExtras(PlayerState playerState) {
    final notifier = ref.read(audioPlayerProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Speed buttons (#17 UI)
        ...[0.75, 1.0, 1.25, 1.5].map((speed) {
          final isSelected = (playerState.speed - speed).abs() < 0.01;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () => notifier.setSpeed(speed),
              child: Text(
                '${speed}x',
                style: TextStyle(
                  color: isSelected ? _kAccent : _kText30,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        }),

        const SizedBox(width: 16),

        // Loop button (#22: three states with badge)
        GestureDetector(
          onTap: notifier.cycleLoopMode,
          child: SizedBox(
            width: 30,
            height: 30,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(
                  child: Icon(
                    playerState.loopMode == ChapterLoopMode.chapter
                        ? Icons.repeat_one_rounded
                        : Icons.repeat_rounded,
                    color: playerState.loopMode != ChapterLoopMode.none
                        ? _kAccent
                        : _kText30,
                    size: 22,
                  ),
                ),
                // "1" badge for chapter mode
                if (playerState.loopMode == ChapterLoopMode.chapter)
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: _kAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            color: _kBgLayer1,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Agent button
        GestureDetector(
          onTap: () {
            // TODO: Navigate to Agent with context
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: _kAccent, width: 1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '\u{1F916}',
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(width: 4),
                Text(
                  'Agent',
                  style: TextStyle(
                    color: _kAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Chapter Chip Widget (#20 + #21 long-press + #22 loop badge) ─
class _ChapterChip extends StatelessWidget {
  final Chapter chapter;
  final int index;
  final bool isCurrent;
  final bool isDone;
  final bool isLooping;
  final Duration currentPosition;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ChapterChip({
    required this.chapter,
    required this.index,
    required this.isCurrent,
    required this.isDone,
    required this.isLooping,
    required this.currentPosition,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        constraints: const BoxConstraints(minWidth: 100),
        decoration: BoxDecoration(
          color: isCurrent ? _kAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: isCurrent
              ? null
              : isDone
                  ? null
                  : Border.all(color: _kText13, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Chapter number + done/loop indicators
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isDone && !isCurrent) ...[
                  const Icon(Icons.check_circle,
                      color: _kGreen, size: 11),
                  const SizedBox(width: 3),
                ],
                if (isCurrent) ...[
                  // Play dot
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
                // Loop indicator (#22)
                if (isLooping) ...[
                  Icon(
                    Icons.repeat_one_rounded,
                    color: isCurrent ? Colors.white : _kAccent,
                    size: 11,
                  ),
                  const SizedBox(width: 2),
                ],
                Text(
                  '第${index + 1}章',
                  style: TextStyle(
                    color: isCurrent
                        ? Colors.white.withOpacity(0.8)
                        : isDone
                            ? _kText30
                            : _kText40,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            // Title
            Text(
              chapter.title.isEmpty ? '第${index + 1}章' : chapter.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isCurrent
                    ? Colors.white
                    : isDone
                        ? _kText30
                        : _kText40,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            // Progress bar for current chapter
            if (isCurrent) ...[
              const SizedBox(height: 4),
              _buildChapterProgress(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChapterProgress() {
    final chapterDuration = chapter.endMs - chapter.startMs;
    final elapsed = currentPosition.inMilliseconds - chapter.startMs;
    final progress =
        chapterDuration > 0 ? (elapsed / chapterDuration).clamp(0.0, 1.0) : 0.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(1),
      child: SizedBox(
        height: 2,
        width: 72,
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white.withOpacity(0.2),
          color: Colors.white,
          minHeight: 2,
        ),
      ),
    );
  }
}

// ── Helper ───────────────────────────────────────────────────
String _formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes % 60;
  final s = d.inSeconds % 60;
  if (h > 0) {
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
  return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
}
