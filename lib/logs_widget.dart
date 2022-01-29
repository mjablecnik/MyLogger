import 'package:flogs/flogs.dart';
import 'package:flutter/widgets.dart';

class LogsWidget extends StatefulWidget {
  const LogsWidget({Key? key, this.from, this.to}) : super(key: key);

  final DateTime? from;
  final DateTime? to;

  @override
  _LogsWidgetState createState() => _LogsWidgetState();
}

class _LogsWidgetState extends State<LogsWidget> {
  List<Log> list = [];

  @override
  initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final logs = await FLog.logs.getByFilter(LogFilter(
      startDateTime: widget.from ?? DateTime(2020),
      endDateTime: widget.to ?? DateTime.now(),
    ));

    setState(() => list.addAll(logs));
    print("data count = ${list.length}");
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 24, left: 16, right: 16),
      itemBuilder: (context, index) {
        return Container(
          child: Text(list[index].toString()),
          height: 65.0,
          alignment: Alignment.centerLeft,
        );
      },
      itemCount: list.length,
    );
  }
}
