import 'package:flutter/material.dart';

import 'color_schemes.g.dart';

abstract class AppTheme {
  static get light => ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        scaffoldBackgroundColor: lightColorScheme.background,
        listTileTheme: _listTileThemeData(),
        iconButtonTheme: _iconButtonThemeData(),
      );

  static IconButtonThemeData _iconButtonThemeData() {
    return IconButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static get dark => ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        scaffoldBackgroundColor: darkColorScheme.background,
        listTileTheme: _listTileThemeData(),
        iconButtonTheme: _iconButtonThemeData(),
      );

  static ListTileThemeData _listTileThemeData() {
    return ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}
