import 'package:flutter/foundation.dart';

class Utils {
  static toEnum(List<Enum> values, String? value) =>
      value == null ? null : values.firstWhere((d) => describeEnum(d).toLowerCase() == value.toLowerCase());

  static fromEnumToString(e) => e?.toString().split('.').last;
}
