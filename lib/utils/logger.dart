import 'package:flutter/foundation.dart';
import 'dart:developer';

enum LogLevel {
  none,
  info,
  debug,
  warning,
  error,
  functionalMessage,
  functionalError,
}

abstract class Logger {
  Logger(this.levels);

  Set<LogLevel> levels;
  Logger? _next;

  bool get universal => levels.containsAll(LogLevel.values);
  set next(Logger nextLogger) => _next = nextLogger;

  void addLevel(LogLevel level) => levels.add(level);

  void log(LogLevel level, String msg) {
    if (levels.contains(level) || universal) {
      writeLog(msg);
    }
    _next?.log(level, msg);
  }

  void writeLog(String msg);
}

class LoggerDebug extends Logger {
  LoggerDebug(Set<LogLevel> levels) : super(levels);

  @override
  void writeLog(String msg) {
    if (kDebugMode) log("[CONSOLE] => $msg");
  }
}

class LoggerError extends Logger {
  LoggerError(Set<LogLevel> levels) : super(levels);

  @override
  void writeLog(String msg) {
    if (kDebugMode) log("[ERROR] => $msg");
  }
}

class LoggerUtils {
  static void log(LogLevel level, String message) {
    Logger debugLog = LoggerDebug(Set.from(LogLevel.values));
    Logger errorLog = LoggerError({LogLevel.error, LogLevel.functionalError});
    debugLog.next = errorLog;
    debugLog.log(level, message);
  }
}
