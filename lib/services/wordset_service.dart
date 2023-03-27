import '../model/WordSetModel.dart';
import '../model/WordModel.dart';

class WordSetService {
  const WordSetService();

  List<WordSetModel> getDummyData() {
    return <WordSetModel>[
      WordSetModel(0, "AAAAAAAAAA", <WordModel>[
        WordModel(0, "AA", "aa"),
        WordModel(1, "BB", "bb"),
        WordModel(2, "CC", "cc"),
        WordModel(3, "DD", "dd"),
        WordModel(4, "EE", "ee"),
        WordModel(5, "FF", "ff"),
        WordModel(6, "GG", "gg"),
        WordModel(7, "HH", "hh"),
        WordModel(8, "II", "ii"),
        WordModel(9, "JJ", "jj"),
        WordModel(10, "KK", "kk"),
        WordModel(11, "LL", "ll"),
      ]),
      WordSetModel(1, "BBBBBBBBBB", <WordModel>[
        WordModel(0, "AA", "aa"),
        WordModel(1, "BB", "bb"),
        WordModel(2, "CC", "cc"),
        WordModel(3, "DD", "dd"),
        WordModel(4, "EE", "ee"),
        WordModel(5, "FF", "ff"),
        WordModel(6, "GG", "gg"),
        WordModel(7, "HH", "hh"),
        WordModel(8, "II", "ii"),
        WordModel(9, "JJ", "jj"),
        WordModel(10, "KK", "kk"),
        WordModel(11, "LL", "ll"),
      ]),
      WordSetModel(2, "CCCCCCCCCC", <WordModel>[
        WordModel(0, "AA", "aa"),
        WordModel(1, "BB", "bb"),
        WordModel(2, "CC", "cc"),
        WordModel(3, "DD", "dd"),
        WordModel(4, "EE", "ee"),
        WordModel(5, "FF", "ff"),
        WordModel(6, "GG", "gg"),
        WordModel(7, "HH", "hh"),
        WordModel(8, "II", "ii"),
        WordModel(9, "JJ", "jj"),
        WordModel(10, "KK", "kk"),
        WordModel(11, "LL", "ll"),
      ]),
    ];
  }
}
