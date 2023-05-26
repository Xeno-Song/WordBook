import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
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

  final int? itemPerPage;

  @override
  State<StatefulWidget> createState() {
    return _CardManageViewPageState();
  }
}

class _CardManageViewPageState extends State<CardManageView> {
  final WordService _service = WordService();
  int currentPage = 1;
  int maxPage = 1;
  int addRemaningWords = 0;
  ListingCondition _listingCondition = ListingCondition.createDateAsc;

  @override
  void initState() {
    super.initState();
    updateMaxPage();
  }

  void updateMaxPage() {
    _service.getAllCount().then((int count) {
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
    _service.remove(model).then((value) => setState(() {
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
      await _service.insertModel(WordModel(
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

      dataTime = dataTime.add(const Duration(seconds: 1));
    }

    setState(() {
      updateMaxPage();
    });
    print("Dummy data creation complete.");
  }

  void loadCsvFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        "csv",
      ],
    );

    if (result == null) {
      return;
    }

    File(result.files.first.path!).readAsString().then((String contents) async {
      // print('File Contents\n---------------');
      // print(contents);
      var lines = contents.split('\n');
      addRemaningWords = lines.length - 1;

      int insertTasks = 0;

      for (int i = 1; i < lines.length; ++i) {
        var datas = lines[i].split(',');
        if (datas.length != 3) {
          setState(() => addRemaningWords = addRemaningWords - 1);
          continue;
        }

        String word = datas[0]; // Word
        String meaning = datas[1]; // Meaning
        String pronunciation = datas[2]; // pronunciation

        // Add word
        WordModel data = WordModel.empty();
        data.word = word;
        data.meaning = meaning;
        data.pronunciation = pronunciation;
        data.createDate = data.modifyDate = data.nextTestDate = DateTime.now();

        await Future.doWhile(() async {
          if (insertTasks > 9) {
            await Future.delayed(const Duration(seconds: 1));
            return true;
          }

          return false;
        });

        insertTasks = insertTasks + 1;
        _service.insertModel(data).then(
              (value) => setState(
                () {
                  insertTasks = insertTasks - 1;
                  addRemaningWords = addRemaningWords - 1;
                },
              ),
            );
      }

      await Future.doWhile(() async {
        if (insertTasks != 0) {
          await Future.delayed(const Duration(seconds: 1));
          return true;
        }

        return false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${lines.length} word added'),
          duration: const Duration(seconds: 2),
        ),
      );
      setState(() => addRemaningWords = 0);
      updateMaxPage();
    });
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
              onSelected: (value) async {
                if (value == 'Add') {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WordAddView()));
                } else if (value == 'Create Dummy') {
                  createDummyData(10000);
                } else if (value == 'Load CSV') {
                  loadCsvFile();
                } else if (value == 'Test') {
                  setState(() {
                    addRemaningWords = addRemaningWords + 1;
                  });
                }
              },
              itemBuilder: (BuildContext context) {
                return {
                  'Add',
                  'Load CSV', /*'Create Dummy', 'Test'*/
                }.map((String choice) {
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
          child: Stack(
            children: List<Widget>.generate(
              (addRemaningWords == 0 ? 1 : 2),
              (index) {
                if (index == 0) {
                  return Column(
                    children: [
                      Expanded(
                        child: FutureBuilder(
                          future: _service.getData(
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
                              service: _service,
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
                                backgroundColor: CommonColors.coloredBackgroundColor,
                              ),
                              child: Text(
                                "<",
                                style: TextStyle(
                                  color: CommonColors.menuTextColor,
                                ),
                              ),
                            ),
                            Text(
                              "    $currentPage / $maxPage    ",
                              style: TextStyle(
                                color: CommonColors.menuTextColor,
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
                                backgroundColor: CommonColors.coloredBackgroundColor,
                              ),
                              child: Text(
                                ">",
                                style: TextStyle(
                                  color: CommonColors.menuTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black87,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitWave(
                          color: CommonColors.secondaryForegroundColor,
                          duration: const Duration(seconds: 2),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Text(
                            "Adding words...  $addRemaningWords",
                            style: TextStyle(
                              color: CommonColors.secondaryForegroundColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
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
            textColor: CommonColors.menuTextColor,
            leading: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.copy,
                  color: CommonColors.menuTextColor,
                ),
              ],
            ),
            trailing: PopupMenuButton(
              color: CommonColors.menuTextColor,
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
