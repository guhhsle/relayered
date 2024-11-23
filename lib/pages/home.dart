import 'package:flutter/material.dart';
import '../layers/settings/calendar.dart';
import '../layers/folder_other.dart';
import '../template/functions.dart';
import '../classes/database.dart';
import '../layers/all_tasks.dart';
import '../widgets/overview.dart';
import '../widgets/calendar.dart';
import '../template/prefs.dart';
import '../widgets/frame.dart';
import '../functions.dart';
import '../data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 1);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([Database(), Preferences()]),
      builder: (context, child) {
        return Frame(
          floatingActionButton: Pref.action.value == 'Floating'
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: FloatingActionButton(
                    onPressed: PinnedLayer().show,
                    child: const Icon(Icons.folder_rounded),
                  ),
                )
              : null,
          automaticallyImplyLeading: false,
          title: Text(DateTime.now().prettify(false)),
          actions: [
            IconButton(
              tooltip: t('Search'),
              icon: const Icon(Icons.fiber_manual_record_outlined),
              onPressed: AllTasks().show,
            ),
            if (Pref.action.value == 'Top')
              IconButton(
                icon: const Icon(Icons.folder_rounded),
                onPressed: PinnedLayer().show,
              ),
            if (web)
              const IconButton(
                onPressed: Database.sync,
                icon: Icon(Icons.refresh_rounded),
              ),
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: CalendarSettings().show,
            ),
          ],
          child: Column(
            children: [
              Pref.showFolders.value ? const Overview() : Container(),
              const Expanded(child: Calendar()),
            ],
          ),
        );
      },
    );
  }
}
