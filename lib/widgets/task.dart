import 'package:flutter/material.dart';
import '../template/functions.dart';
import '../template/tile_card.dart';
import '../classes/database.dart';
import '../template/data.dart';
import '../template/tile.dart';
import '../classes/task.dart';
import '../layers/task.dart';

class TaskWidget extends StatefulWidget {
  final Task task;
  const TaskWidget({
    super.key,
    required this.task,
  });

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  late Task task;
  late TextEditingController textController;
  final focusNode = FocusNode();

  @override
  void initState() {
    task = widget.task;
    textController = TextEditingController(text: task.desc);
    super.initState();
  }

  @override
  void dispose() {
    task.desc = textController.text;
    task.update();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    double bottom = MediaQuery.of(c).viewInsets.vertical;
    if (bottom > 16) bottom -= 16;
    return Semantics(
      label: 'Bottom sheet',
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.2,
        builder: (c, controller) => ListenableBuilder(
          listenable: Database(),
          builder: (c, snapshot) => Card(
            elevation: 6,
            margin: const EdgeInsets.all(8),
            color: Theme.of(c).colorScheme.surface.withValues(alpha: 0.8),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TileCard(Tile(
                                task.name,
                                Icons.edit_rounded,
                                '',
                                () => getInput(task.name, 'Task').then((s) {
                                  (task..name = s).update();
                                }),
                              )),
                            ),
                            IconButton(
                              icon: Icon(task.checkedIcon),
                              onPressed: task.unCheck,
                            ),
                            IconButton(
                              icon: Icon(Icons.menu_rounded),
                              onPressed: TaskLayer(task.id).show,
                            ),
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: controller,
                            physics: scrollPhysics,
                            padding: EdgeInsets.only(bottom: 64),
                            child: TextFormField(
                              maxLines: null,
                              controller: textController,
                              focusNode: focusNode,
                              style: Theme.of(c).textTheme.bodyMedium!,
                              cursorColor: Theme.of(c).colorScheme.primary,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: bottom),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
