import 'package:flutter/material.dart';
import 'package:relayered/widgets/body.dart';

import '../functions/layers.dart';
import '../settings/account.dart';
import '../settings/interface.dart';
import '../settings/storage.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({Key? key}) : super(key: key);

  @override
  PageSettingsState createState() => PageSettingsState();
}

class PageSettingsState extends State<PageSettings> {
  Map<String, Layer> map = {
    'Interface': interface(),
    'Account': account(),
    'Storage': storage(),
    'Primary': themeMap(true),
    'Background': themeMap(false),
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
            leading: Icon(
              map.values.elementAt(index).action.icon,
            ),
            onTap: () => showSheet(
              func: (i) => map.values.elementAt(index),
              param: 0,
              scroll: index > 2,
            ),
          ),
        ),
      ),
    );
  }
}
