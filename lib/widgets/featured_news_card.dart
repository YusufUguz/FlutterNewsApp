// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:news_app/constants.dart';
import 'package:news_app/functions/rightToLeft_animation.dart';
import 'package:news_app/view/screens/content_details_screen.dart';

// ignore: must_be_immutable
class FeaturedNewsCard extends StatelessWidget {
  String id;
  String title;
  String author;
  String publishedAt;
  String imageURL;
  String source;
  String sourceLogoURL;
  List<dynamic> categories;
  String content;
  String description;
  bool? isSourceOneText;
  Function()? onPressed;
  String newsId;

  FeaturedNewsCard({
    Key? key,
    required this.id,
    required this.title,
    required this.author,
    required this.publishedAt,
    required this.imageURL,
    required this.source,
    required this.sourceLogoURL,
    required this.categories,
    required this.content,
    required this.description,
    this.isSourceOneText,
    required this.onPressed,
    required this.newsId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String sourceText1;
    String sourceText2;

    List<String> splittedSourceText = source.split(" ");

    if (splittedSourceText.length == 2) {
      sourceText1 = splittedSourceText[0];
      sourceText2 = splittedSourceText[1];
      isSourceOneText = false;
    } else if (splittedSourceText.length == 3) {
      sourceText1 = splittedSourceText[0] + splittedSourceText[1];
      sourceText2 = splittedSourceText[2];
      isSourceOneText = false;
    } else if (splittedSourceText.length == 4) {
      sourceText1 = '${splittedSourceText[0]} ${splittedSourceText[1]}';
      sourceText2 = '${splittedSourceText[2]} ${splittedSourceText[3]}';
      isSourceOneText = false;
    } else {
      isSourceOneText = true;
      sourceText1 = splittedSourceText[0];
      sourceText2 = '';
    }

    return GestureDetector(
      onTap: () {
        Constants.openCounter++;
        Navigator.push(
            context,
            rightToLeftPageAnimation(ContentDetailsScreen(
              title: title,
              author: author,
              publishedAt: publishedAt,
              imageURL: imageURL,
              source: source,
              sourceLogoURL: sourceLogoURL,
              categories: categories,
              content: content,
              description: description,
              newsId: newsId,
            )));
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.transparent),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    placeholder: (context, url) {
                      return Container(
                        color: Colors.transparent,
                        height: 100,
                        width: 100,
                        child: const SpinKitFadingCircle(
                          color: Constants.appsMainColor,
                          size: 45,
                        ),
                      );
                    },
                    imageUrl: imageURL,
                    errorWidget: (context, string, _) {
                      return const Icon(Icons.error);
                    },
                    width: MediaQuery.of(context).size.width,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.bookmark,
                      color: Colors.white,
                    ),
                    onPressed: onPressed,
                  ),
                ),
              ],
            ),
            Text(
              title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: sourceLogoURL,
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
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    isSourceOneText == false
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(sourceText1),
                              Text(sourceText2),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(sourceText1),
                              Text(sourceText2),
                            ],
                          ),
                  ],
                ),
                Text(
                  publishedAt,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
