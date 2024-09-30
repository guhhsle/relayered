import 'package:flutter/material.dart';
import 'custom_card.dart';
import 'layer.dart';
import '../../template/prefs.dart';

class SheetScrollModel extends StatelessWidget {
  final Function(Map) func;
  final Map? param;
  const SheetScrollModel({
    super.key,
    required this.param,
    required this.func,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Scrollable bottom sheet',
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.transparent,
          child: DraggableScrollableSheet(
            initialChildSize: 0.6,
            maxChildSize: 0.8,
            minChildSize: 0.2,
            builder: (context, controller) => Card(
              margin: const EdgeInsets.all(8),
              color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListenableBuilder(
                  listenable: Preferences(),
                  builder: (context, child) => LayerBuilder(
                    func: func,
                    param: param,
                    builder: (c, snap) {
                      if (!snap.hasData) return Container();
                      Layer ly = snap.data!;
                      return Column(
                        children: [
                          Row(
                            children: [
                              if (ly.leading != null) ...ly.leading!(c),
                              Expanded(child: CustomCard(ly.action)),
                              if (ly.trailing != null) ...ly.trailing!(c),
                            ],
                          ),
                          Expanded(
                            child: Scrollbar(
                              controller: controller,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.only(bottom: 8),
                                controller: controller,
                                itemCount: ly.list.length,
                                itemBuilder: (c, i) => ly.list[i].toWidget(c),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
