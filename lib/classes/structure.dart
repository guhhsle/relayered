import 'folder.dart';
import 'task.dart';

class Structure {
  static final Structure instance = Structure.internal();
  factory Structure() => instance;
  Structure.internal();

  List<Folder> folders = [];

  Folder? findFolder(String? id) {
    for (final folder in folders) {
      if (folder.id == id) return folder;
    }
    return null;
  }

  Task? findTask(String? id) {
    for (final folder in folders) {
      for (final task in folder.items) {
        if (task.id == id) return task;
      }
    }
    return null;
  }

  List<Folder> get shownFolders {
    return folders.where((f) => f.show).toList();
  }

  List<Folder> get pinnedFolders {
    return folders.where((f) => f.pin).toList();
  }

  void clearNullNodes() {
    for (Folder folder in folders) {
      for (int i = 0; i < folder.nodes.length; i++) {
        String node = folder.nodes[i];
        Folder? connection = findFolder(node);
        if (connection == null) {
          folder.nodes.removeAt(i);
          i--;
        } else if (!connection.nodes.contains(folder.id) && folder.id != null) {
          connection.nodes.add(folder.id!);
        }
      }
      folder.nodes.sort((a, b) {
        return findFolder(a)!.name.compareTo(findFolder(b)!.name);
      });
    }
  }

  void sort() => folders.sort((a, b) => a.name.compareTo(b.name));
}
