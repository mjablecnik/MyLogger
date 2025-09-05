import 'package:flutter/material.dart';
import 'package:my_logger/logger.dart';
import 'package:my_logger/logger_core.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  _init();
  runApp(MaterialApp(home: HomePage()));
}

_init() {
  var config = MyLogger.config;
  config.isDevelopmentDebuggingEnabled = false;
  config.timestampFormat = TimestampFormat.TIME_FORMAT_FULL_3;

  MyLogger.applyConfig(config);
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

  _showLogs() => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text("Log List"),
          centerTitle: true,
        ),
        body: LogsWidget(),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyLogger example"),
        centerTitle: true,
        actions: [IconButton(onPressed: _showLogs, icon: Icon(Icons.list_alt))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildRow1(context),
            SizedBox(height: 8),
            _buildRow2(),
            SizedBox(height: 8),
            _buildRow3(),
            SizedBox(height: 8),
            _buildRow4(),
          ],
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
          MyLogger.logs.getAll().then((logs) => logs.forEach(print));
        }),
      ],
    );
  }

  _buildRow2() {
    return Row(
      children: <Widget>[
        _buildButton("Export Logs", () async {
          final exportedFile = await MyLogger.logs.export();
          print("Logs are exported into: $exportedFile");
        }),
        Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
        _buildButton("Clear Logs", () {
          MyLogger.logs.deleteAll();
        }),
      ],
    );
  }

  _buildRow3() {
    return Row(
      children: <Widget>[
        _buildButton("Print last hour Logs", () async {
          print("\nPrinting last hour logs:");
          MyLogger.logs.getLastHour().then((logs) => logs.forEach(print));
        }),
        Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
        _buildButton("Print last 10 min Logs", () async {
          print("\nPrinting last 10 min logs:");
          final dateTime = DateTime.now().subtract(Duration(minutes: 10));
          final filter = LogFilter(startDateTime: dateTime);
          MyLogger.logs.getByFilter(filter).then((logs) => logs.forEach(print));
        }),
      ],
    );
  }

  _buildRow4() {
    return Row(
      children: <Widget>[
        _buildButton("Log Event with StackTrace", () {
          MyLogger.error(
            "My log",
            dataLogType: DataLogType.DEVICE,
            className: "Home",
            exception: Exception("Exception and StackTrace"),
            stacktrace: StackTrace.current,
          );
        }),
        Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
        _buildButton("Delete Logs older then 10 minutes", () {
          final dateTime = DateTime.now().subtract(Duration(minutes: 10));
          final filter = LogFilter(endDateTime: dateTime);
          MyLogger.logs.deleteByFilter(filter).then((_) => print("Deleted"));
        }),
      ],
    );
  }

  _buildButton(String title, VoidCallback onPressed) {
    return Expanded(
      child: SizedBox(
        height: 60,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(title),
        ),
      ),
    );
  }

  // general methods:-----------------------------------------------------------
  void logInfo() {
    MyLogger.log(
      className: "HomePage",
      methodName: "_buildRow1",
      text: "Log text/descritption goes here",
      type: LogLevel.INFO,
      dataLogType: DataLogType.DEVICE,
    );

    MyLogger.config..activeLogLevel = LogLevel.DEBUG;
    MyLogger.info('LogLevel set to: ${MyLogger.config.activeLogLevel}.');
  }

  void logException() {
    try {
      var result = 9 ~/ 0;
      print(result);
    } on Exception catch (exception) {
      MyLogger.error(
        "Exception text/descritption goes here",
        dataLogType: DataLogType.ERRORS,
        className: "Home",
        exception: exception,
      );
    }
  }

  void logWarning() {
    MyLogger.warning(
      "Log text/descritption goes here",
      className: "HomePage",
      methodName: "_buildRow1",
      dataLogType: DataLogType.DEFAULT,
    );
  }

  void logTrace() {
    MyLogger.trace(
      "Log text/descritption goes here",
      className: "HomePage",
      methodName: "_buildRow1",
      dataLogType: DataLogType.DEFAULT,
    );
  }

  //permission methods:---------------------------------------------------------
  Future<void> requestPermission(Permission permission) => permission.request();
}
