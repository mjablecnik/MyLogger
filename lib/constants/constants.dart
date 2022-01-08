class Constants {
  Constants._();

  /// Directory
  static const DIRECTORY_NAME = 'FLogs';

  /// Encryption key null exception
  static const EXCEPTION_NULL_KEY =
      // ignore: lines_longer_than_80_chars
      'Encryption key is not provided, please provide encryption key in LogsConfig';

  // Print Messages
  static const PRINT_EXPORT_MSG =
      // ignore: lines_longer_than_80_chars
      '\n--------------------------------------------------------------------------------------------\nExporting Logs: This might take a while depending upon the size\n--------------------------------------------------------------------------------------------';

  /// Print Log Messages
  static const PRINT_LOG_MSG =
      // ignore: lines_longer_than_80_chars
      '\n--------------------------------------------------------------------------------------------\nPrinting Logs: This might take a while depending upon the size\n---------------------------------------------------------------------------------------------';

  /// Print Data Logs Messages
  static const PRINT_DATA_LOG_MSG =
      // ignore: lines_longer_than_80_chars
      '\n--------------------------------------------------------------------------------------------\nPrinting Data Logs: This might take a while depending upon the size\n----------------------------------------------------------------------------------------';
}

class TimestampFormat {
  static const DEFAULT = "";
  static const DATE_FORMAT_1 = "ddMMyyyy";
  static const DATE_FORMAT_2 = "MM/dd/yyyy";
  static const TIME_FORMAT_FULL_JOINED = "ddMMyyyy_kkmmss_a";
  static const TIME_FORMAT_FULL_1 = "dd MMMM yyyy kk:mm:ss";
  static const TIME_FORMAT_FULL_2 = "MM:dd:yyyy hh:mm:ss a";
  static const TIME_FORMAT_FULL_3 = "yyyy-MM-dd kk:mm:ss";
  static const TIME_FORMAT_24_FULL = "dd/MM/yyyy kk:mm:ss";
  static const TIME_FORMAT_READABLE = "dd MMMM yyyy hh:mm:ss a";
  static const TIME_FORMAT_SIMPLE = "kk:mm:ss";
}

class OutputLogFormat {
  static const DEFAULT = "{{time}} {{level}} [{{class}}:{{method}}] -> {{message}} {{exception}} {{stacktrace}}";
  static const BASIC = "{{time}} {{level}} {{message}}";
  static const SIMPLE = "{{time}} {{level}} - {{message}} {{exception}} {{stacktrace}}";
  static const FULL = "{{time}} {{level}} [{{class}}:{{method}}] DataLogType.{{dataLogType}} -> {{message}} {{exception}} {{stacktrace}}";
}

enum LogLevel { ALL, TRACE, DEBUG, INFO, WARNING, ERROR, SEVERE, FATAL, OFF }

enum FilterType { LAST_HOUR, LAST_24_HOURS, TODAY, WEEK, ALL }

enum DataLogType { DEFAULT, DEVICE, LOCATION, NOTIFICATION, NETWORK, DATABASE, ERRORS }
