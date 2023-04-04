import 'package:flutter/material.dart';
import 'package:word_book/View/components/common/common_text_input_field.dart';
import 'package:word_book/View/components/common/drawer.dart';
import 'package:word_book/View/components/text_input_field.dart';

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
  final _wordSetNameTextEditingController = TextEditingController();
  bool _isContinueCreation = false;

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
            CommonTextInputField(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
              controller: _wordSetNameTextEditingController,
              hint: "Word",
            ),
            CommonTextInputField(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
              controller: _wordSetNameTextEditingController,
              hint: "Pronunciation",
            ),
            CommonTextInputField(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
              controller: _wordSetNameTextEditingController,
              hint: "Meaning",
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.purple,
                    side: const BorderSide(
                      color: Colors.white,
                      width: 1.5,
                    ),
                    value: _isContinueCreation,
                    onChanged: (value) {
                      setState(() {
                        _isContinueCreation = value!;
                      });
                    },
                  ),
                  const Text(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    "Continous generation",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
