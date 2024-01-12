import 'package:flutter/material.dart';
import 'package:relayered/data.dart';
import 'package:relayered/functions/folder_options.dart';
import 'package:relayered/functions/layers.dart';
import 'package:relayered/functions/open_folder.dart';
import 'package:relayered/widgets/custom_chip.dart';

import '../task.dart';

class Relation extends StatefulWidget {
  const Relation({super.key});

  @override
  State<Relation> createState() => RelationState();
}

List<List<List<Node>>> relationDegrees = [];

bool containsID(Node node) {
  for (var degree in relationDegrees) {
    for (var field in degree) {
      for (var other in field) {
        if (other.id == node.id) return true;
      }
    }
  }
  return false;
}

class Node {
  String id;
  Node? parent;
  Node(this.id, {this.parent});
}

void fillDegree(int degree) {
  relationDegrees.add([]);
  if (degree > 10 || relationDegrees[degree].isEmpty) return;
  for (var field in relationDegrees[degree]) {
    for (var node in field) {
      relationDegrees[degree + 1].add([]);
      for (var childID in structure[node.id]!.nodes) {
        Node child = Node(childID, parent: node);
        if (!containsID(child)) {
          relationDegrees[degree + 1].last.add(child);
        }
      }
    }
  }
  fillDegree(degree + 1);
}

void initRelation(String root) {
  relationDegrees.clear();
  relationDegrees.add([
    [Node(root)]
  ]);
  fillDegree(0);
  relationDegrees.removeAt(0);
}

class RelationState extends State<Relation> {
  String selectedRoot = '';

  @override
  void initState() {
    selectedRoot = structure.keys.first;
    super.initState();
  }

  Color mixColors(Color color1, Color color2, double ratio) {
    ratio = ratio.clamp(0.0, 1.0); // Ensure that the ratio is between 0.0 and 1.0

    int mixedRed = ((1 - ratio) * color1.red + ratio * color2.red).round();
    int mixedGreen = ((1 - ratio) * color1.green + ratio * color2.green).round();
    int mixedBlue = ((1 - ratio) * color1.blue + ratio * color2.blue).round();
    int mixedAlpha = ((1 - ratio) * color1.alpha + ratio * color2.alpha).round();

    return Color.fromARGB(mixedAlpha, mixedRed, mixedGreen, mixedBlue);
  }

  @override
  Widget build(BuildContext context) {
    initRelation(selectedRoot);
    List<Folder> pinned = structure.values.where((e) => e.pin).toList();
    Color primary = Theme.of(context).primaryColor;
    Color background = Theme.of(context).colorScheme.background;
    return StreamBuilder(
      stream: streamNote.snapshots(),
      builder: (context, snap) {
        return Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: Card(
                shadowColor: Colors.transparent,
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  physics: scrollPhysics,
                  padding: const EdgeInsets.only(left: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: pinned.length,
                  itemBuilder: (context, index) {
                    Folder folder = pinned[index];
                    return CustomChip(
                      onSelected: (sel) {
                        selectedRoot = folder.id!;
                        setState(() {});
                      },
                      selected: folder.id == selectedRoot,
                      label: folder.name,
                    );
                  },
                ),
              ),
            ),
            ListView.builder(
              itemCount: relationDegrees.length,
              shrinkWrap: true,
              physics: scrollPhysics,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Wrap(
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      for (List<Node> field in relationDegrees[i])
                        SizedBox(
                          height: 50,
                          child: Card(
                            shadowColor: Colors.transparent,
                            color: Theme.of(context).primaryColor.withOpacity(field.isEmpty ? 0 : 0.15),
                            margin: EdgeInsets.all(field.isEmpty ? 0 : 3),
                            shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListView.builder(
                              itemCount: field.length,
                              shrinkWrap: true,
                              physics: scrollPhysics,
                              padding: EdgeInsets.only(left: field.isEmpty ? 0 : 4),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, k) {
                                Folder folder = structure[field[k].id]!;
                                return InkWell(
                                  onLongPress: () => showSheet(
                                    func: folderOptions,
                                    param: folder.id,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4),
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
                                          : mixColors(Theme.of(context).primaryColor, taskColors[folder.color]!, 0.5),
                                      label: Text(
                                        folder.name,
                                        style: TextStyle(
                                          color: folder.color == null && !folder.pin ? primary : background,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
