import 'package:flutter/material.dart';
import '../classes/database.dart';
import '../functions/task.dart';
import '../sheets/all_tasks.dart';
import '../sheets/structure.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import '../template/prefs.dart';
import '../widgets/calendar.dart';
import '../widgets/frame.dart';
import '../data.dart';
import '../settings/calendar.dart';
import '../widgets/overview.dart';

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
                    child: const Icon(Icons.folder_rounded),
                    onPressed: () => showScrollSheet(pinnedFolders),
                  ),
                )
              : null,
          automaticallyImplyLeading: false,
          title: Text(formatDate(DateTime.now(), year: false)),
          actions: [
            IconButton(
              tooltip: t('Search'),
              icon: const Icon(Icons.fiber_manual_record_outlined),
              onPressed: () => showScrollSheet(allTasks),
            ),
            Pref.action.value == 'Top'
                ? IconButton(
                    icon: const Icon(Icons.folder_rounded),
                    onPressed: () => showScrollSheet(pinnedFolders),
                  )
                : Container(),
            web
                ? const IconButton(
                    onPressed: Database.sync,
                    icon: Icon(Icons.refresh_rounded),
                  )
                : Container(),
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => showSheet(calendar),
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
