import 'package:flutter/foundation.dart';
import '../config/supabase_config.dart';

class Logger {
  static void log(String message, {String? tag}) {
    if (kDebugMode || SupabaseConfig.shouldLog) {
      final timestamp = DateTime.now().toIso8601String();
      final logTag = tag != null ? '[$tag]' : '';
      debugPrint('$timestamp $logTag $message');
    }
  }

  static void error(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode || SupabaseConfig.shouldLog) {
      final timestamp = DateTime.now().toIso8601String();
      final logTag = tag != null ? '[$tag]' : '';
      debugPrint('$timestamp $logTag ERROR: $message');
      if (error != null) {
        debugPrint('$timestamp $logTag Error details: $error');
      }
      if (stackTrace != null) {
        debugPrint('$timestamp $logTag Stack trace: $stackTrace');
      }
    }
  }

  static void warn(String message, {String? tag}) {
    if (kDebugMode || SupabaseConfig.shouldLog) {
      final timestamp = DateTime.now().toIso8601String();
      final logTag = tag != null ? '[$tag]' : '';
      debugPrint('$timestamp $logTag WARNING: $message');
    }
  }
}
