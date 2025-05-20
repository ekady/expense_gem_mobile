
class Env {
  static String get backendUrl => 'http://localhost:3000';

  static Future<void> init() async {
    try {
      //
    } catch (e) {
      print('Error loading .env file: $e');
      // Fallback to default values if .env file is not found
    }
  }
}
