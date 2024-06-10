import 'package:flashy_flushbar/flashy_flushbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data.dart';
import 'theme.dart';

class App extends StatelessWidget {
  final Widget child;
  final String title;
  const App({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, snap, chld) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: title,
          theme: theme(color(true, lightTheme: true), color(false, lightTheme: true)),
          darkTheme: theme(color(true, lightTheme: false), color(false, lightTheme: false)),
          builder: FlashyFlushbarProvider.init(),
          home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
            child: Builder(
              builder: (context) {
                SystemChrome.setSystemUIOverlayStyle(
                  const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                  ),
                );
                return child;
              },
            ),
          ),
        );
      },
    );
  }
}
