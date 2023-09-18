import 'package:flutter/foundation.dart';
import 'package:my_logger/logger_core.dart';
import 'package:my_logger/models/logger.dart';
import 'package:jinja/jinja.dart';

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
      final dataLogType = MyLogger.config.dataLogTypeValues.first.runtimeType;
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
      dataLogType: Utils.toEnum(MyLogger.config.dataLogTypeValues, json[LogFields.dataLogType]),
      logLevel: Utils.toEnum(LogLevel.values, json[LogFields.logLevel]),
      stacktrace: json[LogFields.stacktrace],
    );
  }

  @override
  String toString() {
    var template = Environment().fromString(MyLogger.config.outputFormat);
    String output = template.render({
      "time": timestamp!,
      "level": Utils.fromEnumToString(logLevel),
      "message": text!,
      "class": className!,
      "method": methodName!,
      "dataLogType": Utils.fromEnumToString(dataLogType) ?? MyLogger.config.defaultDataLogType,
      "exception": exception ?? '',
      "stacktrace": stacktrace ?? '',
    });

    if (MyLogger.config.isDevelopmentDebuggingEnabled) {
      output += !kReleaseMode ? " ${dataLogType} ${timeInMillis}" : "";
    }

    return "$output\n";
  }
}
