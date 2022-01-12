import 'dart:io';

import 'package:f_logs/constants/constants.dart';
import 'package:f_logs/models/log.dart';
import 'package:f_logs/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:f_logs/models/file.dart' as model;

class LogsExporter {
  static final LogsExporter _singleton = LogsExporter._();

  static LogsExporter get instance => _singleton;

  LogsExporter._();

  String? _localPath;

  Future<String> getDefaultPath() async {
    if (_localPath != null) return _localPath!;
    var directory;

    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getExternalStorageDirectory();
    }

    _localPath = "${directory.path}/${Constants.DIRECTORY_NAME}";
    return _localPath!;
  }

  Future<File> prepareFile(model.File file) async {
    final path = file.path ?? await getDefaultPath();
    await Directory(path).create();
    final fileType = Utils.fromEnumToString(file.type).toLowerCase();
    return File("$path/${file.name}.$fileType");
  }

  Future<File> writeLogsToFile({required List<Log> logs, required model.File file}) async {
    final outputFile = await prepareFile(file);

    String logLines = "";
    logs.forEach((logLine) => logLines += "$logLine\n");
    if (file.type == FileType.TXT) {
      await outputFile.writeAsString(logLines);
    } else {
      // TODO: Implement other types
    }
    return outputFile;
  }
}
