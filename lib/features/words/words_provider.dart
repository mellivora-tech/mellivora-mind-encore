import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../vocabulary/vocabulary_repository.dart';
import 'review_repository.dart';

/// Filter tab for Words page.
enum WordsFilter { all, thisWeek, needReview }

/// Current filter state.
final wordsFilterProvider = StateProvider<WordsFilter>((ref) => WordsFilter.all);

/// Search query.
final wordsSearchQueryProvider = StateProvider<String>((ref) => '');

/// Filtered & searched vocabulary list.
final filteredVocabularyProvider =
    FutureProvider<List<VocabularyData>>((ref) async {
  final filter = ref.watch(wordsFilterProvider);
  final query = ref.watch(wordsSearchQueryProvider);
  final repo = ref.read(vocabularyRepositoryProvider);

  List<VocabularyData> items;

  switch (filter) {
    case WordsFilter.all:
      if (query.isNotEmpty) {
        items = await repo.searchVocabulary(query);
      } else {
        final all = await repo.getAllVocabulary();
        items = all.map((e) => e.vocab).toList();
      }
      break;
    case WordsFilter.thisWeek:
      items = await repo.getThisWeekVocabulary();
      break;
    case WordsFilter.needReview:
      items = await repo.getReviewDueVocabulary();
      break;
  }

  // Apply search filter for non-all tabs
  if (query.isNotEmpty && filter != WordsFilter.all) {
    final lower = query.toLowerCase();
    items = items
        .where((v) =>
            v.word.toLowerCase().contains(lower) ||
            v.meaning.toLowerCase().contains(lower))
        .toList();
  }

  return items;
});

/// Today's review count for badge.
final reviewDueCountProvider = FutureProvider<int>((ref) async {
  final repo = ref.read(reviewRepositoryProvider);
  return repo.getTodayReviewCount();
});
