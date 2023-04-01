import 'dart:convert';

import '../common/date_time_formatter.dart';

class WordTestModel {
  int id = 0;
  String result = "";
  DateTime createDate = DateTime(0, 0, 0, 0, 0, 0);

  WordTestModel(this.id, this.result, this.createDate);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'result': result,
      'createDate': DateTimeFormatter.format(createDate),
    };
  }

  static WordTestModel fromMap(Map<String, dynamic> map) {
    return WordTestModel(map['id'], map['result'], map['createDate']);
  }

  static List<WordTestModel> fromJson(String data) {
    var rawList = json.decode(data);
    return List<WordTestModel>.from(rawList.map((model) => WordTestModel(
        (model['id'] == null) ? int.parse(model['id'].toString()) : 0,
        (model['result'] == null) ? model['result'].toString() : "",
        (model['createDate'] == null)
            ? DateTimeFormatter.parse(model['createDate'].toString())
            : DateTime(0, 0, 0, 0, 0, 0))));
  }
}
