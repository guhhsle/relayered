import 'package:flutter/material.dart';
import 'package:relayered/data.dart';
import 'package:relayered/functions/folder_options.dart';
import 'package:relayered/functions/open_folder.dart';

import '../template/layer.dart';
import 'relation.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => OverviewState();
}

class OverviewState extends State<Overview> {
  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    Color background = Theme.of(context).colorScheme.surface;
    return StreamBuilder(
      stream: streamNote.snapshots(),
      builder: (context, snap) {
        return Card(
          margin: const EdgeInsets.all(8),
          shadowColor: Colors.transparent,
          color: Theme.of(context).primaryColor.withOpacity(0.08),
          shape: const RoundedRectangleBorder(borderRadius: customRadius),
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Wrap(
              alignment: WrapAlignment.end,
              children: [
                for (var folder in structure.values)
                  InkWell(
                    onLongPress: () => showSheet(
                      func: folderOptions,
                      param: folder.id,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, top: 4),
                      child: InputChip(
                        showCheckmark: false,
                        selected: folder.pin || folder.color != null,
                        onSelected: (sel) => showSheet(
                          func: openFolder,
                          param: folder.id,
                          scroll: true,
                        ),
                        selectedColor: folder.color == null
                            ? null
                            : mixColors(
                                background, taskColors[folder.color]!, 0.5),
                        label: Text(
                          folder.name,
                          style: TextStyle(
                            color: folder.pin && folder.color == null
                                ? background
                                : primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
