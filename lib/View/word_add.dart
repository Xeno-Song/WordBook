import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:word_book/View/components/common/common_text_input_field.dart';
import 'package:word_book/View/components/common/drawer.dart';
import 'package:word_book/View/components/text_input_field.dart';
import 'package:word_book/model/WordModel.dart';
import 'package:word_book/services/word_service.dart';

import 'components/common/appbar.dart';
import 'components/common/colors.dart';

class WordAddView extends StatefulWidget {
  const WordAddView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WordAddViewState();
  }
}

class _WordAddViewState extends State<WordAddView> {
  final _wordTextEditingController = TextEditingController();
  final _pronunciationTextEditingController = TextEditingController();
  final _meaningTextEditingController = TextEditingController();
  bool _isContinueCreation = false;

  final _wordService = WordService();
  String? wordTextErrorMessage;
  String? meaningTextErrorMessage;

  void gotoBackPage() => Navigator.of(context).pop();

  void createNewWord() {
    String word = _wordTextEditingController.value.text;
    String pronunciation = _pronunciationTextEditingController.value.text;
    String meaning = _meaningTextEditingController.value.text;

    wordTextErrorMessage = null;
    meaningTextErrorMessage = null;

    setState(() {
      if (word.isEmpty) wordTextErrorMessage = "Please enter word text in field";
      if (meaning.isEmpty) meaningTextErrorMessage = "Please enter word meaning in field";
    });

    if (word.isEmpty || meaning.isEmpty) return;

    if (word.isEmpty) {}
    WordModel data = WordModel.empty();
    data.word = word;
    data.meaning = meaning;
    data.pronunciation = pronunciation;
    data.createDate = data.modifyDate = data.nextTestDate = DateTime.now();
    _wordService.insertModel(data).then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Word created!!'),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );

    if (_isContinueCreation == false) {
      gotoBackPage();
    }

    _wordTextEditingController.clear();
    _pronunciationTextEditingController.clear();
    _meaningTextEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ApplicationDrawer(),
      appBar: CommonAppBar.build(),
      body: Container(
        color: CommonColors.primaryBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                children: [
                  CommonTextInputField(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                    controller: _wordTextEditingController,
                    hint: "Word",
                    errorMessage: wordTextErrorMessage,
                    foregroundColor: CommonColors.white80,
                    onChanged: (value) => setState(() => wordTextErrorMessage = null),
                  ),
                  CommonTextInputField(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                    controller: _pronunciationTextEditingController,
                    hint: "Pronunciation",
                    foregroundColor: CommonColors.white80,
                  ),
                  CommonTextInputField(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                    controller: _meaningTextEditingController,
                    hint: "Meaning",
                    errorMessage: meaningTextErrorMessage,
                    foregroundColor: CommonColors.white80,
                    onChanged: (value) => setState(() => meaningTextErrorMessage = null),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          checkColor: CommonColors.white80,
                          activeColor: Colors.purple,
                          side: const BorderSide(
                            color: CommonColors.white80,
                            width: 1.5,
                          ),
                          value: _isContinueCreation,
                          onChanged: (value) {
                            setState(() {
                              _isContinueCreation = value!;
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            _isContinueCreation = !_isContinueCreation;
                          }),
                          child: const Text(
                            style: TextStyle(
                              color: CommonColors.white80,
                            ),
                            "Continous generation",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              color: CommonColors.secondaryBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      foregroundColor: CommonColors.primaryForegroundColor,
                      elevation: 20,
                      shadowColor: Colors.black45,
                    ),
                    onPressed: () {
                      gotoBackPage();
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      foregroundColor: CommonColors.primaryThemeColorBrighter,
                      elevation: 20,
                      shadowColor: Colors.black45,
                    ),
                    onPressed: () {
                      createNewWord();
                    },
                    child: const Text("Create"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
