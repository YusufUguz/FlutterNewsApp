import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future deleteSavedNews(String userId, String newsId) async {
  try {
    String? userUid = FirebaseAuth.instance.currentUser?.uid;

    if (userUid != null) {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userUid);

      DocumentSnapshot userSnapshot = await userDocRef.get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      List<String> savedNews = List<String>.from(userData['saved'] ?? []);

      if (savedNews.contains(newsId)) {
        savedNews.remove(newsId);

        await userDocRef.update({'saved': savedNews});

        Fluttertoast.showToast(
            msg: 'Kaydedilen İçerik silindi.',
            toastLength: Toast.LENGTH_LONG,
            fontSize: 18);
      } else {
        Fluttertoast.showToast(
            msg: 'Kaydedilen İçerik zaten silinmiş.',
            toastLength: Toast.LENGTH_LONG,
            fontSize: 18);
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Kaydedilen İçeriği silmek için giriş yapmalısınız.',
          toastLength: Toast.LENGTH_LONG,
          fontSize: 18);
    }
  } catch (e) {
    Fluttertoast.showToast(
        msg: 'Bir hata oluştu.', toastLength: Toast.LENGTH_LONG, fontSize: 18);
  }
}
