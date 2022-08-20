import 'package:witcher_guide/enums/index.dart';
import 'package:witcher_guide/models/ImageModel.dart';

class PreviewEntityModel {
  String id;
  String name;
  EntityType type;
  List<ImageModel> images;

  PreviewEntityModel(
      {required this.id,
      required this.images,
      required this.name,
      required this.type});

  factory PreviewEntityModel.fromJson(Map<String, dynamic> json) {
    var list = json["images"] as List;
    List<ImageModel> imagesList =
        list.map((i) => ImageModel.fromJson(i)).toList();
    return PreviewEntityModel(
      id: json["id"],
      name: json["name"],
      type: EntityType.values.firstWhere((element) => element.name == json["type"]),
      images: imagesList,
    );
  }
}
