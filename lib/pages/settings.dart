import 'package:flutter/material.dart';
import 'package:relayered/widgets/body.dart';
import '../settings/account.dart';
import '../settings/interface.dart';
import '../template/layer.dart';
import '../template/theme.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({super.key});

  @override
  PageSettingsState createState() => PageSettingsState();
}

class PageSettingsState extends State<PageSettings> {
  final Map<String, Future<Layer> Function(dynamic)> map = {
    'Interface': interface,
    'Account': account,
    'Primary': themeMap,
    'Background': themeMap,
  };
  final Map<String, IconData> iconMap = {
    'Interface': Icons.toggle_on,
    'Account': Icons.person_rounded,
    'Primary': Icons.colorize_rounded,
    'Background': Icons.colorize_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Body(
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 16, bottom: 32),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: map.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(map.keys.elementAt(index)),
            leading: Icon(iconMap.values.elementAt(index)),
            onTap: () => showSheet(
              func: map.values.elementAt(index),
              param: index == 2,
              scroll: index > 1,
            ),
          ),
        ),
      ),
    );
  }
}
