import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../classes/database.dart';
import '../data.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import '../template/prefs.dart';
import '../template/tile.dart';

String mail = '', password = '';
Stream<Layer> accountSet(Layer l) async* {
  yield accountLayer(l);
  yield* Database.stream.map((e) => accountLayer(l));
}

Layer accountLayer(Layer l) {
  if (Database.logged) {
    l.action = Tile(
      Database.user.email ?? 'ERROR',
      Icons.mail_outline_rounded,
      '',
      () => getInput(Database.user.email, 'New email').then((i) {
        Database.user.verifyBeforeUpdateEmail(i);
      }),
    );
    l.list = [
      Tile('Encryption key', Icons.key_rounded, '', () {
        Navigator.of(l.context).pop();
        getKey();
      }),
      Tile.fromPref(Pref.syncTimeout),
      Tile('Change password', Icons.password_rounded, '', () {
        Database.resetPassword(Database.user.email!);
      }),
      Tile('Log out', Icons.person_remove_rounded, '', () async {
        await FirebaseFirestore.instance.enableNetwork();
        await FirebaseAuth.instance.signInAnonymously();
        await FirebaseFirestore.instance.disableNetwork();
      }),
    ];
  } else {
    l.action = Tile('Continue', Icons.keyboard_return_rounded, '', () {
      Database.signIn(mail.trim(), password);
    });
    l.list = [
      Tile(
        mail == '' ? 'Email' : mail,
        Icons.mail_outline_rounded,
        '',
        () async {
          mail = await getInput(mail, 'Email');
          Preferences.notify();
        },
      ),
      Tile(
        password == '' ? 'Password' : password,
        Icons.password_rounded,
        '',
        () async {
          password = await getInput(password, 'Password');
          Preferences.notify();
        },
      ),
      Tile('Encryption key', Icons.key_rounded, '', () {
        getKey();
      }),
    ];
  }
  return l;
}

Future<void> getKey() async {
  String next = await getPrefInput(Pref.encryptKey);
  next = next.padRight(16, '0').substring(0, 16);
  Pref.encryptKey.set(next);
}
