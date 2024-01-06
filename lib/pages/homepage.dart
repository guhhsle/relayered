import 'package:flutter/material.dart';

import '../data.dart';
import '../functions.dart';
import '../functions/layers.dart';
import '../functions/structure.dart';
import '../settings/calendar.dart';
import '../widgets/body.dart';
import '../widgets/calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: refreshLay,
      builder: (context, snap, child) {
        return Scaffold(
          floatingActionButton: pf['action'] == 'Floating'
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: FloatingActionButton(
                    child: const Icon(Icons.folder_rounded),
                    onPressed: () => showSheet(
                      func: pinnedFolders,
                      param: null,
                      scroll: true,
                    ),
                  ),
                )
              : null,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(formatDate(DateTime.now(), year: false)),
            actions: [
              pf['action'] == 'Top'
                  ? IconButton(
                      icon: const Icon(Icons.folder_rounded),
                      onPressed: () => showSheet(
                        func: pinnedFolders,
                        param: null,
                        scroll: true,
                      ),
                    )
                  : Container(),
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
      },
    );
  }
}
