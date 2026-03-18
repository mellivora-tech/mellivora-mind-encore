import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/services/audio_player_service.dart';
import '../../shared/providers/app_providers.dart';
import '../vocabulary/vocabulary_repository.dart';
import 'flashcard_page.dart';
import 'words_provider.dart';

// ── Design tokens ──────────────────────────────────────────
const _kBgLayer1 = Color(0xFF1A1814);
const _kBgLayer2 = Color(0xFF242018);
const _kAccent = Color(0xFFF5A623);
const _kTextPrimary = Color(0xFFF0EBE0);
const _kText70 = Color(0xB3F0EBE0);
const _kText40 = Color(0x66F0EBE0);
const _kText20 = Color(0x33F0EBE0);
const _kText13 = Color(0x21F0EBE0);
const _kRed = Color(0xFFE57373);

/// #31 + #32: Words list page with tabs, search, and flashcard entry.
class WordsPage extends ConsumerStatefulWidget {
  const WordsPage({super.key});

  @override
  ConsumerState<WordsPage> createState() => _WordsPageState();
}

class _WordsPageState extends ConsumerState<WordsPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vocabAsync = ref.watch(filteredVocabularyProvider);
    final filter = ref.watch(wordsFilterProvider);
    final reviewCount = ref.watch(reviewDueCountProvider);

    return Scaffold(
      backgroundColor: _kBgLayer1,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 16, 0),
              child: Row(
                children: [
                  const Text(
                    'Words',
                    style: TextStyle(
                      color: _kTextPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  // Review button (#32)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const FlashcardPage(),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _kAccent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\u{2192} 复习',
                            style: TextStyle(
                              color: _kBgLayer1,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          reviewCount.when(
                            data: (count) => count > 0
                                ? Text(
                                    ' $count',
                                    style: TextStyle(
                                      color: _kBgLayer1,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Search bar (#32)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: _kBgLayer2,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: _kTextPrimary, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: '搜索单词或释义...',
                    hintStyle: TextStyle(color: _kText40, fontSize: 14),
                    prefixIcon:
                        Icon(Icons.search, color: _kText40, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  onChanged: (value) {
                    ref.read(wordsSearchQueryProvider.notifier).state = value;
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Filter tabs (#32)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterTab('全部', WordsFilter.all, filter),
                  const SizedBox(width: 8),
                  _buildFilterTab('本周新增', WordsFilter.thisWeek, filter),
                  const SizedBox(width: 8),
                  _buildFilterTab('待复习', WordsFilter.needReview, filter),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Word list
            Expanded(
              child: vocabAsync.when(
                data: (items) => items.isEmpty
                    ? _buildEmptyState()
                    : _buildWordList(items),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: _kAccent),
                ),
                error: (e, _) => Center(
                  child: Text('Error: $e',
                      style: const TextStyle(color: _kRed)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(
      String label, WordsFilter tab, WordsFilter current) {
    final isSelected = tab == current;
    return GestureDetector(
      onTap: () => ref.read(wordsFilterProvider.notifier).state = tab,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? _kAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? null
              : Border.all(color: _kText13, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? _kBgLayer1 : _kText40,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border_rounded,
              color: _kText20, size: 56),
          const SizedBox(height: 16),
          const Text(
            '查词后收藏的词会出现在这里',
            style: TextStyle(color: _kText40, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildWordList(List<VocabularyData> items) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      itemBuilder: (ctx, i) => _WordTile(
        vocab: items[i],
        onDelete: () => _confirmDelete(items[i]),
        onTapSource: () => _jumpToSource(items[i]),
      ),
    );
  }

  void _confirmDelete(VocabularyData vocab) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _kBgLayer2,
        title: const Text('删除词汇',
            style: TextStyle(color: _kTextPrimary)),
        content: Text('确定删除 "${vocab.word}"？',
            style: const TextStyle(color: _kText70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消', style: TextStyle(color: _kText40)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                final repo = ref.read(vocabularyRepositoryProvider);
                await repo.deleteVocabulary(vocab.id);
                ref.invalidate(filteredVocabularyProvider);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('删除失败: $e')),
                  );
                }
              }
            },
            child: const Text('删除', style: TextStyle(color: _kRed)),
          ),
        ],
      ),
    );
  }

  /// #31: Jump to source audio + seek to offset.
  void _jumpToSource(VocabularyData vocab) {
    if (vocab.sourceOffsetMs <= 0) return;

    ref.read(currentAudioIdProvider.notifier).state = vocab.audioId;
    ref.read(miniPlayerVisibleProvider.notifier).state = true;
    ref.read(playerOverlayVisibleProvider.notifier).state = true;

    // Seek after a short delay to let player load
    Future.delayed(const Duration(milliseconds: 500), () {
      ref
          .read(audioPlayerProvider.notifier)
          .seekTo(Duration(milliseconds: vocab.sourceOffsetMs));
    });
  }
}

class _WordTile extends StatelessWidget {
  final VocabularyData vocab;
  final VoidCallback onDelete;
  final VoidCallback onTapSource;

  const _WordTile({
    required this.vocab,
    required this.onDelete,
    required this.onTapSource,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(vocab.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: _kRed.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: _kRed),
      ),
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _kBgLayer2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  vocab.word,
                  style: const TextStyle(
                    color: _kTextPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                if (vocab.pos.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: _kAccent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      vocab.pos,
                      style:
                          const TextStyle(color: _kAccent, fontSize: 10),
                    ),
                  ),
                const Spacer(),
                Text(
                  _relativeTime(vocab.createdAt),
                  style: const TextStyle(color: _kText40, fontSize: 11),
                ),
              ],
            ),
            if (vocab.meaning.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                vocab.meaning,
                style: const TextStyle(color: _kText70, fontSize: 14),
              ),
            ],
            if (vocab.sourceOffsetMs > 0) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: onTapSource,
                child: Row(
                  children: [
                    const Text('\u{1F4FB}',
                        style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    Text(
                      _formatOffset(vocab.sourceOffsetMs),
                      style:
                          const TextStyle(color: _kText40, fontSize: 12),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.north_east,
                        color: _kText40, size: 10),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}天前';
    if (diff.inHours > 0) return '${diff.inHours}小时前';
    if (diff.inMinutes > 0) return '${diff.inMinutes}分钟前';
    return '刚刚';
  }

  String _formatOffset(int ms) {
    if (ms <= 0) return '';
    final m = (ms ~/ 60000).toString().padLeft(2, '0');
    final s = ((ms ~/ 1000) % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
