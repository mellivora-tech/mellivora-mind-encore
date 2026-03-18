import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'review_repository.dart';

// ── Design tokens ──────────────────────────────────────────
const _kBgLayer1 = Color(0xFF1A1814);
const _kBgLayer2 = Color(0xFF242018);
const _kAccent = Color(0xFFF5A623);
const _kTextPrimary = Color(0xFFF0EBE0);
const _kText70 = Color(0xB3F0EBE0);
const _kText40 = Color(0x66F0EBE0);
const _kText20 = Color(0x33F0EBE0);
const _kGreen = Color(0xFF4CAF50);
const _kRed = Color(0xFFE57373);

/// #33: Flashcard page with 3D flip animation + Ebbinghaus review queue.
/// #37: Supports optional [wordIds] for targeted practice mode.
class FlashcardPage extends ConsumerStatefulWidget {
  /// If non-null, only review these specific words (targeted practice).
  final List<String>? wordIds;

  const FlashcardPage({super.key, this.wordIds});

  @override
  ConsumerState<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends ConsumerState<FlashcardPage> {
  List<ReviewItem> _queue = [];
  int _currentIndex = 0;
  bool _loading = true;
  int _correctCount = 0;
  final List<ReviewItem> _wrongItems = [];
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _loadQueue();
  }

  Future<void> _loadQueue() async {
    try {
      final repo = ref.read(reviewRepositoryProvider);
      final wordIds = widget.wordIds;

      List<ReviewItem> queue;
      if (wordIds != null && wordIds.isNotEmpty) {
        // #37: Targeted practice mode — load only specified words
        queue = await repo.getReviewQueueForWords(wordIds);
      } else {
        queue = await repo.getTodayReviewQueue();
      }

      if (mounted) {
        setState(() {
          _queue = queue;
          _loading = false;
          _finished = queue.isEmpty;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _finished = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载复习队列失败: $e')),
        );
      }
    }
  }

  void _onRemembered() async {
    if (_currentIndex >= _queue.length) return;

    final item = _queue[_currentIndex];
    try {
      final repo = ref.read(reviewRepositoryProvider);
      await repo.markRemembered(item.vocab.id);
    } catch (_) {
      // DB error — continue anyway so user isn't blocked
    }

    setState(() {
      _correctCount++;
      _currentIndex++;
      if (_currentIndex >= _queue.length) {
        _finished = true;
      }
    });
  }

  void _onForgotten() async {
    if (_currentIndex >= _queue.length) return;

    final item = _queue[_currentIndex];
    try {
      final repo = ref.read(reviewRepositoryProvider);
      await repo.markForgotten(item.vocab.id);
    } catch (_) {
      // DB error — continue anyway
    }

    setState(() {
      _wrongItems.add(item);
      _currentIndex++;
      if (_currentIndex >= _queue.length) {
        _finished = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBgLayer1,
      appBar: AppBar(
        backgroundColor: _kBgLayer1,
        foregroundColor: _kTextPrimary,
        title: _loading || _finished
            ? Text(
                widget.wordIds != null ? '专项练习' : '复习',
                style: const TextStyle(fontSize: 18),
              )
            : Text(
                '${_currentIndex + 1} / ${_queue.length}',
                style: const TextStyle(color: _kText70, fontSize: 16),
              ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: _kAccent))
          : _finished
              ? _buildCompletionPage()
              : _buildFlashcard(),
    );
  }

  Widget _buildFlashcard() {
    final item = _queue[_currentIndex];
    return Column(
      children: [
        // Card area
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _FlipCard(
              front: _buildFront(item),
              back: _buildBack(item),
            ),
          ),
        ),

        // Action buttons
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40),
          child: Row(
            children: [
              // Forgotten
              Expanded(
                child: GestureDetector(
                  onTap: _onForgotten,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: _kText20,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text(
                        '还不会',
                        style: TextStyle(
                          color: _kText70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Remembered
              Expanded(
                child: GestureDetector(
                  onTap: _onRemembered,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: _kAccent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        '记住了 \u2713',
                        style: TextStyle(
                          color: _kBgLayer1,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFront(ReviewItem item) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _kBgLayer2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kText20, width: 0.5),
      ),
      child: Center(
        child: Text(
          item.vocab.word,
          style: const TextStyle(
            color: _kTextPrimary,
            fontSize: 36,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildBack(ReviewItem item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _kBgLayer2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kAccent.withOpacity(0.3), width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Chinese meaning
          Text(
            item.vocab.meaning.isNotEmpty
                ? item.vocab.meaning
                : item.vocab.definition,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _kTextPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (item.vocab.phonetic.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              item.vocab.phonetic,
              style: const TextStyle(color: _kText40, fontSize: 16),
            ),
          ],
          if (item.sourceSentence.isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _kText20.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _buildHighlightedSentence(
                  item.sourceSentence, item.vocab.word),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHighlightedSentence(String sentence, String word) {
    final lower = sentence.toLowerCase();
    final idx = lower.indexOf(word.toLowerCase());
    if (idx < 0) {
      return Text(
        sentence,
        style: const TextStyle(color: _kText70, fontSize: 14, height: 1.5),
      );
    }
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: _kText70, fontSize: 14, height: 1.5),
        children: [
          TextSpan(text: sentence.substring(0, idx)),
          TextSpan(
            text: sentence.substring(idx, idx + word.length),
            style: const TextStyle(
              color: _kAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: sentence.substring(idx + word.length)),
        ],
      ),
    );
  }

  Widget _buildCompletionPage() {
    final total = _queue.length;
    final correctRate =
        total > 0 ? (_correctCount / total * 100).round() : 0;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (total == 0) ...[
            const Icon(Icons.check_circle_outline,
                color: _kGreen, size: 64),
            const SizedBox(height: 16),
            const Text(
              '今天没有需要复习的词',
              style: TextStyle(
                color: _kTextPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else ...[
            const Text(
              '\u{1F389}',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 16),
            const Text(
              '复习完成！',
              style: TextStyle(
                color: _kTextPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '正确率 $correctRate%',
              style: TextStyle(
                color: correctRate >= 80 ? _kGreen : _kAccent,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_wrongItems.isNotEmpty) ...[
              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '还不会的词：',
                  style: TextStyle(color: _kText70, fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _wrongItems.length,
                  itemBuilder: (ctx, i) {
                    final item = _wrongItems[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _kBgLayer2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.vocab.word,
                              style: const TextStyle(
                                color: _kTextPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            item.vocab.meaning.isNotEmpty
                                ? item.vocab.meaning
                                : item.vocab.definition,
                            style:
                                const TextStyle(color: _kText70, fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: _kAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '返回',
                  style: TextStyle(
                    color: _kBgLayer1,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// #33: 3D Flip Card Widget — Y-axis 180 degree rotation.
class _FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;

  const _FlipCard({required this.front, required this.back});

  @override
  State<_FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<_FlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void didUpdateWidget(_FlipCard old) {
    super.didUpdateWidget(old);
    // Reset flip when card content changes (new word)
    if (_controller.value != 0) {
      _controller.reset();
      _isFront = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (ctx, _) {
          final angle = _controller.value * pi;
          final showFront = angle < pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateY(angle),
            child: showFront
                ? widget.front
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: widget.back,
                  ),
          );
        },
      ),
    );
  }
}

