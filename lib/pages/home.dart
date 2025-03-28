import 'package:flutter/material.dart';
import '../layers/settings/calendar.dart';
import '../template/functions.dart';
import '../classes/database.dart';
import '../layers/all_tasks.dart';
import '../widgets/overview.dart';
import '../widgets/calendar.dart';
import '../template/prefs.dart';
import '../widgets/frame.dart';
import '../functions.dart';

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
          automaticallyImplyLeading: false,
          title: Text(DateTime.now().prettify(false)),
          actions: [
            IconButton(
              tooltip: t('Search'),
              icon: const Icon(Icons.fiber_manual_record_outlined),
              onPressed: AllTasks().show,
            ),
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: CalendarSettings().show,
            ),
          ],
          child: const Column(
            children: [
              Overview(),
              Expanded(child: Calendar()),
            ],
          ),
        );
      },
    );
  }
}
