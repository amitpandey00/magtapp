import 'package:flutter/foundation.dart';

/// Simple logger utility for the application
/// Uses debugPrint in debug mode and is silent in release mode
class Logger {
  static void log(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('$prefix$message');
    }
  }

  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('$prefix❌ ERROR: $message');
      if (error != null) {
        debugPrint('$prefix  Error details: $error');
      }
      if (stackTrace != null) {
        debugPrint('$prefix  Stack trace: $stackTrace');
      }
    }
  }

  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('$prefix⚠️ WARNING: $message');
    }
  }

  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('$prefixℹ️ INFO: $message');
    }
  }

  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('$prefix🔍 DEBUG: $message');
    }
  }
}

