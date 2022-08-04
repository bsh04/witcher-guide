import 'package:witcher_guide/models/PreviewEntityModel.dart';

class MainScreenData {
  List<PreviewEntityModel> mostPopularArticles = [];
  List<PreviewEntityModel> newestArticles = [];
  List<PreviewEntityModel> allArticles = [];

  MainScreenData({required this.mostPopularArticles, required this.newestArticles, required this.allArticles});

  factory MainScreenData.fromJson(Map<String, dynamic> json) {
    var newestArticles = json["newestArticles"] as List;
    List<PreviewEntityModel> newestArticlesList = newestArticles.map((i) => PreviewEntityModel.fromJson(i)).toList();

    var mostPopularArticles = json["mostPopularArticles"] as List;
    List<PreviewEntityModel> mostPopularArticlesList = mostPopularArticles.map((i) => PreviewEntityModel.fromJson(i)).toList();

    var allArticles = json["allArticles"] as List;
    List<PreviewEntityModel> allArticlesList = allArticles.map((i) => PreviewEntityModel.fromJson(i)).toList();

    return MainScreenData(
      newestArticles: newestArticlesList,
      mostPopularArticles: mostPopularArticlesList,
      allArticles: allArticlesList,
    );
  }
}