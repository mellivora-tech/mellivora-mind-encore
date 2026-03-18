import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/audio_player_service.dart';
import '../../../core/services/subtitle_service.dart';
import '../../vocabulary/word_card_sheet.dart';

// ── Design tokens ──────────────────────────────────────────
const _kBgLayer1 = Color(0xFF1A1814);
const _kBgLayer2 = Color(0xFF242018);
const _kAccent = Color(0xFFF5A623);
const _kTextPrimary = Color(0xFFF0EBE0);
const _kText70 = Color(0xB3F0EBE0);
const _kText40 = Color(0x66F0EBE0);
const _kText20 = Color(0x33F0EBE0);

/// #28: CC subtitle overlay — 3-second auto-dismiss, tap words to lookup.
class SubtitleOverlay extends ConsumerStatefulWidget {
  final VoidCallback? onAskAgent;

  const SubtitleOverlay({super.key, this.onAskAgent});

  @override
  ConsumerState<SubtitleOverlay> createState() => _SubtitleOverlayState();
}

class _SubtitleOverlayState extends ConsumerState<SubtitleOverlay>
    with SingleTickerProviderStateMixin {
  bool _visible = false;
  Timer? _hideTimer;
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void toggle() {
    if (_visible) {
      _hide();
    } else {
      _show();
    }
  }

  void _show() {
    setState(() => _visible = true);
    _animController.forward();
    _startHideTimer();
  }

  void _hide() {
    _hideTimer?.cancel();
    _animController.reverse().then((_) {
      if (mounted) setState(() => _visible = false);
    });
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) _hide();
    });
  }

  void _resetTimer() {
    _startHideTimer();
  }

  @override
  Widget build(BuildContext context) {
    final subtitleState = ref.watch(subtitleServiceProvider);
    final playerState = ref.watch(audioPlayerProvider);

    if (!_visible) {
      return _buildHiddenInfo(playerState);
    }

    final segment = subtitleState.currentSegment;
    if (segment == null) {
      return _buildHiddenInfo(playerState);
    }

    return SlideTransition(
      position: _slideAnim,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _kBgLayer2.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kText20, width: 0.5),
        ),
        child: _buildWordWrappedText(segment, playerState),
      ),
    );
  }

  /// When subtitle is hidden, show chapter name + progress.
  Widget _buildHiddenInfo(PlayerState playerState) {
    if (playerState.chapters.isEmpty) return const SizedBox.shrink();

    final chapter = playerState.chapters[playerState.currentChapterIndex];
    final heardCount = playerState.chapters.where((c) => c.isHeard).length;
    final totalCount = playerState.chapters.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            chapter.title.isNotEmpty ? chapter.title : '第${playerState.currentChapterIndex + 1}章',
            style: const TextStyle(
              color: _kText70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '已听 $heardCount/$totalCount 章',
            style: const TextStyle(color: _kText40, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Build subtitle text with each word tappable.
  Widget _buildWordWrappedText(TranscriptSegment segment, PlayerState playerState) {
    final words = segment.text.split(RegExp(r'(\s+)'));
    final spans = <InlineSpan>[];

    for (int i = 0; i < words.length; i++) {
      final w = words[i];
      if (w.trim().isEmpty) {
        spans.add(TextSpan(text: w));
        continue;
      }

      // Clean word for lookup (remove punctuation)
      final cleanWord = w.replaceAll(RegExp(r"[^\w'-]"), '');

      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: GestureDetector(
          onTap: () {
            _resetTimer();
            if (cleanWord.isNotEmpty) {
              _onWordTap(cleanWord, segment.text, playerState);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Text(
              w,
              style: const TextStyle(
                color: _kTextPrimary,
                fontSize: 18,
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ));

      // Add space between words
      if (i < words.length - 1) {
        spans.add(const TextSpan(text: ' '));
      }
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  void _onWordTap(String word, String sentence, PlayerState playerState) {
    // #29: Show word card bottom sheet
    showWordCardSheet(
      context: context,
      ref: ref,
      word: word,
      sentence: sentence,
      audioId: playerState.audioId ?? '',
      chapterId: playerState.chapters.isNotEmpty
          ? playerState.chapters[playerState.currentChapterIndex].id
          : null,
      sourceOffsetMs: playerState.position.inMilliseconds,
      onAskAgent: widget.onAskAgent,
    ).then((_) {
      // #30: After word card closes, reset subtitle 3s timer
      if (mounted && _visible) _resetTimer();
    });
  }
}

/// Global key to control subtitle overlay from outside.
final subtitleOverlayKey = GlobalKey<_SubtitleOverlayState>();
