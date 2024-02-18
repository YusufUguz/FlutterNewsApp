import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchURL {
  void launchSocialMediaURL(String platform) async {
    Uri url;

    if (platform == 'facebook') {
      url = Uri(
          scheme: 'https',
          host: "www.facebook.com",
          path: '/teknolojiveoyunadair');
    } else if (platform == 'instagram') {
      url = Uri(
          scheme: 'https',
          host: "www.instagram.com",
          path: '/teknolojiveoyunadair');
    } else if (platform == 'twitter') {
      url = Uri(
          scheme: 'https', host: "www.twitter.com", path: '/_teknoloji_oyun');
    } else if (platform == 'youtube') {
      url = Uri(
          scheme: 'https',
          host: "www.youtube.com",
          path: '/@teknolojiveoyunadair6170');
    } else if (platform == 'tiktok') {
      url = Uri(
          scheme: 'https',
          host: "www.tiktok.com",
          path: '/@teknolojiveoyunadair');
    } else {
      url = Uri(
          scheme: 'https', host: "www.teknolojiveoyunadair.com", path: '/home');
    }

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
