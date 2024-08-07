import 'package:flutter/material.dart';
import '../sheets/folder_options.dart';
import '../sheets/open_folder.dart';
import '../template/layer.dart';
import '../data.dart';
import 'encrypt.dart';
import 'task.dart';
import 'database.dart';

class Folder extends Crypt {
  String name;
  String? color;
  String prefix;
  String? id;
  bool pin;
  List<String> nodes;
  List<Task> items;
  Folder({
    required this.name,
    required this.items,
    required this.nodes,
    this.color,
    this.id,
    this.prefix = '',
    this.pin = false,
  });

  static Folder fromJson(Map json) {
    Folder folder = Folder(
      name: Crypt.decrypt(json['name']) ?? '/${json['name']}',
      id: json['id'] ?? '',
      color: json['col'] == 'Adaptive' ? null : json['col'],
      items: [],
      prefix: json['pre'] ?? '',
      nodes: (json['nodes'] as List? ?? <String>[]).map((e) {
        return e.toString();
      }).toList(),
      pin: json['pin'] ?? false,
    );
    for (Map m in json['items']) {
      folder.items.add(Task.fromJson(m, folder));
    }
    return folder;
  }

  Map<String, Object?> get toJson {
    return {
      'name': Crypt.encrypt(name),
      'id': id,
      'col': color,
      'pin': pin,
      'nodes': nodes,
      'pre': prefix,
      'items': items.map((e) => e.toJson).toList(),
    };
  }

  static Folder defaultNew(String name, {String? node}) {
    return Folder(
        name: name, items: [], nodes: node != null ? [node] : <String>[]);
  }

  Future<void> upload() async {
    await Database.folders.add(toJson);
    refreshLayer();
  }

  Setting get toSetting {
    return Setting(
      name,
      Icons.folder_outlined,
      '',
      (p0) => open(context: p0),
      secondary: (c) {},
      onHold: (c) => options(),
      iconColor: taskColors[color],
    );
  }

  void options() {
    showSheet(
      func: folderOptions,
      param: id,
    );
  }

  void open({BuildContext? context}) {
    showSheet(
      func: openFolder,
      param: id,
      scroll: true,
      hidePrev: pf['stackLayers'] ? null : context,
    );
  }

  Future update() async {
    if (id != null) {
      await Database.folders.doc(id).update(toJson);
      refreshLayer();
    } else {
      await upload();
    }
  }

  Future delete() async {
    await Database.folders.doc(id).delete();
    refreshLayer();
  }
}
