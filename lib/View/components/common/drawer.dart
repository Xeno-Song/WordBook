import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              print("Drawer - Main Tap");
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.copy,
              color: Colors.white70,
            ),
            title: const Text('Flash Card'),
            textColor: Colors.white70,
            onTap: () {
              print("Drawer - Flash Card Tap");
            },
          ),
        ],
      ),
    );
  }
}
