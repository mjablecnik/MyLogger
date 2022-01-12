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
    return Formatter.format(this, FLog.config);
  }
}
