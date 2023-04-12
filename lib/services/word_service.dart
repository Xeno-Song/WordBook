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

  Future<List<WordModel>> getTestOutdateWord(int limit) async {
    var connection = await DatabaseService.database;
    var raw = await connection.query(
      _tableName,
      where: "nextTestData > ${DateTime.now()}",
      orderBy: "nextTestDate ASC",
      limit: limit,
    );

    return List.generate(raw.length, (index) => WordModel.fromMap(raw[index]));
  }

  Future<List<WordModel>?> getNotTestedWord(int limit) async {
    var connection = await DatabaseService.database;
    var raw = await connection.query(
      _tableName,
      where: "nextTestDate = null OR nextTestDate = \"\"",
      orderBy: "RANDOM()",
      limit: limit,
    );

    if (raw.isEmpty) return null;
    return List.generate(raw.length, (index) => WordModel.fromMap(raw[index]));
  }

  Future<List<String>> getRandomWordString(int limit, List<WordModel>? excludes) async {
    var connection = await DatabaseService.database;

    String excludeCondition = "";
    if (excludes != null) {
      for (var element in excludes) {
        if (excludeCondition.isNotEmpty) {
          excludeCondition = "$excludeCondition AND id != ${element.id}";
        } else {
          excludeCondition = "id != ${element.id}";
        }
      }
    }

    var raw = await connection.query(
      _tableName,
      where: excludeCondition,
      orderBy: "RANDOM()",
      limit: limit,
    );

    return List.generate(raw.length, (index) => raw[index]['word'].toString());
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

  Future<bool> remove(WordModel model) async {
    var connection = await DatabaseService.database;
    var rawResult = await connection.delete(
      _tableName,
      where: "id = ${model.id} AND word = '${model.word}'",
    );

    return rawResult == 1;
  }

  // List<WordModel> getWord()
  // {
  //   _collection.get
  // }
}
