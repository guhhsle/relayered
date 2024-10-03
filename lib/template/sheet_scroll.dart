import 'package:flutter/material.dart';
import 'custom_card.dart';
import 'layer.dart';
import '../../template/prefs.dart';

class SheetScrollModel extends StatelessWidget {
  final Layer template;
  const SheetScrollModel({
    super.key,
    required this.template,
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
                    template: template,
                    builder: (context, snap) {
                      if (!snap.hasData) return Container();
                      Layer ly = snap.data!;
                      ly.dirtyContext = context;
                      return Column(
                        children: [
                          Row(
                            children: [
                              ...ly.leading ?? [],
                              Expanded(child: CustomCard(ly.action)),
                              ...ly.trailing ?? [],
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
                                itemBuilder: (c, i) =>
                                    ly.list.elementAt(i).toWidget,
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
