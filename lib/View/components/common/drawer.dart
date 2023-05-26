import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_book/View/card_manage.dart';
import 'package:word_book/View/components/common/colors.dart';
import 'package:word_book/View/flashcard.dart';

class ApplicationDrawer extends StatelessWidget {
  const ApplicationDrawer({
    super.key,
    this.onPageChanged,
  });

  final Function? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: CommonColors.primaryBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            accountName: Text("Xeno.Song"),
            accountEmail: Text("H202046033@hycu.ac.kr"),
            currentAccountPicture: CircleAvatar(backgroundImage: AssetImage('assets/image/icon.jpg')),
          ),
          ListTile(
            leading: Icon(
              Icons.apps,
              color: CommonColors.menuTextColor,
            ),
            title: const Text('Main'),
            textColor: CommonColors.menuTextColor,
            style: ListTileStyle.drawer,
            onTap: () {
              _closeDrawer(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.copy,
              color: CommonColors.menuTextColor,
            ),
            title: const Text('Flash Card'),
            textColor: CommonColors.menuTextColor,
            onTap: () {
              _closeDrawer(context);
              onPageChanged?.call();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => FlashcardView()))
                  .then((value) => onPageChanged?.call());
            },
          ),
          ListTile(
            leading: Icon(
              Icons.copy,
              color: CommonColors.menuTextColor,
            ),
            title: const Text('Manage WordSet'),
            textColor: CommonColors.menuTextColor,
            onTap: () {
              _closeDrawer(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => CardManageView()))
                  .then((value) => onPageChanged?.call());
            },
          ),
        ],
      ),
    );
  }

  void _closeDrawer(BuildContext context) => Navigator.pop(context);
}
