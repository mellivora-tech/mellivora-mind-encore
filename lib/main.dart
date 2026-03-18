import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/services/notification_service.dart';
import 'features/agent/agent_push_service.dart';
import 'features/agent/weekly_report_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  runApp(
    const ProviderScope(
      child: EncoreApp(),
    ),
  );

  // #40: Defer non-critical initialization to after first frame
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await NotificationService().init();
    // #37: Sync agent practice push schedule
    await AgentPushService().syncSchedule();
    // #38: Sync weekly report push schedule
    await WeeklyReportService().syncSchedule();
  });
}
