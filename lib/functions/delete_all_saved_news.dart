import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

void deleteAllSavedNews() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentReference userDocRef = firestore.collection('users').doc(user.uid);

    await userDocRef.update({
      'saved': [],
    });

    Fluttertoast.showToast(
        msg: 'Kaydedilen tüm içerikler silindi.',
        toastLength: Toast.LENGTH_LONG,
        fontSize: 18);
  } else {
    Fluttertoast.showToast(
        msg: 'Bu işlem için oturum açmalısınız.',
        toastLength: Toast.LENGTH_LONG,
        fontSize: 18);
  }
}
