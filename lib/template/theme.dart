import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'functions.dart';
import 'layer.dart';
import 'prefs.dart';
import 'dart:math';
import 'data.dart';
import '../data.dart';

Color color(bool primary, {bool? light}) {
  var dispatcher = SchedulerBinding.instance.platformDispatcher;
  light ??= dispatcher.platformBrightness == Brightness.light;

  try {
    return colorFromHex(pf[pfString(primary, light)]);
  } catch (e) {
    if (primary) return Colors.black;
    return Colors.white;
  }
}

Color lighterColor(Color p, Color q) {
  if (p.computeLuminance() > q.computeLuminance()) return p;
  return q;
}

String pfString(bool primary, bool light) {
  return {
    (false, false): 'backgroundDark',
    (false, true): 'background',
    (true, false): 'primaryDark',
    (true, true): 'primary'
  }[(primary, light)]!;
}

Color colorFromHex(String hex) {
  return Color(int.parse('0xFF$hex'));
}

Stream<Layer> themeMap(dynamic primary) async* {
  primary is bool;
  var dispatcher = SchedulerBinding.instance.platformDispatcher;
  bool light = dispatcher.platformBrightness == Brightness.light;
  Layer layer = Layer(
    action: Setting(
      pf[pfString(primary, light)],
      primary ? Icons.colorize_rounded : Icons.tonality_rounded,
      '',
      (c) => fetchColor(primary, light),
    ),
    trailing: (c) => [
      IconButton(
        icon: const Icon(Icons.shuffle_rounded),
        onPressed: () => randomColor(primary, light),
      ),
      IconButton(
        icon: const Icon(Icons.add_rounded),
        onPressed: () => fetchColor(primary, light),
      ),
    ],
    list: colorMap.entries.map((color) {
      return Setting(
        color.key,
        color.value,
        '',
        (c) {
          setPref(
            pfString(primary, light),
            color.key,
            refresh: true,
          );
        },
        iconColor: colorFromHex(color.key),
      );
    }).toList(),
  );
  yield layer;
}

void randomColor(bool primary, bool light) {
  String result = '';
  for (int i = 0; i < 6; i++) {
    int random = Random().nextInt(16);
    if (random < 10) {
      result += '$random';
    } else {
      result += String.fromCharCode(random + 55);
    }
  }
  setPref(
    pfString(primary, light),
    result,
    refresh: true,
  );
}

Future<void> fetchColor(bool primary, bool light) async {
  try {
    String val = await getInput('', 'HEX value');
    val = val.replaceAll('#', '');
    int.parse('0xFF$val');
    setPref(
      pfString(primary, light),
      val,
      refresh: true,
    );
  } catch (e) {
    showSnack('$e', false);
  }
}

ThemeData theme(Color p, Color b) {
  return ThemeData(
    useMaterial3: false,
    colorScheme: ColorScheme(
      primary: p,
      secondary: p,
      brightness: Brightness.light,
      error: Colors.red,
      onError: b,
      onPrimary: b,
      onSecondary: b,
      onSurface: p,
      surface: b,
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(p.withOpacity(0.7)),
      radius: const Radius.circular(16),
      thumbVisibility: const WidgetStatePropertyAll(true),
      trackVisibility: const WidgetStatePropertyAll(false),
    ),
    primaryColor: p,
    fontFamily: pf['font'],
    scaffoldBackgroundColor:
        {'Black': Colors.black, 'Transparent': b}[pf['appbar']] ?? p,
    appBarTheme: AppBarTheme(
      backgroundColor:
          {'Black': Colors.black, 'Transparent': b}[pf['appbar']] ?? p,
      foregroundColor:
          {'Black': lighterColor(p, b), 'Transparent': p}[pf['appbar']] ?? b,
      shadowColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color:
            {'Black': lighterColor(p, b), 'Transparent': p}[pf['appbar']] ?? b,
        fontFamily: pf['font'],
        fontSize: 18,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor:
          {'Black': lighterColor(p, b), 'Transparent': p}[pf['appbar']] ?? b,
    ),
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
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: p, width: 2),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: p, width: 2),
      ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}
