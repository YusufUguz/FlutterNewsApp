import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoriesCard extends StatelessWidget {
  CategoriesCard({
    super.key,
    required this.categoriesImage,
    required this.categoriesName,
  });

  String categoriesName;
  String categoriesImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            categoriesImage,
            fit: BoxFit.cover,
            height: 200,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.4),
          ),
          height: 200,
        ),
        Text(
          categoriesName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ],
    );
  }
}
