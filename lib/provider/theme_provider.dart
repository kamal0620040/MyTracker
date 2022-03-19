import 'package:flutter/material.dart';
import 'package:mytracker/utils/colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  bool get isDarkMode => themeMode == ThemeMode.dark;
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: mobileBackgroundColorDark,
    colorScheme: const ColorScheme.dark(),
  );
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: mobileBackgroundColorLight,
    colorScheme: const ColorScheme.light(),
  );
}
