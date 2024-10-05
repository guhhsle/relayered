import 'package:relayered/classes/folder.dart';
import 'package:relayered/sheets/choose_folder.dart';

import '../classes/task.dart';

class MoveTask extends FolderBrowser {
  String? taskID;
  Task get task => Task.fromID(taskID);
  MoveTask(this.taskID);

  @override
  void onSelected(Folder chosen) {
    final json = task.toJson;
    task.delete();
    Task.fromJson(json, chosen).upload();
  }
}
