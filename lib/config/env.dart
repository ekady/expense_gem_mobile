import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get backendUrl => dotenv.env['BACKEND_URL'] ?? 'https://api.expense-tracker.com';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';

  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
  }
} 