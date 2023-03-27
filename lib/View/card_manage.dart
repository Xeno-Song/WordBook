import 'package:flutter/material.dart';
import 'package:word_book/model/WordModel.dart';

import '../model/WordSetModel.dart';
import '../services/wordset_service.dart';

class CardManageView extends StatefulWidget {
  CardManageView({super.key, required this.contentHeight});
  final double contentHeight;
  final WordSetService _service = WordSetService();

  bool _isAdding = false;

  @override
  State<StatefulWidget> createState() {
    return _CardManageViewPageState();
  }
}

class _CardManageViewPageState extends State<CardManageView> {
  @override
  Widget build(BuildContext context) {
    widget._service.insertWord(WordModel(0, "AA", "aa", "AA"));

    List<Widget> contents = <Widget>[];
    contents.add(SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: CardManageItemBuilder(
        service: widget._service,
      ),
    ));
    contents.add(const CardAddPopupScreen());
    if (widget._isAdding) {
      // contents.add(Container(
      //   decoration: const BoxDecoration(
      //     color: Colors.black45,
      //   ),
      //   child: const Center(
      //     child: Text(""),
      //   ),
      // ));
      // contents.add(Positioned(
      //   top: 20,
      //   left: 20,
      //   bottom: 20,
      //   right: 20,
      //   child: Container(
      //     decoration: BoxDecoration(
      //       color: Colors.white,
      //       borderRadius: BorderRadius.circular(20),
      //     ),
      //     child: const Text("AAAA"),
      //   ),
      // ));
    }

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        body: Container(
          color: const Color.fromARGB(0xFF, 0x1C, 0x1B, 0x1F),
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: contents,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              widget._isAdding = true;
            });
          },
          tooltip: 'Create New',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }
}

class CardAddPopupScreen extends StatefulWidget {
  const CardAddPopupScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CardAddPopupScreenState();
  }
}

class _CardAddPopupScreenState extends State<CardAddPopupScreen> {
  final _wordSetNameTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select assignment'),
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {},
          child: const Text('Treasury department'),
        ),
        SimpleDialogOption(
          onPressed: () {},
          child: const Text('State department'),
        ),
      ],
    );
  }
}

class CardManageItemBuilder extends StatefulWidget {
  const CardManageItemBuilder({super.key, this.itemCount, this.wordSet, required this.service});
  final int? itemCount;
  final List<WordSetModel>? wordSet;
  final WordSetService service;

  @override
  State<StatefulWidget> createState() {
    return _CardManageItemBuilderState();
  }
}

class _CardManageItemBuilderState extends State<CardManageItemBuilder> {
  @override
  Widget build(BuildContext context) {
    var data = widget.service?.getDummyData();
    var list = <Widget>[];

    for (int i = 0; i < data!.length; ++i) {
      var dataIndex = data[i];
      var wordCount = dataIndex.words.length;

      list.add(
        Material(
          color: Colors.transparent,
          child: ListTile(
            onTap: () {},
            title: Text(dataIndex.name),
            subtitle: Text("$wordCount words"),
            textColor: Colors.white,
            leading: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.copy,
                  color: Colors.white,
                ),
              ],
            ),
            trailing: PopupMenuButton(
              color: Colors.white,
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                const PopupMenuItem(
                  textStyle: TextStyle(
                    color: Colors.red,
                  ),
                  child: Text('Delete'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // return ListView.builder(
    //   itemCount: widget.itemCount,
    //   itemBuilder: (BuildContext context, int index) {
    //     return Material(
    //       color: Colors.transparent,
    //       child: ListTile(
    //         onTap: () {},
    //         title: const Text("Word Set #1"),
    //         textColor: Colors.white,
    //         leading: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: const [
    //             Icon(
    //               Icons.copy,
    //               color: Colors.white,
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: list,
    );
  }
}
