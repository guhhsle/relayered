import 'package:flutter/material.dart';
import 'custom_card.dart';
import 'layer.dart';
import '../../template/prefs.dart';

class SheetModel extends StatelessWidget {
  final Layer template;

  const SheetModel({
    super.key,
    required this.template,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Static bottom sheet',
      child: Card(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
        margin: const EdgeInsets.all(8),
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
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Row(
                      children: [
                        ...ly.leading ?? [],
                        Expanded(child: CustomCard(ly.action)),
                        ...ly.trailing ?? [],
                      ],
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ly.list.length,
                      shrinkWrap: true,
                      itemBuilder: (c, i) => ly.list.elementAt(i).toWidget,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
