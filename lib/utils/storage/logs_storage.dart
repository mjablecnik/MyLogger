import 'dart:io';

import 'package:f_logs/f_logs.dart';
import 'package:path_provider/path_provider.dart';

class LogStorage {
  static final LogStorage _singleton = LogStorage._();

  /// Singleton accessor
  static LogStorage get instance => _singleton;

  // A private constructor. Allows us to create instances of LogsStorage
  // only from within the LogsStorage class itself.
  LogStorage._();

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

  Future<File> _getLocalFile() async {
    if (_localFile != null) return _localFile!;

    final path = "${await _getLocalPath()}/${Constants.DIRECTORY_NAME}";

    //creating directory
    Directory directory = await Directory(path).create();
    print(directory.path);

    //opening file
    var file = File("$path/flog.txt");
    var isExist = await file.exists();

    //check to see if file exist
    if (isExist) {
      print('File exists------------------>_getLocalFile()');
    } else {
      print('file does not exist---------->_getLocalFile()');
    }

    return file;
  }

  /// Read the Log-String from file
  Future<String> readLogsFromFile() async {
    try {
      final file = await _getLocalFile();

      // Read the file
      var contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return error message
      return "Unable to read file";
    }
  }

  /// Writes the `log`-String to file
  Future<File> writeLogsToFile(String log) async {
    final file = await _getLocalFile();

    // Write the file
    return file.writeAsString('$log');
  }
}
