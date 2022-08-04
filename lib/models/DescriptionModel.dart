class DescriptionModel {
  String? title;
  String content;

  DescriptionModel({required this.content, this.title});

  factory DescriptionModel.fromJson(Map<String, dynamic> json) {
    return DescriptionModel(
      content: json["content"],
      title: json["title"],
    );
  }
}