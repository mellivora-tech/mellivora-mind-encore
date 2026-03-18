import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  // 初始化本地通知（iOS/Android 权限申请）
  await NotificationService().init();

  runApp(
    const ProviderScope(
      child: EncoreApp(),
    ),
  );
}
