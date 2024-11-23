import 'package:flutter/material.dart';
import 'encrypt.dart';
import 'folder.dart';
import '../template/functions.dart';
import '../template/tile.dart';
import '../pages/task.dart';
import '../functions.dart';
import '../data.dart';

class Task extends Crypt {
  String name, desc, color;
  String? id;
  List<DateTime> dues;
  Folder path;
  bool done, pinned;

  Task({
    required this.name,
    required this.desc,
    required this.color,
    required this.path,
    this.dues = const [],
    this.id,
    this.done = false,
    this.pinned = false,
  });

  static Task defaultNew(Folder path, {String? name}) {
    //final Delta delta = quill.Delta()..insert('${desc ?? ''}\n');
    return Task(
      name: name ?? 'NOVO',
      desc: r'[{"insert":"\n"}]',
      path: path,
      color: Pref.defaultColor.value,
      dues: [],
    );
  }

  static Task fromJson(Map json, Folder path) {
    return Task(
      id: json['id'] ?? '',
      name: Crypt.decrypt(json['name']) ?? json['name'] ?? '',
      pinned: json['pin'] ?? false,
      done: json['done'] ?? false,
      color: json['col'] ?? 'Adaptive',
      desc: Crypt.decrypt(json['desc']) ?? json['desc'] ?? '\n',
      dues: (json['dues'] as List? ?? []).map((e) {
        return DateTime.parse(e);
      }).toList(),
      path: path,
    );
  }

  static Task error() => defaultNew(Folder.defaultNew('/ERROR'), name: 'ERROR');

  Tile toTile(VoidCallback onTap, {String? title}) {
    title ??= '$name   ${date(false, true)}';
    return Tile.complex(
      title,
      checkedIcon,
      '',
      onTap,
      iconColor: taskColors[color],
      secondary: () {
        done = !done;
        update();
      },
      onHold: () => goToPage(TaskPage(task: this)),
    );
  }

  Map<String, Object?> get toJson {
    return {
      'id': id,
      'name': Crypt.encrypt(name),
      'pin': pinned,
      'done': done,
      'col': color,
      'desc': Crypt.encrypt(desc),
      'dues': dues.map((e) => e.toIso8601String()).toList(),
    };
  }

  Future<void> upload() async {
    id = '$hashCode';
    path.items.add(this);
    await path.update();
  }

  Future update() async => path.update();

  Future delete() async {
    path.items.remove(this);
    await path.update();
  }

  IconData get pinnedIcon {
    if (pinned) return Icons.push_pin_rounded;
    return Icons.push_pin_outlined;
  }

  IconData get checkedIcon => checked(done);

  bool get hasDue => dues.isNotEmpty;

  String date([bool showYear = false, bool showMonth = false]) {
    if (!hasDue) {
      return '  ${showYear ? '     ' : ''}${showMonth ? '   ' : ''}';
    } else if (dues.length == 1) {
      return dues[0].prettify(showYear, showMonth);
    } else {
      return '${dues[0].prettify(showYear, showMonth)}...';
    }
  }
}
