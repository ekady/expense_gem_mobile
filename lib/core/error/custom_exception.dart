class CustomException implements Exception {
  final String message;

  CustomException(this.message);

  @override
  String toString() {
    if (message.isEmpty) {
      return 'An unexpected error occurred';
    }
    return message;
  }
}