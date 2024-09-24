// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/functions/calculate_time_ago.dart';
import 'package:news_app/functions/save_news.dart';
import 'package:news_app/services/comments_service.dart';

// ignore: must_be_immutable
class ContentDetailsScreen extends StatefulWidget {
  String title;
  String author;
  String publishedAt;
  String imageURL;
  String source;
  String sourceLogoURL;
  List<dynamic> categories;
  String content;
  String description;
  String newsId;

  ContentDetailsScreen({
    Key? key,
    required this.title,
    required this.author,
    required this.publishedAt,
    required this.imageURL,
    required this.source,
    required this.sourceLogoURL,
    required this.categories,
    required this.content,
    required this.description,
    required this.newsId,
  }) : super(key: key);

  @override
  State<ContentDetailsScreen> createState() => _ContentDetailsScreenState();
}

class _ContentDetailsScreenState extends State<ContentDetailsScreen> {
  late InterstitialAd _interstitialAd;
  bool _isAdLoaded = false;
  final TextEditingController _commentController = TextEditingController();
  final CommentsService _commentsService = CommentsService();

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-7514295026478931/7184233718',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            _interstitialAd = ad;
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
          setState(() {
            _isAdLoaded = true;
          });
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_isAdLoaded && Constants.openCounter % 5 == 0) {
      _interstitialAd.show();
    } else {
      debugPrint('InterstitialAd not loaded or not ready to be shown.');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Open Count for ListCard:${Constants.openCounter}');
    _showInterstitialAd();
    List<String> contentParagraphs = widget.content.split('\\n');
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.appsMainColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              if (user == null) {
                Fluttertoast.showToast(
                    msg: 'İçerik kaydetmek için giriş yapmalısınız.',
                    toastLength: Toast.LENGTH_LONG,
                    fontSize: 18);
              } else {
                saveNewsToUser(user.uid, widget.newsId);
              }
            },
            icon: const Icon(FontAwesomeIcons.bookmark),
          ),
          IconButton(
              onPressed: () {}, icon: const Icon(FontAwesomeIcons.shareNodes)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageURL,
                    placeholder: (context, url) {
                      return Container(
                        color: Colors.transparent,
                        height: 100,
                        width: 50,
                        child: const SpinKitFadingCircle(
                          color: Constants.appsMainColor,
                          size: 45,
                        ),
                      );
                    },
                  )),
              const SizedBox(height: 10),
              Text(
                widget.title,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Constants.appsMainColor,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Yazar : ${widget.author}",
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
                  ),
                  Text(
                    widget.publishedAt,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.description,
                textAlign: TextAlign.left,
                style:
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: contentParagraphs.map((paragraph) {
                  return Column(
                    children: [
                      Text(
                        paragraph,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Kategoriler : ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.categories.map((category) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Chip(
                              label: Text(category),
                              backgroundColor: Constants.appsMainColor,
                              labelStyle: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Kaynak : ',
                    style: TextStyle(fontSize: 20),
                  ),
                  CachedNetworkImage(
                    imageUrl: widget.sourceLogoURL,
                    width: 30,
                    height: 30,
                    placeholder: (context, url) {
                      return Center(
                        child: Container(
                          color: Colors.transparent,
                          height: 100,
                          width: 100,
                          child: const SpinKitFadingCircle(
                            color: Constants.appsMainColor,
                            size: 30,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.source,
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Yorumlar",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                          cursorColor: Constants.appsMainColor,
                          controller: _commentController,
                          decoration: InputDecoration(
                              labelStyle: const TextStyle(
                                  color: Constants.appsMainColor),
                              focusedBorder: Constants().textfieldBorder,
                              enabledBorder: Constants().textfieldBorder,
                              border: const OutlineInputBorder(),
                              labelText: "Yorum Yaz..")),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton(
                      onPressed: () async {
                        if (user == null) {
                          Fluttertoast.showToast(
                              msg: 'Yorum yapabilmek için giriş yapmalısınız.');
                        } else if (_commentController.text == '') {
                          Fluttertoast.showToast(msg: 'Yorum Yazınız.');
                        } else {
                          String commentId =
                              firestore.collection('comments').doc().id;
                          String userId = user.uid;
                          String? userName =
                              await _commentsService.getUserName(user.uid);

                          // Add comment to Firestore
                          await _commentsService.addComment(
                              commentId,
                              widget.newsId,
                              userName,
                              userId,
                              _commentController.text);

                          // Clear the comment input field
                          _commentController.clear();
                        }
                      },
                      icon: const Icon(
                        FontAwesomeIcons.paperPlane,
                        color: Constants.appsMainColor,
                      )),
                ],
              ),
              StreamBuilder(
                stream: _commentsService.getCommentsForNews(widget.newsId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  var comments = snapshot.data!.docs;

                  return comments.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(50.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.commentSlash,
                                  color: Colors.black,
                                  size: 45,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Bu İçerik İçin Yorum Yapılmamış.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            var comment =
                                comments[index].data() as Map<String, dynamic>;
                            var commentDate = '';
                            if (comment['commentDate'] != null) {
                              commentDate = calculateTimeAgo(
                                  comment['commentDate'].toDate().toString());
                            } else {
                              commentDate = 'No date available';
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: GestureDetector(
                                onLongPress: () {
                                  if (comment['userID'] == user!.uid) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    CommentsService()
                                                        .deleteComment(comment[
                                                            'commentID']);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'Evet',
                                                    style: TextStyle(
                                                        color: Constants
                                                            .appsMainColor,
                                                        fontSize: 20),
                                                  )),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Hayır',
                                                  style: TextStyle(
                                                      color: Constants
                                                          .appsMainColor,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ],
                                            title: const Text(
                                                "Yorumunuzu silmek İstediğinizden emin misiniz?"),
                                          );
                                        });
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${comment['userName']} - ',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                              color: Constants.appsMainColor),
                                        ),
                                        Text(
                                          commentDate,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      comment['comment'],
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
