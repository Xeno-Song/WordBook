import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../model/WordSetModel.dart';
import '../model/WordModel.dart';

class WordSetService {
  Future<Database> _initDatabase() async {
    sqfliteFfiInit();

    var databasePath = join((await getApplicationSupportDirectory()).path, "word_set_datbase.db");
    // var isFileExists = await io.File(databasePath).exists();
    var db = await databaseFactoryFfi.openDatabase(databasePath);

    var tableExistsCheckQueryResult = await db.query('sqlite_master', where: 'name = ?', whereArgs: [tableName]);
    if (tableExistsCheckQueryResult.isEmpty) {
      db.execute(
          "CREATE TABLE words(id INTEGER PRIMARY KEY AUTOINCREMENT, word TEXT, meaning TEXT, pronunciation TEXT)");
    }

    return db;
  }

  late Future<Database> database = _initDatabase();
  static const String tableName = "words";

  WordSetService();

  insertWord(WordModel wordData) async {
    var connection = await database;
    var data = wordData.toMap();
    data.remove('id');

    await connection.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<WordModel>> getWords() async {
    var connection = await database;
    List<Map<String, dynamic>> maps = await connection.query(tableName);

    return List.generate(maps.length, (i) {
      return WordModel(
        maps[i]['id'],
        maps[i]['word'],
        maps[i]['meaning'],
        maps[i]['pronunciation'],
      );
    });
  }

  List<WordSetModel> getDummyData() {
    return <WordSetModel>[
      WordSetModel(0, "AAAAAAAAAA", <WordModel>[
        WordModel(0, "AA", "aa", "AA"),
        WordModel(1, "BB", "bb", "AA"),
        WordModel(2, "CC", "cc", "AA"),
        WordModel(3, "DD", "dd", "AA"),
        WordModel(4, "EE", "ee", "AA"),
        WordModel(5, "FF", "ff", "AA"),
        WordModel(6, "GG", "gg", "AA"),
        WordModel(7, "HH", "hh", "AA"),
        WordModel(8, "II", "ii", "AA"),
        WordModel(9, "JJ", "jj", "AA"),
        WordModel(10, "KK", "kk", "AA"),
        WordModel(11, "LL", "ll", "AA"),
      ]),
      WordSetModel(1, "BBBBBBBBBB", <WordModel>[
        WordModel(0, "AA", "aa", "AA"),
        WordModel(1, "BB", "bb", "AA"),
        WordModel(2, "CC", "cc", "AA"),
        WordModel(3, "DD", "dd", "AA"),
        WordModel(4, "EE", "ee", "AA"),
        WordModel(5, "FF", "ff", "AA"),
        WordModel(6, "GG", "gg", "AA"),
        WordModel(7, "HH", "hh", "AA"),
        WordModel(8, "II", "ii", "AA"),
        WordModel(9, "JJ", "jj", "AA"),
        WordModel(10, "KK", "kk", "AA"),
        WordModel(11, "LL", "ll", "AA"),
      ]),
      WordSetModel(2, "CCCCCCCCCC", <WordModel>[
        WordModel(0, "AA", "aa", "AA"),
        WordModel(1, "BB", "bb", "AA"),
        WordModel(2, "CC", "cc", "AA"),
        WordModel(3, "DD", "dd", "AA"),
        WordModel(4, "EE", "ee", "AA"),
        WordModel(5, "FF", "ff", "AA"),
        WordModel(6, "GG", "gg", "AA"),
        WordModel(7, "HH", "hh", "AA"),
        WordModel(8, "II", "ii", "AA"),
        WordModel(9, "JJ", "jj", "AA"),
        WordModel(10, "KK", "kk", "AA"),
        WordModel(11, "LL", "ll", "AA"),
      ]),
    ];
  }
}
