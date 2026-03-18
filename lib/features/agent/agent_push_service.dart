import 'package:drift/drift.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

import '../../core/database/app_database.dart';

/// #37 (US-A01): Agent practice push notification service.
/// Checks word_memory for words queried 3+ times in the past 7 days,
/// then schedules a daily local notification at user-configured time.
class AgentPushService {
  static final AgentPushService _instance = AgentPushService._internal();
  factory AgentPushService() => _instance;
  AgentPushService._internal();

  static const _kPracticeEnabledKey = 'agent_practice_push_enabled';
  static const _kPracticeHourKey = 'agent_practice_push_hour';
  static const _kPracticeMinuteKey = 'agent_practice_push_minute';
  static const _kNotificationId = 9001;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _tzInitialized = false;

  void _ensureTzInit() {
    if (!_tzInitialized) {
      tz_data.initializeTimeZones();
      _tzInitialized = true;
    }
  }

  /// Schedule or cancel the daily practice reminder based on user settings.
  Future<void> syncSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_kPracticeEnabledKey) ?? true;

    if (!enabled) {
      await _plugin.cancel(_kNotificationId);
      return;
    }

    final hour = prefs.getInt(_kPracticeHourKey) ?? 8;
    final minute = prefs.getInt(_kPracticeMinuteKey) ?? 0;

    _ensureTzInit();
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'agent_practice_channel',
      'Agent Practice Reminders',
      channelDescription: 'Daily practice reminders from Agent',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.zonedSchedule(
      _kNotificationId,
      '专项练习提醒',
      '检查本周高频查词中...',
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'agent_practice',
    );
  }

  /// Query word_memory for words queried >= 3 times in last 7 days,
  /// then fire a notification if any found.
  Future<void> checkAndNotify(AppDatabase db) async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_kPracticeEnabledKey) ?? true;
    if (!enabled) return;

    final weekAgo = DateTime.now().subtract(const Duration(days: 7));

    final rows = await (db.select(db.wordMemory)
          ..where((t) =>
              t.queryCount.isBiggerOrEqualValue(3) &
              t.lastQueriedAt.isBiggerOrEqualValue(weekAgo)))
        .get();

    if (rows.isEmpty) return;

    final wordCount = rows.length;
    final wordIds = rows.map((r) => r.wordId).toList();

    const androidDetails = AndroidNotificationDetails(
      'agent_practice_channel',
      'Agent Practice Reminders',
      channelDescription: 'Daily practice reminders from Agent',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(
      _kNotificationId,
      '专项练习提醒',
      '你有$wordCount个词这周查了3次以上，要做专项练习吗？',
      details,
      payload: 'agent_practice:${wordIds.join(",")}',
    );
  }

  /// Parse notification payload to extract word IDs.
  static List<String>? parsePayloadWordIds(String? payload) {
    if (payload == null || !payload.startsWith('agent_practice:')) return null;
    final ids = payload.substring('agent_practice:'.length);
    if (ids.isEmpty) return null;
    return ids.split(',');
  }

  /// Update push settings and re-sync schedule.
  Future<void> updateSettings({
    bool? enabled,
    int? hour,
    int? minute,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (enabled != null) await prefs.setBool(_kPracticeEnabledKey, enabled);
    if (hour != null) await prefs.setInt(_kPracticeHourKey, hour);
    if (minute != null) await prefs.setInt(_kPracticeMinuteKey, minute);
    await syncSchedule();
  }
}
