import 'dart:io';
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
import 'package:word_book/View/components/common/configuration.dart';
import 'package:word_book/common/date_time_formatter.dart';
import 'package:word_book/model/WordTestModel.dart';
import 'package:word_book/services/flashcard_service.dart';

import '../model/WordModel.dart';
import 'components/common/drawer.dart';

class FlashcardObject {
  FlashcardObject(this.model, this.choices) {
    choices = <String>[model.meaning] + choices;
    choices.shuffle();

    answerIndex = choices.indexOf(model.meaning);

    testable = model.testResult.isNotEmpty;
    tested = false;
  }

  WordModel model;
  List<String> choices;
  bool testable = false;
  bool tested = false;
  int answerIndex = -1;
}

class FlashcardView extends StatefulWidget {
  const FlashcardView({super.key});

  @override
  State<StatefulWidget> createState() {
    return FlashcardViewState();
  }
}

class FlashcardViewState extends State<FlashcardView> {
  final FlashcardService _service = FlashcardService();
  final List<FlashcardObject> _waitingWords = <FlashcardObject>[];
  int offset = 0;
  FlipCardController controller = FlipCardController();

  @override
  void initState() {
    super.initState();

    _service.getNextWord(limit: 3).then((list) {
      list?.forEach((element) {
        _service.getRandomMeaningString(3, element).then((value) {
          setState(() {
            _waitingWords.add(FlashcardObject(element, value));
          });
        });
      });
    });
  }

  void onCardSwipe() {
    FlashcardObject model = _waitingWords[0];
    _waitingWords.remove(model);
    setState(() {
      controller.state?.isFront = true;
    });

    if (!model.testable) {
      Duration initTestInterval = Duration(minutes: Configuration.minTestInterval);
      model.model.testResult.add(WordTestModel(0, "P", DateTime.now()));
      model.model.nextTestDate = DateTime.now().add(initTestInterval);
      model.model.modifyDate = DateTime.now();
      model.model.testInterval = initTestInterval.inMinutes;
      _service.updateTestResult(model.model);
    }

    _service
        .getNextWord(
      limit: 1,
      excludeId: List<int>.generate(_waitingWords.length, (index) => _waitingWords[index].model.id),
    )
        .then((word) {
      _service.getRandomMeaningString(3, word![0]).then((value) {
        setState(() {
          _waitingWords.add(FlashcardObject(word[0], value));
        });
      });
    });
  }

  void onTestResultReceived(bool isCorrect) {
    setState(() => _waitingWords[0].tested = true);

    FlashcardObject testData = _waitingWords[0];
    WordModel model = testData.model;
    DateTime currentTime = DateTime.now();

    if (isCorrect) {
      model.testResult.add(WordTestModel(model.testResult.length, "P", currentTime));
      model.testInterval = (model.testInterval * 1.5).ceil();
    } else {
      model.testResult.add(WordTestModel(model.testResult.length, "P", currentTime));
      if (model.testInterval > (60 * 24 * 1.5).ceil()) {
        model.testInterval = 60 * 24;
      } else {
        model.testInterval = min((model.testInterval / 3 * 2).ceil(), Configuration.minTestInterval);
      }
    }

    model.modifyDate = currentTime;
    model.nextTestDate = currentTime.add(Duration(minutes: model.testInterval));
    _service.updateTestResult(model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ApplicationDrawer(),
      appBar: CommonAppBar.build(),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    if (_waitingWords.isEmpty) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        color: CommonColors.primaryBackgroundColor,
        child: SpinKitFoldingCube(
          color: CommonColors.secondaryForegroundColor,
          duration: const Duration(seconds: 4),
          size: 50.0,
        ),
      );
    }

