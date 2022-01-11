import 'dart:async';

import 'package:f_logs/f_logs.dart';
import 'package:f_logs/models/file.dart';
import 'package:f_logs/services/logs_configuration.dart';

class LogsProvider {
  static LogConfig get config => LogsConfiguration.instance.config;

  // Singleton instance
  static final LogsProvider _singleton = LogsProvider._();

  /// Singleton accessor
  static LogsProvider get instance => _singleton;

  LogsProvider._();

  static _isLogLevelValid(LogLevel logLevel) {
    return LogLevel.values.indexOf(config.activeLogLevel) <= LogLevel.values.indexOf(logLevel) &&
        config.logLevelsEnabled.contains(config.activeLogLevel);
  }

  Future<List<Log>> getAll() async {
    return await LogsDatabase.instance.select();
  }

  write(Log log) {
    if (_isLogLevelValid(log.logLevel!)) {
      if (config.isDebuggable) {
        print(Formatter.format(log, config));
      }
      LogsDatabase.instance.insert(log);
    }
  }

  clear() {
    LogsDatabase.instance.delete();
  }

  Future<String> export(File? file) async {
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
