import 'package:flutter/foundation.dart';
import 'dart:developer';

class Logger {
  static showLog(String status, String e) {
    if (kDebugMode) log("$status => ${e.toString()}");
  }
}
