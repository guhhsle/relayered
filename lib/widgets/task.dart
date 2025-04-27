import 'package:flutter/material.dart';
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
  late TextEditingController textController;
  @override
  void initState() {
    textController = TextEditingController(text: widget.task.desc);
    super.initState();
  }

  @override
  void dispose() {
    widget.task.desc = textController.text;
    widget.task.update();
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
            builder: (c, controller) => Card(
              elevation: 6,
              margin: const EdgeInsets.all(8),
              color: Theme.of(c).colorScheme.surface.withValues(alpha: 0.8),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TileCard(Tile(
                            widget.task.name,
                            Icons.menu_rounded,
                            '',
                            TaskLayer(widget.task.id).show,
                          )),
                        ),
                        IconButton(
                          icon: Icon(widget.task.checkedIcon),
                          onPressed: () => setState(() {
                            widget.task.unCheck();
                          }),
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
                        cursorColor: Theme.of(context).colorScheme.primary,
                        backgroundCursorColor:
                            Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
