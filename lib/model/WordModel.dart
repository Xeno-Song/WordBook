import 'dart:convert';

import 'package:word_book/common/date_time_formatter.dart';
import 'package:word_book/model/WordTestModel.dart';

class WordModel {
  int id = 0;
  String word = "";
  String meaning = "";
  String pronunciation = "";
  List<WordTestModel> testResult = List<WordTestModel>.empty();
  DateTime createDate = DateTime(0, 0, 0, 0, 0, 0);
  DateTime modifyDate = DateTime(0, 0, 0, 0, 0, 0);
  DateTime nextTestDate = DateTime(0, 0, 0, 0, 0, 0);

  WordModel(
    this.id,
    this.word,
    this.meaning,
    this.pronunciation,
    this.testResult,
    this.createDate,
    this.modifyDate,
    this.nextTestDate,
  );

  static WordModel empty() => WordModel(
        0,
        "",
        "",
        "",
        List<WordTestModel>.empty(),
        DateTime(0, 0, 0, 0, 0, 0),
        DateTime(0, 0, 0, 0, 0, 0),
        DateTime(0, 0, 0, 0, 0, 0),
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
      'pronunciation': pronunciation,
      'createDate': DateTimeFormatter.format(createDate),
      'modifyDate': DateTimeFormatter.format(modifyDate),
      'nextTestDate': DateTimeFormatter.format(nextTestDate),
      'testResult': json.encode(List<dynamic>.generate(testResult.length, (index) => testResult[index].toMap()))
    };
  }

  static WordModel fromMap(Map<String, Object?> map) {
    // print(int.parse(map['id'].toString()));
    // print(map['word'].toString());
    // print(map['meaning'].toString());
    // print(map['pronunciation'].toString());
    // print(WordTestModel.fromJson((map['testResult'].toString())));
    // print(DateTimeFormatter.parse(map['createDate'].toString()));
    // print(DateTimeFormatter.parse(map['modifyDate'].toString()));
    // print(DateTimeFormatter.parse(map['nextTestData'].toString()));

    return WordModel(
      int.parse(map['id'].toString()),
      map['word'].toString(),
      map['meaning'].toString(),
      map['pronunciation'].toString(),
      WordTestModel.fromJson((map['testResult'].toString())),
      DateTimeFormatter.parse(map['createDate'].toString()),
      DateTimeFormatter.parse(map['modifyDate'].toString()),
      DateTimeFormatter.parse(map['nextTestDate'].toString()),
    );
  }
}
