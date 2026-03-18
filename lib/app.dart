import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/services/notification_service.dart';
import 'features/agent/agent_push_service.dart';

class EncoreApp extends ConsumerStatefulWidget {
  const EncoreApp({super.key});

  @override
  ConsumerState<EncoreApp> createState() => _EncoreAppState();
}

class _EncoreAppState extends ConsumerState<EncoreApp> {
  Timer? _notificationCheckTimer;

  @override
  void initState() {
    super.initState();
    // Poll for pending notification taps (checked every 500ms after startup)
    _notificationCheckTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _handlePendingNotification();
    });
  }

  @override
  void dispose() {
    _notificationCheckTimer?.cancel();
    super.dispose();
  }

  void _handlePendingNotification() {
    final payload = NotificationService.pendingPayload;
    if (payload == null) return;
    NotificationService.pendingPayload = null;

    final router = ref.read(routerProvider);

    if (payload.startsWith('audio:')) {
      final audioId = payload.substring('audio:'.length);
      router.push('/player/$audioId');
    } else if (payload == 'weekly_report') {
      router.push('/weekly-report');
    } else if (payload.startsWith('agent_practice')) {
      final wordIds = AgentPushService.parsePayloadWordIds(payload);
      if (wordIds != null && wordIds.isNotEmpty) {
        router.push('/flashcard?wordIds=${wordIds.join(",")}');
      } else {
        router.go('/words');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Encore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
