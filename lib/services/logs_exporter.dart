import 'dart:io';

import 'package:f_logs/f_logs.dart';
import 'package:path_provider/path_provider.dart';

class LogsExporter {
  static final LogsExporter _singleton = LogsExporter._();

  /// Singleton accessor
  static LogsExporter get instance => _singleton;

  // A private constructor. Allows us to create instances of LogsStorage
  // only from within the LogsStorage class itself.
  LogsExporter._();

  String? _localPath;
  File? _localFile;

  Future<String> _getLocalPath() async {
    if (_localPath != null) return _localPath!;
    var directory;

    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getExternalStorageDirectory();
    }

    return directory.path;
  }

  Future<File> _getLocalFile({required String name}) async {
    if (_localFile != null) return _localFile!;

    final path = "${await _getLocalPath()}/${Constants.DIRECTORY_NAME}";

    Directory directory = await Directory(path).create();
    print(directory.path);

    return File("$path/$name.txt");
  }

  /// Read the Log-String from file
  Future<String> readLogsFromFile({required String fileName}) async {
    try {
      final file = await _getLocalFile(name: fileName);
      var contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "Unable to read file";
    }
  }

  /// Writes the `log`-String to file
  Future<File> writeLogsToFile({required List<Log> logs, required String fileName}) async {
    final file = await _getLocalFile(name: fileName);
    String logLines = "";
    logs.forEach((logLine) => logLines += "$logLine\n");
    await file.writeAsString(logLines);
    return file;
  }
}
