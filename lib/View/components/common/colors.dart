import 'dart:ui';

import 'package:flutter/material.dart';

class CommonColors {
  static Color primaryBackgroundColor = const Color.fromARGB(0xFF, 0x1C, 0x1B, 0x1F);
  static Color secondaryBackgroundColor = const Color.fromARGB(0xFF, 0x20, 0x20, 0x23);
  static Color coloredBackgroundColor = const Color.fromARGB(0xFF, 0x66, 0x37, 0x89);

  static Color primaryActiveColor = const Color.fromARGB(0xFF, 0x52, 0x37, 0x59);

  static Color primaryForegroundColor = const Color.fromARGB(0xFF, 0xF0, 0xEA, 0xF0);
  static Color secondaryForegroundColor = const Color.fromARGB(0xFF, 0xc5, 0xc1, 0xc5);

  static Color menuTextColor = Colors.white;
  static Color primaryThemeColor = Colors.deepPurple;
  static Color primaryThemeColorBrighter = const Color.fromARGB(0xFF, 0xA5, 0x88, 0xF8);

  static Color white80 = const Color.fromRGBO(0xFF, 0xFF, 0xFF, 0.8);
  static Color white90 = const Color.fromRGBO(0xFF, 0xFF, 0xFF, 0.9);

  static Color colorCorrect = const Color.fromARGB(0xFF, 0x19, 0x51, 0x18);
  static Color colorWrong = const Color.fromARGB(0xFF, 0x5C, 0x1C, 0x1D);

  static bool isDark = false;

  static void setTheme(bool isDark) {
    CommonColors.isDark = isDark;

    if (isDark) {
      primaryBackgroundColor = const Color.fromARGB(0xFF, 0x1C, 0x1B, 0x1F);
      secondaryBackgroundColor = const Color.fromARGB(0xFF, 0x20, 0x20, 0x23);
      coloredBackgroundColor = const Color.fromARGB(0xFF, 0x4B, 0x29, 0x65);
      primaryActiveColor = const Color.fromARGB(0xFF, 0x52, 0x37, 0x59);
      primaryForegroundColor = const Color.fromARGB(0xFF, 0xF0, 0xEA, 0xF0);
      secondaryForegroundColor = const Color.fromARGB(0xFF, 0xc5, 0xc1, 0xc5);
      menuTextColor = Colors.white;
      primaryThemeColor = Colors.deepPurple;
      primaryThemeColorBrighter = const Color.fromARGB(0xFF, 0xA5, 0x88, 0xF8);
      white80 = const Color.fromRGBO(0xFF, 0xFF, 0xFF, 0.8);
      white90 = const Color.fromRGBO(0xFF, 0xFF, 0xFF, 0.9);
      colorCorrect = const Color.fromARGB(0xFF, 0x19, 0x51, 0x18);
      colorWrong = const Color.fromARGB(0xFF, 0x5C, 0x1C, 0x1D);
    } else {
      primaryBackgroundColor = const Color.fromARGB(0xFF, 0xFC, 0xFB, 0xFF);
      secondaryBackgroundColor = const Color.fromARGB(0xFF, 0xD6, 0xC8, 0xEE);
      coloredBackgroundColor = const Color.fromARGB(0xFF, 0xCA, 0xAF, 0xDF);
      primaryActiveColor = const Color.fromARGB(0xFF, 0x52, 0x37, 0x59);
      primaryForegroundColor = const Color.fromARGB(0xFF, 0x10, 0x1A, 0x10);
      secondaryForegroundColor = const Color.fromARGB(0xFF, 0x7F, 0x24, 0xEE);
      menuTextColor = const Color.fromARGB(0xFF, 0x10, 0x1A, 0x10);
      primaryThemeColor = Colors.deepPurple;
      primaryThemeColorBrighter = const Color.fromARGB(0xFF, 0xA5, 0x88, 0xF8);
      white80 = const Color.fromRGBO(0xFF, 0xFF, 0xFF, 0.8);
      white90 = const Color.fromRGBO(0xFF, 0xFF, 0xFF, 0.9);
      colorCorrect = const Color.fromARGB(0xFF, 0x97, 0xFF, 0x95);
      colorWrong = const Color.fromARGB(0xFF, 0xFF, 0x98, 0x9A);
    }
  }
}
