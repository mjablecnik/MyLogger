import 'dart:io';

import 'package:f_logs/f_logs.dart';
import 'package:sembast/sembast.dart';
import 'package:stack_trace/stack_trace.dart';

class FLog {
  // flogs data source
  static final _flogDao = FlogDao.instance;

  //local storage
  static final LogStorage _storage = LogStorage.instance;

  //logs configuration
  static LogsConfig _config = LogsConfig();

  // A private constructor. Allows us to create instances of FLog
  // only from within the FLog class itself.
  FLog._();

  //Public Methods:-------------------------------------------------------------
  /// logThis
  ///
  /// Logs 'String' data along with class & function name to hourly based file
  /// with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  /// @param type         the type
  static void logThis({
    String? className,
    String? methodName,
    required String text,
    required LogLevel type,
    dynamic exception,
    Enum? dataLogType,
    StackTrace? stacktrace,
  }) async {
    // prevent to write LogLevel.ALL and LogLevel.OFF to db
    if (![LogLevel.OFF, LogLevel.ALL].contains(type)) {
      _logThis(className, methodName, text, type, exception, dataLogType, stacktrace);
    }
  }

  /// trace
  ///
  /// Logs 'String' data along with class & function name to hourly based file
  /// with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  static void trace({
    String? className,
    String? methodName,
    required String text,
    dynamic exception,
    Enum? dataLogType,
    StackTrace? stacktrace,
  }) async {
    _logThis(className, methodName, text, LogLevel.TRACE, exception, dataLogType, stacktrace);
  }

  /// debug
  ///
  /// Logs 'String' data along with class & function name to hourly based file
  /// with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  static void debug({
    String? className,
    String? methodName,
    required String text,
    dynamic exception,
    Enum? dataLogType,
    StackTrace? stacktrace,
  }) async {
    _logThis(className, methodName, text, LogLevel.DEBUG, exception, dataLogType, stacktrace);
  }

  /// info
  ///
  /// Logs 'String' data along with class & function name to hourly based file
  /// with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  static void info({
    String? className,
    String? methodName,
    required String text,
    dynamic exception,
    Enum? dataLogType,
    StackTrace? stacktrace,
  }) async {
    _logThis(className, methodName, text, LogLevel.INFO, exception, dataLogType, stacktrace);
  }

  /// warning
  ///
  /// Logs 'String' data along with class & function name to hourly based file
  /// with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  static void warning({
    String? className,
    String? methodName,
    required String text,
    dynamic exception,
    Enum? dataLogType,
    StackTrace? stacktrace,
  }) async {
    _logThis(className, methodName, text, LogLevel.WARNING, exception, dataLogType, stacktrace);
  }

  /// error
  ///
  /// Logs 'String' data along with class & function name to hourly based file
  /// with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  static void error({
    String? className,
    String? methodName,
    required String text,
    dynamic exception,
    Enum? dataLogType,
    StackTrace? stacktrace,
  }) async {
    _logThis(className, methodName, text, LogLevel.ERROR, exception, dataLogType, stacktrace);
  }

  /// severe
  ///
  /// Logs 'String' data along with class & function name to hourly based file
  /// with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  static void severe({
    String? className,
    String? methodName,
    required String text,
    dynamic exception,
    Enum? dataLogType,
    StackTrace? stacktrace,
  }) async {
    _logThis(className, methodName, text, LogLevel.SEVERE, exception, dataLogType, stacktrace);
  }

  /// fatal
  ///
  /// Logs 'String' data along with class & function name to hourly based file
  /// with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  static void fatal({
    String? className,
    String? methodName,
    required String text,
    dynamic exception,
    Enum? dataLogType,
    StackTrace? stacktrace,
  }) async {
    _logThis(className, methodName, text, LogLevel.FATAL, exception, dataLogType, stacktrace);
  }

  /// printLogs
  ///
  /// This will return array of logs and print them as a string using
  /// StringBuffer()
  static void printLogs() async {
    print(Constants.PRINT_LOG_MSG);

    _flogDao.getLogs().then((logs) {
      var buffer = StringBuffer();

      if (logs.length > 0) {
        logs.forEach((log) {
          buffer.write(Formatter.format(log, _config));
        });
        print(buffer.toString());
      } else {
        print("No logs found!");
      }
      buffer.clear();
    });
  }

  /// printDataLogs
  ///
  /// This will return array of logs grouped by dataType and print them as a
  /// string using StringBuffer()
  static void printDataLogs({
    List<String>? dataLogsType,
    List<String>? logLevels,
    int? startTimeInMillis,
    int? endTimeInMillis,
    FilterType? filterType,
  }) async {
    print(Constants.PRINT_DATA_LOG_MSG);

    final logs = await _flogDao.getLogs(
      filters: Filters.generateFilters(
        dataLogsType: dataLogsType,
        logLevels: logLevels,
        startTimeInMillis: startTimeInMillis,
        endTimeInMillis: endTimeInMillis,
        filterType: filterType,
      ),
    );

    var buffer = StringBuffer();
    if (logs.isNotEmpty) {
      logs.forEach((log) {
        buffer.write(Formatter.format(log, _config));
      });
      print(buffer.toString());
    } else {
      print("No logs found!");
    }
    buffer.clear();
  }

  /// printFileLogs
  ///
  /// This will print logs stored in a file as string using StringBuffer()
  static void printFileLogs() async {
    print(Constants.PRINT_LOG_MSG);

    _storage.readLogsFromFile().then(print);
  }

  /// exportLogs
  ///
  /// This will export logs to external storage under FLog directory
  static Future<File> exportLogs() async {
    var buffer = StringBuffer();

    print(Constants.PRINT_EXPORT_MSG);

    //get all logs and write to file
    final logs = await _flogDao.getLogs();

    logs.forEach((log) {
      buffer.write(Formatter.format(log, _config));
    });

    // writing logs to file and returning file object
    final file = await _storage.writeLogsToFile(buffer.toString());
    print(buffer.toString());
    buffer.clear();
    return file;
  }

  /// getAllLogsByFilter
  ///
  /// This will return the list of logs stored based on the provided filters
  static Future<List<Log>> getAllLogsByFilter(
      {List<String>? dataLogsType,
      List<String>? logLevels,
      int? startTimeInMillis,
      int? endTimeInMillis,
      FilterType? filterType}) async {
    return await _flogDao.getLogs(
      filters: Filters.generateFilters(
        dataLogsType: dataLogsType,
        logLevels: logLevels,
        startTimeInMillis: startTimeInMillis,
        endTimeInMillis: endTimeInMillis,
        filterType: filterType,
      ),
    );
  }

  /// getAllLogsByCustomFilter
  ///
  /// This will return the list of logs stored based on the custom filters
  /// provided by the user
  static Future<List<Log>> getAllLogsByCustomFilter({List<Filter>? filters}) async {
    return await _flogDao.getLogs(filters: filters!);
  }

  /// clearLogs
  ///
  /// This will clear all the logs stored in database
  static Future<void> clearLogs() async {
    await _flogDao.deleteLogs();
    print("Logs Cleared!");
  }

  /// deleteAllLogsByFilter
  ///
  /// This will delete logs by provided filters
  static Future<void> deleteAllLogsByFilter({List<Filter>? filters}) async {
    var deleted = await _flogDao.deleteLogs(filters: filters!);
    print("Deleted $deleted logs");
  }

  /// applyConfigurations
  ///
  /// This will apply user provided configurations to FLogs
  static void applyConfigurations(LogsConfig config) {
    _config = config;

    //check to see if encryption is enabled
    if (_config.encryption.isNotEmpty) {
      //check to see if encryption key is provided
      if (_config.encryptionKey.isEmpty) {
        throw Exception(Constants.EXCEPTION_NULL_KEY);
      }
    }
  }

  /// getDefaultConfigurations
  ///
  /// Returns configuration
  static LogsConfig getConfiguration() {
    return _config;
  }

  //Private Methods:------------------------------------------------------------
  /// _logThis
  ///
  /// Logs 'String' data along with class & function name to hourly based file
  /// with formatted timestamps.
  ///
  /// @param className    the class name
  /// @param methodName the method name
  /// @param text         the text
  /// @param type         the type
  static void _logThis(
    String? className,
    String? methodName,
    String text,
    LogLevel type,
    dynamic exception,
    Enum? dataLogType,
    StackTrace? stacktrace,
  ) {
    // This variable can be ClassName.MethodName or only a function name, when it doesn't belong to a class, e.g. main()
    var member = Trace.current().frames[2].member!;

    //check to see if className is not provided
    //then its already been taken from calling class
    if (className == null) {
      // If there is a . in the member name, it means the method belongs to a class. Thus we can split it.
      if (member.contains(".")) {
        className = member.split(".")[0];
      } else {
        className = "";
      }
    }

    //check to see if methodName is not provided
    //then its already been taken from calling class
    if (methodName == null) {
      // If there is a . in the member name, it means the method belongs to a class. Thus we can split it.
      if (member.contains(".")) {
        methodName = member.split(".")[1];
      } else {
        methodName = member;
      }
    }

    // Generate a custom formatted stack trace
    String? formattedStackTrace;
    if (_config.stackTraceFormatter != null) {
      formattedStackTrace = _config.stackTraceFormatter!(stacktrace ?? StackTrace.current);
    }

    //creating log object
    final log = Log(
      className: className,
      methodName: methodName,
      text: text,
      logLevel: type,
      dataLogType: dataLogType,
      exception: exception?.toString(),
      timestamp: DateTimeUtils.getCurrentTimestamp(_config),
      timeInMillis: DateTimeUtils.getCurrentTimeInMillis(),
      stacktrace: formattedStackTrace ?? stacktrace?.toString(),
    );

    _writeLogs(log);
  }

  /// _writeLogs
  ///
  /// Will write logs to local database
  static _writeLogs(Log log) async {
    if (_isLogLevelValid(log.logLevel!)) {
      if (_config.isDebuggable) {
        print(Formatter.format(log, _config));
      }
      await _flogDao.insert(log);
    }
  }

  static _isLogLevelValid(LogLevel logLevel) {
    return LogLevel.values.indexOf(_config.activeLogLevel) <= LogLevel.values.indexOf(logLevel) &&
        _config.logLevelsEnabled.contains(_config.activeLogLevel);
  }
}
