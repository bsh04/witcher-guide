import 'package:witcher_guide/models/ImageModel.dart';

class PreviewEntityModel {
  String id;
  String name;
  List<ImageModel> images;

  PreviewEntityModel({required this.id, required this.images, required this.name});

  factory PreviewEntityModel.fromJson(Map<String, dynamic> json) {
    var list = json["images"] as List;
    List<ImageModel> imagesList = list.map((i) => ImageModel.fromJson(i)).toList();
    return PreviewEntityModel(
      id: json["id"],
      name: json["name"],
      images: imagesList,
    );
  }
}