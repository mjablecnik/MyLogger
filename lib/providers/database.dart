import 'dart:async';

import 'package:f_logs/f_logs.dart';
import 'package:f_logs/utils/encryption/gcm.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabase {
  // Singleton instance
  static final AppDatabase _singleton = AppDatabase._();

  /// Singleton accessor
  static AppDatabase get instance => _singleton;

  // Completer is used for transforming synchronous code into asynchronous code.
  Completer<Database>? _dbOpenCompleter;

  /// Key for encryption
  String encryptionKey = "";

  // A private constructor. Allows us to create instances of AppDatabase
  // only from within the AppDatabase class itself.
  AppDatabase._();

  /// Database object accessor
  Future<Database> get database async {
    // If completer is null, AppDatabaseClass is newly instantiated, so database is not yet opened
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();

      // Calling _openDatabase will also complete the completer with database instance
      _openDatabase();
    }
    // If the database is already opened, awaiting the future will happen instantly.
    // Otherwise, awaiting the returned future will take some time - until complete() is called
    // on the Completer in _openDatabase() below.
    return _dbOpenCompleter!.future;
  }

  Future _openDatabase() async {
    // Get a platform-specific directory where persistent app data can be stored
    final directory = await getApplicationSupportDirectory();

    final configuration = FLog.getConfiguration();

    // Path with the form: /platform-specific-directory/demo.db
    final dbPath = join(directory.path, DBConstants.DB_NAME);

    var codec;

    if (configuration.encryption.isNotEmpty && configuration.encryptionKey.isNotEmpty) {
      // Initialize the encryption codec with a user password
      if (configuration.encryption == 'xxtea') {
        codec = getXXTeaSembastCodec(password: configuration.encryptionKey);
      } else if (configuration.encryption == 'aes-gcm') {
        codec = getGCMSembastCodec(password: configuration.encryptionKey);
      } else {
        throw 'Unsupported encryption';
      }
    }

    final database = await databaseFactoryIo.openDatabase(dbPath, codec: codec);

    _dbOpenCompleter!.complete(database);
  }
}
