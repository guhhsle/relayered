import 'package:flutter/material.dart';
import 'package:relayered/classes/structure.dart';
import '../layers/folder_options.dart';
import '../template/tile_chip.dart';
import '../classes/database.dart';
import '../layers/folder.dart';
import '../template/data.dart';
import '../template/tile.dart';
import '../data.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => OverviewState();
}

class OverviewState extends State<Overview> {
  @override
  Widget build(BuildContext context) {
    Color background = Theme.of(context).colorScheme.surface;
    return StreamBuilder(
      stream: Database.stream,
      builder: (context, snap) {
        final shownFolders = Structure().shownFolders;
        return SizedBox(
          height: 64,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            physics: scrollPhysics,
            scrollDirection: Axis.horizontal,
            itemCount: shownFolders.length,
            itemBuilder: (context, i) {
              final folder = shownFolders[i];
              return TileChip(
                selected: folder.pin && folder.color == null,
                showAvatar: false,
                tile: Tile.complex(
                  folder.name,
                  Icons.folder_rounded,
                  '',
                  () => FolderLayer(folder.id).show(),
                  onHold: () => FolderOptions(folder.id).show(),
                ),
                background: folder.color == null
                    ? null
                    : mixColors(background, taskColors[folder.color]!, 0.5),
              );
            },
          ),
        );
      },
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
