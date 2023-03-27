class WordModel {
  int id = 0;
  String word = "";
  String meaning = "";
  String pronunciation = "";

  WordModel(this.id, this.word, this.meaning, this.pronunciation);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
      'pronunciation': pronunciation,
    };
  }
}
