import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/openai_service.dart';
import 'vocabulary_repository.dart';

// ── Design tokens ──────────────────────────────────────────
const _kBgLayer2 = Color(0xFF242018);
const _kAccent = Color(0xFFF5A623);
const _kTextPrimary = Color(0xFFF0EBE0);
const _kText70 = Color(0xB3F0EBE0);
const _kText40 = Color(0x66F0EBE0);
const _kText20 = Color(0x33F0EBE0);
const _kGreen = Color(0xFF4CAF50);

/// In-memory cache for word definitions within a session.
final _definitionCache = <String, WordDefinition>{};

class WordDefinition {
  final String phonetic;
  final String pos;
  final String meaning;

  const WordDefinition({
    this.phonetic = '',
    this.pos = '',
    this.meaning = '',
  });
}

/// #29: Word Card Bottom Sheet — tap word in subtitle → sheet with definition.
/// #30: Add to vocabulary + playback not interrupted.
Future<void> showWordCardSheet({
  required BuildContext context,
  required WidgetRef ref,
  required String word,
  required String sentence,
  required String audioId,
  String? chapterId,
  int sourceOffsetMs = 0,
  VoidCallback? onAskAgent,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    // #30: isDismissible true — audio continues playing
    isDismissible: true,
    builder: (ctx) => _WordCardContent(
      word: word,
      sentence: sentence,
      audioId: audioId,
      chapterId: chapterId,
      sourceOffsetMs: sourceOffsetMs,
      onAskAgent: onAskAgent,
    ),
  );
}

class _WordCardContent extends ConsumerStatefulWidget {
  final String word;
  final String sentence;
  final String audioId;
  final String? chapterId;
  final int sourceOffsetMs;
  final VoidCallback? onAskAgent;

  const _WordCardContent({
    required this.word,
    required this.sentence,
    required this.audioId,
    this.chapterId,
    this.sourceOffsetMs = 0,
    this.onAskAgent,
  });

  @override
  ConsumerState<_WordCardContent> createState() => _WordCardContentState();
}

class _WordCardContentState extends ConsumerState<_WordCardContent> {
  WordDefinition? _definition;
  bool _loading = true;
  bool _isCollected = false;
  String? _vocabId;

  @override
  void initState() {
    super.initState();
    _loadDefinition();
    _checkCollected();
  }

  Future<void> _loadDefinition() async {
    final cacheKey = widget.word.toLowerCase();

    // Check cache first
    if (_definitionCache.containsKey(cacheKey)) {
      if (mounted) {
        setState(() {
          _definition = _definitionCache[cacheKey];
          _loading = false;
        });
      }
      return;
    }

    // Call OpenAI
    final openai = ref.read(openAIServiceProvider);
    if (!openai.isConfigured) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    try {
      final response = await openai.chatCompletion(
        systemPrompt:
            '你是一个英语词典助手。请为单词提供：音标、词性、中文释义（≤20字）。'
            '仅返回JSON格式：{"phonetic":"...","pos":"...","meaning":"..."}',
        userMessage:
            '单词："${widget.word}"。上下文：${widget.sentence}',
      );

      final parsed = OpenAIService.parseWordDefinition(response);
      final def = WordDefinition(
        phonetic: parsed?['phonetic'] ?? '',
        pos: parsed?['pos'] ?? '',
        meaning: parsed?['meaning'] ?? '',
      );

      _definitionCache[cacheKey] = def;

      if (mounted) {
        setState(() {
          _definition = def;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _checkCollected() async {
    final repo = ref.read(vocabularyRepositoryProvider);
    final collected =
        await repo.isWordCollected(widget.word, widget.audioId);
    if (mounted) setState(() => _isCollected = collected);
  }

  Future<void> _addToVocabulary() async {
    final repo = ref.read(vocabularyRepositoryProvider);
    final id = await repo.addToVocabulary(
      word: widget.word,
      phonetic: _definition?.phonetic ?? '',
      pos: _definition?.pos ?? '',
      meaning: _definition?.meaning ?? '',
      audioId: widget.audioId,
      chapterId: widget.chapterId,
      sourceOffsetMs: widget.sourceOffsetMs,
    );

    // Update word_memory query count
    await repo.updateWordMemoryOnQuery(id);

    if (mounted) {
      setState(() {
        _isCollected = true;
        _vocabId = id;
      });

      // #30: Toast
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('已加入词汇本'),
          duration: Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.5,
      decoration: const BoxDecoration(
        color: _kBgLayer2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: _kText20,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _loading ? _buildSkeleton() : _buildContent(),
            ),
          ),

          // Bottom buttons
          _buildBottomBar(),
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Word placeholder
        Container(
          width: 120,
          height: 32,
          decoration: BoxDecoration(
            color: _kText20,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 80,
          height: 16,
          decoration: BoxDecoration(
            color: _kText20,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 16,
          decoration: BoxDecoration(
            color: _kText20,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 200,
          height: 16,
          decoration: BoxDecoration(
            color: _kText20,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Word
          Text(
            widget.word,
            style: const TextStyle(
              color: _kTextPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),

          // Phonetic
          if (_definition?.phonetic.isNotEmpty == true)
            Text(
              _definition!.phonetic,
              style: const TextStyle(color: _kText40, fontSize: 15),
            ),
          const SizedBox(height: 8),

          // POS + Meaning
          if (_definition != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_definition!.pos.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _kAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _definition!.pos,
                      style:
                          const TextStyle(color: _kAccent, fontSize: 12),
                    ),
                  ),
                if (_definition!.pos.isNotEmpty) const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _definition!.meaning,
                    style: const TextStyle(
                      color: _kTextPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],

          if (_definition == null)
            const Text(
              'API Key 未配置，无法获取释义',
              style: TextStyle(color: _kText40, fontSize: 14),
            ),

          const SizedBox(height: 24),

          // Source sentence with word highlighted
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _kText20.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildHighlightedSentence(),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedSentence() {
    final sentence = widget.sentence;
    final word = widget.word;
    final lowerSentence = sentence.toLowerCase();
    final lowerWord = word.toLowerCase();
    final idx = lowerSentence.indexOf(lowerWord);

    if (idx < 0) {
      return Text(
        sentence,
        style: const TextStyle(color: _kText70, fontSize: 15, height: 1.5),
      );
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: _kText70, fontSize: 15, height: 1.5),
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

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Add to vocabulary button (#30)
          Expanded(
            child: GestureDetector(
              onTap: _isCollected ? null : _addToVocabulary,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: _isCollected
                      ? _kGreen.withOpacity(0.15)
                      : _kAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    _isCollected ? '\u2713 已加入' : '+ 加入词汇本',
                    style: TextStyle(
                      color: _isCollected ? _kGreen : _kBgLayer2,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // #36: Ask Agent button
          if (widget.onAskAgent != null) ...[
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                widget.onAskAgent?.call();
              },
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: _kAccent, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('\u{1F916}', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 4),
                    Text(
                      '继续问 Agent',
                      style: TextStyle(
                        color: _kAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
