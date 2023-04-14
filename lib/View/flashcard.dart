import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:word_book/View/components/common/appbar.dart';
import 'package:word_book/View/components/common/colors.dart';
import 'package:word_book/services/flashcard_service.dart';

import '../model/WordModel.dart';
import 'components/common/drawer.dart';

class FlashcardView extends StatefulWidget {
  const FlashcardView({super.key});

  @override
  State<StatefulWidget> createState() {
    return FlashcardViewState();
  }
}

class FlashcardViewState extends State<FlashcardView> {
  final FlashcardService _service = FlashcardService();
  List<WordModel> _waitingWords = List<WordModel>.empty();
  int offset = 0;
  FlipCardController controller = FlipCardController();

  @override
  void initState() {
    super.initState();

    _service.getNextWord(limit: 3).then((list) {
      setState(() {
        _waitingWords = list!;
      });
    });
  }

  void onCardSwipe() {
    WordModel model = _waitingWords[0];
    _waitingWords.remove(model);
    setState(() {
      controller.state!.isFront = true;
    });

    _service.getNextWord(limit: 1).then((list) {
      _waitingWords += list!;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_waitingWords.isEmpty) {
      return const Center(
        child: SpinKitFoldingCube(
          color: Colors.white,
          duration: Duration(seconds: 4),
          size: 50.0,
        ),
      );
    }

    return Scaffold(
      drawer: const ApplicationDrawer(),
      appBar: CommonAppBar.build(),
      body: Container(
        color: CommonColors.primaryBackgroundColor,
        child: CardSwiper(
          cardsCount: 3,
          isLoop: true,
          numberOfCardsDisplayed: 3,
          onSwipe: (int a, int? b, CardSwiperDirection direction) {
            onCardSwipe();
            return false;
          },
          cardBuilder: (context, index) {
            if (index == 0) {
              return TestableWordCardIndex(
                model: _waitingWords[index],
                controller: controller,
              );
            }
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
              child: Container(),
            );
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
    required this.controller,
  });

  final WordModel? model;
  final List<String>? questionOptions;
  final Action? onCorrectAnswer;
  final Action? onWrongAnswer;
  final FlipCardController controller;

  @override
  State<StatefulWidget> createState() {
    return _TestableWordCardIndexState();
  }
}

class _TestableWordCardIndexState extends State<TestableWordCardIndex> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      frontWidget: Container(
        child: DecoratedBox(
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
            child: Text(
              widget.model!.word,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
              ),
            ),
          ),
        ),
      ),
      backWidget: Container(
        child: DecoratedBox(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Center(
                  child: Text(
                    "${widget.model!.pronunciation}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  widget.model!.meaning,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      controller: widget.controller,
      rotateSide: RotateSide.left,
      onTapFlipping: true,
      animationDuration: const Duration(milliseconds: 300),
    ); /*AnimatedSize(
      duration: const Duration(seconds: 1),
      child: DecoratedBox(
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
          child: ,
        ),
      ),
    );*/
  }
}
