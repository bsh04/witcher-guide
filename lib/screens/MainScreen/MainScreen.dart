import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:witcher_guide/API/URLs.dart';
import 'package:witcher_guide/API/httpManager.dart';
import 'package:witcher_guide/components/ArticleCard.dart';
import 'package:witcher_guide/components/PreviewImage.dart';
import 'package:witcher_guide/enums/index.dart';
import 'package:witcher_guide/models/MainScreenData.dart';
import 'package:witcher_guide/screens/MainScreen/Filters.dart';
import 'package:witcher_guide/secureStorageManager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

MainScreenData initValues = MainScreenData(
    mostPopularArticles: [], newestArticles: [], allArticles: []);

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _gridController = ScrollController();
  final ScrollController _pageScrollController = ScrollController();
  final ScrollController _pageScrollbarController = ScrollController();

  bool isLoading = true;
  bool isVisibleAddButton = false;
  bool isOpenFilters = false;

  EntityType? _entityType;

  MainScreenData data = initValues;

  @override
  void initState() {
    super.initState();
    _handleSetToken();
    _handleDataFetch();
  }

  void _handleToggleFilters() {
    setState(() {
      isOpenFilters = !isOpenFilters;
    });
  }

  void _handleSetToken() async {
    var token = await getStorageKey(tokenKey);
    setState(() {
      isVisibleAddButton = token != null;
    });
  }

  void _handleDataFetch([String? query, EntityType? type]) async {
    RequestParams params = RequestParams();
    params.url = getUrl(mainPageDataUrl);
    params.method = Method.POST;
    params.body = {"query": query, "type": type?.name};

    Response response = await request(params);
    if (response.status == 200) {
      setState(() {
        data = MainScreenData.fromJson(response.data);
      });
    }

    setState(() {
      isLoading = false;
      isOpenFilters = false;
    });

    if (type != null) {
      setState(() {
        _entityType = type;
      });
    }
  }

  void _handleResetList() {
    setState(() {
      data = initValues;
      isLoading = true;
    });
  }

  void _handleSearch(String? query) {
    _handleResetList();
    _handleDataFetch(query);
  }

  void _handleResetFilters() {
    setState(() {
      _entityType = null;
      data = initValues;
      isLoading = true;
    });
    _handleDataFetch();
  }

  void _handlePersonClick() async {
    var token = await getStorageKey(tokenKey);
    if (token == null) {
      Navigator.pushNamed(context, "/login");
    } else {
      Navigator.pushNamed(context, "/settings");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    bool emptySearchValue = _searchController.value.text.isEmpty;
    bool isVisibleBlocks = emptySearchValue && _entityType == null;

    var physics = isOpenFilters ? const NeverScrollableScrollPhysics() : null;
    return Scaffold(
        appBar: AppBar(title: const Text("Main page"), actions: [
          if (isVisibleAddButton)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, "/character");
              },
            ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.person, size: 30.0),
              onPressed: _handlePersonClick,
            ),
          ),
        ]),
        body: Scrollbar(
          controller: _pageScrollbarController,
          child: ListView(
            physics: physics,
            controller: _pageScrollController,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                    onChanged: _handleSearch,
                    controller: _searchController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 20),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: GestureDetector(
                          onTap: _handleToggleFilters,
                          child: Image.asset(
                            "assets/filters_icon.png",
                            color: Colors.black54,
                          ),
                        ),
                        hintText: 'Search...',
                        hintStyle:
                            TextStyle(color: Colors.black.withOpacity(0.4)))),
              ),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Stack(
                  children: [
                    Column(
                      children: [
                        Visibility(
                          visible:
                              data.newestArticles.isNotEmpty && isVisibleBlocks,
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Newest articles",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black45),
                                ),
                              ),
                              SizedBox(
                                height: 150,
                                child: GridView.builder(
                                    physics: physics,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      mainAxisExtent: width / 3,
                                    ),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: data.newestArticles.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            index == 0 ? 10 : 0, 0, 10, 0),
                                        child: ArticleCard(
                                          item: data.newestArticles[index],
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: data.mostPopularArticles.isNotEmpty &&
                              isVisibleBlocks,
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                child: Text(
                                  "Most popular articles",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black45),
                                ),
                              ),
                              SizedBox(
                                height: 150,
                                child: GridView.builder(
                                    physics: physics,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      mainAxisExtent: width / 3,
                                    ),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: data.mostPopularArticles.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            index == 0 ? 10 : 0, 0, 10, 0),
                                        child: ArticleCard(
                                          item: data.mostPopularArticles[index],
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: data.allArticles.isNotEmpty,
                          child: Column(
                            children: [
                              if (emptySearchValue)
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                  child: Text(
                                    "All articles",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black45),
                                  ),
                                ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 20),
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    controller: _gridController,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: MediaQuery.of(context)
                                              .size
                                              .width /
                                          (MediaQuery.of(context).size.height /
                                              4),
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      mainAxisExtent: 150,
                                    ),
                                    itemCount: data.allArticles.length,
                                    itemBuilder: (context, index) {
                                      return ArticleCard(
                                        item: data.allArticles[index],
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    MainScreenFilters(
                        initEntityType: _entityType,
                        isOpenFilters: isOpenFilters,
                        handleResetFilters: _handleResetFilters,
                        handleApplyFilters: (type) {
                          _handleResetList();
                          _handleDataFetch(_searchController.value.text, type);
                        }),
                  ],
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
            ],
          ),
        ));
  }
}
