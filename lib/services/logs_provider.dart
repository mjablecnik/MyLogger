import 'dart:io' as io;
import 'dart:async';

import 'package:my_logger/logger.dart';

import '../logger_core.dart';

class LogsProvider {
  static LogConfig get config => LogsConfiguration.instance.config;

  static final LogsProvider _singleton = LogsProvider._();

  static LogsProvider get instance => _singleton;

  LogsProvider._();

  static _isLogLevelValid(LogLevel logLevel) {
    return LogLevel.values.indexOf(config.activeLogLevel) <= LogLevel.values.indexOf(logLevel) &&
        config.logLevelsEnabled.contains(config.activeLogLevel);
  }

  Future<List<Log>> getAll() async {
    return await LogsDatabase.instance.select(
      filters: LogFilter.all().generate(),
    );
  }

  Future<List<Log>> getLastHour() async {
    return await LogsDatabase.instance.select(
      filters: LogFilter.last60Minutes().generate(),
    );
  }

  Future<List<Log>> getByFilter(LogFilter filter) async {
    return await LogsDatabase.instance.select(
      filters: filter.generate(),
    );
  }

  write(Log log) {
    if (_isLogLevelValid(log.logLevel!)) {
      if (config.isDebuggable) {
        print(log);
      }
      LogsDatabase.instance.insert(log);
    }
  }

  deleteAll() {
    LogsDatabase.instance.delete();
  }

  deleteLastHour() {
    LogsDatabase.instance.delete(
      filters: LogFilter.last60Minutes().generate(),
    );
  }

  deleteByFilter(LogFilter filter) async {
    LogsDatabase.instance.delete(
      filters: filter.generate(),
    );
  }

  Future<io.File> export({String? fileName, LogFilter? filter, FileType? exportType}) async {
    final logs = filter == null ? getAll() : getByFilter(filter);
    final output = await LogsExporter.instance.writeLogsToFile(
      logs: await logs,
      file: LogFile(
        name: fileName ?? config.defaultExportFile.name,
        type: exportType ?? config.defaultExportFile.type,
      ),
    );
    return output;
  }
}
