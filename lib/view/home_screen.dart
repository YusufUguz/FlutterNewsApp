import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app/functions/rightToLeft_animation.dart';
import 'package:news_app/functions/save_news.dart';
import 'package:news_app/model/content_model.dart';
import 'package:news_app/providers/main_provider.dart';
import 'package:news_app/functions/calculate_time_ago.dart';
import 'package:news_app/view/see_all_screen.dart';
import 'package:news_app/widgets/listview_card.dart';
import 'package:news_app/widgets/header_container.dart';
import 'package:news_app/widgets/featured_news_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var mainProvider = Provider.of<MainProvider>(context, listen: false);
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderContainer(
                titleText: 'ÖNE ÇIKAN HABERLER', isNeedSeeAll: false),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 280,
              child: FutureBuilder(
                  future: mainProvider.getFeaturedNews(),
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
                      return (mainProvider.featuredNews.isEmpty)
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  "Bir Hata Oluştu.İnternet bağlantınızı kontrol ediniz.",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : CarouselSlider.builder(
                              itemCount: mainProvider.featuredNews.length,
                              itemBuilder: (context, index, realIndex) {
                                Content featuredNews =
                                    mainProvider.featuredNews[index];
                                return FeaturedNewsCard(
                                  newsId: featuredNews.id!,
                                  onPressed: () {
                                    if (user == null) {
                                      Fluttertoast.showToast(
                                          msg:
                                              'İçerik kaydetmek için giriş yapmalısınız.',
                                          toastLength: Toast.LENGTH_LONG,
                                          fontSize: 18);
                                    } else {
                                      saveNewsToUser(
                                          user.uid, featuredNews.id!);
                                    }
                                  },
                                  id: featuredNews.id!,
                                  author: featuredNews.author!,
                                  content: featuredNews.content!,
                                  description: featuredNews.description!,
                                  source: featuredNews.source!,
                                  sourceLogoURL: featuredNews.sourceLogoURL!,
                                  categories: featuredNews.categories!,
                                  imageURL: featuredNews.imageURL!,
                                  title: featuredNews.title!,
                                  publishedAt: calculateTimeAgo(
                                      featuredNews.publishedAt!.toString()),
                                );
                              },
                              options: CarouselOptions(
                                scrollDirection: Axis.horizontal,
                                height: 300,
                              ),
                            );
                    }
                  }),
            ),
            HeaderContainer(
              titleText: 'HABER AKIŞI',
              isNeedSeeAll: true,
              onTap: () {
                Navigator.push(
                    context,
                    rightToLeftPageAnimation(
                        SeeAllScreen(typeOfContent: 'Haberler')));
              },
            ),
            FutureBuilder(
                future: mainProvider.getNewsFeed(),
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
                    return (mainProvider.newsFeed.isEmpty)
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Bir Hata Oluştu.İnternet bağlantınızı kontrol ediniz.",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: mainProvider.newsFeed.length,
                            itemBuilder: ((context, index) {
                              var allNews = mainProvider.newsFeed[index];
                              return ListViewCard(
                                isNeedBookmark: true,
                                onPressed: () {
                                  if (user == null) {
                                    Fluttertoast.showToast(
                                        msg:
                                            'İçerik kaydetmek için giriş yapmalısınız.',
                                        toastLength: Toast.LENGTH_LONG,
                                        fontSize: 18);
                                  } else {
                                    saveNewsToUser(user.uid, allNews.id!);
                                  }
                                },
                                id: allNews.id!,
                                author: allNews.author!,
                                content: allNews.content!,
                                description: allNews.description!,
                                source: allNews.source!,
                                sourceLogoURL: allNews.sourceLogoURL!,
                                categories: allNews.categories!,
                                imageURL: allNews.imageURL!,
                                title: allNews.title!,
                                publishedAt: calculateTimeAgo(
                                    allNews.publishedAt!.toString()),
                              );
                            }));
                  }
                }),
            HeaderContainer(
              titleText: 'MAKALELER',
              isNeedSeeAll: true,
              onTap: () {
                Navigator.push(
                    context,
                    rightToLeftPageAnimation(
                        SeeAllScreen(typeOfContent: 'Makaleler')));
              },
            ),
            FutureBuilder(
                future: mainProvider.getArticles(),
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
                    return (mainProvider.articles.isEmpty)
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Bir Hata Oluştu.İnternet bağlantınızı kontrol ediniz.",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: 2,
                            itemBuilder: ((context, index) {
                              var allArticles = mainProvider.articles[index];
                              return ListViewCard(
                                isNeedBookmark: true,
                                onPressed: () {
                                  if (user == null) {
                                    Fluttertoast.showToast(
                                        msg:
                                            'İçerik kaydetmek için giriş yapmalısınız.',
                                        toastLength: Toast.LENGTH_LONG,
                                        fontSize: 18);
                                  } else {
                                    saveNewsToUser(user.uid, allArticles.id!);
                                  }
                                },
                                id: allArticles.id!,
                                author: allArticles.author!,
                                content: allArticles.content!,
                                description: allArticles.description!,
                                source: allArticles.source!,
                                sourceLogoURL: allArticles.sourceLogoURL!,
                                categories: allArticles.categories!,
                                imageURL: allArticles.imageURL!,
                                title: allArticles.title!,
                                publishedAt: calculateTimeAgo(
                                    allArticles.publishedAt!.toString()),
                              );
                            }));
                  }
                }),
            HeaderContainer(
              titleText: 'EĞLENCE',
              isNeedSeeAll: true,
              onTap: () {
                Navigator.push(
                    context,
                    rightToLeftPageAnimation(
                        SeeAllScreen(typeOfContent: 'Eğlence')));
              },
            ),
            FutureBuilder(
                future: mainProvider.getEntertainments(),
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
                    return (mainProvider.entertainments.isEmpty)
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Bir Hata Oluştu.İnternet bağlantınızı kontrol ediniz.",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: 2,
                            itemBuilder: ((context, index) {
                              var allEntertainments =
                                  mainProvider.entertainments[index];
                              return ListViewCard(
                                isNeedBookmark: true,
                                onPressed: () {
                                  if (user == null) {
                                    Fluttertoast.showToast(
                                        msg:
                                            'İçerik kaydetmek için giriş yapmalısınız.',
                                        toastLength: Toast.LENGTH_LONG,
                                        fontSize: 18);
                                  } else {
                                    saveNewsToUser(
                                        user.uid, allEntertainments.id!);
                                  }
                                },
                                id: allEntertainments.id!,
                                author: allEntertainments.author!,
                                content: allEntertainments.content!,
                                description: allEntertainments.description!,
                                source: allEntertainments.source!,
                                sourceLogoURL: allEntertainments.sourceLogoURL!,
                                categories: allEntertainments.categories!,
                                imageURL: allEntertainments.imageURL!,
                                title: allEntertainments.title!,
                                publishedAt: calculateTimeAgo(
                                    allEntertainments.publishedAt!.toString()),
                              );
                            }));
                  }
                }),
          ],
        ),
      ),
    );
  }
}


















/*

final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<CarouselSliderState> _carouselSliderKey =
      GlobalKey<CarouselSliderState>();
  final GlobalKey<AnimatedListState> _newsKey = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _articlesKey =
      GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _entertainmentsKey =
      GlobalKey<AnimatedListState>();

  Future<void> _refresh() async {
    try {
      var mainProvider = Provider.of<MainProvider>(context, listen: false);

      _refreshKey.currentState?.show();

      await Future.wait([
        mainProvider.getFeaturedNews(),
        mainProvider.getAllNews(),
        mainProvider.getArticles(),
        mainProvider.getEntertainments(),
      ]);

      _carouselSliderKey.currentState?.setState(() {});
      _articlesKey.currentState?.setState(() {});
      _newsKey.currentState?.setState(() {});
      _entertainmentsKey.currentState?.setState(() {});

      await Future.delayed(const Duration(seconds: 2));
      _refreshKey.currentState?.deactivate();
    } catch (e) {
      debugPrint('Error = $e');
      _refreshKey.currentState?.deactivate();
    }
  }

  */
