import 'package:flutter/material.dart';

import '../data.dart';
import '../functions.dart';
import '../functions/layers.dart';
import 'custom_card.dart';

class SheetModel extends StatefulWidget {
  final Layer Function(dynamic) func;
  final dynamic param;
  const SheetModel({
    super.key,
    required this.func,
    required this.param,
  });

  @override
  State<SheetModel> createState() => _SheetModelState();
}

class _SheetModelState extends State<SheetModel> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: Theme.of(context).colorScheme.background.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ValueListenableBuilder(
            valueListenable: refreshLay,
            builder: (context, non, child) {
              Layer layer = widget.func(widget.param);
              List<Setting> list = layer.list;
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Row(
                    children: layer.leading +
                        [
                          Expanded(child: CustomCard(layer.action)),
                        ] +
                        layer.trailing,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        leading: list[i].secondary == null
                            ? Icon(
                                list[i].icon,
                                color: list[i].iconColor,
                              )
                            : null,
                        title: Text(t(list[i].title)),
                        trailing: list[i].secondary != null
                            ? IconButton(
                                icon: Icon(
                                  list[i].icon,
                                  color: list[i].iconColor,
                                ),
                                onPressed: () {
                                  list[i].secondary!(context);
                                  setState(() {});
                                },
                              )
                            : Text(t(list[i].trailing)),
                        onTap: () {
                          list[i].onTap(context);
                          setState(() {});
                        },
                        onLongPress: list[i].onHold == null
                            ? null
                            : () {
                                list[i].onHold!(context);
                                setState(() {});
                              },
                      );
                    },
                  ),
                ],
              );
            }),
      ),
    );
  }
}
