import 'package:witcher_guide/types/index.dart';

class MainScreenData {
  List<PreviewEntityI> mostPopularArticles = [];
  List<PreviewEntityI> newestArticles = [];

  MainScreenData({required this.mostPopularArticles, required this.newestArticles});

  factory MainScreenData.fromJson(Map<String, dynamic> json) {
    var newestArticles = json["newestArticles"] as List;
    List<PreviewEntityI> newestArticlesList = newestArticles.map((i) => PreviewEntityI.fromJson(i)).toList();

    var mostPopularArticles = json["mostPopularArticles"] as List;
    List<PreviewEntityI> mostPopularArticlesList = mostPopularArticles.map((i) => PreviewEntityI.fromJson(i)).toList();
    return MainScreenData(
      newestArticles: newestArticlesList,
      mostPopularArticles: mostPopularArticlesList,
    );
  }
}