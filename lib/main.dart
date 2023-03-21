import 'package:flutter/material.dart';
import 'package:word_book/View/card_manage.dart';
import 'package:word_book/View/main.dart';

void main() {
  print("Test Hello World!");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page', appbarHeight: 50),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.appbarHeight});
  final double appbarHeight;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double bodyHeight = screenSize.height - widget.appbarHeight;

    return Scaffold(
      drawer: Drawer(
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
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(widget.appbarHeight),
        child: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
      ),
      body: CardManageView(contentHeight: bodyHeight),
      //floatingActionButton: FloatingActionButton(
      //  onPressed: _incrementCounter,
      //  tooltip: 'Increment',
      //  child: const Icon(Icons.add),
      //), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
