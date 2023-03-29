import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_book/View/card_manage.dart';

class ApplicationDrawer extends StatelessWidget {
  const ApplicationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(0xFF, 0x1C, 0x1B, 0x1F),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple,
            ),
            accountName: Text("Xeno.Song"),
            accountEmail: Text("H202046033@hycu.ac.kr"),
            currentAccountPicture: CircleAvatar(backgroundImage: AssetImage('assets/image/icon.jpg')),
          ),
          ListTile(
            leading: const Icon(
              Icons.apps,
              color: Colors.white70,
            ),
            title: const Text('Main'),
            textColor: Colors.white70,
            style: ListTileStyle.drawer,
            onTap: () {
              _closeDrawer(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.copy,
              color: Colors.white70,
            ),
            title: const Text('Flash Card'),
            textColor: Colors.white70,
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.copy,
              color: Colors.white70,
            ),
            title: const Text('Manage WordSet'),
            textColor: Colors.white70,
            onTap: () {
              _closeDrawer(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => CardManageView()));
            },
          ),
        ],
      ),
    );
  }

  void _closeDrawer(BuildContext context) => Navigator.pop(context);
}
