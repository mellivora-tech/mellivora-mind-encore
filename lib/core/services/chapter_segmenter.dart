import 'dart:math';

/// A draft chapter produced by the segmentation algorithm.
class ChapterDraft {
  final int startMs;
  final int endMs;
  final List<int> segmentIndexes;
  final String rawText;

  const ChapterDraft({
    required this.startMs,
    required this.endMs,
    required this.segmentIndexes,
    required this.rawText,
  });

  int get durationMs => endMs - startMs;

  @override
  String toString() =>
      'ChapterDraft(${startMs}ms-${endMs}ms, ${segmentIndexes.length} segs, '
      '${(durationMs / 1000 / 60).toStringAsFixed(1)}min)';
}

/// Input segment from Whisper transcription result.
class WhisperSegment {
  final int index;
  final String text;
  final int startMs;
  final int endMs;

  const WhisperSegment({
    required this.index,
    required this.text,
    required this.startMs,
    required this.endMs,
  });
}

/// Chapter segmentation algorithm.
///
/// Splits Whisper transcription segments into chapters using a hybrid approach:
/// 1. Natural pauses: gaps > [pauseThresholdMs] between segments are split points
/// 2. Duration window: target [targetMinMinutes]-[targetMaxMinutes] per chapter,
///    hard max [hardMaxMinutes]
/// 3. Sentence boundary alignment: never split mid-sentence (split at .?! boundaries)
class ChapterSegmenter {
  /// Gap threshold (ms) to consider a "natural pause" split point.
  final int pauseThresholdMs;

  /// Target minimum chapter duration in minutes.
  final double targetMinMinutes;

  /// Target maximum chapter duration in minutes.
  final double targetMaxMinutes;

  /// Hard maximum chapter duration in minutes.
  final double hardMaxMinutes;

  const ChapterSegmenter({
    this.pauseThresholdMs = 1500,
    this.targetMinMinutes = 3.0,
    this.targetMaxMinutes = 8.0,
    this.hardMaxMinutes = 10.0,
  });

  /// Segment a list of Whisper segments into chapters.
  ///
  /// Returns an empty list if [segments] is empty.
  List<ChapterDraft> segment(List<WhisperSegment> segments) {
    if (segments.isEmpty) return [];

    // Sort by startMs to ensure correct ordering
    final sorted = List<WhisperSegment>.from(segments)
      ..sort((a, b) => a.startMs.compareTo(b.startMs));

    // Step 1: Find all candidate split points
    final splitPoints = _findSplitPoints(sorted);

    // Step 2: Build chapters from split points
    return _buildChapters(sorted, splitPoints);
  }

  /// Find candidate split points based on natural pauses and sentence boundaries.
  /// Returns a set of segment indexes where a new chapter should START.
  List<int> _findSplitPoints(List<WhisperSegment> segments) {
    final points = <int>[];

    for (int i = 1; i < segments.length; i++) {
      final gap = segments[i].startMs - segments[i - 1].endMs;
      if (gap >= pauseThresholdMs) {
        // Natural pause detected — mark as potential split point
        points.add(i);
      }
    }

    return points;
  }

  /// Build chapters using split points, respecting duration constraints.
  List<ChapterDraft> _buildChapters(
    List<WhisperSegment> segments,
    List<int> naturalSplitPoints,
  ) {
    final targetMinMs = (targetMinMinutes * 60 * 1000).round();
    final targetMaxMs = (targetMaxMinutes * 60 * 1000).round();
    final hardMaxMs = (hardMaxMinutes * 60 * 1000).round();

    final chapters = <ChapterDraft>[];
    int chapterStart = 0; // index of first segment in current chapter

    // Convert split points to a Set for O(1) lookup
    final splitSet = naturalSplitPoints.toSet();

    int i = 0;
    while (i < segments.length) {
      final chapterStartMs = segments[chapterStart].startMs;
      final currentDuration = segments[i].endMs - chapterStartMs;

      // Check if we should split here
      bool shouldSplit = false;

      if (i == segments.length - 1) {
        // Last segment — must close the chapter
        shouldSplit = true;
      } else if (splitSet.contains(i + 1) && currentDuration >= targetMinMs) {
        // Natural pause at next segment AND we've reached minimum duration
        shouldSplit = true;
      } else if (currentDuration >= hardMaxMs) {
        // Hard max exceeded — force split at best sentence boundary
        shouldSplit = true;
      } else if (currentDuration >= targetMaxMs && _endsAtSentenceBoundary(segments[i].text)) {
        // Exceeded target max and current segment ends at sentence boundary
        shouldSplit = true;
      }

      if (shouldSplit) {
        // If we're at hard max and not at a sentence boundary,
        // look backward for the nearest sentence boundary
        int splitEnd = i;
        if (currentDuration >= hardMaxMs && !_endsAtSentenceBoundary(segments[i].text)) {
          splitEnd = _findNearestSentenceBoundary(segments, chapterStart, i);
        }

        chapters.add(_createChapter(segments, chapterStart, splitEnd));
        chapterStart = splitEnd + 1;
        i = chapterStart;
        continue;
      }

      i++;
    }

    // Handle any remaining segments not yet added
    if (chapterStart < segments.length && (chapters.isEmpty || chapters.last.segmentIndexes.last != segments.last.index)) {
      chapters.add(_createChapter(segments, chapterStart, segments.length - 1));
    }

    return chapters;
  }

  /// Find the nearest segment ending at a sentence boundary, searching backward from [end].
  /// Returns [end] if no sentence boundary is found (don't go below [start]+1 to avoid empty chapters).
  int _findNearestSentenceBoundary(
    List<WhisperSegment> segments,
    int start,
    int end,
  ) {
    // Search backward, but don't go before start+1 (keep at least 1 segment before split)
    for (int j = end; j > start; j--) {
      if (_endsAtSentenceBoundary(segments[j].text)) {
        return j;
      }
    }
    return end; // No sentence boundary found, split anyway
  }

  /// Check if text ends at a sentence boundary (period, question mark, exclamation mark).
  bool _endsAtSentenceBoundary(String text) {
    final trimmed = text.trimRight();
    if (trimmed.isEmpty) return false;

    final lastChar = trimmed[trimmed.length - 1];
    return lastChar == '.' || lastChar == '?' || lastChar == '!';
  }

  /// Create a ChapterDraft from a range of segments.
  ChapterDraft _createChapter(
    List<WhisperSegment> segments,
    int startIdx,
    int endIdx,
  ) {
    final chapterSegments = segments.sublist(startIdx, endIdx + 1);
    return ChapterDraft(
      startMs: chapterSegments.first.startMs,
      endMs: chapterSegments.last.endMs,
      segmentIndexes: chapterSegments.map((s) => s.index).toList(),
      rawText: chapterSegments.map((s) => s.text.trim()).join(' '),
    );
  }
}
