import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/functions/calculate_time_ago.dart';
import 'package:news_app/functions/save_news.dart';
import 'package:news_app/providers/search_provider.dart';
import 'package:news_app/widgets/listview_card.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Provider.of<NewsSearchProvider>(context, listen: false)
        .clearSearchResults();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.appsMainColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                cursorColor: Constants.appsMainColor,
                onChanged: (keyword) {
                  _searchNewsAfterBuild(context, keyword);
                },
                controller: _searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Constants.appsMainColor),
                      borderRadius: BorderRadius.circular(10)),
                  labelText: 'İçerik Ara..',
                  labelStyle: const TextStyle(color: Constants.appsMainColor),
                  prefixIcon: const Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Constants.appsMainColor,
                  ),
                  enabledBorder: Constants().textfieldBorder,
                  focusedBorder: Constants().textfieldBorder,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Constants.appsMainColor,
                    ),
                    onPressed: () {
                      _searchNews(context, _searchController.text);
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<NewsSearchProvider>(
              builder: (context, newsSearchProvider, child) {
                return newsSearchProvider.searchResults.isEmpty &&
                        _searchController.text != ""
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.notEqual,
                              size: 50,
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Veri bulunamadı,doğru yazdığınızdan emin olunuz.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: newsSearchProvider.searchResults.length,
                        itemBuilder: (context, index) {
                          var searchResultsIndex =
                              newsSearchProvider.searchResults[index];
                          return ListViewCard(
                            id: searchResultsIndex['id'],
                            title: searchResultsIndex['title'],
                            author: searchResultsIndex['author'],
                            publishedAt: calculateTimeAgo(
                                searchResultsIndex['publishedAt']
                                    .toDate()
                                    .toString()),
                            imageURL: searchResultsIndex['imageURL'],
                            source: searchResultsIndex['source'],
                            sourceLogoURL: searchResultsIndex['sourceLogoURL'],
                            categories: searchResultsIndex['categories'],
                            content: searchResultsIndex['content'],
                            description: searchResultsIndex['description'],
                            onPressed: () {
                              saveNewsToUser(
                                  user!.uid, searchResultsIndex['id']);
                            },
                            isNeedBookmark: true,
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _searchNews(BuildContext context, String keyword) async {
    NewsSearchProvider newsSearchProvider =
        Provider.of<NewsSearchProvider>(context, listen: false);
    await newsSearchProvider.searchNews(keyword);
  }

  void _searchNewsAfterBuild(BuildContext context, String keyword) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchNews(context, keyword);
    });
  }
}
