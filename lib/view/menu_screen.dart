import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/functions/launch_url.dart';
import 'package:news_app/functions/rightToLeft_animation.dart';
import 'package:news_app/services/auth_service.dart';
import 'package:news_app/view/login_register_screen.dart';

// ignore: must_be_immutable
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? name;

  bool isUserSignedIn = false;

  Future<void> getCurrentUser() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where(
            'email',
            isEqualTo: user.email,
          )
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          name = userData['name'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    if (user != null) {
      isUserSignedIn = true;
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            user == null
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Constants.appsMainColor,
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            rightToLeftPageAnimation(LoginRegisterScreen()));
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: const Center(
                          child: Text(
                            'Giriş Yap / Kayıt Ol',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Constants.appsMainColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Hoşgeldiniz,',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                name == null
                                    ? const SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        '$name',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 23),
                                      )
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    FontAwesomeIcons.gear,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Auth().signOut();
                                    setState(() {
                                      isUserSignedIn = false;
                                    });
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.rightFromBracket,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Constants.appsMainColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(
                          child: Text(
                        'Sosyal Medya Hesaplarımız',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MenuSocialIcons(
                              icon: FontAwesomeIcons.facebook,
                              onPressed: () {
                                LaunchURL().launchSocialMediaURL('facebook');
                              }),
                          MenuSocialIcons(
                              icon: FontAwesomeIcons.instagram,
                              onPressed: () {
                                LaunchURL().launchSocialMediaURL('instagram');
                              }),
                          MenuSocialIcons(
                              icon: FontAwesomeIcons.squareXTwitter,
                              onPressed: () {
                                LaunchURL().launchSocialMediaURL('twitter');
                              }),
                          MenuSocialIcons(
                            icon: FontAwesomeIcons.youtube,
                            onPressed: () {
                              LaunchURL().launchSocialMediaURL('youtube');
                            },
                          ),
                          MenuSocialIcons(
                            icon: FontAwesomeIcons.tiktok,
                            onPressed: () {
                              LaunchURL().launchSocialMediaURL('tiktok');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                children: [
                  MenuListTile(
                    text: 'Bize Yazın',
                    icon: FontAwesomeIcons.envelope,
                  ),
                  MenuListTile(
                    text: 'Hakkımızda',
                    icon: FontAwesomeIcons.info,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MenuSocialIcons extends StatelessWidget {
  MenuSocialIcons({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  IconData icon;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white, size: 40),
    );
  }
}

// ignore: must_be_immutable
class MenuListTile extends StatelessWidget {
  MenuListTile({super.key, required this.text, required this.icon});

  String text;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
      leading: Icon(
        icon,
        color: Constants.appsMainColor,
      ),
      trailing: const Icon(
        FontAwesomeIcons.chevronRight,
        color: Constants.appsMainColor,
      ),
    );
  }
}
