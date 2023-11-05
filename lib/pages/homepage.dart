import 'package:flutter/material.dart';

import '../body.dart';
import '../data.dart';
import '../functions.dart';
import '../functions/layers.dart';
import '../settings/calendar.dart';
import '../task.dart';
import '../widgets/calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8),
        child: InkWell(
          onLongPress: () async {
            Task.defaultNew(
              pf['defaultFolder'],
              name: await getInput(null, hintText: 'New task'),
            ).upload();
          },
          child: FloatingActionButton(
            child: const Icon(Icons.folder_rounded),
            onPressed: () => showSheet(
              func: openFolder,
              param: pf['defaultFolder'],
              scroll: true,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(formatDate(DateTime.now(), year: false)),
        actions: [
          web
              ? const IconButton(
                  onPressed: sync,
                  icon: Icon(Icons.refresh_rounded),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => showSheet(
                param: 0,
                func: (i) => calendar(),
              ),
            ),
          ),
        ],
      ),
      body: const Body(child: Calendar()),
    );
  }
}
