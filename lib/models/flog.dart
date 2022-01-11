import 'package:f_logs/f_logs.dart';
import 'package:f_logs/services/logs_configuration.dart';
import 'package:stack_trace/stack_trace.dart';

class FLog {
  // A private constructor. Allows us to create instances of FLog
  // only from within the FLog class itself.
  FLog._();

  //logs configuration
  static LogConfig get config => LogsConfiguration.instance.config;

  static applyConfig(LogConfig config) => LogsConfiguration.instance.applyConfig(config);

  static LogsProvider get logs => LogsProvider.instance;

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
    if (config.stackTraceFormatter != null) {
      formattedStackTrace = config.stackTraceFormatter!(stacktrace ?? StackTrace.current);
    }

    //creating log object
    final log = Log(
      className: className,
      methodName: methodName,
      text: text,
      logLevel: type,
      dataLogType: dataLogType,
      exception: exception?.toString(),
      timestamp: DateTimeUtils.getCurrentTime(config),
      timeInMillis: DateTimeUtils.getCurrentTimeInMillis(),
      stacktrace: formattedStackTrace ?? stacktrace?.toString(),
    );

    LogsProvider.instance.write(log);
  }

}
