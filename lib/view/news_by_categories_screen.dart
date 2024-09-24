import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/functions/calculate_time_ago.dart';
import 'package:news_app/functions/save_news.dart';
import 'package:news_app/model/content_model.dart';
import 'package:news_app/widgets/listview_card.dart';

class NewsByCategoriesScreen extends StatelessWidget {
  final String category;
  final List<Content> newsList;

  const NewsByCategoriesScreen(
      {super.key, required this.category, required this.newsList});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.appsMainColor,
        foregroundColor: Colors.white,
        title: Text(
          category,
          style: const TextStyle(fontSize: 25, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          var news = newsList[index];

          return ListViewCard(
              isNeedBookmark: true,
              onPressed: () {
                if (user == null) {
                  Fluttertoast.showToast(
                      msg: 'İçerik kaydetmek için giriş yapmalısınız.',
                      toastLength: Toast.LENGTH_LONG,
                      fontSize: 18);
                } else {
                  saveNewsToUser(user.uid, news.id!);
                }
              },
              id: news.id!,
              author: news.author!,
              content: news.content!,
              description: news.description!,
              source: news.source!,
              sourceLogoURL: news.sourceLogoURL!,
              categories: news.categories!,
              imageURL: news.imageURL!,
              title: news.title!,
              publishedAt: calculateTimeAgo(news.publishedAt!.toString()));
        },
      ),
    );
  }
}
