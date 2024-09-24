import 'package:flutter/material.dart';
import 'package:news_app/functions/rightToLeft_animation.dart';
import 'package:news_app/providers/main_provider.dart';
import 'package:news_app/services/categories_service.dart';
import 'package:news_app/view/news_by_categories_screen.dart';
import 'package:news_app/widgets/categories_card.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<MainProvider>(context, listen: false)
        .getCategoriesFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    var mainProvider = Provider.of<MainProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 7, mainAxisSpacing: 7),
            itemCount: mainProvider.categories.length,
            scrollDirection: Axis.vertical,
            itemBuilder: ((context, index) {
              String category = mainProvider.categories[index];
              return GestureDetector(
                onTap: () {
                  var databaseService = CategoriesService();
                  databaseService.getNewsByCategory(category).then((newsList) {
                    Navigator.push(
                        context,
                        rightToLeftPageAnimation(NewsByCategoriesScreen(
                            category: category, newsList: newsList)));
                  });
                },
                child: CategoriesCard(
                    categoriesImage: "images/$category.jpg",
                    categoriesName: category),
              );
            })),
      ),
    );
  }
}
