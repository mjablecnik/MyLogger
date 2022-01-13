import 'dart:async';

import 'package:flogs/flogs.dart';

class LogsConfiguration {
  Future<LogsDatabase> get database async => await LogsDatabase.instance;

  LogConfig _config = LogConfig();

  static final LogsConfiguration _singleton = LogsConfiguration._();

  static LogsConfiguration get instance => _singleton;

  LogsConfiguration._();

  LogConfig get config => _config;

  applyConfig(LogConfig config) {
    if (_config.encryption != EncryptionType.NONE && _config.encryptionKey.isEmpty) {
      throw Exception(Constants.EXCEPTION_NULL_KEY);
    }
    _config = config;
  }
}
