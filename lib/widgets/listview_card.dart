// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/functions/rightToLeft_animation.dart';
import 'package:news_app/view/screens/content_details_screen.dart';

// ignore: must_be_immutable
class ListViewCard extends StatefulWidget {
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
  Function()? onPressed;
  bool isNeedBookmark;
  Function()? onLongPress;

  ListViewCard({
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
    required this.onPressed,
    required this.isNeedBookmark,
    this.onLongPress,
  }) : super(key: key);

  @override
  State<ListViewCard> createState() => _ListViewCardState();
}

class _ListViewCardState extends State<ListViewCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPress,
      onTap: () {
        Constants.openCounter++;
        Navigator.push(
            context,
            rightToLeftPageAnimation(ContentDetailsScreen(
                newsId: widget.id,
                title: widget.title,
                author: widget.author,
                publishedAt: widget.publishedAt,
                imageURL: widget.imageURL,
                source: widget.source,
                sourceLogoURL: widget.sourceLogoURL,
                categories: widget.categories,
                content: widget.content,
                description: widget.description)));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(widget.publishedAt),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Stack(children: [
                CachedNetworkImage(
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
                  imageUrl: widget.imageURL,
                  errorWidget: (context, string, _) {
                    return const Icon(Icons.error);
                  },
                  width: 140,
                  height: 90,
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) => ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: (widget.isNeedBookmark == true)
                      ? IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.bookmark,
                            color: Colors.white,
                          ),
                          onPressed: widget.onPressed)
                      : const Center(),
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
