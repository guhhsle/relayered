// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../data.dart';
import '../functions/mail.dart';
import '../functions/task.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import '../template/prefs.dart';

String mail = '', password = '';
Future<Layer> accountSet(dynamic d) async {
  if (user.isAnonymous || user.email == null) {
    return Layer(
      action: Setting(
        'Continue',
        Icons.keyboard_return_rounded,
        '',
        (c) => FirebaseService().signIn(
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
  } else {
    return Layer(
      action: Setting(
        user.email ?? 'ERROR',
        Icons.mail_outline_rounded,
        '',
        (c) async => user.verifyBeforeUpdateEmail(await getInput(user.email)),
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
          '${pf['syncTimeout']}',
          (c) => setPref('syncTimeout', (pf['syncTimeout'] + 2) % 20),
        ),
        Setting(
          'Change password',
          Icons.password_rounded,
          '',
          (c) => FirebaseService().resetPassword(user.email!, c),
        ),
        Setting(
          'Log out',
          Icons.person_remove_rounded,
          '',
          (c) async {
            await FirebaseAuth.instance.signInAnonymously();
            user = FirebaseAuth.instance.currentUser!;
            noteStream = listenNotes();
            await FirebaseFirestore.instance.disableNetwork();
            Navigator.of(c).pop();
          },
        ),
      ],
    );
  }
}

Future<void> getKey(String init) async {
  String next = await getInput(init);
  next = next.padRight(16, '0').substring(0, 16);
  setPref('encryptKey', next);
}
