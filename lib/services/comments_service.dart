import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addComment(String commentID, String newsId, String? userName,
      String userId, String text) async {
    await _firestore.collection('comments').doc(commentID).set({
      'newsID': newsId,
      'userID': userId,
      'userName': userName,
      'comment': text,
      'commentDate': FieldValue.serverTimestamp(),
      'commentID': commentID
    });
  }

  Stream<QuerySnapshot> getCommentsForNews(String newsId) {
    return _firestore
        .collection('comments')
        .where('newsID', isEqualTo: newsId)
        .orderBy('commentDate', descending: true)
        .snapshots();
  }

  Future<String?> getUserName(String userId) async {
    DocumentSnapshot userSnapshot =
        await _firestore.collection('users').doc(userId).get();
    if (userSnapshot.exists) {
      return userSnapshot['username'];
    } else {
      return null;
    }
  }

  Future<void> deleteComment(String commentId) async {
    await _firestore.collection('comments').doc(commentId).delete();
  }
}
