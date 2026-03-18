import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../features/agent/agent_push_service.dart';

/// Service for local push notifications.
/// Handles transcription-complete, agent practice, and weekly report notifications.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool _hasPermission = false;

  /// Global navigator key for in-app fallback and notification tap navigation.
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Initialize the notification plugin and request permissions.
  Future<void> init() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Request permission on iOS
    if (Platform.isIOS) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      _hasPermission = granted ?? false;
    } else {
      // Android: create notification channels
      final androidPlugin =
          _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      const transcriptionChannel = AndroidNotificationChannel(
        'transcription_channel',
        'Transcription Notifications',
        description: 'Notifications for transcription completion',
        importance: Importance.high,
      );
      await androidPlugin?.createNotificationChannel(transcriptionChannel);

      const practiceChannel = AndroidNotificationChannel(
        'agent_practice_channel',
        'Agent Practice Reminders',
        description: 'Daily practice reminders from Agent',
        importance: Importance.high,
      );
      await androidPlugin?.createNotificationChannel(practiceChannel);

      const reportChannel = AndroidNotificationChannel(
        'weekly_report_channel',
        'Weekly Reports',
        description: 'Weekly learning report notifications',
        importance: Importance.high,
      );
      await androidPlugin?.createNotificationChannel(reportChannel);

      _hasPermission = true;
    }

    _initialized = true;
  }

  bool get hasPermission => _hasPermission;

  /// Show a notification when transcription completes.
  Future<void> showTranscriptionComplete({
    required String audioId,
    required String audioTitle,
    required int chapterCount,
  }) async {
    if (!_initialized) await init();

    const androidDetails = AndroidNotificationDetails(
      'transcription_channel',
      'Transcription Notifications',
      channelDescription: 'Notifications for transcription completion',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    if (_hasPermission) {
      await _plugin.show(
        audioId.hashCode,
        '转录完成 🎧',
        '$audioTitle 已转录完成，共 $chapterCount 个章节，可以开始学习了！',
        details,
        payload: 'audio:$audioId',
      );
    } else {
      _showInAppBanner(audioId, audioTitle, chapterCount);
    }
  }

  /// Show a notification when transcription fails.
  Future<void> showTranscriptionFailed({
    required String audioId,
    required String audioTitle,
  }) async {
    if (!_initialized) await init();

    const androidDetails = AndroidNotificationDetails(
      'transcription_channel',
      'Transcription Notifications',
      channelDescription: 'Notifications for transcription completion',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    if (_hasPermission) {
      await _plugin.show(
        audioId.hashCode,
        '转录失败',
        '$audioTitle 转录失败，请检查网络或 API Key 后重试',
        details,
        payload: 'audio:$audioId',
      );
    } else {
      final context = navigatorKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$audioTitle 转录失败，请检查网络或 API Key 后重试'),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  /// Fallback when notification permission is not granted.
  void _showInAppBanner(String audioId, String audioTitle, int chapterCount) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$audioTitle 已转录完成，共 $chapterCount 个章节，可以开始学习了！',
          ),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: '查看',
            onPressed: () {
              // Navigate to player
              navigatorKey.currentState?.pushNamed('/player/$audioId');
            },
          ),
        ),
      );
    }
  }

  /// Last tapped notification payload — consumed by router / UI.
  static String? pendingPayload;

  /// Handle notification tap — store payload for consumption.
  static void _onNotificationTap(NotificationResponse response) {
    pendingPayload = response.payload;
  }
}
