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
    return WordModel(
      (map['id'] == null) ? int.parse(map['id'].toString()) : 0,
      (map['word'] == null) ? map['word'].toString() : "",
      (map['meaning'] == null) ? map['meaning'].toString() : "",
      (map['pronunciation'] == null) ? map['pronunciation'].toString() : "",
      WordTestModel.fromJson((map['testResult'] == null) ? map['testResult'].toString() : ""),
      (map['createDate'] == null) ? DateTimeFormatter.parse(map['createDate'].toString()) : DateTime(0, 0, 0, 0, 0, 0),
      (map['modifyDate'] == null) ? DateTimeFormatter.parse(map['modifyDate'].toString()) : DateTime(0, 0, 0, 0, 0, 0),
      (map['nextTestDate'] == null)
          ? DateTimeFormatter.parse(map['nextTestDate'].toString())
          : DateTime(0, 0, 0, 0, 0, 0),
    );
  }
}
