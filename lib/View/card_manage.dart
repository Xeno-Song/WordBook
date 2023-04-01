import 'package:flutter/material.dart';
import 'package:word_book/View/components/common/appbar.dart';
import 'package:word_book/View/components/common/colors.dart';
import 'package:word_book/model/WordModel.dart';
import 'package:word_book/model/WordTestModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/word_service.dart';
import 'components/common/drawer.dart';

class CardManageView extends StatefulWidget {
  CardManageView({super.key});
  final WordService _service = WordService();
  int currentPage = 1;
  int maxPage = 10;

  @override
  State<StatefulWidget> createState() {
    return _CardManageViewPageState();
  }
}

class _CardManageViewPageState extends State<CardManageView> {
  @override
  void initState() {
    super.initState();
    updateMaxPage();
  }

  void updateMaxPage() {
    widget._service.getAllCount().then((int count) {
      setState(() {
        widget.maxPage = ((count / 100) + 1).toInt();
        // print("Total Count : $count / Pages : ${widget.maxPage}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        drawer: const ApplicationDrawer(),
        appBar: CommonAppBar.build(),
        body: Container(
          color: const Color.fromARGB(0xFF, 0x1C, 0x1B, 0x1F),
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: CardManageItemBuilder(
                  service: widget._service,
                  offset: (widget.currentPage - 1) * 100,
                  count: 100,
                ),
              ),
              SizedBox(
                height: 50,
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => {
                        setState(
                          () {
                            if (widget.currentPage > 1) widget.currentPage--;
                          },
                        )
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: CommonColors.secondaryBackgroundColor,
                      ),
                      child: const Text("<"),
                    ),
                    Text(
                      "    ${widget.currentPage} / ${widget.maxPage}    ",
                      style: const TextStyle(
                        color: CommonColors.primaryForegroundColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () => {
                        setState(
                          () {
                            if (widget.currentPage < widget.maxPage) widget.currentPage++;
                          },
                        )
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: CommonColors.secondaryBackgroundColor,
                      ),
                      child: const Text(">"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              // _isAdding = true;
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (_) => WordSetCreationView()),
              // );
              for (int i = 0; i < 10000; ++i) {
                widget._service.insertModel(WordModel(
                  0,
                  "word_$i",
                  "meaning_$i",
                  "pronunciation",
                  List<WordTestModel>.empty(),
                  DateTime.now(),
                  DateTime.now(),
                  DateTime.now(),
                ));
              }
            });
          },
          tooltip: 'Create New',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }
}

class CardManageItemBuilder extends StatefulWidget {
  const CardManageItemBuilder(
      {super.key, required this.offset, required this.count, this.wordSet, required this.service});
  final int offset;
  final int count;
  final List<WordService>? wordSet;
  final WordService service;

  @override
  State<StatefulWidget> createState() {
    return _CardManageItemBuilderState();
  }
}

class _CardManageItemBuilderState extends State<CardManageItemBuilder> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WordModel>>(
        future: widget.service.getDataLimit(widget.offset, widget.count),
        builder: (context, AsyncSnapshot<List<WordModel>> snapshot) {
          if (snapshot.hasData) {
            return _buildWordList(snapshot.data!);
          } else {
            return const SpinKitFoldingCube(
              color: Colors.white,
              duration: Duration(seconds: 4),
              size: 50.0,
            );
          }
        });

    /*
    var data = widget.service?.getAll();
    var list = <Widget>[];

    for (int i = 0; i < data!.; ++i) {
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

     */
  }

  Widget _buildWordList(List<WordModel> data) {
    var list = <Widget>[];

    for (int i = 0; i < data.length; ++i) {
      var dataIndex = data[i];

      list.add(
        Material(
          color: Colors.transparent,
          child: ListTile(
            onTap: () {},
            title: Text(dataIndex.word),
            subtitle: Text(dataIndex.meaning),
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

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: list,
      ),
    );
  }
}
