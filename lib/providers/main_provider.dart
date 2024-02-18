import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_app/model/content_model.dart';
import 'package:news_app/model/video_model.dart';
import 'package:news_app/services/categories_service.dart';

class MainProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Content> _featuredNews = [];
  List<Content> _allNews = [];
  List<Content> _newsFeed = [];
  List<Content> _articles = [];
  List<Content> _entertainments = [];
  List<Content> _savedNews = [];
  List<Video> _videos = [];
  final List<Content> _searchedNews = [];

  List<Content> get allNews => _allNews;
  List<Content> get newsFeed => _newsFeed;
  List<Content> get featuredNews => _featuredNews;
  List<Content> get articles => _articles;
  List<Content> get entertainments => _entertainments;
  List<Content> get savedNews => _savedNews;
  List<Video> get videos => _videos;
  List<Content> get searchedNews => _searchedNews;

  Future<void> getFeaturedNews() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('news')
          .where('isFeatured', isEqualTo: true)
          .orderBy("publishedAt", descending: true)
          .get();
      _featuredNews = querySnapshot.docs
          .map((doc) => Content(
              id: doc['id'],
              author: doc['author'],
              categories: doc['categories'],
              content: doc['content'],
              description: doc['description'],
              imageURL: doc['imageURL'],
              publishedAt: doc['publishedAt'].toDate(),
              source: doc['source'],
              sourceLogoURL: doc['sourceLogoURL'],
              title: doc['title']))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Hata oluştu: $e");
    }
  }

  Future<void> getNewsFeed() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('news')
          .orderBy("publishedAt", descending: true)
          .where(
            'isNews',
            isEqualTo: true,
          )
          .where('isFeatured', isEqualTo: false)
          .get();
      _newsFeed = querySnapshot.docs
          .map((doc) => Content(
              id: doc['id'],
              author: doc['author'],
              categories: doc['categories'],
              content: doc['content'],
              description: doc['description'],
              imageURL: doc['imageURL'],
              publishedAt: doc['publishedAt'].toDate(),
              source: doc['source'],
              sourceLogoURL: doc['sourceLogoURL'],
              title: doc['title']))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Hata oluştu: $e");
    }
  }

  Future<void> getAllNews() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('news')
          .orderBy("publishedAt", descending: true)
          .where(
            'isNews',
            isEqualTo: true,
          )
          .get();
      _allNews = querySnapshot.docs
          .map((doc) => Content(
              id: doc['id'],
              author: doc['author'],
              categories: doc['categories'],
              content: doc['content'],
              description: doc['description'],
              imageURL: doc['imageURL'],
              publishedAt: doc['publishedAt'].toDate(),
              source: doc['source'],
              sourceLogoURL: doc['sourceLogoURL'],
              title: doc['title']))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Hata oluştu: $e");
    }
  }

  Future<void> getArticles() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('news')
          .orderBy("publishedAt", descending: true)
          .where('isArticle', isEqualTo: true)
          .get();
      _articles = querySnapshot.docs
          .map((doc) => Content(
              id: doc['id'],
              author: doc['author'],
              categories: doc['categories'],
              content: doc['content'],
              description: doc['description'],
              imageURL: doc['imageURL'],
              publishedAt: doc['publishedAt'].toDate(),
              source: doc['source'],
              sourceLogoURL: doc['sourceLogoURL'],
              title: doc['title']))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Hata oluştu: $e");
    }
  }

  Future<void> getEntertainments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('news')
          .orderBy("publishedAt", descending: true)
          .where('isEnt', isEqualTo: true)
          .get();
      _entertainments = querySnapshot.docs
          .map((doc) => Content(
              id: doc['id'],
              author: doc['author'],
              categories: doc['categories'],
              content: doc['content'],
              description: doc['description'],
              imageURL: doc['imageURL'],
              publishedAt: doc['publishedAt'].toDate(),
              source: doc['source'],
              sourceLogoURL: doc['sourceLogoURL'],
              title: doc['title']))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Hata oluştu: $e");
    }
  }

  List<String> _categories = [];
  List<String> get categories => _categories;

  String _selectedCategory = '';
  String get selectedCategory => _selectedCategory;

  void setCategories(List<String> categories) {
    _categories = categories;
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> getCategoriesFromFirestore() async {
    var firestoreService = CategoriesService();
    List<String> categories = await firestoreService.getCategories();
    setCategories(categories);
  }

  Future<void> getUsersSavedNews(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        List<String> savedNewsIds = List<String>.from(userDoc.get('saved'));

        // ignore: unused_local_variable
        for (String newsId in savedNewsIds) {
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('news')
              .where('id', whereIn: savedNewsIds)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            _savedNews = querySnapshot.docs
                .map((doc) => Content(
                      id: doc['id'],
                      author: doc['author'],
                      categories: doc['categories'],
                      content: doc['content'],
                      description: doc['description'],
                      imageURL: doc['imageURL'],
                      publishedAt: doc['publishedAt'].toDate(),
                      source: doc['source'],
                      sourceLogoURL: doc['sourceLogoURL'],
                      title: doc['title'],
                    ))
                .toList();

            debugPrint('Kullanıcının kaydettiği haberler: $savedNews');
          }
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Hata oluştu: $e");
    }
  }

  Future<void> getVideoURLs() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('videos')
          .orderBy('publishedAt', descending: true)
          .get();
      _videos = querySnapshot.docs
          .map((doc) => Video(
              title: doc['title'],
              publishedAt: doc['publishedAt'].toDate(),
              videoURL: doc['videoURL']))
          .toList();
    } catch (e) {
      debugPrint('Error getting video URLs: $e');
      return;
    }
  }
}
