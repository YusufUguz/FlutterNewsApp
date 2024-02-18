import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/model/content_model.dart';

class CategoriesService {
  Future<List<String>> getCategories() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('news').get();

    Set<String> categories = {};

    for (var doc in querySnapshot.docs) {
      if (doc.data().containsKey('categories')) {
        List<dynamic> docCategories = doc['categories'];
        categories.addAll(docCategories.map((category) => category.toString()));
      }
    }

    return categories.toList();
  }

  Future<List<Content>> getNewsByCategory(String category) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('news')
        .where('categories', arrayContains: category)
        .orderBy('publishedAt', descending: true)
        .get();

    List<Content> newsList = [];

    for (var doc in querySnapshot.docs) {
      List<dynamic> docCategories = doc['categories'];
      List<String> stringCategories = List<String>.from(docCategories);

      Content content = Content(
        id: doc['id'],
        title: doc['title'],
        author: doc['author'],
        content: doc['content'],
        description: doc['description'],
        source: doc['source'],
        sourceLogoURL: doc['sourceLogoURL'],
        categories: stringCategories,
        imageURL: doc['imageURL'],
        publishedAt: doc['publishedAt'].toDate(),
      );

      newsList.add(content);
    }

    return newsList;
  }
}
