import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:word_book/View/components/common/colors.dart';
import 'package:word_book/main.dart';
import 'package:word_book/model/WordTestModel.dart';
import 'package:word_book/services/database_service.dart';

import '../model/WordModel.dart';
import '../services/word_service.dart';
import 'card_manage.dart';
import 'components/common/appbar.dart';
import 'components/common/drawer.dart';
import 'components/flip_number.dart';
import 'flashcard.dart';

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
                              color: Colors.black45.withOpacity(0.55),
                              spreadRadius: 5,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("등록된 단어 : "),
                              const Text("학습중인 단어 : "),
                              const Text("미학습 단어 : "),
                              const Text("장기 기억 단어 : "),
                              FlipNumber(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 100, maxHeight: 150),
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
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: const Color.fromARGB(0xFF, 0xBC, 0xDC, 0xFF),
                                  shadowColor: Colors.black45.withOpacity(0.55),
                                  elevation: 20,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FlashcardView()));
                                },
                                child: const Text(
                                  "Flash Card",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: CommonColors.primaryBackgroundColor,
                                  ),
                                ),
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
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: const Color.fromARGB(0xFF, 0xD0, 0xBC, 0xFF),
                                  shadowColor: Colors.black45.withOpacity(0.55),
                                  elevation: 20,
                                ),
                                // style: ButtonStyle(
                                //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                //     RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(20),
                                //     ),
                                //   ),
                                //   backgroundColor: MaterialStateProperty.all<Color>(
                                //     const Color.fromARGB(0xFF, 0xD0, 0xBC, 0xFF),
                                //   ),
                                // ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => CardManageView()));
                                },
                                child: const Text(
                                  "Manage Words",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: CommonColors.primaryBackgroundColor,
                                  ),
                                ),
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
