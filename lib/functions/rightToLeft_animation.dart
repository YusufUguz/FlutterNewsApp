import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

PageTransition<dynamic> rightToLeftPageAnimation(Widget theScreen) {
  return PageTransition(
      child: theScreen,
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 350),
      type: PageTransitionType.rightToLeft);
}