// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relayered/functions.dart';

import '../data.dart';
import '../pages/homepage.dart';
import 'task.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithMail(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      try {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } catch (e) {
        try {
          await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          await user.sendEmailVerification();
        } on FirebaseAuthException catch (e) {
          crashDialog(context, e.code);
        }
      }
      user = FirebaseAuth.instance.currentUser!;

      await FirebaseFirestore.instance.enableNetwork();
      sync();
      noteStream = listenNotes(user);

      Navigator.of(context).push(MaterialPageRoute(builder: (c) => const HomePage()));
    } on FirebaseAuthException catch (e) {
      crashDialog(context, e.code);
    }
  }

  Future resetPassword(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      crashDialog(context, 'Request for password reset sent, check your email');
    } on FirebaseAuthException catch (e) {
      crashDialog(context, e.code);
    }
  }
}

void crashDialog(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              fontFamily: pf['font'],
              color: Theme.of(context).colorScheme.background,
              fontWeight: FontWeight.bold,
            ),
            child: Text(text),
          ),
        ),
      );
    },
  );
}
