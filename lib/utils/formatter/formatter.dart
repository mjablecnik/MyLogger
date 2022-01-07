import 'package:f_logs/f_logs.dart';
import 'package:flutter/foundation.dart';
import 'package:template_string/template_string.dart';

class Formatter {
  static String format(Log log, LogsConfig config) {
    String output = config.outputFormat.insertTemplateValues({
      "time": log.timestamp!,
      "level": LogLevelConverter.fromEnumToString(log.logLevel),
      "message": log.text!,
      "class": log.className!,
      "method": log.methodName!,
      "exception": log.exception ?? '',
      "stacktrace": log.stacktrace ?? '',
    });

    if (config.isDevelopmentDebuggingEnabled) {
      output += !kReleaseMode ? " ${log.dataLogType} ${log.timeInMillis}" : "";
    }

    return "$output\n";
  }
}
