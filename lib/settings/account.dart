import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../functions.dart';
import '../functions/layers.dart';
import '../functions/mail.dart';
import '../functions/task.dart';
import '../pages/mail.dart';
import 'interface.dart';

Layer account() {
  if (user.isAnonymous || user.email == null) {
    return Layer(
      action: Setting(
        'Sign in',
        Icons.mail_outline_rounded,
        '',
        (c) async {
          await Navigator.push(
            c,
            MaterialPageRoute(
              builder: (context) => const PageMail(),
            ),
          );
        },
      ),
      list: [],
    );
  } else {
    return Layer(
      action: Setting(
        user.email ?? 'ERROR',
        Icons.mail_outline_rounded,
        '',
        (c) async => user.updateEmail(await getInput(user.email)),
      ),
      list: [
        Setting(
          'Key',
          Icons.key_rounded,
          'pf//encryptKey',
          (c) async {
            Navigator.of(c).pop();
            await getKey(pf['encryptKey']);
          },
        ),
        Setting(
          user.displayName ?? 'User',
          Icons.person_rounded,
          'Change',
          (c) async => user.updateDisplayName(await getInput(user.displayName)),
        ),
        Setting(
          'Sync timeout',
          Icons.cloud_sync_rounded,
          'pf//syncTimeout',
          (c) => setPref('syncTimeout', (pf['syncTimeout'] + 2) % 20),
        ),
        Setting(
          'Change password',
          Icons.password_rounded,
          '',
          (c) => FirebaseService().resetPassword(user.email ?? ' ', c),
        ),
        Setting(
          'Log out',
          Icons.person_remove_rounded,
          '',
          (c) async {
            await FirebaseAuth.instance.signInAnonymously().then((result) {
              user = FirebaseAuth.instance.currentUser!;
              noteStream = listenNotes(user);
            });
          },
        ),
        Setting(
          'Delete account',
          Icons.person_off_rounded,
          '',
          (c) {},
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
