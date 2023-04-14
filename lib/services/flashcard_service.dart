import 'package:word_book/services/word_service.dart';

import '../model/WordModel.dart';

class FlashcardService {
  final WordService _service = WordService();

  Future<List<WordModel>?> getNextWord({int limit = 1}) async {
    List<WordModel> modelList = await _service.getTestOutdateWord(limit);
    if (modelList.length == limit) return modelList;
    // print(modelList);

    var model = await _service.getNotTestedWord(limit - modelList.length);
    if (model != null) {
      modelList += model;
    }

    // Any word was not targeted for next learning (end learning or add words more)
    return modelList;
  }

  Future<List<String>> getRandomWordString(int limit, WordModel exclude) async {
    List<String> wordList = await _service.getRandomWordString(limit, List<WordModel>.generate(1, (index) => exclude));
    return wordList;
  }
}
