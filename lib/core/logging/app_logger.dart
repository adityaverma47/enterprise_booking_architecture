import 'package:flutter/foundation.dart';

/// Centralized logging abstraction
/// Supports different log levels and can be extended for production monitoring
abstract class AppLogger {
  void debug(String message, [Object? error, StackTrace? stackTrace]);
  void info(String message, [Object? error, StackTrace? stackTrace]);
  void warning(String message, [Object? error, StackTrace? stackTrace]);
  void error(String message, [Object? error, StackTrace? stackTrace]);
}

/// Default implementation using Flutter's debugPrint
class DefaultAppLogger implements AppLogger {
  @override
  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('[DEBUG] $message');
      if (error != null) debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('Stack: $stackTrace');
    }
  }

  @override
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('[INFO] $message');
      if (error != null) debugPrint('Error: $error');
    }
  }

  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('[WARNING] $message');
      if (error != null) debugPrint('Error: $error');
    }
  }

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    debugPrint('[ERROR] $message');
    if (error != null) debugPrint('Error: $error');
    if (stackTrace != null) debugPrint('Stack: $stackTrace');
  }
}
