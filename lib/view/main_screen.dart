import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/functions/rightToLeft_animation.dart';
import 'package:news_app/view/categories_screen.dart';
import 'package:news_app/view/home_screen.dart';
import 'package:news_app/view/menu_screen.dart';
import 'package:news_app/view/saved_screen.dart';
import 'package:news_app/view/search_screen.dart';
import 'package:news_app/view/videos_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  // ignore: non_constant_identifier_names
  final List<Widget> _NavBarItems = [
    const HomeScreen(),
    const CategoriesScreen(),
    VideosScreen(),
    const SavedScreen(),
    const MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Constants.appsMainColor,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context, rightToLeftPageAnimation(const SearchScreen()));
              },
              icon: const Icon(
                FontAwesomeIcons.magnifyingGlass,
                size: 20,
                color: Colors.white,
              ),
            ),
          ],
          title: Image.asset(
            'images/logo.png',
            width: 160,
            height: 130,
          ),
        ),
        body: SafeArea(
          child: Center(
            child: _NavBarItems.elementAt(_selectedIndex),
          ),
        ),
        bottomNavigationBar: GNav(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16.5),
          selectedIndex: _selectedIndex,
          onTabChange: _onItemTapped,
          activeColor: Constants.appsMainColor,
          hoverColor: Colors.grey.shade300,
          backgroundColor: Colors.grey.shade200,
          gap: 5,
          tabs: const [
            GButton(
              icon: FontAwesomeIcons.house,
              text: 'Anasayfa',
            ),
            GButton(
              icon: Icons.category,
              text: 'Kategoriler',
            ),
            GButton(
              icon: FontAwesomeIcons.play,
              text: 'Video',
            ),
            GButton(
              icon: FontAwesomeIcons.bookmark,
              text: 'Kaydet',
            ),
            GButton(
              icon: FontAwesomeIcons.bars,
              text: 'Menü',
            ),
          ],
        ));
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }
}
