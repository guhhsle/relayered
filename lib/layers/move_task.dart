import 'folder_browser.dart';
import '../classes/structure.dart';
import '../classes/folder.dart';
import '../classes/task.dart';

class MoveTask extends FolderBrowser {
  String? taskID;
  Task get task => Structure().findTask(taskID) ?? Task.error();
  MoveTask(this.taskID);

  @override
  void onSelected(Folder chosen) {
    final json = task.toJson;
    task.delete();
    Task.fromJson(json, chosen).upload();
  }
}
