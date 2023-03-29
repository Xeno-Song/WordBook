import 'package:flutter/material.dart';
import 'package:word_book/View/components/common/drawer.dart';
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
    return Scaffold(
      drawer: const ApplicationDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("AA"),
        ),
      ),
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
