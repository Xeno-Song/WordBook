import 'package:flutter/material.dart';
import 'package:word_book/View/components/common/appbar.dart';
import 'package:word_book/View/components/common/colors.dart';
import 'package:word_book/View/word_add.dart';
import 'package:word_book/common/date_time_formatter.dart';
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
  ListingCondition _listingCondition = ListingCondition.createDateAsc;

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
        if (currentPage == 0 && maxPage != 0) currentPage = 1;
        // print("Total Count : $count / Pages : ${widget.maxPage}");
      });
    });
  }

  void handleWordItemTrailingMenuTap(WordModel model, String value) {
    if (value == "delete") deleteWord(model);
  }

  void deleteWord(WordModel model) {
    widget._service.remove(model).then((value) => setState(() {
          updateMaxPage();
        }));
  }

  void onSelectedSortRuleChanged(ListingCondition? sortRule) {
    if (sortRule == null) return;
    setState(() => _listingCondition = sortRule!);
  }

  void createDummyData(int dataCount) async {
    const int dataCount = 10000;
    DateTime dataTime = DateTime.now().add(const Duration(seconds: -dataCount));

    for (int i = 0; i < 10000; ++i) {
      await widget._service.insertModel(WordModel(
        0,
        "word_$i",
        "meaning_$i",
        "pronunciation",
        List<WordTestModel>.empty(),
        dataTime,
        dataTime,
        0,
        null,
      ));

      print(DateTimeFormatter.format(dataTime));
      dataTime = dataTime.add(const Duration(seconds: 1));
    }

    setState(() {
      updateMaxPage();
    });
    print("Dummy data creation complete.");
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        drawer: const ApplicationDrawer(),
        appBar: CommonAppBar.build(
          <Widget>[
            PopupMenuButton<String>(
              icon: const Icon(Icons.sort_rounded),
              itemBuilder: (BuildContext context) {
                return ListingCondition.values.map((ListingCondition choice) {
                  String? choiceString = ListingConditionConverter.convertToString(choice);

                  return PopupMenuItem<String>(
                    value: choiceString,
                    child: Text(choiceString!),
                  );
                }).toList();
              },
              onSelected: (String value) => onSelectedSortRuleChanged(ListingConditionConverter.convertToEnum(value)),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'Add') {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WordAddView()));
                } else if (value == 'Create Dummy') {
                  createDummyData(10000);
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Add', 'Create Dummy'}.map((String choice) {
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
          color: CommonColors.primaryBackgroundColor,
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: widget._service.getData(
                      offset: (currentPage - 1) * 100,
                      limit: 100,
                      order: ListingConditionConverter.convertToQuery(_listingCondition)),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SpinKitFoldingCube(
                        color: Colors.white,
                        duration: Duration(seconds: 4),
                        size: 50,
                      );
                    }
                    return CardManageItemBuilder(
                      service: widget._service,
                      offset: (currentPage - 1) * 100,
                      count: 100,
                      onTrailingTap: handleWordItemTrailingMenuTap,
                      data: snapshot.data!,
                    );
                  },
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
  const CardManageItemBuilder({
    super.key,
    required this.offset,
    required this.count,
    this.wordSet,
    required this.service,
    this.onTrailingTap,
    required this.data,
  });
  final int offset;
  final int count;
  final List<WordService>? wordSet;
  final WordService service;
  final Function(WordModel model, String value)? onTrailingTap;
  final List<WordModel> data;

  @override
  State<StatefulWidget> createState() {
    return _CardManageItemBuilderState();
  }
}

enum ListingCondition {
  createDateAsc,
  createDateDesc,
}

class ListingConditionConverter {
  static const Map<ListingCondition?, String> enumStringMap = {
    ListingCondition.createDateAsc: "CreateDate ASC",
    ListingCondition.createDateDesc: "CreateDate DESC",
  };

  static String? convertToString(ListingCondition condition) {
    return enumStringMap[condition];
  }

  static String? convertToQuery(ListingCondition condition) {
    switch (condition) {
      case ListingCondition.createDateAsc:
        return "createDate ASC";
      case ListingCondition.createDateDesc:
        return "createDate DESC";
    }
  }

  static ListingCondition? convertToEnum(String condition) {
    return enumStringMap.keys.firstWhere(
      (k) => enumStringMap[k] == condition,
      orElse: () => null,
    );
  }
}

class _CardManageItemBuilderState extends State<CardManageItemBuilder> {
  @override
  Widget build(BuildContext context) {
    return _buildWordList(widget.data);
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
