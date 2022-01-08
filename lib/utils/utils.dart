import 'package:flutter/foundation.dart';

class Utils {
  static toEnum(e, String value) => e?.values.firstWhere((d) => describeEnum(d).toLowerCase() == value.toLowerCase());

  static fromEnumToString(e) => e?.toString().split('.').last;
}