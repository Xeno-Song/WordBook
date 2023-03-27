import 'package:word_book/model/WordModel.dart';

class WordSetModel {
  var idx = 0;
  var name = "";
  List<WordModel> words = [];

  WordSetModel(this.idx, this.name, this.words);
}
