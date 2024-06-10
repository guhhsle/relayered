import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../data.dart';
import 'data.dart';
import 'functions.dart';
import 'layer.dart';
import 'prefs.dart';

Color color(bool primary, {bool? lightTheme}) {
  var dispatcher = SchedulerBinding.instance.platformDispatcher;
  lightTheme ??= dispatcher.platformBrightness == Brightness.light;

  if (primary) {
    return colors[pf[lightTheme ? 'primary' : 'primaryDark']] ??
        Color(int.tryParse('0xFF${pf[lightTheme ? 'primary' : 'primaryDark']}') ?? 0xFF170a1c);
  } else {
    return colors[pf[lightTheme ? 'background' : 'backgroundDark']] ??
        Color(int.tryParse('0xFF${pf[lightTheme ? 'background' : 'backgroundDark']}') ?? 0xFFf6f7eb);
  }
}

Color lighterColor(Color p, Color q) {
  if (p.computeLuminance() > q.computeLuminance()) return p;
  return q;
}

Stream<Layer> themeMap(dynamic p) async* {
  p is bool;
  var dispatcher = SchedulerBinding.instance.platformDispatcher;
  bool light = dispatcher.platformBrightness == Brightness.light;
  Layer layer = Layer(
      action: Setting(
        light ? pf[p ? 'primary' : 'background'] : pf[p ? 'primaryDark' : 'backgroundDark'],
        p ? Icons.colorize_rounded : Icons.tonality_rounded,
        '',
        (c) => fetchColor(p, light),
      ),
      list: []);
  for (int i = 0; i < colors.length; i++) {
    String name = colors.keys.toList()[i];
    layer.list.add(
      Setting(
        name,
        iconsTheme[name]!,
        '',
        (c) => setPref(
          light ? (p ? 'primary' : 'background') : (p ? 'primaryDark' : 'backgroundDark'),
          name,
          refresh: true,
        ),
        iconColor: colors.values.elementAt(i),
      ),
    );
  }
  yield layer;
}

Future<void> fetchColor(bool p, bool light) async {
  try {
    String val = await getInput('', hintText: 'HEX value')
      ..replaceAll('#', '');
    int.parse('0xFF$val');
    setPref(
      light ? (p ? 'primary' : 'background') : (p ? 'primaryDark' : 'backgroundDark'),
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
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: {'Black': lighterColor(p, b), 'Transparent': p}[pf['appbar']] ?? b,
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
