import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:news_app/providers/main_provider.dart';
import 'package:news_app/providers/search_provider.dart';
import 'package:news_app/view/main_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MobileAds.instance.initialize());
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyB5HMHp0-blKXYJmuLisYEkR_MS1t0mqjA",
          appId: "1:426807708168:android:455eaf658c0b68fa4bdfbd",
          messagingSenderId: "426807708168",
          projectId: "newsapp-98abe"));

  initializeDateFormatting('tr_TR', '').then((_) {
    runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(
          create: (context) => MainProvider(),
        ),
        ChangeNotifierProvider(create: (_) => NewsSearchProvider()),
      ], child: const NewsApp()),
    );
  });
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Gabarito'),
      debugShowCheckedModeBanner: false,
      title: 'Teknoloji ve Oyuna Dair',
      home: const MainScreen(),
    );
  }
}
