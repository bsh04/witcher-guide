
import 'package:witcher_guide/models/DescriptionModel.dart';
import 'package:witcher_guide/models/ImageModel.dart';
import 'package:witcher_guide/models/UserModel.dart';

class BaseEntityModel {
  String id;
  String name;
  int viewCount;
  int created;
  UserModel creator;
  List<ImageModel>? images;
  List<DescriptionModel>? description;

  BaseEntityModel(
      {required this.id,
        required this.name,
        required this.created,
        required this.creator,
        required this.viewCount,
        images,
        description});

  factory BaseEntityModel.fromJson(Map<String, dynamic> json) {
    List<ImageModel> imagesList =
    json["images"].map((i) => ImageModel.fromJson(i)).toList();
    List<DescriptionModel> descriptionsList =
    json["description"].map((i) => DescriptionModel.fromJson(i)).toList();
    return BaseEntityModel(
        id: json["id"],
        name: json["name"],
        viewCount: json["viewCount"],
        images: imagesList,
        created: json["created"],
        creator: UserModel.fromJson(json["creator"]),
        description: descriptionsList);
  }
}