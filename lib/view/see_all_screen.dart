import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/functions/calculate_time_ago.dart';
import 'package:news_app/functions/save_news.dart';
import 'package:news_app/model/content_model.dart';
import 'package:news_app/providers/main_provider.dart';
import 'package:news_app/widgets/listview_card.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SeeAllScreen extends StatelessWidget {
  SeeAllScreen({super.key, required this.typeOfContent});

  String typeOfContent;

  @override
  Widget build(BuildContext context) {
    var mainProvider = Provider.of<MainProvider>(context, listen: false);
    User? user = FirebaseAuth.instance.currentUser;

    Future<void>? getFuture(String contentType) {
      if (contentType == 'Haberler') {
        return mainProvider.getAllNews();
      } else if (contentType == 'Makaleler') {
        return mainProvider.getArticles();
      } else {
        return mainProvider.getEntertainments();
      }
    }

    int getItemCount(String contentType) {
      if (contentType == 'Haberler') {
        return mainProvider.allNews.length;
      } else if (contentType == 'Makaleler') {
        return mainProvider.articles.length;
      } else {
        return mainProvider.entertainments.length;
      }
    }

    List<Content> getAllContent(String contentType) {
      if (contentType == 'Haberler') {
        return mainProvider.allNews;
      } else if (contentType == 'Makaleler') {
        return mainProvider.articles;
      } else {
        return mainProvider.entertainments;
      }
    }

    String getAppBarTitle(contentType) {
      if (contentType == 'Haberler') {
        return 'TÜM HABERLER';
      } else if (contentType == 'Makaleler') {
        return 'MAKALELER';
      } else {
        return 'EĞLENCE';
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.appsMainColor,
        title: Text(getAppBarTitle(typeOfContent)),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getFuture(typeOfContent),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: getItemCount(typeOfContent),
                  itemBuilder: ((context, index) {
                    var allContent = getAllContent(typeOfContent)[index];
                    return ListViewCard(
                      isNeedBookmark: true,
                      onPressed: () {
                        if (user == null) {
                          Fluttertoast.showToast(
                              msg: 'İçerik kaydetmek için giriş yapmalısınız.',
                              toastLength: Toast.LENGTH_LONG,
                              fontSize: 18);
                        } else {
                          saveNewsToUser(user.uid, allContent.id!);
                        }
                      },
                      id: allContent.id!,
                      author: allContent.author!,
                      content: allContent.content!,
                      description: allContent.description!,
                      source: allContent.source!,
                      sourceLogoURL: allContent.sourceLogoURL!,
                      categories: allContent.categories!,
                      imageURL: allContent.imageURL!,
                      title: allContent.title!,
                      publishedAt:
                          calculateTimeAgo(allContent.publishedAt!.toString()),
                    );
                  }));
            }
          }),
    );
  }
}
