import 'package:my_logger/core/constants.dart';
import 'package:sembast/sembast.dart';

class LogFilter {
  final List<Enum>? dataLogsType;

  final List<Enum>? logLevels;

  final DateTime? startDateTime;

  final DateTime? endDateTime;

  const LogFilter({this.dataLogsType, this.logLevels, this.startDateTime, this.endDateTime});

  factory LogFilter.last10Minutes({List<Enum>? dataLogsType, List<Enum>? logLevels}) {
    return LogFilter(
      startDateTime: DateTime.now().subtract(Duration(minutes: 10)),
      logLevels: logLevels,
      dataLogsType: dataLogsType,
    );
  }

  factory LogFilter.last60Minutes({List<Enum>? dataLogsType, List<Enum>? logLevels}) {
    return LogFilter(
      startDateTime: _getSubtractedDateTime(1),
      logLevels: logLevels,
      dataLogsType: dataLogsType,
    );
  }

  factory LogFilter.last24Hours({List<Enum>? dataLogsType, List<Enum>? logLevels}) {
    return LogFilter(
      startDateTime: _getSubtractedDateTime(24),
      logLevels: logLevels,
      dataLogsType: dataLogsType,
    );
  }

  factory LogFilter.thisHour({List<Enum>? dataLogsType, List<Enum>? logLevels}) {
    return LogFilter(
      startDateTime: DateTime.now().subtract(Duration(minutes: DateTime.now().minute)),
      logLevels: logLevels,
      dataLogsType: dataLogsType,
    );
  }

  factory LogFilter.today({List<Enum>? dataLogsType, List<Enum>? logLevels}) {
    return LogFilter(
      startDateTime: _getTodayDateTime(),
      logLevels: logLevels,
      dataLogsType: dataLogsType,
    );
  }

  factory LogFilter.week({List<Enum>? dataLogsType, List<Enum>? logLevels}) {
    return LogFilter(
      startDateTime: _getTodayDateTime().subtract(Duration(days: 7)),
      logLevels: logLevels,
      dataLogsType: dataLogsType,
    );
  }

  factory LogFilter.all({List<Enum>? dataLogsType, List<Enum>? logLevels}) {
    return LogFilter(
      startDateTime: DateTime(2000, 1, 1),
      logLevels: logLevels,
      dataLogsType: dataLogsType,
    );
  }

  generate() {
    return _generateFilters(
      dataLogsType: this.dataLogsType ?? [],
      logLevels: this.logLevels ?? [],
      startDateTime: this.startDateTime,
      endDateTime: this.endDateTime,
    );
  }

  static _getSubtractedDateTime(int sub) => DateTime.now().subtract(Duration(hours: sub));

  static _getTodayDateTime() => _getSubtractedDateTime(DateTime.now().hour);

  static List<Filter> _generateFilters({
    List<Enum> dataLogsType = const [],
    List<Enum> logLevels = const [],
    DateTime? startDateTime,
    DateTime? endDateTime,
  }) {
    var filters = <Filter>[];

    if (dataLogsType.isNotEmpty) filters.add(Filter.inList(LogFields.dataLogType, dataLogsType));

    if (logLevels.isNotEmpty) filters.add(Filter.inList(LogFields.logLevel, logLevels));

    if (startDateTime != null)
      filters.add(Filter.greaterThan(LogFields.timeInMillis, startDateTime.millisecondsSinceEpoch));

    if (endDateTime != null)
      filters.add(Filter.lessThan(LogFields.timeInMillis, endDateTime.millisecondsSinceEpoch));

    return filters;
  }
}
