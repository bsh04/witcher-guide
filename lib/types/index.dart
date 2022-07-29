import 'dart:convert';

class PreviewEntityI {
  String id;
  String name;
  List<ImageI> images;

  PreviewEntityI({required this.id, required this.images, required this.name});

  factory PreviewEntityI.fromJson(Map<String, dynamic> json) {
    var list = json["images"] as List;
    List<ImageI> imagesList = list.map((i) => ImageI.fromJson(i)).toList();
    return PreviewEntityI(
      id: json["id"],
      name: json["name"],
      images: imagesList,
    );
  }
}

class EntityI {
  String id;
  String name;
  int viewCount;
  int created;
  UserI creator;
  List<ImageI>? images;
  List<DescriptionI>? description;

  EntityI(
      {required this.id,
      required this.name,
      required this.created,
      required this.creator,
      required this.viewCount,
      images,
      description});

  factory EntityI.fromJson(Map<String, dynamic> json) {
    List<ImageI> imagesList =
        json["images"].map((i) => ImageI.fromJson(i)).toList();
    List<DescriptionI> descriptionsList =
        json["description"].map((i) => DescriptionI.fromJson(i)).toList();
    return EntityI(
        id: json["id"],
        name: json["name"],
        viewCount: json["viewCount"],
        images: imagesList,
        created: json["created"],
        creator: UserI.fromJson(json["creator"]),
        description: descriptionsList);
  }
}

class CharacterI extends EntityI {
  CharacterI(
      {required String id,
      required String name,
      required int viewCount,
      required int created,
      required UserI creator,
      images,
      description})
      : super(
            id: id,
            name: name,
            created: created,
            creator: creator,
            viewCount: viewCount);

  factory CharacterI.fromJson(Map<String, dynamic> json) {
    List<ImageI> imagesList = List<ImageI>.from(
        (json["images"]).map((i) => ImageI.fromJson(i))).toList();

    List<DescriptionI> descriptionsList = (json["description"] as List)
        .map((i) => DescriptionI.fromJson(i))
        .toList();
    return CharacterI(
        id: json["id"],
        name: json["name"],
        viewCount: json["viewCount"],
        images: imagesList,
        created: json["created"],
        creator: UserI.fromJson(json["creator"]),
        description: descriptionsList);
  }
}

class UserI {
  String id;
  String login;
  String? token;

  UserI({required this.id, required this.login, token});

  factory UserI.fromJson(Map<String, dynamic> json) {
    return UserI(
      id: json["id"],
      login: json["login"],
      token: json["token"],
    );
  }
}

class ImageI {
  String id;
  String name;
  String type;

  ImageI({required this.id, required this.name, required this.type});

  fullFileName() {
    return id + "." + type;
  }

  factory ImageI.fromJson(Map<String, dynamic> json) {
    return ImageI(
      id: json["id"],
      name: json["name"],
      type: json["type"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "type": type,
    };
  }
}

class DescriptionI {
  String? title;
  String content;

  DescriptionI({required this.content, title});

  factory DescriptionI.fromJson(Map<String, dynamic> json) {
    return DescriptionI(
      content: json["content"],
      title: json["title"],
    );
  }
}
