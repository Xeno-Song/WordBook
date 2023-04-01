import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as Sqflite;

import '../model/WordModel.dart';
import 'database_service.dart';

class WordService {
  static const String _tableName = "words";

  WordService() {
    DatabaseService.createTable(
      _tableName,
      "CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, word TEXT, meaning TEXT, pronunciation TEXT, createDate TEXT, modifyDate TEXT, nextTestDate Text, testResult TEXT)",
    );
  }

  Future<List<WordModel>> getAllData() async {
    var connection = await DatabaseService.database;
    var raw = await connection.query(
      _tableName,
    );

    return List.generate(raw.length, (index) => WordModel.fromMap(raw[index]));
  }

  Future<List<WordModel>> getDataLimit(int offset, int limit) async {
    var connection = await DatabaseService.database;
    var raw = await connection.query(
      _tableName,
      offset: offset,
      limit: limit,
    );

    return List.generate(raw.length, (index) => WordModel.fromMap(raw[index]));
  }

  Future<void> insertModel(WordModel model) async {
    var connection = await DatabaseService.database;
    var dataMap = model.toMap();
    dataMap.remove('id');

    connection.insert(
      _tableName,
      dataMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getAllCount() async {
    var connection = await DatabaseService.database;
    var rawResult = await connection.rawQuery('SELECT COUNT(*) FROM $_tableName');

    return int.parse(rawResult[0]["COUNT(*)"].toString());
  }

  // List<WordModel> getWord()
  // {
  //   _collection.get
  // }
}
