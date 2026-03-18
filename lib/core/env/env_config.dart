import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get whisperApiKey => dotenv.env['WHISPER_API_KEY'] ?? '';
  static String get llmApiKey => dotenv.env['LLM_API_KEY'] ?? '';
  static String get googleClientId => dotenv.env['GOOGLE_CLIENT_ID'] ?? '';

  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
}
