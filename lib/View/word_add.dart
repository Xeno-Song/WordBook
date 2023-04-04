import 'package:flutter/material.dart';
import 'package:word_book/View/components/common/drawer.dart';
import 'package:word_book/View/components/text_input_field.dart';

import 'components/common/appbar.dart';

class WordAddView extends StatefulWidget {
  const WordAddView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WordAddViewState();
  }
}

class _WordAddViewState extends State<WordAddView> {
  final _wordSetNameTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ApplicationDrawer(),
      appBar: CommonAppBar.build(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextInputField(
            textEditingController: _wordSetNameTextEditingController,
            fieldName: "TEST",
          ),
        ],
      ),
    );
  }
}
