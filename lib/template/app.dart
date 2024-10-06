import 'package:flashy_flushbar/flashy_flushbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'functions.dart';
import 'theme.dart';
import 'data.dart';
import '../data.dart';

class App extends StatelessWidget {
  final Widget child;
  final String title;
  const App({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemePref(),
      builder: (context, chld) => MaterialApp(
        locale: Locale(Pref.locale.value),
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: title,
        scrollBehavior: NoScrollBehavior(),
        theme: ThemePref.data(
          ThemePref.color(true, light: true),
          ThemePref.color(false, light: true),
        ),
        darkTheme: ThemePref.data(
          ThemePref.color(true, light: false),
          ThemePref.color(false, light: false),
        ),
        builder: FlashyFlushbarProvider.init(),
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: ThemePref.color(false),
          ),
          child: Builder(
            builder: (context) {
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  systemNavigationBarColor: ThemePref.color(false),
                ),
              );
              return FutureBuilder(
                future: loadLocale(),
                builder: (c, d) => d.hasData ? child : Container(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class NoScrollBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child; // No scrollbar
  }
}
