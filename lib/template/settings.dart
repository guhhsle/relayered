import 'package:flutter/material.dart';
import '../data.dart';
import '../template/functions.dart';
import '../widgets/frame.dart';
import 'data.dart';

class PageSettings extends StatelessWidget {
  const PageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Frame(
      title: Text(t('Settings')),
      child: ListView.builder(
        physics: scrollPhysics,
        padding: EdgeInsets.only(top: 16),
        shrinkWrap: true,
        itemCount: settings.length,
        itemBuilder: (context, i) => settings[i].toTile(context),
      ),
    );
  }
}
