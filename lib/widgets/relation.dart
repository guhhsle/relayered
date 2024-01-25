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

final GlobalKey relationKey = GlobalKey();

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

String selectedRoot = '';
double scale = 1;

Color mixColors(Color color1, Color color2, double ratio) {
  ratio = ratio.clamp(0.0, 1.0);
  int mixedRed = ((1 - ratio) * color1.red + ratio * color2.red).round();
  int mixedGreen = ((1 - ratio) * color1.green + ratio * color2.green).round();
  int mixedBlue = ((1 - ratio) * color1.blue + ratio * color2.blue).round();
  int mixedAlpha = ((1 - ratio) * color1.alpha + ratio * color2.alpha).round();

  return Color.fromARGB(mixedAlpha, mixedRed, mixedGreen, mixedBlue);
}

class RelationState extends State<Relation> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamNote.snapshots(),
      builder: (context, snap) {
        return ZoomableRelation(param: snap);
      },
    );
  }
}

class ZoomableRelation extends StatefulWidget {
  final Object param;
  const ZoomableRelation({super.key, required this.param});

  @override
  State<ZoomableRelation> createState() => _ZoomableRelationState();
}

class _ZoomableRelationState extends State<ZoomableRelation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  List<Folder> pinned = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      value: scale,
      duration: const Duration(milliseconds: 128),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (selectedRoot == '') {
        selectedRoot = structure.entries.firstWhere((e) => e.value.pin).key;
      }
      initRelation(selectedRoot);
      pinned = structure.values.where((e) => e.pin).toList();
    } catch (e) {
      //STRUCTURE NOT INITIALIZED
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox = relationKey.currentContext!.findRenderObject() as RenderBox;
      final double childWidth = renderBox.size.width;
      double newScale = MediaQuery.of(context).size.width / childWidth;
      _scaleAnimation = Tween<double>(begin: scale, end: newScale).animate(_controller);
      _controller.forward(from: 0);
      scale = newScale;
    });
    Color primary = Theme.of(context).primaryColor;
    Color background = Theme.of(context).colorScheme.background;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(double.infinity),
            constrained: false,
            minScale: 1,
            child: Transform.scale(
              alignment: Alignment.topLeft,
              scale: _scaleAnimation.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / scale,
                    child: Card(
                      shadowColor: Colors.transparent,
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      shape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                        height: 45,
                        child: ListView.builder(
                          shrinkWrap: true,
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
                              onHold: () => showSheet(
                                func: openFolder,
                                param: folder.id,
                                scroll: true,
                              ),
                              selected: folder.id == selectedRoot,
                              label: folder.name,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    key: relationKey,
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
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
