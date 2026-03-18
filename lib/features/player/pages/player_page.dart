import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/services/audio_player_service.dart';
import '../../../core/services/subtitle_service.dart';
import '../../../shared/providers/app_providers.dart';
import '../../agent/agent_chat_page.dart';
import '../../agent/agent_context.dart';
import '../../agent/agent_context_provider.dart';
import '../../agent/agent_panel.dart';
import '../../agent/agent_provider.dart';
import '../widgets/subtitle_overlay.dart';

// ── Design tokens (pixel-perfect) ──────────────────────────
const _kBgLayer1 = Color(0xFF1A1814);
const _kBgLayer2 = Color(0xFF242018);
const _kAccent = Color(0xFFF5A623);
const _kTextPrimary = Color(0xFFF0EBE0);
const _kText70 = Color(0xB3F0EBE0);
const _kText40 = Color(0x66F0EBE0);
const _kText30 = Color(0x4DF0EBE0);
const _kText20 = Color(0x33F0EBE0);
const _kText13 = Color(0x21F0EBE0);
const _kGreen = Color(0xFF4CAF50);
const _kSpringCurve = Cubic(0.16, 1, 0.3, 1);

class PlayerPage extends ConsumerStatefulWidget {
  final String audioId;

  const PlayerPage({super.key, required this.audioId});

  @override
  ConsumerState<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends ConsumerState<PlayerPage> with SingleTickerProviderStateMixin {
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;
  final ScrollController _chapterScrollController = ScrollController();
  bool _initialized = false;

  // #36: Chapter end prompt tracking
  bool _chapterEndPromptShown = false;
  int _lastPromptedChapterIndex = -1;

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

    if (currentState.audioId == widget.audioId && currentState.isPlaying) {
      ref.read(miniPlayerVisibleProvider.notifier).state = true;
      ref.read(currentAudioIdProvider.notifier).state = widget.audioId;
      ref.read(subtitleServiceProvider.notifier).loadSubtitles(widget.audioId);
      return;
    }

    final audioItem = await (db.select(db.audioItems)..where((t) => t.id.equals(widget.audioId)))
        .getSingleOrNull();

    if (audioItem == null) return;

    // Verify audio file exists on disk
    if (!File(audioItem.filePath).existsSync()) {
      debugPrint('Audio file not found: ${audioItem.filePath}');
      return;
    }

    final savedState = await AudioPlayerNotifier.getPlaybackState(db, widget.audioId);

    if (savedState != null && savedState.lastPositionMs > 0 && mounted) {
      final shouldResume = await _showResumeDialog(savedState.lastPositionMs);
      if (!mounted) return;

      if (shouldResume == true) {
        int startChapter = 0;
        if (savedState.lastChapterId != null) {
          final chapters = await (db.select(db.chapters)
                ..where((t) => t.audioId.equals(widget.audioId))
                ..orderBy([(t) => OrderingTerm.asc(t.index)]))
              .get();
          startChapter = chapters.indexWhere((c) => c.id == savedState.lastChapterId);
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

    if (mounted) {
      ref.read(miniPlayerVisibleProvider.notifier).state = true;
      ref.read(currentAudioIdProvider.notifier).state = widget.audioId;
      ref.read(subtitleServiceProvider.notifier).loadSubtitles(widget.audioId);
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
                title: const Text('继续播放', style: TextStyle(color: _kTextPrimary)),
                onTap: () => Navigator.of(ctx).pop(true),
              ),
              ListTile(
                leading: const Icon(Icons.replay, color: _kText40),
                title: const Text('从头播放', style: TextStyle(color: _kTextPrimary)),
                onTap: () => Navigator.of(ctx).pop(false),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    }
  }

  /// #36: Check chapter progress for auto-prompt.
  void _checkChapterEndPrompt(PlayerState playerState) {
    if (playerState.chapters.isEmpty) return;

    final ch = playerState.chapters[playerState.currentChapterIndex];
    final chapterDuration = ch.endMs - ch.startMs;
    if (chapterDuration <= 0) return;

    final elapsed = playerState.position.inMilliseconds - ch.startMs;
    final progress = elapsed / chapterDuration;

    if (progress > 0.9 &&
        playerState.currentChapterIndex != _lastPromptedChapterIndex &&
        !_chapterEndPromptShown) {
      final ctx = ref.read(agentContextProvider);
      if (ctx.sessionLookups.isNotEmpty) {
        _lastPromptedChapterIndex = playerState.currentChapterIndex;
        _chapterEndPromptShown = true;

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) _showChapterEndPrompt(ctx, playerState);
        });
      }
    }

    if (playerState.currentChapterIndex != _lastPromptedChapterIndex) {
      _chapterEndPromptShown = false;
    }
  }

