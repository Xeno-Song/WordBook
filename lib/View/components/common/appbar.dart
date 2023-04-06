import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_book/View/components/common/colors.dart';

class CommonAppBar {
  static PreferredSize build([List<Widget>? actions]) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Word Book"),
        backgroundColor: CommonColors.primaryThemeColor,
        actions: actions,
      ),
    );
  }
}
