import 'dart:async';

import 'package:f_logs/f_logs.dart';

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

  Future<String> export([File? file]) async {
    final logs = getAll();
    final output = await LogsExporter.instance.writeLogsToFile(
      file: file ?? config.defaultExportFile,
      logs: await logs,
    );
    return output.path;
  }

  sendToServer({required Uri serverAddress}) async {
    final file = await export(config.defaultExportFile);
    // TODO: Send exported logs into remote server
    // TODO: Delete ZIP file after send
  }
}
