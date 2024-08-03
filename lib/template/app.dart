import 'package:flashy_flushbar/flashy_flushbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data.dart';
import 'data.dart';
import 'functions.dart';
import 'theme.dart';

class App extends StatelessWidget {
  final Widget child;
  final String title;
  const App({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, snap, chld) => FutureBuilder(
        future: loadLocale(),
        builder: (context, data) => MaterialApp(
          locale: Locale(pf['locale']),
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: title,
          theme: theme(
            color(true, lightTheme: true),
            color(false, lightTheme: true),
          ),
          darkTheme: theme(
            color(true, lightTheme: false),
            color(false, lightTheme: false),
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
                return child;
              },
            ),
          ),
        ),
      ),
    );
  }
}
