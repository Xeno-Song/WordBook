import 'package:sqflite_common/sqlite_api.dart';

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

  Future<List<WordModel>> getModel() async {
    var connection = await DatabaseService.database;
    var raw = await connection.query(
      _tableName,
    );

    return List.generate(raw.length, (index) => WordModel.fromMap(raw[index]));
  }

  Future<void> insertModel(WordModel model) async {
    var connection = await DatabaseService.database;
    var dataMap = model.toMap();
    dataMap.remove('id');

    print(dataMap);

    connection.insert(
      _tableName,
      dataMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // List<WordModel> getWord()
  // {
  //   _collection.get
  // }
}
