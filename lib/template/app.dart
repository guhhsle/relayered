import 'package:flashy_flushbar/flashy_flushbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'functions.dart';
import '../data.dart';
import 'theme.dart';
import 'data.dart';

class App extends StatelessWidget {
  final Widget child;
  final String title;
  const App({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, snap, chld) => MaterialApp(
        locale: Locale(pf['locale']),
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: title,
        theme: theme(
          color(true, light: true),
          color(false, light: true),
        ),
        darkTheme: theme(
          color(true, light: false),
          color(false, light: false),
        ),
        builder: FlashyFlushbarProvider.init(),
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: color(false),
          ),
          child: Builder(
            builder: (context) {
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  systemNavigationBarColor: color(false),
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
