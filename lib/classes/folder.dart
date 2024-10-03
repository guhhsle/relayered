import 'package:flutter/material.dart';
import 'package:relayered/template/data.dart';
import 'database.dart';
import 'encrypt.dart';
import 'task.dart';
import '../sheets/folder_options.dart';
import '../sheets/open_folder.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../data.dart';

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
    return Folder(name: name, items: [], nodes: node != null ? [node] : []);
  }

  Future<void> upload() async {
    await Database.folders.add(toJson);
    Database.notify();
  }

  Tile get toTile {
    return Tile.complex(
      name,
      Icons.folder_outlined,
      '',
      () => open(context: navigatorKey.currentContext!),
      secondary: () {},
      onHold: () => options(),
      iconColor: taskColors[color],
    );
  }

  void options() => showSheet(folderOptions, {'id': id});

  void open({BuildContext? context}) {
    if (Pref.stackLayers.value && context != null) {
      Navigator.of(context).pop();
    }
    showScrollSheet(openFolder, {'id': id});
  }

  Future update() async {
    if (id != null) {
      await Database.folders.doc(id).update(toJson);
      Database.notify();
    } else {
      await upload();
    }
  }

  Future delete() async {
    await Database.folders.doc(id).delete();
    Database.notify();
  }
}
