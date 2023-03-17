import 'package:flutter/material.dart';
import 'package:word_book/main.dart';

class MainView extends StatefulWidget {
  const MainView({super.key, required this.contentHeight});
  final double contentHeight;

  @override
  State<StatefulWidget> createState() {
    return _MainViewPageState();
  }
}

class _MainViewPageState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double cellSize = screenSize.width;
    final int crossAxisCount = screenSize.width ~/ cellSize;
    final myHomePage = context.findAncestorWidgetOfExactType<MyHomePage>();
    final double childAspectRatio = cellSize / (widget.contentHeight);

    return GridView.count(
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(0),
                  border: Border.all(width: 1, color: const Color.fromARGB(0xFF, 0x1C, 0x1B, 0x1F))),
              child: Column(
                children: [
                  Expanded(
                      flex: 2,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(0),
                              border: Border.all(width: 1, color: const Color.fromARGB(0xFF, 0xFF, 0, 0))),
                          child: const Center(
                            child: Text("Word Area"),
                          ))),
                  const Expanded(flex: 1, child: Text("Button Area"))
                ],
              ),
            ))
      ],
    );
  }
}
