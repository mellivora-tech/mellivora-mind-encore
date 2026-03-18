import 'package:flutter_test/flutter_test.dart';
import 'package:mellivora_english_app/core/services/chapter_segmenter.dart';

void main() {
  late ChapterSegmenter segmenter;

  setUp(() {
    segmenter = const ChapterSegmenter();
  });

  group('ChapterSegmenter', () {
    test('empty segments returns empty list', () {
      expect(segmenter.segment([]), isEmpty);
    });

    test('single short segment returns one chapter', () {
      final segments = [
        WhisperSegment(index: 0, text: 'Hello world.', startMs: 0, endMs: 5000),
      ];
      final chapters = segmenter.segment(segments);

      expect(chapters.length, 1);
      expect(chapters[0].startMs, 0);
      expect(chapters[0].endMs, 5000);
      expect(chapters[0].segmentIndexes, [0]);
      expect(chapters[0].rawText, 'Hello world.');
    });

    test('segments within target duration stay as one chapter', () {
      // Total: ~2 minutes — below target min (3 min), should be 1 chapter
      final segments = _generateSegments(
        count: 12,
        durationMs: 10000, // 10s each = 2 min total
        gapMs: 200,
      );
      final chapters = segmenter.segment(segments);

      expect(chapters.length, 1);
    });

    test('natural pause splits when duration meets minimum', () {
      // 40 segments * 10s = ~400s ≈ 6.67 min
      // Put a 2s gap (> 1.5s threshold) at segment 20 (~3.33 min)
      final segments = <WhisperSegment>[];
      int currentMs = 0;
      for (int i = 0; i < 40; i++) {
        final gap = (i == 20) ? 2000 : 200; // 2s gap at segment 20
        final start = currentMs + gap;
        final end = start + 10000;
        segments.add(WhisperSegment(
          index: i,
          text: 'Segment $i sentence.',
          startMs: start,
          endMs: end,
        ));
        currentMs = end;
      }

      final chapters = segmenter.segment(segments);

      expect(chapters.length, 2);
      expect(chapters[0].segmentIndexes.last, 19);
      expect(chapters[1].segmentIndexes.first, 20);
    });

    test('natural pause ignored when chapter too short', () {
      // 6 segments * 10s = 60s < 3 min minimum
      // Gap at segment 3 (30s in — too short to split)
      final segments = <WhisperSegment>[];
      int currentMs = 0;
      for (int i = 0; i < 6; i++) {
        final gap = (i == 3) ? 2000 : 200;
        final start = currentMs + gap;
        final end = start + 10000;
        segments.add(WhisperSegment(
          index: i,
          text: 'Segment $i.',
          startMs: start,
          endMs: end,
        ));
        currentMs = end;
      }

      final chapters = segmenter.segment(segments);

      expect(chapters.length, 1);
    });

    test('hard max forces split even without natural pause', () {
      // 80 segments * 10s = 800s ≈ 13.3 min — exceeds 10 min hard max
      // No natural pauses at all
      final segments = _generateSegments(
        count: 80,
        durationMs: 10000,
        gapMs: 200,
        addSentenceEnd: true,
      );

      final chapters = segmenter.segment(segments);

      // Should split into at least 2 chapters
      expect(chapters.length, greaterThanOrEqualTo(2));

      // No chapter should exceed hard max (10 min = 600000ms)
      for (final c in chapters) {
        expect(c.durationMs, lessThanOrEqualTo(600000 + 10200));
        // small tolerance for last segment
      }
    });

    test('sentence boundary alignment — avoids mid-sentence split', () {
      // Create segments: some end with period, some don't
      final segments = <WhisperSegment>[];
      int currentMs = 0;
      for (int i = 0; i < 70; i++) {
        final start = currentMs + 200;
        final end = start + 10000;
        // Only every 5th segment ends with a period
        final text = (i % 5 == 4) ? 'End of sentence $i.' : 'Middle of text $i';
        segments.add(WhisperSegment(
          index: i,
          text: text,
          startMs: start,
          endMs: end,
        ));
        currentMs = end;
      }

      final chapters = segmenter.segment(segments);

      // All chapters except possibly the last should end at sentence boundary
      for (int i = 0; i < chapters.length - 1; i++) {
        final lastText = chapters[i].rawText;
        final trimmed = lastText.trimRight();
        expect(
          trimmed.endsWith('.') || trimmed.endsWith('?') || trimmed.endsWith('!'),
          isTrue,
          reason: 'Chapter $i should end at sentence boundary, got: "$trimmed"',
        );
      }
    });

    test('all segments are covered — no gaps between chapters', () {
      final segments = _generateSegments(
        count: 50,
        durationMs: 10000,
        gapMs: 300,
        addSentenceEnd: true,
      );

      final chapters = segmenter.segment(segments);

      // Collect all segment indexes from chapters
      final allIndexes = chapters.expand((c) => c.segmentIndexes).toList();

      // Should contain all original indexes
      final expectedIndexes = segments.map((s) => s.index).toList();
      expect(allIndexes, expectedIndexes);
    });

    test('chapters are contiguous — no time overlap', () {
      final segments = _generateSegments(
        count: 60,
        durationMs: 10000,
        gapMs: 200,
        addSentenceEnd: true,
      );

      final chapters = segmenter.segment(segments);

      for (int i = 1; i < chapters.length; i++) {
        expect(
          chapters[i].startMs,
          greaterThanOrEqualTo(chapters[i - 1].endMs),
          reason: 'Chapter $i overlaps with chapter ${i - 1}',
        );
      }
    });

    test('question mark and exclamation mark are sentence boundaries', () {
      final segments = <WhisperSegment>[];
      int currentMs = 0;
      for (int i = 0; i < 70; i++) {
        final start = currentMs + 200;
        final end = start + 10000;
        String text;
        if (i % 7 == 6) {
          text = 'Is this a question?';
        } else if (i % 7 == 3) {
          text = 'What an exclamation!';
        } else {
          text = 'Continuing text $i';
        }
        segments.add(WhisperSegment(
          index: i,
          text: text,
          startMs: start,
          endMs: end,
        ));
        currentMs = end;
      }

      final chapters = segmenter.segment(segments);

      // All chapters except last should end with sentence boundary
      for (int i = 0; i < chapters.length - 1; i++) {
        final trimmed = chapters[i].rawText.trimRight();
        final lastChar = trimmed[trimmed.length - 1];
        expect(
          lastChar == '.' || lastChar == '?' || lastChar == '!',
          isTrue,
          reason: 'Chapter $i ends with "$lastChar"',
        );
      }
    });

    test('custom parameters are respected', () {
      final customSegmenter = ChapterSegmenter(
        pauseThresholdMs: 500, // lower threshold
        targetMinMinutes: 1.0,
        targetMaxMinutes: 2.0,
        hardMaxMinutes: 3.0,
      );

      // 30 segments * 10s = 300s = 5 min
      // Gap of 600ms at segment 10 (~1.7 min)
      final segments = <WhisperSegment>[];
      int currentMs = 0;
      for (int i = 0; i < 30; i++) {
        final gap = (i == 10) ? 600 : 200;
        final start = currentMs + gap;
        final end = start + 10000;
        segments.add(WhisperSegment(
          index: i,
          text: 'Segment $i.',
          startMs: start,
          endMs: end,
        ));
        currentMs = end;
      }

      final chapters = customSegmenter.segment(segments);

      // Should split at segment 10 (gap > 500ms threshold, duration > 1 min)
      expect(chapters.length, greaterThanOrEqualTo(2));
    });

    test('unsorted segments are handled correctly', () {
      final segments = [
        WhisperSegment(index: 2, text: 'Third.', startMs: 20000, endMs: 30000),
        WhisperSegment(index: 0, text: 'First.', startMs: 0, endMs: 10000),
        WhisperSegment(index: 1, text: 'Second.', startMs: 10000, endMs: 20000),
      ];

      final chapters = segmenter.segment(segments);

      expect(chapters.length, 1);
      expect(chapters[0].rawText, 'First. Second. Third.');
    });

    test('durationMs getter is correct', () {
      final draft = ChapterDraft(
        startMs: 1000,
        endMs: 5000,
        segmentIndexes: [0, 1],
        rawText: 'test',
      );
      expect(draft.durationMs, 4000);
    });
  });
}

/// Helper to generate evenly-spaced test segments.
List<WhisperSegment> _generateSegments({
  required int count,
  required int durationMs,
  required int gapMs,
  bool addSentenceEnd = false,
}) {
  final segments = <WhisperSegment>[];
  int currentMs = 0;
  for (int i = 0; i < count; i++) {
    final start = currentMs + gapMs;
    final end = start + durationMs;
    final text =
        addSentenceEnd ? 'Segment number $i content here.' : 'Segment number $i content here';
    segments.add(WhisperSegment(
      index: i,
      text: text,
      startMs: start,
      endMs: end,
    ));
    currentMs = end;
  }
  return segments;
}
