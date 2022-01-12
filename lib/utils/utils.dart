import 'package:f_logs/models/config.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Utils {
  static toEnum(List<Enum> values, String? value) =>
      value == null ? null : values.firstWhere((d) => describeEnum(d).toLowerCase() == value.toLowerCase());

  static fromEnumToString(e) => e?.toString().split('.').last;

  static int getCurrentTimeInMillis() => DateTime.now().millisecondsSinceEpoch;

  static String getCurrentTime(LogConfig config) {
    if (config.timestampFormat.isEmpty) {
      return DateTime.now().toString();
    } else {
      return DateFormat(config.timestampFormat).format(DateTime.now());
    }
  }
}
