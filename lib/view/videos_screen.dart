import 'package:flutter/material.dart';
import 'package:news_app/providers/main_provider.dart';
import 'package:news_app/view/video_player_page.dart';

class VideosScreen extends StatelessWidget {
  final MainProvider _firestoreService = MainProvider();

  VideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _firestoreService.getVideoURLs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var videos = _firestoreService.videos;
            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _firestoreService.videos.length,
              itemBuilder: (context, index) {
                return VideoPlayerPage(
                  title: videos[index].title,
                  videoUrl: videos[index].videoURL,
                  publishedAt: videos[index].publishedAt,
                );
              },
            );
          }
        },
      ),
    );
  }
}
