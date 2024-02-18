import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewsSearchProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _searchResults = [];

  List<Map<String, dynamic>> get searchResults => _searchResults;

  set searchResults(List<Map<String, dynamic>> results) {
    _searchResults = results;
    notifyListeners();
  }

  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }

  Future<void> searchNews(String keyword) async {
    keyword = keyword.toLowerCase();

    QuerySnapshot querySnapshot = await _firestore.collection('news').get();

    List<Map<String, dynamic>> allNews = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    List<Map<String, dynamic>> filteredResults = allNews.where((news) {
      return news['title'].toLowerCase().contains(keyword);
    }).toList();

    searchResults = filteredResults;
  }
}
