class RefreshTokenMissingException implements Exception {
  final String message;
  RefreshTokenMissingException([this.message = 'No refresh token available']);

  @override
  String toString() => 'RefreshTokenMissingException: $message';
}
