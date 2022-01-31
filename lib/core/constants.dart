class Constants {
  Constants._();

  /// Directory
  static const DIRECTORY_NAME = 'MyLogger';

  /// Store Name
  static const STORE_NAME = 'my_logger';

  /// DB Name
  static const DB_NAME = 'my_logger.db';

  /// Encryption key null exception
  static const EXCEPTION_NULL_KEY =
  // ignore: lines_longer_than_80_chars
      'Encryption key is not provided, please provide encryption key in LogsConfig';
}

class LogFields {
  static const id = 'id';
  static const className = 'className';
  static const methodName = 'methodName';
  static const text = 'text';
  static const timestamp = 'timestamp';
  static const exception = 'exception';
  static const dataLogType = 'dataLogType';
  static const timeInMillis = 'timeInMillis';
  static const logLevel = 'logLevel';
  static const stacktrace = 'stacktrace';
}

class TimestampFormat {
  static const DEFAULT = "";
  static const DATE_FORMAT_1 = "ddMMyyyy";
  static const DATE_FORMAT_2 = "MM/dd/yyyy";
  static const TIME_FORMAT_FULL_1 = "dd MMMM yyyy HH:mm:ss";
  static const TIME_FORMAT_FULL_2 = "MM:dd:yyyy HH:mm:ss a";
  static const TIME_FORMAT_FULL_3 = "yyyy-MM-dd HH:mm:ss";
  static const TIME_FORMAT_24_FULL = "dd/MM/yyyy HH:mm:ss";
  static const TIME_FORMAT_READABLE = "dd MMMM yyyy HH:mm:ss a";
  static const TIME_FORMAT_SIMPLE = "HH:mm:ss";
}

class OutputLogFormat {
  static const DEFAULT = "{{time}} {{level}} [{{class}}:{{method}}] -> {{message}} {{exception}} {{stacktrace}}";
  static const BASIC = "{{time}} {{level}} {{message}}";
  static const SIMPLE = "{{time}} {{level}} - {{message}} {{exception}} {{stacktrace}}";
  static const FULL = "{{time}} {{level}} [{{class}}:{{method}}] DataLogType.{{dataLogType}} -> {{message}} {{exception}} {{stacktrace}}";
}

enum LogLevel { ALL, DEBUG, TRACE, INFO, WARNING, ERROR, SEVERE, FATAL, OFF }

enum FilterType { LAST_HOUR, LAST_24_HOURS, TODAY, WEEK, ALL }

enum DataLogType { DEFAULT, DEVICE, LOCATION, NOTIFICATION, NETWORK, DATABASE, ERRORS }

enum FileType { TXT, ZIP }

enum EncryptionType { NONE, XXTEA, AES_GCM }
