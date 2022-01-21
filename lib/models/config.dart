import 'package:flogs/models/log_file.dart';
import 'package:flogs/flogs.dart';

typedef String? StackTraceFormatter(StackTrace stackTrace);

class LogConfig {
  /// print logs in Logcat
  bool isDebuggable = true;

  /// print logs in Logcat
  bool isDevelopmentDebuggingEnabled = false;

  /// Logs are enabled
  bool isLogsEnabled = true;

  /// Your set of enabled levels, like INFO, WARNING, ERROR, SEVERE, ...
  /// default is all levels (compatibility to previous version)
  List<LogLevel> logLevelsEnabled = [
    LogLevel.ALL,
    LogLevel.TRACE,
    LogLevel.DEBUG,
    LogLevel.INFO,
    LogLevel.WARNING,
    LogLevel.ERROR,
    LogLevel.SEVERE,
    LogLevel.FATAL,
    LogLevel.OFF
  ];

  /// Active log level, lower levels are skipped
  /// default is LogLevel.INFO (compatibility to previous version)
  LogLevel activeLogLevel = LogLevel.INFO;

  /// Like Network, Database, Location etc
  List<Enum> dataLogTypeValues = DataLogType.values;

  /// Show this string if DataLogType is null
  String defaultDataLogType = 'NONE';

  /// Log data format
  String outputFormat = OutputLogFormat.FULL;

  /// Encryption enabled
  EncryptionType encryption = EncryptionType.NONE;

  /// Encryption Key
  String encryptionKey = "";

  /// Timestamp format
  String timestampFormat = TimestampFormat.DEFAULT;

  // Configure a custom formatter for the StackTrace
  StackTraceFormatter? stackTraceFormatter;

  LogFile defaultExportFile = LogFile(name: "LogExport", type: FileType.TXT);
}
