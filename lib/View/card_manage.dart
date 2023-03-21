import 'package:flutter/material.dart';
import 'package:word_book/main.dart';

class CardManageView extends StatefulWidget {
  const CardManageView({super.key, required this.contentHeight});

  final double contentHeight;

  @override
  State<StatefulWidget> createState() {
    return _CardManageViewPageState();
  }
}

class _CardManageViewPageState extends State<CardManageView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(0xFF, 0x1C, 0x1B, 0x1F),
      height: double.infinity,
      width: double.infinity,
      child: const SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: CardManageItemBuilder(
          itemCount: 10,
        ),
      ),
    );
  }
}

class CardManageItemBuilder extends StatefulWidget {
  const CardManageItemBuilder({super.key, this.itemCount});
  final int? itemCount;

  @override
  State<StatefulWidget> createState() {
    return _CardManageItemBuilderState();
  }
}

class _CardManageItemBuilderState extends State<CardManageItemBuilder> {
  @override
  Widget build(BuildContext context) {
    var list = <Widget>[];
    for (int i = 0; i < widget.itemCount!; ++i) {
      list.add(
        Material(
          color: Colors.transparent,
          child: ListTile(
            onTap: () {},
            title: const Text("Word Set #1"),
            subtitle: const Text("256 words"),
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
