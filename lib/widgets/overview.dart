import 'package:flutter/material.dart';
import 'package:relayered/data.dart';
import 'package:relayered/functions/folder_options.dart';
import 'package:relayered/functions/layers.dart';
import 'package:relayered/functions/open_folder.dart';
import 'package:relayered/widgets/custom_chip.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => OverviewState();
}

class OverviewState extends State<Overview> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamNote.snapshots(),
      builder: (context, snap) {
        return Card(
          margin: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 5,
          ),
          shadowColor: Colors.transparent,
          color: Theme.of(context).primaryColor.withOpacity(0.08),
          shape: const RoundedRectangleBorder(borderRadius: customRadius),
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Wrap(
              alignment: WrapAlignment.end,
              children: [
                for (var folder in structure.values)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: CustomChip(
                      onSelected: (sel) => showSheet(
                        func: openFolder,
                        param: folder.id,
                        scroll: true,
                      ),
                      onHold: () => showSheet(
                        func: folderOptions,
                        param: folder.id,
                      ),
                      selected: folder.pin,
                      label: folder.name,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
