import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'data.dart';
import 'functions.dart';

import 'package:encrypt/encrypt.dart' as e;

String encrypt(String raw) {
  try {
    final keyString = pf['encryptKey'];
    final key = e.Key.fromUtf8(keyString);
    final iv = e.IV.fromUtf8(keyString);
    final encrypter = e.Encrypter(e.AES(key));
    String result = encrypter.encrypt(raw, iv: iv).base64;
    return result;
  } catch (e) {
    return raw;
  }
}

String? decryptStr(String? crypt) {
  try {
    final keyString = pf['encryptKey'];
    final key = e.Key.fromUtf8(keyString);
    final iv = e.IV.fromUtf8(keyString);
    final encrypter = e.Encrypter(e.AES(key));
    return encrypter.decrypt(
      e.Encrypted.fromBase64(crypt!),
      iv: iv,
    );
  } catch (e) {
    return null;
  }
}

class Folder {
  String name;
  String? color;
  String? id;
  List<Task> items;

  Folder({
    required this.name,
    required this.items,
    this.color,
    this.id,
  });

  static Folder fromJson(Map json) {
    Folder folder = Folder(
      name: decryptStr(json['name']) ?? '/${json['name']}',
      id: json['id'] ?? '',
      color: json['col'],
      items: [],
    );
    for (Map m in json['items']) {
      folder.items.add(Task.fromJson(m, folder));
    }
    return folder;
  }

  Map<String, Object?> toJson() => {
        'name': encrypt(name),
        'id': id,
        'col': color,
        'items': items.map((e) => e.toJson()).toList(),
      };

  static Folder defaultNew({String name = '/'}) {
    return Folder(name: name, items: []);
  }

  Future<void> upload() async {
    await coll().add(toJson());
    refreshLayer();
  }

  Future update() async {
    if (id != null) {
      await coll().doc(id).update(toJson());
      refreshLayer();
    } else {
      await upload();
    }
  }

  Future delete() async {
    await coll().doc(id).delete();
    refreshLayer();
  }
}

class Task {
  String name, desc, color;
  String? id;
  DateTime? due;
  Folder path;
  bool done, pinned;

  Task({
    required this.name,
    required this.desc,
    required this.color,
    required this.path,
    this.due,
    this.id,
    this.done = false,
    this.pinned = false,
  });

  static Task defaultNew(Folder path, {String? name, String? desc}) {
    final quill.Delta delta = quill.Delta()..insert('${desc ?? ''}\n');
    return Task(
      name: name ?? 'NOVO',
      desc: jsonEncode(delta.toJson()),
      path: path,
      color: pf['defaultColor'],
      due: pf['taskNow'] ? DateTime.now() : null,
    );
  }

  static Task fromJson(Map json, Folder path) {
    return Task(
      id: json['id'] ?? '',
      name: decryptStr(json['name']) ?? json['name'] ?? '',
      pinned: json['pin'] ?? false,
      done: json['done'] ?? false,
      color: json['col'] ?? 'Adaptive',
      desc: decryptStr(json['desc']) ?? json['desc'] ?? '\n',
      due: json['due'] != null ? DateTime.parse(json['due']) : null,
      path: path,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'name': encrypt(name),
        'pin': pinned,
        'done': done,
        'col': color,
        'desc': encrypt(desc),
        'due': due?.toIso8601String(),
      };

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

  IconData checked() {
    if (done) return Icons.radio_button_checked;
    return Icons.radio_button_unchecked;
  }

  bool hasDue() => due != null;

  String shortDesc() {
    try {
      return quill.Document.fromJson(json.decode(desc)).toPlainText();
    } catch (e) {
      return 'ERROR';
    }
  }

  String date({bool year = false, bool month = false}) {
    if (due == null) return '     ';
    return formatDate(due!, year: year, month: month);
  }
}

CollectionReference<Map<String, dynamic>> coll() {
  return FirebaseFirestore.instance.collection('users').doc(user.uid).collection('folders');
}
