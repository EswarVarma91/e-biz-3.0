class FirebaseUserModel {
  String token;

  FirebaseUserModel(this.token);

  FirebaseUserModel.fromJson(Map<String, dynamic> json)
      : token = json['token'];

  Map<String, dynamic> toJson() => {
        'token': token,
      };
}
