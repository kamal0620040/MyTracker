import 'package:flutter/cupertino.dart';
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
    cupertinoOverrideTheme: CupertinoThemeData(
      primaryColor: Color.fromRGBO(101, 146, 233, 1),
      primaryContrastingColor: Color.fromRGBO(202, 202, 202, 1),
      barBackgroundColor: mobileBackgroundColorDark,
    ),
    appBarTheme: AppBarTheme(backgroundColor: mobileBackgroundColorDark),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.white,
        primary: mobileBackgroundColorDark,
        side: BorderSide(color: Color.fromRGBO(87, 87, 87, 1), width: 1.0),
      ),
    ),
    colorScheme: const ColorScheme.dark(),
  );
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: mobileBackgroundColorLight,
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: mobileBackgroundColorLight,
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
      primaryColor: Color.fromRGBO(101, 146, 233, 1),
      primaryContrastingColor: Color.fromRGBO(202, 202, 202, 1),
      barBackgroundColor: mobileBackgroundColorLight,
    ),
    appBarTheme: AppBarTheme(backgroundColor: mobileBackgroundColorLight),
    colorScheme: const ColorScheme.light(),
  );
}
