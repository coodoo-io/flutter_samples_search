/// Error thrown by the runtime system when app config parameter is missing
class AppConfigError extends Error {
  final String message;

  /// Creates an assertion error with the provided [message].
  AppConfigError({required this.message});

  @override
  String toString() {
    return 'AppConfig missing: ${Error.safeToString(message)}';
  }
}
