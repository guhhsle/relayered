import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../template/functions.dart';
import '../sheets/open_task.dart';
import '../widgets/frame.dart';
import '../classes/task.dart';

class TaskPage extends StatefulWidget {
  final Task task;

  const TaskPage({
    super.key,
    required this.task,
  });
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
      document: Document.fromJson(json.decode(task.desc)),
      selection: const TextSelection.collapsed(offset: 0),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool keyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return PopScope(
      onPopInvokedWithResult: (b, d) => updateNote(),
      child: Frame(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: TaskLayer(task.id).show,
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
            hintText: t('Title'),
          ),
          onChanged: (str) => task.name = str,
        ),
        child: Column(
          children: [
            Expanded(
              child: NoteTemplate(controller: controller),
            ),
            if (keyboard)
              QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                  controller: controller,
                  sectionDividerColor: Theme.of(context).colorScheme.surface,
                  color: Colors.transparent,
                  multiRowsDisplay: false,
                  showFontFamily: false,
                  showBoldButton: false,
                  toolbarSize: 38,
                  sectionDividerSpace: 0,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void updateNote() {
    task.desc = jsonEncode(controller.document.toDelta().toJson());
    task.update();
  }
}

class NoteTemplate extends StatelessWidget {
  final QuillController controller;
  const NoteTemplate({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return QuillEditor(
      scrollController: ScrollController(),
      focusNode: FocusNode(),
      configurations: QuillEditorConfigurations(
        controller: controller,
        autoFocus: false,
        scrollPhysics: const BouncingScrollPhysics(),
        scrollable: true,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        expands: true,
        onImagePaste: (imageBytes) async => imageBytes.toString(),
      ),
    );
  }
}
