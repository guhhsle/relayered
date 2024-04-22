// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../data.dart';
import '../pages/homepage.dart';
import 'task.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signIn(
    String email,
    String password,
    BuildContext context,
    bool existing,
  ) async {
    await FirebaseFirestore.instance.enableNetwork();
    try {
      if (existing) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await user.sendEmailVerification();
      }
    } catch (e) {
      crashDialog(context, '$e');
    }
    user = FirebaseAuth.instance.currentUser!;
    noteStream = listenNotes();

    Navigator.of(context).push(MaterialPageRoute(builder: (c) => const HomePage()));
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
