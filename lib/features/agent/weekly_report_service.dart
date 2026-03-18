import 'package:drift/drift.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

import '../../core/database/app_database.dart';

/// #38 (US-A02): Weekly learning report generation service.
/// Triggers every Sunday at 20:00 to generate stats and push notification.
class WeeklyReportService {
  static final WeeklyReportService _instance = WeeklyReportService._internal();
  factory WeeklyReportService() => _instance;
  WeeklyReportService._internal();

  static const _kReportEnabledKey = 'weekly_report_push_enabled';
  static const _kNotificationId = 9002;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _tzInitialized = false;

  void _ensureTzInit() {
    if (!_tzInitialized) {
      tz_data.initializeTimeZones();
      _tzInitialized = true;
    }
  }

  /// Schedule the weekly Sunday 20:00 notification.
  Future<void> syncSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_kReportEnabledKey) ?? true;

    if (!enabled) {
      await _plugin.cancel(_kNotificationId);
      return;
    }

    _ensureTzInit();
    final now = tz.TZDateTime.now(tz.local);
    // Find next Sunday 20:00
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 20, 0);
    while (scheduled.weekday != DateTime.sunday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'weekly_report_channel',
      'Weekly Reports',
      channelDescription: 'Weekly learning report notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.zonedSchedule(
      _kNotificationId,
      '本周学习报告',
      '点击查看你的本周学习数据',
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: 'weekly_report',
    );
  }

  /// Generate this week's report data from the database.
  Future<WeeklyReportData> generateReport(AppDatabase db) async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday % 7));
    final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day);

    // 1. Listened audio duration: sum of content_memory heard chapters this week
    final contentRows = await (db.select(db.contentMemory)
          ..where((t) => t.lastHeardAt.isBiggerOrEqualValue(weekStartDate)))
        .get();
    final audioSessions = contentRows.length;

    // Estimate listened time from chapters heard * avg 45s per chapter
    int totalChaptersHeard = 0;
    for (final row in contentRows) {
      totalChaptersHeard += row.chaptersHeard;
    }
    final listenedMinutes = (totalChaptersHeard * 45 / 60).round();

    // 2. Query count: word_memory.last_queried_at this week
    final queryRows = await (db.select(db.wordMemory)
          ..where((t) => t.lastQueriedAt.isBiggerOrEqualValue(weekStartDate)))
        .get();
    final queryCount = queryRows.fold<int>(0, (sum, r) => sum + r.queryCount);

    // 3. New vocabulary count: vocabulary.created_at this week
    final newVocab = await (db.select(db.vocabulary)
          ..where((t) => t.createdAt.isBiggerOrEqualValue(weekStartDate)))
        .get();
    final newWordCount = newVocab.length;

    // 4. Review accuracy: review_schedule this week
    final allReviews = await (db.select(db.reviewSchedule)).get();
    int correctCount = 0;
    int totalReviews = 0;
    for (final r in allReviews) {
      if (r.lastResult.isNotEmpty) {
        totalReviews++;
        if (r.lastResult == 'correct') correctCount++;
      }
    }
    final accuracy = totalReviews > 0 ? (correctCount / totalReviews * 100).round() : 0;

    // 5. Hardest word: word_memory with highest query_count
    final allMemory = await (db.select(db.wordMemory)
          ..orderBy([(t) => OrderingTerm.desc(t.queryCount)])
          ..limit(1))
        .get();
    String hardestWord = '';
    if (allMemory.isNotEmpty) {
      final vocab = await (db.select(db.vocabulary)
            ..where((t) => t.id.equals(allMemory.first.wordId)))
          .getSingleOrNull();
      hardestWord = vocab?.word ?? '';
    }

    return WeeklyReportData(
      audioSessions: audioSessions,
      listenedMinutes: listenedMinutes,
      queryCount: queryCount,
      newWordCount: newWordCount,
      reviewAccuracy: accuracy,
      totalReviews: totalReviews,
      hardestWord: hardestWord,
      weekStartDate: weekStartDate,
    );
  }

  /// Generate report and send push notification.
  Future<void> checkAndNotify(AppDatabase db) async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_kReportEnabledKey) ?? true;
    if (!enabled) return;

    final report = await generateReport(db);

    const androidDetails = AndroidNotificationDetails(
      'weekly_report_channel',
      'Weekly Reports',
      channelDescription: 'Weekly learning report notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(
      _kNotificationId,
      '本周学习报告',
      '听了${report.audioSessions}段·${report.listenedMinutes}分钟·查词${report.queryCount}次·新词${report.newWordCount}个',
      details,
      payload: 'weekly_report',
    );
  }

  Future<void> updateSettings({bool? enabled}) async {
    final prefs = await SharedPreferences.getInstance();
    if (enabled != null) await prefs.setBool(_kReportEnabledKey, enabled);
    await syncSchedule();
  }
}

class WeeklyReportData {
  final int audioSessions;
  final int listenedMinutes;
  final int queryCount;
  final int newWordCount;
  final int reviewAccuracy;
  final int totalReviews;
  final String hardestWord;
  final DateTime weekStartDate;

  const WeeklyReportData({
    required this.audioSessions,
    required this.listenedMinutes,
    required this.queryCount,
    required this.newWordCount,
    required this.reviewAccuracy,
    required this.totalReviews,
    required this.hardestWord,
    required this.weekStartDate,
  });
}
