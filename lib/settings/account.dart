import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../classes/database.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../data.dart';

class AccountLayer extends Layer {
  static String mail = '';
  static String password = '';
  @override
  void construct() {
    listenTo(Database());
    if (Database.logged) {
      action = Tile(
        Database.user.email ?? 'ERROR',
        Icons.mail_outline_rounded,
        '',
        () => getInput(Database.user.email, 'New email').then((i) {
          Database.user.verifyBeforeUpdateEmail(i);
        }),
      );
      list = [
        Tile('Encryption key', Icons.key_rounded, '', () {
          Navigator.of(context).pop();
          getKey();
        }),
        Tile.fromPref(Pref.syncTimeout),
        Tile('Change password', Icons.password_rounded, '', () {
          Database.resetPassword(Database.user.email!);
        }),
        Tile('Log out', Icons.person_remove_rounded, '', () async {
          await FirebaseFirestore.instance.enableNetwork();
          await FirebaseAuth.instance.signInAnonymously();
          FirebaseFirestore.instance.disableNetwork();
        }),
      ];
    } else {
      action = Tile('Continue', Icons.keyboard_return_rounded, '', () {
        Database.signIn(mail.trim(), password);
      });
      list = [
        Tile(
          mail == '' ? 'Email' : mail,
          Icons.mail_outline_rounded,
          '',
          () async {
            mail = await getInput(mail, 'Email');
            notifyListeners();
          },
        ),
        Tile(
          password == '' ? 'Password' : password,
          Icons.password_rounded,
          '',
          () async {
            password = await getInput(password, 'Password');
            notifyListeners();
          },
        ),
        Tile('Encryption key', Icons.key_rounded, '', () {
          getKey();
        }),
      ];
    }
  }

  static Future<void> getKey() async {
    String next = await getPrefInput(Pref.encryptKey);
    next = next.padRight(16, '0').substring(0, 16);
    Pref.encryptKey.set(next);
  }
}