  void _showChapterEndPrompt(AgentContext ctx, PlayerState playerState) {
    final chapterNum = playerState.currentChapterIndex + 1;
    final wordCount = ctx.sessionLookups.length;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 8),
        backgroundColor: _kBgLayer2,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(
          'Ch.$chapterNum 听完了 \u{1F389} 查了$wordCount个词，花3分钟考一下？',
          style: const TextStyle(color: _kTextPrimary, fontSize: 14),
        ),
        action: SnackBarAction(
          label: '好，出题',
          textColor: _kAccent,
          onPressed: () {
            ref.read(agentContextProvider.notifier).setTrigger(AgentTrigger.chapterEnd);
            ref.read(agentChatProvider.notifier).startSession(AgentMode.quiz);
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AgentChatPage()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(audioPlayerProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) => _initPlayer());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentChapter(playerState.currentChapterIndex);
    });

    _checkChapterEndPrompt(playerState);

    return SlideTransition(
      position: _slideAnimation,
      child: Scaffold(
        backgroundColor: _kBgLayer1,
        body: SafeArea(
          child: Column(
            children: [
              _buildNavBar(playerState),
              _buildChapterNav(playerState),
              Expanded(child: _buildSubtitleArea(playerState)),
              _buildControlArea(playerState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBar(PlayerState playerState) {
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              final overlayVisible = ref.read(playerOverlayVisibleProvider);
              if (overlayVisible) {
                ref.read(playerOverlayVisibleProvider.notifier).state = false;
              } else {
                context.pop();
              }
              ref.read(agentContextProvider.notifier).clearSession();
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.queue_music, color: _kText40, size: 24),
          ),
        ],
      ),
    );
  }

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
            onTap: () => ref.read(audioPlayerProvider.notifier).seekToChapter(index),
            onLongPress: () => _showChapterContextMenu(context, index, playerState),
          );
        },
      ),
    );
  }

  void _showChapterContextMenu(BuildContext context, int index, PlayerState playerState) {
    HapticFeedback.mediumImpact();
    final notifier = ref.read(audioPlayerProvider.notifier);
    final isLoopingThis =
        playerState.loopMode == ChapterLoopMode.chapter && playerState.loopingChapterIndex == index;

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
              child: Text(isLoopingThis ? '取消循环' : '\u21BA 循环这段'),
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
                subtitleOverlayKey.currentState?.toggle();
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
                  isLoopingThis ? '取消循环' : '\u21BA 循环这段',
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
                title: const Text('跳到这里', style: TextStyle(color: _kTextPrimary)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  notifier.seekToChapter(index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.closed_caption_rounded, color: _kText40),
                title: const Text('查看字幕', style: TextStyle(color: _kTextPrimary)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  subtitleOverlayKey.currentState?.toggle();
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
    const chipWidth = 128.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final targetOffset = (chipWidth * index) - (screenWidth / 2) + (chipWidth / 2);
    final maxScroll = _chapterScrollController.position.maxScrollExtent;
    final clampedOffset = targetOffset.clamp(0.0, maxScroll);

    _chapterScrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 300),
      curve: _kSpringCurve,
    );
  }

  Widget _buildSubtitleArea(PlayerState playerState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          SubtitleOverlay(
            key: subtitleOverlayKey,
            onAskAgent: () {
              final ctx = ref.read(agentContextProvider);
              ref.read(agentContextProvider.notifier).setTrigger(AgentTrigger.wordCard);
              ref
                  .read(agentChatProvider.notifier)
                  .startSession(AgentMode.freeChat, initialWord: ctx.currentWord);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AgentChatPage()),
              );
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildControlArea(PlayerState playerState) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => subtitleOverlayKey.currentState?.toggle(),
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
          ),
          const SizedBox(height: 12),
          _buildProgressBar(playerState),
          const SizedBox(height: 4),
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
          _buildPlaybackControls(playerState),
          const SizedBox(height: 20),
          _buildSpeedAndExtras(playerState),
        ],
      ),
    );
  }

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
          final position = Duration(milliseconds: (value * totalMs).round());
          ref.read(audioPlayerProvider.notifier).seekTo(position);
          ref.read(subtitleServiceProvider.notifier).forceUpdate(position);
        },
      ),
    );
  }

  Widget _buildPlaybackControls(PlayerState playerState) {
    final notifier = ref.read(audioPlayerProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _controlButton(
          icon: Icons.skip_previous_rounded,
          size: 28,
          onTap: notifier.skipToPreviousChapter,
        ),
        const SizedBox(width: 24),
        _controlButton(
          icon: Icons.replay,
          size: 28,
          onTap: () => notifier.seekRelative(const Duration(seconds: -15)),
        ),
        const SizedBox(width: 24),
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
              playerState.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: _kBgLayer1,
              size: 32,
            ),
          ),
        ),
        const SizedBox(width: 24),
        _controlButton(
          icon: Icons.forward_10,
          size: 28,
          onTap: () => notifier.seekRelative(const Duration(seconds: 15)),
        ),
        const SizedBox(width: 24),
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

  Widget _buildSpeedAndExtras(PlayerState playerState) {
    final notifier = ref.read(audioPlayerProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
                    color: playerState.loopMode != ChapterLoopMode.none ? _kAccent : _kText30,
                    size: 22,
                  ),
                ),
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
        GestureDetector(
          onTap: () => showAgentPanel(context, ref),
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

// ── Chapter Chip Widget ────────────────────────────────────
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isDone && !isCurrent) ...[
                  const Icon(Icons.check_circle, color: _kGreen, size: 11),
                  const SizedBox(width: 3),
                ],
                if (isCurrent) ...[
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
    final progress = chapterDuration > 0 ? (elapsed / chapterDuration).clamp(0.0, 1.0) : 0.0;

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

String _formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes % 60;
  final s = d.inSeconds % 60;
  if (h > 0) {
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
  return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
}
