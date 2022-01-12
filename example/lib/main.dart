import 'package:flogs/flogs.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  _init();
  runApp(HomePage());
}

_init() {
  var config = FLog.config;
  config.isDevelopmentDebuggingEnabled = false;
  config.timestampFormat = TimestampFormat.TIME_FORMAT_FULL_3;

  FLog.applyConfig(config);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Permission _permissionGroup = Permission.storage;

  @override
  void initState() {
    super.initState();
    requestPermission(_permissionGroup);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildRow1(context),
              _buildRow2(),
              _buildRow3(),
              _buildRow4(),
            ],
          ),
        ),
      ),
    );
  }

  _buildRow1(BuildContext context) {
    return Row(
      children: <Widget>[
        _buildButton("Log Event", () {
          logInfo();
          logException();
          logWarning();
          logTrace();
        }),
        Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
        _buildButton("Print all Logs", () async {
          print("\nPrinting all logs:");
          FLog.logs.getAll().then((logs) => logs.forEach(print));
        }),
      ],
    );
  }

  _buildRow2() {
    return Row(
      children: <Widget>[
        _buildButton("Export Logs", () async {
          final exportedFile = await FLog.logs.export();
          print("Logs are exported into: $exportedFile");
        }),
        Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
        _buildButton("Clear Logs", () {
          FLog.logs.deleteAll();
        }),
      ],
    );
  }

  _buildRow3() {
    return Row(
      children: <Widget>[
        _buildButton("Print last hour Logs", () async {
          print("\nPrinting last hour logs:");
          FLog.logs.getLastHour().then((logs) => logs.forEach(print));
        }),
        Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
        _buildButton("Print last 10 min Logs", () async {
          print("\nPrinting last 10 min logs:");
          final dateTime = DateTime.now().subtract(Duration(minutes: 10));
          final filter = LogFilter(startDateTime: dateTime);
          FLog.logs.getByFilter(filter).then((logs) => logs.forEach(print));
        }),
      ],
    );
  }

  _buildRow4() {
    return Row(
      children: <Widget>[
        _buildButton("Log Event with StackTrace", () {
          FLog.error(
            text: "My log",
            dataLogType: DataLogType.DEVICE,
            className: "Home",
            exception: Exception("Exception and StackTrace"),
            stacktrace: StackTrace.current,
          );
        }),
        Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
        _buildButton("Delete Logs by Filter (older then 10 minutes)", () {
          final dateTime = DateTime.now().subtract(Duration(minutes: 10));
          final filter = LogFilter(startDateTime: dateTime);
          FLog.logs.deleteByFilter(filter).then((_) => print("Deleted"));
        }),
      ],
    );
  }

  _buildButton(String title, VoidCallback onPressed) {
    return Expanded(
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(title),
        textColor: Colors.white,
        color: Colors.blueAccent,
      ),
    );
  }

  // general methods:-----------------------------------------------------------
  void logInfo() {
    FLog.log(
      className: "HomePage",
      methodName: "_buildRow1",
      text: "Log text/descritption goes here",
      type: LogLevel.INFO,
      dataLogType: DataLogType.DEVICE,
    );

    FLog.config..activeLogLevel = LogLevel.DEBUG;
    FLog.info(text: 'LogLevel set to: ${FLog.config.activeLogLevel}.');
  }

  void logException() {
    try {
      var result = 9 ~/ 0;
      print(result);
    } on Exception catch (exception) {
      FLog.error(
        text: "Exception text/descritption goes here",
        dataLogType: DataLogType.ERRORS,
        className: "Home",
        exception: exception,
      );
    }
  }

  void logWarning() {
    FLog.warning(
      className: "HomePage",
      methodName: "_buildRow1",
      text: "Log text/descritption goes here",
      dataLogType: DataLogType.DEFAULT,
    );
  }

  void logTrace() {
    FLog.trace(
      className: "HomePage",
      methodName: "_buildRow1",
      text: "Log text/descritption goes here",
      dataLogType: DataLogType.DEFAULT,
    );
  }

  //permission methods:---------------------------------------------------------
  Future<void> requestPermission(Permission permission) => permission.request();
}
