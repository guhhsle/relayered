import 'package:flutter/material.dart';
import 'package:relayered/template/functions.dart';
import '../classes/folder.dart';
import '../layers/folder_options.dart';
import '../template/tile_chip.dart';
import '../classes/structure.dart';
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
        final shownFolders = Structure().pinnedFolders;
        return SizedBox(
          height: 64,
          child: ListView(
            padding: const EdgeInsets.all(12),
            scrollDirection: Axis.horizontal,
            physics: scrollPhysics,
            children: [
              ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: shownFolders.length,
                itemBuilder: (context, i) {
                  final folder = shownFolders[i];
                  return TileChip(
                    selected: false,
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
              TileChip(
                selected: false,
                showAvatar: false,
                tile: Tile('+', Icons.folder_rounded, '', () async {
                  final name = await getInput('', 'New pinned folder');
                  final newFolder = Folder.defaultNew(name)..pin = true;
                  newFolder.upload();
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

Color mixColors(Color color1, Color color2, double ratio) {
  ratio = ratio.clamp(0.0, 1.0);
  int mixedRed = ((1 - ratio) * color1.r + ratio * color2.r).round();
  int mixedGreen = ((1 - ratio) * color1.g + ratio * color2.g).round();
  int mixedBlue = ((1 - ratio) * color1.b + ratio * color2.b).round();
  int mixedAlpha = ((1 - ratio) * color1.a + ratio * color2.a).round();

  return Color.fromARGB(mixedAlpha, mixedRed, mixedGreen, mixedBlue);
}
