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
      if (relationDegrees[degree + 1].last.isEmpty) {
        for (int i = 0; i < structure[node.id]!.name.length; i++) {
          relationDegrees[degree + 1].add([]);
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
  for (int i = relationDegrees.length - 1; i >= 0; i--) {
    if (relationDegrees[i].isNotEmpty) break;
    relationDegrees.removeAt(i);
  }
}

class RelationState extends State<Relation> {
  String selectedRoot = '';

  Color mixColors(Color color1, Color color2, double ratio) {
    ratio = ratio.clamp(0.0, 1.0); // Ensure that the ratio is between 0.0 and 1.0

    int mixedRed = ((1 - ratio) * color1.red + ratio * color2.red).round();
    int mixedGreen = ((1 - ratio) * color1.green + ratio * color2.green).round();
    int mixedBlue = ((1 - ratio) * color1.blue + ratio * color2.blue).round();
    int mixedAlpha = ((1 - ratio) * color1.alpha + ratio * color2.alpha).round();

    return Color.fromARGB(mixedAlpha, mixedRed, mixedGreen, mixedBlue);
  }

  List<Folder> pinned = [];

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    Color background = Theme.of(context).colorScheme.background;
    return StreamBuilder(
      stream: streamNote.snapshots(),
      builder: (context, snap) {
        try {
          if (selectedRoot == '') selectedRoot = structure.keys.first;
          initRelation(selectedRoot);
          pinned = structure.values.where((e) => e.pin).toList();
        } catch (e) {
          //STRUCTURE NOT INITIALIZED
        }
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: SingleChildScrollView(
            physics: scrollPhysics,
            child: SingleChildScrollView(
              physics: scrollPhysics,
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 55,
                    child: Card(
                      shadowColor: Colors.transparent,
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      shape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(left: 4),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      children: [
                        for (var degree in relationDegrees)
                          SizedBox(
                            height: 55,
                            child: Row(
                              children: [
                                for (var field in degree)
                                  Card(
                                    shadowColor: Colors.transparent,
                                    color: Theme.of(context).primaryColor.withOpacity(field.isEmpty ? 0 : 0.15),
                                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: field.isEmpty ? 5 : 2),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide.none,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: field.isEmpty ? 0 : 4),
                                      child: Row(
                                        children: [
                                          for (Folder folder in field.map((e) => structure[e.id]!))
                                            InkWell(
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
                                                      : mixColors(background, taskColors[folder.color]!, 0.5),
                                                  label: Text(
                                                    folder.name,
                                                    style: TextStyle(
                                                      color: folder.pin && folder.color == null ? background : primary,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                  /*
                  ListView.builder(
                    itemCount: relationDegrees.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: SizedBox(
                          height: 50,
                          child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: relationDegrees[i].length,
                              itemBuilder: (context, j) {
                                List<Node> field = relationDegrees[i][j];
                                return SizedBox(
                                  height: 50,
                                  child: Card(
                                    shadowColor: Colors.transparent,
                                    color: Theme.of(context).primaryColor.withOpacity(field.isEmpty ? 0 : 0.15),
                                    margin: EdgeInsets.symmetric(vertical: 2.5, horizontal: field.isEmpty ? 4 : 2),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide.none,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListView.builder(
                                      itemCount: field.length,
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
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
                                                  : mixColors(background, taskColors[folder.color]!, 0.5),
                                              label: Text(
                                                folder.name,
                                                style: TextStyle(
                                                  color: folder.pin && folder.color == null ? background : primary,
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
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            			  */
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
