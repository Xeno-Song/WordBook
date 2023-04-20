import 'package:word_book/services/word_service.dart';

import '../model/WordModel.dart';

class FlashcardService {
  final WordService _service = WordService();

  Future<List<WordModel>?> getNextWord({int limit = 1, List<int>? excludeId}) async {
    excludeId ??= List<int>.empty();

    List<WordModel> modelList = await _service.getTestOutdateWord(limit, excludeId: excludeId);
    if (modelList.length == limit) return modelList;

    excludeId = excludeId + List<int>.generate(modelList.length, (index) => modelList[index].id);
    // print(modelList);

    var model = await _service.getNotTestedWord(limit - modelList.length, excludeId: excludeId);
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

  Future<void> updateTestResult(WordModel model) async {
    await _service.update(model.id, model);
  }
}
