class UserModel {
  String id;
  String login;
  String? token;

  UserModel({required this.id, required this.login, token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      login: json["login"],
      token: json["token"],
    );
  }
}