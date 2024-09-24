import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app/functions/rightToLeft_animation.dart';
import 'package:news_app/view/main_screen.dart';

class Auth {
  final firebaseAuth = FirebaseAuth.instance;
  final userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> signInWithEmailAndPassword(
      {required BuildContext context,
      required String email,
      required String password}) async {
    final UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    // ignore: use_build_context_synchronously
    final navigator = Navigator.of(context);

    try {
      if (userCredential.user != null) {
        navigator.pushReplacement(rightToLeftPageAnimation(const MainScreen()));
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required BuildContext context,
    required String name,
    required String username,
    required String email,
    required String password,
    required List<String> saved,
  }) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;
        await _createUser(
            uid: uid,
            name: name,
            username: username,
            email: email,
            password: password,
            saved: saved);
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> _createUser({
    required String name,
    required String username,
    required String email,
    required String password,
    required List<String> saved,
    required String uid,
  }) async {
    await userCollection.doc(uid).set({
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'saved': saved,
    });
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
