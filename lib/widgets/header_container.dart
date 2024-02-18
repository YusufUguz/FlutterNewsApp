import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/constants.dart';

// ignore: must_be_immutable
class HeaderContainer extends StatelessWidget {
  HeaderContainer(
      {super.key, required this.titleText, this.isNeedSeeAll, this.onTap});

  String titleText;
  bool? isNeedSeeAll;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Constants.appsMainColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: isNeedSeeAll == false
            ? Center(
                child: Text(
                  titleText,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Text(
                      titleText,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tümünü Gör',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        Icon(
                          FontAwesomeIcons.chevronRight,
                          color: Colors.white,
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