    return Container(
      color: CommonColors.primaryBackgroundColor,
      child: CardSwiper(
        cardsCount: 3,
        isLoop: true,
        numberOfCardsDisplayed: 3,
        onSwipe: (int a, int? b, CardSwiperDirection direction) {
          onCardSwipe();
          return false;
        },
        isDisabled: _waitingWords[0].testable && !_waitingWords[0].tested,
        cardBuilder: (context, index) {
          if (index == 0) {
            return TestableWordCardIndex(
              dataObject: _waitingWords[index],
              controller: controller,
              onCorrectAnswer: () => onTestResultReceived(true),
              onWrongAnswer: () => onTestResultReceived(false),
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
    );
  }
}

class TestableWordCardIndex extends StatefulWidget {
  const TestableWordCardIndex({
    super.key,
    this.dataObject,
    this.questionOptions,
    this.onCorrectAnswer,
    this.onWrongAnswer,
    required this.controller,
  });

  final FlashcardObject? dataObject;
  final List<String>? questionOptions;
  final Function()? onCorrectAnswer;
  final Function()? onWrongAnswer;
  final FlipCardController controller;

  @override
  State<StatefulWidget> createState() {
    return _TestableWordCardIndexState();
  }
}

class _TestableWordCardIndexState extends State<TestableWordCardIndex> with SingleTickerProviderStateMixin {
  FlashcardObject? _oldDataObject;
  int selectedItemIndex = -1;
  Animation? _colorTween;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();

    _oldDataObject = widget.dataObject;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _colorTween = ColorTween(
      begin: CommonColors.secondaryBackgroundColor,
      end: CommonColors.secondaryBackgroundColor,
    ).animate(_animationController!);
  }

  void _onDataObjectChanged() {
    selectedItemIndex = -1;
  }

  void onChoiceSelected(int choiceIndex) {
    setState(() => selectedItemIndex = choiceIndex);

    // . widget.questionOptions[choiceIndex];
    String correctWord = widget.dataObject!.model.meaning;

    if (correctWord == widget.dataObject!.choices[choiceIndex]) {
      onCorrectChoice();
    } else {
      onWrongChoice();
    }
  }

  void onCorrectChoice() {
    _colorTween = ColorTween(
      begin: CommonColors.colorCorrect,
      end: CommonColors.secondaryBackgroundColor,
    ).animate(_animationController!);
    _animationController?.forward(from: 0.0);

    widget.onCorrectAnswer?.call();
  }

  void onWrongChoice() {
    _colorTween = ColorTween(
      begin: CommonColors.colorWrong,
      end: CommonColors.secondaryBackgroundColor,
    ).animate(_animationController!);
    _animationController?.forward(from: 0.0);

    widget.onWrongAnswer?.call();
  }

  Widget buildWordVisualizationCard() {
    return FlipCard(
      frontWidget: DecoratedBox(
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
            widget.dataObject!.model.word,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
            ),
          ),
        ),
      ),
      backWidget: DecoratedBox(
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
                  widget.dataObject!.model.pronunciation,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                widget.dataObject!.model.meaning,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
      controller: widget.controller,
      rotateSide: RotateSide.left,
      onTapFlipping: true,
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  Widget buildMultipleChoiceCard() {
    return FlipCard(
      frontWidget: AnimatedBuilder(
        animation: _colorTween!,
        builder: (BuildContext context, Widget? child) {
          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: _colorTween!.value,
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
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Flexible(
                    flex: 5,
                    child: Center(
                      child: Text(
                        widget.dataObject!.model.word,
                        style: TextStyle(
                          color: CommonColors.primaryForegroundColor,
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child: Flex(
                        direction: Axis.vertical,
                        children: List<Widget>.generate(4, (index) {
                          Color buttonColor = const Color.fromARGB(50, 20, 20, 20);
                          if (selectedItemIndex != -1) {
                            if (widget.dataObject!.answerIndex == index) {
                              buttonColor = CommonColors.colorCorrect;
                            } else if (index == selectedItemIndex) {
                              buttonColor = CommonColors.colorWrong;
                            }
                          }

                          return Flexible(
                            flex: 1,
                            child: ChoiceButton(
                              text: widget.dataObject!.choices[index],
                              onPressed: () => onChoiceSelected(index),
                              backgroundColor: buttonColor,
                              enable: selectedItemIndex == -1,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      backWidget: DecoratedBox(
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
                  widget.dataObject!.model.pronunciation,
                  style: TextStyle(
                    color: CommonColors.primaryForegroundColor,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                widget.dataObject!.model.meaning,
                style: TextStyle(
                  color: CommonColors.primaryForegroundColor,
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
      controller: widget.controller,
      rotateSide: RotateSide.left,
      onTapFlipping: selectedItemIndex != -1,
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dataObject != _oldDataObject) {
      _oldDataObject = widget.dataObject;
      _onDataObjectChanged();
    }
    if (widget.dataObject!.model.testResult.isEmpty) {
      return buildWordVisualizationCard();
    } else {
      return buildMultipleChoiceCard();
    }
  }
}

class ChoiceButton extends StatefulWidget {
  const ChoiceButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor = Colors.transparent,
    this.enable = true,
  });

  final String? text;
  final Function()? onPressed;
  final Color? backgroundColor;
  final bool? enable;

  @override
  State<StatefulWidget> createState() {
    return _ChoiceButtonState();
  }
}

class _ChoiceButtonState extends State<ChoiceButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: widget.backgroundColor,
            elevation: 20,
            shadowColor: Colors.black38,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            side: const BorderSide(
              color: Colors.white54,
            ),
          ),
          onPressed: widget.enable == true ? () => widget.onPressed?.call() : null,
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            child: Text(
              widget.text!,
              style: TextStyle(
                color: CommonColors.primaryForegroundColor,
                // color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
