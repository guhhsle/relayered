// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relayered/template/functions.dart';
import '../data.dart';
import '../pages/homepage.dart';
import 'task.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signIn(
    String email,
    String password,
    BuildContext context,
  ) async {
    await FirebaseFirestore.instance.enableNetwork();
    try {
      try {
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } catch (e) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } catch (e) {
      showSnack('$e', false);
    }
    user = FirebaseAuth.instance.currentUser!;
    noteStream = listenNotes();

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (c) => const HomePage()));
  }

  Future resetPassword(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showSnack('Request for password reset sent, check your email', false);
    } on FirebaseAuthException catch (e) {
      showSnack(e.code, false);
    }
  }
}
