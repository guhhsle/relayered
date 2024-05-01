import 'package:flutter/material.dart';
import '../functions/task.dart';
import '../template/data.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import '../widgets/calendar.dart';
import '../widgets/relation.dart';
import '../data.dart';
import '../functions/structure.dart';
import '../settings/calendar.dart';
import '../widgets/body.dart';
import '../widgets/overview.dart';
import 'search.dart';

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
              IconButton(
                tooltip: t('Search'),
                icon: const Icon(Icons.fiber_manual_record_outlined),
                onPressed: () {
                  goToPage(const Search());
                  //showSearch(context: context, delegate: Delegate());
                },
              ),
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
          body: Body(
            child: PageView(
              controller: _pageController,
              physics: scrollPhysics,
              children: const [
                Overview(),
                Calendar(),
                Relation(),
              ],
            ),
          ),
        );
      },
    );
  }
}
