import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:word_book/View/components/common/colors.dart';
import 'package:word_book/main.dart';
import 'package:word_book/model/WordTestModel.dart';
import 'package:word_book/services/database_service.dart';

import '../model/WordModel.dart';
import '../services/word_service.dart';
import 'components/common/appbar.dart';
import 'components/common/drawer.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainViewPageState();
  }
}

class _MainViewPageState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    // WordModel model = WordModel(
    //   0,
    //   "this.word",
    //   "this.meaning",
    //   "this.pronunciation",
    //   List<WordTestModel>.filled(3, WordTestModel(0, "OK", DateTime.now())),
    //   DateTime.now(),
    //   DateTime.now(),
    //   DateTime.now(),
    // );
    // print(model.toMap());

    // WordService service = WordService();
    // service.insertModel(WordModel(
    //   0,
    //   "AA",
    //   "meaning",
    //   "pronunciation",
    //   List<WordTestModel>.empty(),
    //   DateTime.now(),
    //   DateTime.now(),
    //   DateTime.now(),
    // ));
    // WordService service = WordService();

    return Scaffold(
      drawer: const ApplicationDrawer(),
      appBar: CommonAppBar.build(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double cellSize = screenSize.width;
    final int crossAxisCount = screenSize.width ~/ cellSize;
    final double bodyHeight = screenSize.height - 50;
    final double childAspectRatio = cellSize / (bodyHeight);

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxHeight > 300) {
        return GridView.count(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(0),
                border: Border.all(
                  width: 1,
                  color: CommonColors.primaryBackgroundColor,
                ),
                color: CommonColors.primaryBackgroundColor,
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12),
                          color: CommonColors.secondaryBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(0x26, 0, 0, 0),
                              offset: Offset.fromDirection(0.785398, 5),
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 48,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(12),
                                child: const Text(
                                  "오늘의 단어",
                                  style: TextStyle(
                                    color: CommonColors.primaryForegroundColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 3,
                              decoration: const BoxDecoration(
                                color: CommonColors.primaryForegroundColor,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  "彼女\n그녀",
                                  style: TextStyle(
                                    color: CommonColors.primaryForegroundColor,
                                    fontSize: 40,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 100, maxHeight: 200),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(0x00, 0x00, 0xFF, 0x00),
                                  width: 2,
                                ),
                              ),
                              child: TextButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    const Color.fromARGB(0xFF, 0xBC, 0xD0, 0xFF),
                                  ),
                                ),
                                onPressed: () {
                                  print("Button Pressed #1");
                                },
                                child: const Text("Button #1"),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(0x00, 0x00, 0xFF, 0x00),
                                  width: 2,
                                ),
                              ),
                              child: TextButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    const Color.fromARGB(0xFF, 0xD0, 0xBC, 0xFF),
                                  ),
                                ),
                                onPressed: () {
                                  print("Button Pressed #2");
                                },
                                child: const Text("Button #2"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      } else {
        return GridView.count(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(0),
                border: Border.all(
                  width: 1,
                  color: const Color.fromARGB(0xFF, 0x1C, 0x1B, 0x1F),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(0xFF, 0xFF, 0, 0),
                                  width: 3,
                                ),
                              ),
                              child: const Text("Button Area"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }
    });
  }
}
