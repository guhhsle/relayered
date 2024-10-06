import 'package:flutter/material.dart';
import 'package:relayered/sheets/folder_options.dart';
import 'package:relayered/sheets/open_folder.dart';
import '../classes/database.dart';
import '../template/data.dart';
import '../data.dart';

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
      stream: Database.stream,
      builder: (context, snap) => SizedBox(
        height: 64,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          physics: scrollPhysics,
          scrollDirection: Axis.horizontal,
          itemCount: structure.length,
          itemBuilder: (context, i) {
            final folder = structure.values.elementAt(i);
            return InkWell(
              onLongPress: FolderOptions(folder.id).show,
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 4),
                child: InputChip(
                  showCheckmark: false,
                  selected: folder.pin || folder.color != null,
                  onSelected: (sel) => FolderLayer(folder.id).show(),
                  selectedColor: folder.color == null
                      ? null
                      : mixColors(background, taskColors[folder.color]!, 0.5),
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
            );
          },
        ),
      ),
    );
  }
}

Color mixColors(Color color1, Color color2, double ratio) {
  ratio = ratio.clamp(0.0, 1.0);
  int mixedRed = ((1 - ratio) * color1.red + ratio * color2.red).round();
  int mixedGreen = ((1 - ratio) * color1.green + ratio * color2.green).round();
  int mixedBlue = ((1 - ratio) * color1.blue + ratio * color2.blue).round();
  int mixedAlpha = ((1 - ratio) * color1.alpha + ratio * color2.alpha).round();

  return Color.fromARGB(mixedAlpha, mixedRed, mixedGreen, mixedBlue);
}
