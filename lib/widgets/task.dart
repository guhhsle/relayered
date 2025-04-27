import 'package:flutter/material.dart';
import 'package:relayered/classes/database.dart';
import 'package:relayered/template/data.dart';
import '../template/functions.dart';
import '../template/tile_card.dart';
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
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Bottom sheet',
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.transparent,
          child: DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.2,
            builder: (c, controller) => ListenableBuilder(
                listenable: Database(),
                builder: (context, snapshot) {
                  return Card(
                    elevation: 6,
                    margin: const EdgeInsets.all(8),
                    color:
                        Theme.of(c).colorScheme.surface.withValues(alpha: 0.8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: ListView(
                        controller: controller,
                        physics: scrollPhysics,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TileCard(Tile(
                                  task.name,
                                  Icons.edit_rounded,
                                  '',
                                  () => getInput(task.name, 'Task name')
                                      .then((s) {
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
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: EditableText(
                              maxLines: null,
                              controller: textController,
                              focusNode: FocusNode(),
                              style: Theme.of(context).textTheme.bodyMedium!,
                              cursorColor:
                                  Theme.of(context).colorScheme.primary,
                              backgroundCursorColor:
                                  Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
