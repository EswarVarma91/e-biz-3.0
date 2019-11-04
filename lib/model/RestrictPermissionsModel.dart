class RestrictPermissionsModel {
  int status;

  RestrictPermissionsModel(this.status);

  RestrictPermissionsModel.fromJson(Map<String, dynamic> json)
      : status = json['cnt'];


  Map<String, dynamic> toJson() =>
      {
        'cnt': status,
      };
}
