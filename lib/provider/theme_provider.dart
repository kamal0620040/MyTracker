import 'package:flutter/material.dart';
import 'package:mytracker/utils/colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  bool get isDarkMode => themeMode == ThemeMode.dark;
}

class MyThemes {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: mobileBackgroundColorDark,
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: mobileBackgroundColorDark,

      // Not used form here
      // border: OutlineInputBorder(
      //   borderSide: BorderSide(color: Colors.pink, width: 1.0),
      // ),
    ),
    colorScheme: const ColorScheme.dark(),
  );
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: mobileBackgroundColorLight,
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: mobileBackgroundColorLight,
    ),
    colorScheme: const ColorScheme.light(),
  );
}
