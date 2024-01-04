import 'package:flutter/material.dart';

import 'data.dart';
import 'functions.dart';

ThemeData theme(Color p, Color b) {
  return ThemeData(
    useMaterial3: false,
    colorScheme: ColorScheme(
      primary: p,
      secondary: p,
      background: b,
      brightness: Brightness.light,
      error: Colors.red,
      onBackground: p,
      onError: b,
      onPrimary: b,
      onSecondary: b,
      onSurface: p,
      surface: b,
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: MaterialStatePropertyAll(p.withOpacity(0.7)),
      radius: const Radius.circular(16),
      thumbVisibility: const MaterialStatePropertyAll(true),
      trackVisibility: const MaterialStatePropertyAll(false),
    ),
    primaryColor: p,
    fontFamily: pf['font'],
    scaffoldBackgroundColor: {'Black': Colors.black, 'Transparent': b}[pf['appbar']] ?? p,
    appBarTheme: AppBarTheme(
      backgroundColor: {'Black': Colors.black, 'Transparent': b}[pf['appbar']] ?? p,
      foregroundColor: {'Black': lighterColor(p, b), 'Transparent': p}[pf['appbar']] ?? b,
      shadowColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: {'Black': lighterColor(p, b), 'Transparent': p}[pf['appbar']] ?? b,
        fontFamily: 'JetBrainsMono',
        fontSize: 18,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: p),
    textTheme: TextTheme(
      titleMedium: TextStyle(fontWeight: FontWeight.w600, color: p),
      titleLarge: TextStyle(fontWeight: FontWeight.w600, color: p),
      titleSmall: TextStyle(fontWeight: FontWeight.w600, color: p),
      bodyMedium: TextStyle(fontWeight: FontWeight.w600, color: p),
      bodyLarge: TextStyle(fontWeight: FontWeight.w600, color: p),
      displayLarge: TextStyle(fontWeight: FontWeight.w600, color: p),
      displayMedium: TextStyle(fontWeight: FontWeight.w600, color: p),
      displaySmall: TextStyle(fontWeight: FontWeight.w600, color: p),
    ),
    inputDecorationTheme: InputDecorationTheme(
      suffixIconColor: p,
      counterStyle: TextStyle(color: p, fontWeight: FontWeight.w600),
      labelStyle: TextStyle(color: p, fontWeight: FontWeight.w600),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: p, width: 2)),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p, width: 2)),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      refreshBackgroundColor: b,
    ),
    dialogBackgroundColor: b,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: p,
      contentTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: 'JetBrainsMono',
        color: b,
      ),
    ),
    sliderTheme: const SliderThemeData(
      trackHeight: 3,
      thumbShape: RoundSliderThumbShape(
        enabledThumbRadius: 9,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: b,
      selectedColor: p,
      checkmarkColor: b,
      shadowColor: Colors.transparent,
      labelStyle: TextStyle(
        color: p,
        fontWeight: FontWeight.w600,
        fontFamily: pf['font'],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: p, width: 2),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStatePropertyAll(
          TextStyle(
            color: p,
            fontWeight: FontWeight.w600,
            fontFamily: pf['font'],
          ),
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
      textColor: p,
      iconColor: p,
      style: ListTileStyle.drawer,
    ),
    iconTheme: IconThemeData(color: p),
    cardTheme: CardTheme(
      elevation: 6,
      shadowColor: p,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      color: p,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: p, width: 2),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
