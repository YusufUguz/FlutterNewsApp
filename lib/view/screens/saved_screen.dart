import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/functions/calculate_time_ago.dart';
import 'package:news_app/functions/delete_all_saved_news.dart';
import 'package:news_app/functions/delete_saved_news.dart';
import 'package:news_app/functions/rightToLeft_animation.dart';
import 'package:news_app/functions/save_news.dart';
import 'package:news_app/providers/main_provider.dart';
import 'package:news_app/view/screens/login_register_screen.dart';
import 'package:news_app/view/screens/main_screen.dart';
import 'package:news_app/widgets/listview_card.dart';
import 'package:provider/provider.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    var mainProvider = Provider.of<MainProvider>(context, listen: false);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (user == null) {
              Fluttertoast.showToast(
                  msg: 'Bu işlem için giriş yapmalısınız.',
                  toastLength: Toast.LENGTH_LONG,
                  fontSize: 18);
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      actionsPadding: const EdgeInsets.all(10),
                      actions: [
                        TextButton(
                          onPressed: () {
                            deleteAllSavedNews();
                            Navigator.pushReplacement(context,
                                rightToLeftPageAnimation(const MainScreen()));
                            setState(() {
                              mainProvider.savedNews.clear();
                            });
                          },
                          child: const Text(
                            'Evet',
                            style: TextStyle(
                                color: Constants.appsMainColor, fontSize: 20),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Vazgeç',
                              style: TextStyle(
                                  color: Constants.appsMainColor, fontSize: 20),
                            ))
                      ],
                      title: const Text(
                          'Tüm Kaydedilenleri silmek istediğinizden emin misiniz?'),
                    );
                  });
            }
          },
          backgroundColor: Constants.appsMainColor,
          child: const Icon(Icons.delete)),
      body: SafeArea(
        child: user == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      FontAwesomeIcons.bookmark,
                      size: 100,
                      color: Constants.appsMainColor,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'İçerik Kaydedebilmek İçin Giriş Yapmanız Gerekmektedir.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 250,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.appsMainColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              rightToLeftPageAnimation(LoginRegisterScreen()));
                        },
                        child: const Text(
                          'Giriş Yap / Kayıt Ol',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : FutureBuilder(
                future: mainProvider.getUsersSavedNews(user.uid),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (mainProvider.savedNews.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Kaydedilmiş içerik bulunmamaktadır.',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: mainProvider.savedNews.length,
                        itemBuilder: ((context, index) {
                          var savedNews = mainProvider.savedNews[index];
                          return ListViewCard(
                            onLongPress: () async {
                              await deleteSavedNews(user.uid, savedNews.id!);
                              await mainProvider.getUsersSavedNews(user.uid);
                              setState(() {
                                mainProvider.savedNews;
                              });
                            },
                            isNeedBookmark: false,
                            onPressed: () {
                              saveNewsToUser(user.uid, savedNews.id!);
                            },
                            id: savedNews.id!,
                            author: savedNews.author!,
                            content: savedNews.content!,
                            description: savedNews.description!,
                            source: savedNews.source!,
                            sourceLogoURL: savedNews.sourceLogoURL!,
                            categories: savedNews.categories!,
                            imageURL: savedNews.imageURL!,
                            title: savedNews.title!,
                            publishedAt: calculateTimeAgo(
                                savedNews.publishedAt!.toString()),
                          );
                        }));
                  }
                }),
      ),
    );
  }
}
