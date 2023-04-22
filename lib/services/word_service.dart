import 'dart:async';
import 'dart:async';

import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as Sqflite;
import 'package:word_book/common/date_time_formatter.dart';

import '../model/WordModel.dart';
import 'database_service.dart';

class WordService {
  static const String _tableName = "words";
  final Completer _tableChecked = Completer();

  WordService() {
    _tableChecked.complete(DatabaseService.createTable(
      _tableName,
      "CREATE TABLE $_tableName("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "word TEXT,"
      "meaning TEXT,"
      "pronunciation TEXT,"
      "createDate TEXT,"
      "modifyDate TEXT,"
      "testInterval INTEGER,"
      "nextTestDate Text,"
      "testResult TEXT)",
    ));
  }

  Future<void> _waitForTableCheck() async {
    if (_tableChecked.isCompleted) await _tableChecked.future;
  }

  Future<List<WordModel>> getAllData() async {
    await _waitForTableCheck();

    var connection = await DatabaseService.database;
    var raw = await connection.query(
      _tableName,
    );

    return List.generate(raw.length, (index) => WordModel.fromMap(raw[index]));
  }

  Future<List<WordModel>> getDataLimit(int offset, int limit) async {
    await _waitForTableCheck();

    var connection = await DatabaseService.database;
    var raw = await connection.query(
      _tableName,
      offset: offset,
      limit: limit,
    );

    var list = List.generate(raw.length, (index) => WordModel.fromMap(raw[index]));
    return list;
  }

  Future<List<WordModel>> getData({int? offset, int? limit, String? order, String? where}) async {
    await _waitForTableCheck();

    var connection = await DatabaseService.database;
    var raw = await connection.query(
      _tableName,
      offset: offset,
      limit: limit,
      orderBy: order,
      where: where,
    );

    var list = List.generate(raw.length, (index) => WordModel.fromMap(raw[index]));
    return list;
  }

  Future<List<WordModel>> getTestOutdateWord(int limit, {List<int>? excludeId}) async {
    await _waitForTableCheck();

    var connection = await DatabaseService.database;

    String whereCondition = "nextTestDate < \"${DateTimeFormatter.format(DateTime.now())}\"";
    if (excludeId != null) {
      for (var element in excludeId) {
        if (whereCondition.isNotEmpty) {
          whereCondition = "$whereCondition AND id != $element";
        } else {
          whereCondition = "id != $element";
        }
      }
    }

    var raw = await connection.query(
      _tableName,
      where: whereCondition,
      orderBy: "nextTestDate ASC",
      limit: limit,
    );

    return List.generate(raw.length, (index) => WordModel.fromMap(raw[index]));
  }

  Future<List<WordModel>?> getNotTestedWord(int limit, {List<int>? excludeId}) async {
    await _waitForTableCheck();

    var connection = await DatabaseService.database;

    String whereCondition = "nextTestDate is null OR nextTestDate = \"\"";
    if (excludeId != null) {
      for (var element in excludeId) {
        if (whereCondition.isNotEmpty) {
          whereCondition = "$whereCondition AND id != $element";
        } else {
          whereCondition = "id != $element";
        }
      }
    }

    var raw = await connection.query(
      _tableName,
      where: whereCondition,
      orderBy: "RANDOM()",
      limit: limit,
    );

    if (raw.isEmpty) return null;
    return List.generate(raw.length, (index) => WordModel.fromMap(raw[index]));
  }

  Future<List<String>> getRandomWordString(int limit, List<WordModel>? excludes) async {
    await _waitForTableCheck();

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
    await _waitForTableCheck();

    var connection = await DatabaseService.database;
    var dataMap = model.toMap();
    dataMap.remove('id');

    await connection.insert(
      _tableName,
      dataMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getAllCount() async {
    await _waitForTableCheck();

    var connection = await DatabaseService.database;
    var rawResult = await connection.rawQuery('SELECT COUNT(*) FROM $_tableName');

    return int.parse(rawResult[0]["COUNT(*)"].toString());
  }

  Future<bool> remove(WordModel model) async {
    await _waitForTableCheck();

    var connection = await DatabaseService.database;
    var rawResult = await connection.delete(
      _tableName,
      where: "id = ${model.id} AND word = '${model.word}'",
    );

    return rawResult == 1;
  }

  Future<bool> update(int id, WordModel model) async {
    await _waitForTableCheck();

    var connection = await DatabaseService.database;
    await connection.update(
      _tableName,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );

    return true;
  }

  // List<WordModel> getWord()
  // {
  //   _collection.get
  // }
}
