import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:word_book/View/card_manage.dart';
import 'package:word_book/View/components/common/appbar.dart';
import 'package:word_book/View/main.dart';

import 'View/components/common/drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (Platform.isWindows) {
    WindowManager.instance.setMinimumSize(const Size(350, 600));
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final RouteObserver<PageRoute> _routeObserver = RouteObserver<PageRoute>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MainView(routeObserver: _routeObserver),
      navigatorObservers: [
        _routeObserver,
      ],
    );
  }
}
