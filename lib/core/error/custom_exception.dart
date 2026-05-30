class CustomException implements Exception {
  static const apiUnavailableMessage =
      'We could not reach Expense Gem right now. '
      'Please check your connection and try again.';

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
