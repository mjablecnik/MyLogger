import 'package:flogs/utils/utils.dart';
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
      'className': className,
      'methodName': methodName,
      'text': text,
      'timestamp': timestamp,
      'timeInMillis': timeInMillis,
      'exception': exception,
      'dataLogType': Utils.fromEnumToString(dataLogType),
      'logLevel': Utils.fromEnumToString(logLevel),
      'stacktrace': stacktrace,
    };
  }

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      className: json['className'],
      methodName: json['methodName'],
      text: json['text'],
      timestamp: json['timestamp'],
      timeInMillis: json['timeInMillis'],
      exception: json['exception'],
      dataLogType: Utils.toEnum(FLog.config.dataLogTypeValues, json['dataLogType']),
      logLevel: Utils.toEnum(LogLevel.values, json['logLevel']),
      stacktrace: json['stacktrace'],
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
