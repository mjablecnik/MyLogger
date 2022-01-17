import 'package:flogs/core/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:template_string/src/extension.dart';

import '../flogs.dart';

class Log {
  // Id will be gotten from the database.
  // It's automatically generated & unique for every stored Log.
  int? id;

  String? className;
  String? methodName;
  String? text;
  String? timestamp;
  String? exception;
  Enum? dataLogType;
  int? timeInMillis;
  LogLevel? logLevel;
  String? stacktrace;

  Log({
    this.className,
    this.methodName,
    this.text,
    this.timestamp,
    this.timeInMillis,
    this.exception,
    this.logLevel,
    this.dataLogType,
    this.stacktrace,
  }) {
    if (dataLogType != null) {
      final dataLogType = FLog.config.dataLogTypeValues.first.runtimeType;
      if (this.dataLogType.runtimeType != dataLogType) {
        throw "DataLogType is not: $dataLogType";
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      LogFields.className: className,
      LogFields.methodName: methodName,
      LogFields.text: text,
      LogFields.timestamp: timestamp,
      LogFields.timeInMillis: timeInMillis,
      LogFields.exception: exception,
      LogFields.dataLogType: Utils.fromEnumToString(dataLogType),
      LogFields.logLevel: Utils.fromEnumToString(logLevel),
      LogFields.stacktrace: stacktrace,
    };
  }

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      className: json[LogFields.className],
      methodName: json[LogFields.methodName],
      text: json[LogFields.text],
      timestamp: json[LogFields.timestamp],
      timeInMillis: json[LogFields.timeInMillis],
      exception: json[LogFields.exception],
      dataLogType: Utils.toEnum(FLog.config.dataLogTypeValues, json[LogFields.dataLogType]),
      logLevel: Utils.toEnum(LogLevel.values, json[LogFields.logLevel]),
      stacktrace: json[LogFields.stacktrace],
    );
  }

  @override
  String toString() {
    String output = FLog.config.outputFormat.insertTemplateValues({
      "time": timestamp!,
      "level": Utils.fromEnumToString(logLevel),
      "message": text!,
      "class": className!,
      "method": methodName!,
      "dataLogType": Utils.fromEnumToString(dataLogType) ?? FLog.config.defaultDataLogType,
      "exception": exception ?? '',
      "stacktrace": stacktrace ?? '',
    });

    if (FLog.config.isDevelopmentDebuggingEnabled) {
      output += !kReleaseMode ? " ${dataLogType} ${timeInMillis}" : "";
    }

    return "$output\n";
  }
}
