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
Stream<Layer> accountSet(Map non) async* {
  yield accountLayer({});
  yield* Database.stream.map((e) => accountLayer({}));
}

Layer accountLayer(Map non) {
  if (Database.logged) {
    return Layer(
      action: Tile(
        Database.user.email ?? 'ERROR',
        Icons.mail_outline_rounded,
        '',
        onTap: (c) => getInput(Database.user.email, 'New email').then((i) {
          Database.user.verifyBeforeUpdateEmail(i);
        }),
      ),
      list: [
        Tile('Encryption key', Icons.key_rounded, '', onTap: (c) {
          Navigator.of(c).pop();
          getKey();
        }),
        Tile.fromPref(Pref.syncTimeout),
        Tile('Change password', Icons.password_rounded, '', onTap: (c) {
          Database.resetPassword(Database.user.email!);
        }),
        Tile('Log out', Icons.person_remove_rounded, '', onTap: (c) async {
          await FirebaseFirestore.instance.enableNetwork();
          await FirebaseAuth.instance.signInAnonymously();
          await FirebaseFirestore.instance.disableNetwork();
        }),
      ],
    );
  } else {
    return Layer(
      action: Tile('Continue', Icons.keyboard_return_rounded, '', onTap: (c) {
        Database.signIn(mail.trim(), password);
      }),
      list: [
        Tile(
          mail == '' ? 'Email' : mail,
          Icons.mail_outline_rounded,
          '',
          onTap: (c) async {
            mail = await getInput(mail, 'Email');
            Preferences.notify();
          },
        ),
        Tile(
          password == '' ? 'Password' : password,
          Icons.password_rounded,
          '',
          onTap: (c) async {
            password = await getInput(password, 'Password');
            Preferences.notify();
          },
        ),
        Tile('Encryption key', Icons.key_rounded, '', onTap: (c) {
          getKey();
        }),
      ],
    );
  }
}

Future<void> getKey() async {
  String next = await getPrefInput(Pref.encryptKey);
  next = next.padRight(16, '0').substring(0, 16);
  Pref.encryptKey.set(next);
}
