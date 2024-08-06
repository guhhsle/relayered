import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../classes/database.dart';
import '../data.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import '../template/prefs.dart';

String mail = '', password = '';
Stream<Layer> accountSet(dynamic d) async* {
  yield* Database.stream.map((_) {
    if (Database.logged) {
      return Layer(
        action: Setting(
          Database.user.email ?? 'ERROR',
          Icons.mail_outline_rounded,
          '',
          (c) async => Database.user.verifyBeforeUpdateEmail(
            await getInput(Database.user.email),
          ),
        ),
        list: [
          Setting(
            'Encryption key',
            Icons.key_rounded,
            '',
            (c) async {
              Navigator.of(c).pop();
              await getKey(pf['encryptKey']);
            },
          ),
          Setting(
            'Sync timeout',
            Icons.cloud_sync_rounded,
            pf['syncTimeout'],
            (c) => setPref('syncTimeout', (pf['syncTimeout'] + 2) % 20),
          ),
          Setting(
            'Change password',
            Icons.password_rounded,
            '',
            (c) => Database.resetPassword(Database.user.email!, c),
          ),
          Setting(
            'Log out',
            Icons.person_remove_rounded,
            '',
            (c) async {
              await FirebaseFirestore.instance.enableNetwork();
              await FirebaseAuth.instance.signInAnonymously();
              await FirebaseFirestore.instance.disableNetwork();
            },
          ),
        ],
      );
    } else {
      return Layer(
        action: Setting(
          'Continue',
          Icons.keyboard_return_rounded,
          '',
          (c) => Database.signIn(
            mail.trim(),
            password,
            c,
          ),
        ),
        list: [
          Setting(
            mail == '' ? 'Email' : mail,
            Icons.mail_outline_rounded,
            '',
            (c) async {
              mail = await getInput(mail, hintText: 'Email');
              refreshLayer();
            },
          ),
          Setting(
            password == '' ? 'Password' : password,
            Icons.password_rounded,
            '',
            (c) async {
              password = await getInput(password, hintText: 'Password');
              refreshLayer();
            },
          ),
          Setting(
            'Encryption key',
            Icons.key_rounded,
            '',
            (c) async {
              await getKey(pf['encryptKey']);
              refreshLayer();
            },
          ),
        ],
      );
    }
  });
}

Future<void> getKey(String init) async {
  String next = await getInput(init);
  next = next.padRight(16, '0').substring(0, 16);
  setPref('encryptKey', next);
}
