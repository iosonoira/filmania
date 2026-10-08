import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;

abstract class AppLogger {
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('[DEBUG]${tag != null ? '[$tag]' : ''} $message');
    }
  }

  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('[INFO]${tag != null ? '[$tag]' : ''} $message');
    }
  }

  static void warning(String message, {String? tag}) {
    debugPrint('[WARN]${tag != null ? '[$tag]' : ''} $message');
  }

  static void error(
    String message, {
    String? tag,
    Object? exception,
    StackTrace? stackTrace,
  }) {
    debugPrint('[ERROR]${tag != null ? '[$tag]' : ''} $message');
    if (exception != null) debugPrint('  Exception: $exception');
    if (stackTrace != null) debugPrint('  StackTrace: $stackTrace');
  }
}
