import 'package:flutter/material.dart';
import 'package:word_book/View/components/text_input_field.dart';

class WordSetCreationView extends StatefulWidget {
  const WordSetCreationView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WordSetCreationViewState();
  }
}

class _WordSetCreationViewState extends State<WordSetCreationView> {
  final _wordSetNameTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextInputField(
          textEditingController: _wordSetNameTextEditingController,
          fieldName: "TEST",
        ),
      ],
    );
  }
}
