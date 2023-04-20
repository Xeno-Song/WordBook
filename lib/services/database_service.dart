import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  static var _database;

  static Future<Database> get database async {
    if (_database != null) return _database;

    sqfliteFfiInit();
    var databasePath = join((await getApplicationSupportDirectory()).path, "word_set_datbase.db");
    var database = await databaseFactoryFfi.openDatabase(databasePath);
    _database = database;

    return _database;
  }

  static Future<bool> tableExist(String tableName) async {
    var queryResylt = await (await database).query('sqlite_master', where: 'name = ?', whereArgs: [tableName]);
    return queryResylt.isNotEmpty;
  }

  static Future<void> createTable(String tableName, String query) async {
    if (!(await tableExist(tableName))) (await database).execute(query);
  }
}
