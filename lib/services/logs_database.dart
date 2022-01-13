import 'dart:async';

import 'package:flogs/flogs.dart';
import 'package:flogs/core/encryption/gcm.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class LogsDatabase {
  static final LogsDatabase _singleton = LogsDatabase._();

  static LogsDatabase get instance => _singleton;

  // Completer is used for transforming synchronous code into asynchronous code.
  Completer<Database>? _dbOpenCompleter;

  final _flogsStore = intMapStoreFactory.store(Constants.STORE_NAME);

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

    final dbPath = join(directory.path, Constants.DB_NAME);

    var codec;

    // Initialize the encryption codec with a user password
    if (configuration.encryptionKey.isNotEmpty) {
      switch (configuration.encryption) {
        case EncryptionType.XXTEA:
          codec = getXXTeaSembastCodec(password: configuration.encryptionKey);
          break;
        case EncryptionType.AES_GCM:
          codec = getGCMSembastCodec(password: configuration.encryptionKey);
          break;
        case EncryptionType.NONE:
          break;
      }
    }

    final database = await databaseFactoryIo.openDatabase(dbPath, codec: codec);

    _dbOpenCompleter!.complete(database);
  }

  Future<List<Log>> select({List<Filter>? filters}) async {
    Finder? finder;
    if (filters != null) {
      finder = Finder(filter: Filter.and(filters), sortOrders: [SortOrder(LogFields.timeInMillis)]);
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
