import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:word_book/View/components/common/appbar.dart';
import 'package:word_book/View/components/common/colors.dart';
import 'package:word_book/services/flashcard_service.dart';

import '../model/WordModel.dart';
import 'components/common/drawer.dart';

class FlashcardView extends StatefulWidget {
  FlashcardView({super.key});

  @override
  State<StatefulWidget> createState() {
    return FlashcardViewState();
  }
}

class FlashcardViewState extends State<FlashcardView> {
  final FlashcardService _service = FlashcardService();
  final List<WordModel> _waitingWords = List<WordModel>.empty();

  @override
  void initState() {
    super.initState();

    // _service.getNextWord(limit: 3).then((list) {
    //   setState(() {
    //     _waitingWords.addAll(list?.iterator as Iterable<WordModel>);
    //   });
    // });
    // _waitingWords.add()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ApplicationDrawer(),
      appBar: CommonAppBar.build(),
      body: Container(
        color: CommonColors.primaryBackgroundColor,
        child: CardSwiper(
          cardsCount: 10,
          isLoop: true,
          numberOfCardsDisplayed: 3,
          cardBuilder: (context, index) {
            return const TestableWordCardIndex();
          },
        ),
      ),
    );
  }
}

class TestableWordCardIndex extends StatefulWidget {
  const TestableWordCardIndex({
    super.key,
    this.model,
    this.questionOptions,
    this.onCorrectAnswer,
    this.onWrongAnswer,
  });

  final WordModel? model;
  final List<String>? questionOptions;
  final Action? onCorrectAnswer;
  final Action? onWrongAnswer;

  @override
  State<StatefulWidget> createState() {
    return _TestableWordCardIndexState();
  }
}

class _TestableWordCardIndexState extends State<TestableWordCardIndex> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: CommonColors.secondaryBackgroundColor,
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: Colors.black45.withOpacity(0.55),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        alignment: Alignment.center,
        child: const Text("1"),
      ),
    );
  }
}
