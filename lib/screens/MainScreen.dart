import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:witcher_guide/API/URLs.dart';
import 'package:witcher_guide/API/httpManager.dart';
import 'package:witcher_guide/components/ArticleCard.dart';
import 'package:witcher_guide/components/PreviewImage.dart';
import 'package:witcher_guide/models/MainScreenData.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool isLoading = true;

  MainScreenData data =
      MainScreenData(mostPopularArticles: [], newestArticles: []);

  @override
  void initState() {
    super.initState();
    _handleDataFetch();
  }

  void _handleDataFetch() async {
    RequestParams params = RequestParams();
    params.url = getUrl(mainPageDataUrl);
    params.method = Method.GET;

    Response response = await request(params);
    if (response.status == 200) {
      setState(() {
        data = MainScreenData.fromJson(response.data);
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(title: const Text("Main page"), actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                icon: const Icon(Icons.person, size: 30.0),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                }),
          )
        ]),
        body: SizedBox(
          height: double.maxFinite,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 20),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search...',
                        hintStyle:
                            TextStyle(color: Colors.black.withOpacity(0.4)))),
              ),
              if (isLoading)
                const CircularProgressIndicator()
              else
                SizedBox(
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: data.newestArticles.isNotEmpty,
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Newest articles",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black45),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 150,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: data.newestArticles.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
                                  child: ArticleCard(
                                    item: data.newestArticles[index],
                                  ),
                                );
                              }),
                        ),
                      ),
                      Visibility(
                        visible: data.mostPopularArticles.isNotEmpty,
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: Text(
                            "Most popular articles",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black45),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 150,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: data.mostPopularArticles.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
                                  child: ArticleCard(
                                    item: data.mostPopularArticles[index],
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              if (data.mostPopularArticles.isEmpty &&
                  data.newestArticles.isEmpty &&
                  !isLoading)
                const Center(
                  child: Text(
                    "NO ARTICLES",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black45,
                    ),
                  ),
                ),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/character");
                  },
                  child: const Text(
                    "Add character",
                    style: TextStyle(fontSize: 16),
                  ))
            ],
          ),
        ));
  }
}
