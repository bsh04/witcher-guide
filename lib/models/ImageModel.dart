class ImageModel {
  String id;
  String name;
  String type;

  ImageModel({required this.id, required this.name, required this.type});

  fullFileName() {
    return id + "." + type;
  }

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
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