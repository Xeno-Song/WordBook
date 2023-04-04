import 'package:flutter/material.dart';
import 'package:word_book/View/components/common/appbar.dart';
import 'package:word_book/View/components/common/colors.dart';
import 'package:word_book/model/WordModel.dart';
import 'package:word_book/model/WordTestModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/word_service.dart';
import 'components/common/drawer.dart';

class CardManageView extends StatefulWidget {
  CardManageView({super.key, this.itemPerPage = 100});
  final WordService _service = WordService();

  final int? itemPerPage;

  @override
  State<StatefulWidget> createState() {
    return _CardManageViewPageState();
  }
}

class _CardManageViewPageState extends State<CardManageView> {
  int currentPage = 1;
  int maxPage = 1;

  @override
  void initState() {
    super.initState();
    updateMaxPage();
  }

  void updateMaxPage() {
    widget._service.getAllCount().then((int count) {
      setState(() {
        maxPage = ((count / 100) + (count % 100 == 0 ? 0 : 1)).toInt();
        if (currentPage > maxPage) currentPage = maxPage;
        // print("Total Count : $count / Pages : ${widget.maxPage}");
      });
    });
  }

  void handleAppbarAction(String menu) {
    print("App bar action handled : $menu");
  }

  void handleWordItemTrailingMenuTap(WordModel model, String value) {
    if (value == "delete") deleteWord(model);
  }

  void deleteWord(WordModel model) {
    widget._service.remove(model).then((value) => setState(() {
          updateMaxPage();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        drawer: const ApplicationDrawer(),
        appBar: CommonAppBar.build(
          <Widget>[
            PopupMenuButton<String>(
              onSelected: handleAppbarAction,
              itemBuilder: (BuildContext context) {
                return {'Add'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Container(
          color: const Color.fromARGB(0xFF, 0x1C, 0x1B, 0x1F),
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: CardManageItemBuilder(
                  service: widget._service,
                  offset: (currentPage - 1) * 100,
                  count: 100,
                  onTrailingTap: handleWordItemTrailingMenuTap,
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
                            if (currentPage > 1) currentPage--;
                          },
                        )
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: CommonColors.secondaryBackgroundColor,
                      ),
                      child: const Text("<"),
                    ),
                    Text(
                      "    $currentPage / $maxPage    ",
                      style: const TextStyle(
                        color: CommonColors.primaryForegroundColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () => {
                        setState(
                          () {
                            if (currentPage < maxPage) currentPage++;
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
      );
    });
  }
}

class CardManageItemBuilder extends StatefulWidget {
  const CardManageItemBuilder(
      {super.key, required this.offset, required this.count, this.wordSet, required this.service, this.onTrailingTap});
  final int offset;
  final int count;
  final List<WordService>? wordSet;
  final WordService service;
  final Function(WordModel model, String value)? onTrailingTap;

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
      },
    );
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
                  value: "delete",
                  child: Text('Delete'),
                ),
              ],
              onSelected: (value) => widget.onTrailingTap!(dataIndex, value),
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
