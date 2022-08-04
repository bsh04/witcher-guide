import 'package:witcher_guide/models/BaseEntityModel.dart';
import 'package:witcher_guide/models/DescriptionModel.dart';
import 'package:witcher_guide/models/ImageModel.dart';
import 'package:witcher_guide/models/UserModel.dart';

class CharacterModel {
  String id;
  String name;
  int viewCount;
  int created;
  UserModel creator;
  List<ImageModel> images;
  List<DescriptionModel> description;

  CharacterModel({
    required this.id,
    required this.name,
    required this.created,
    required this.creator,
    required this.viewCount,
    required this.images,
    required this.description,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    var imagesL = json["images"] as List;
    List<ImageModel> imagesList =
        imagesL.map((i) => ImageModel.fromJson(i)).toList();

    var descriptionL = json["description"] as List;
    List<DescriptionModel> descriptionsList =
        descriptionL.map((i) => DescriptionModel.fromJson(i)).toList();
    return CharacterModel(
        id: json["id"],
        name: json["name"],
        viewCount: json["viewCount"],
        images: imagesList,
        created: json["created"],
        creator: UserModel.fromJson(json["creator"]),
        description: descriptionsList);
  }
}
