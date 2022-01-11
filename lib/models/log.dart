import 'package:f_logs/utils/utils.dart';

import '../f_logs.dart';

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
      if (dataLogType.runtimeType != FLog.config.dataLogType) {
        throw "DataLogType is not: ${FLog.config.dataLogType}";
      }
    }
  }

  /// Converts class to json
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

  /// create `Log` from json
  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      className: json['className'],
      methodName: json['methodName'],
      text: json['text'],
      timestamp: json['timestamp'],
      timeInMillis: json['timeInMillis'],
      exception: json['exception'],
      dataLogType: Utils.toEnum(FLog.config.dataLogType, json['dataLogType']),
      logLevel: Utils.toEnum(LogLevel, json['logLevel']),
      stacktrace: json['stacktrace'],
    );
  }
}
