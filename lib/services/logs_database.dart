import 'dart:async';

import 'package:f_logs/f_logs.dart';
import 'package:f_logs/utils/encryption/gcm.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class LogsDatabase {
  static final LogsDatabase _singleton = LogsDatabase._();

  static LogsDatabase get instance => _singleton;

  // Completer is used for transforming synchronous code into asynchronous code.
  Completer<Database>? _dbOpenCompleter;

  final _flogsStore = intMapStoreFactory.store(DBConstants.FLOG_STORE_NAME);

  String encryptionKey = "";

  LogsDatabase._();

  Future<Database> get database async {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();

      _setup();
    }
    return _dbOpenCompleter!.future;
  }

  Future _setup() async {
    // Get a platform-specific directory where persistent app data can be stored
    final directory = await getApplicationSupportDirectory();

    final configuration = FLog.config;

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

  Future<List<Log>> select({List<Filter>? filters}) async {
    Finder? finder;
    if (filters != null) {
      finder = Finder(filter: Filter.and(filters), sortOrders: [SortOrder(DBConstants.FIELD_TIME_IN_MILLIS)]);
    }

    final recordSnapshots = await (_flogsStore.find(
      await database,
      finder: finder,
    ));

    return recordSnapshots.map((snapshot) {
      final log = Log.fromJson(snapshot.value);
      log.id = snapshot.key;
      return log;
    }).toList();
  }

  Future<int> insert(Log log) async {
    return await _flogsStore.add(await database, log.toJson());
  }

  Future<int> delete({List<Filter>? filters}) async {
    Finder? finder;
    if (filters != null) {
      finder = Finder(
        filter: Filter.and(filters),
      );
    }

    var deleted = await _flogsStore.delete(
      await database,
      finder: finder,
    );
    return deleted;
  }
}
