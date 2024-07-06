import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  bool get isDarkMode => themeMode == ThemeMode.light;

  void toggleTheme(bool isOne) {
    themeMode = isOne ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class myTheme {
  static final darkTheme = ThemeData(
      scaffoldBackgroundColor: const Color(0xff3450A1),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xff3450A1)),
      primaryColor: const Color(0xffeaeaed),
      cardColor: const Color(0xff43025f),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFF00FF)));

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xffeaeaed),
    primaryColor: Colors.black,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xff43025f)),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xffeaeaed)),
  );
}
