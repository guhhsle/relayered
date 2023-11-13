import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../data.dart';
import '../functions/layers.dart';
import '../functions/open_task.dart';
import '../task.dart';
import '../widgets/body.dart';

class TaskPage extends StatefulWidget {
  final Task task;

  const TaskPage({
    Key? key,
    required this.task,
  }) : super(key: key);
  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  late Task task;
  late QuillController controller;

  @override
  void initState() {
    task = widget.task;
    controller = QuillController(
      document: Document.fromJson(
        json.decode(task.desc),
      ),
      selection: const TextSelection.collapsed(
        offset: 0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool k = MediaQuery.of(context).viewInsets.bottom != 0;
    Color p = Theme.of(context).colorScheme.primary;
    Color b = Theme.of(context).colorScheme.background;
    return WillPopScope(
      onWillPop: () {
        updateNote();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => showSheet(
              func: openTask,
              param: task.id,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () {
                  updateNote();
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.done_rounded),
              ),
            ),
          ],
          title: TextFormField(
            maxLines: 1,
            maxLength: 24,
            key: Key(task.name),
            initialValue: task.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).appBarTheme.foregroundColor,
              fontSize: 18,
            ),
            cursorColor: Theme.of(context).appBarTheme.foregroundColor,
            decoration: InputDecoration(
              counterText: "",
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: l['Title'],
            ),
            onChanged: (str) => task.name = str,
          ),
        ),
        body: Body(
          child: Column(
            children: [
              Expanded(
                child: NoteTemplate(
                  controller: controller,
                ),
              ),
              k
                  ? QuillProvider(
                      configurations: QuillConfigurations(controller: controller),
                      child: QuillToolbar(
                        configurations: QuillToolbarConfigurations(
                          color: b,
                          iconTheme: QuillIconTheme(
                            iconSelectedColor: b,
                            iconUnselectedColor: p,
                            iconSelectedFillColor: p,
                            iconUnselectedFillColor: b,
                            disabledIconColor: p,
                            disabledIconFillColor: p,
                          ),
                          multiRowsDisplay: false,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future updateNote() async {
    task.desc = jsonEncode(controller.document.toDelta().toJson());
    task.update();
  }
}

class NoteTemplate extends StatelessWidget {
  final QuillController controller;
  const NoteTemplate({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuillProvider(
      configurations: QuillConfigurations(controller: controller),
      child: QuillEditor(
        scrollController: ScrollController(),
        focusNode: FocusNode(),
        configurations: QuillEditorConfigurations(
          autoFocus: false,
          scrollPhysics: const BouncingScrollPhysics(),
          scrollable: true,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          expands: true,
          readOnly: false,
          onImagePaste: (imageBytes) async {
            return imageBytes.toString();
          },
        ),
      ),
    );
  }
}
