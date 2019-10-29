class RestrictPermissionsModel {
  String status;

  RestrictPermissionsModel(this.status);

  RestrictPermissionsModel.fromJson(Map<String, dynamic> json)
      : status = json['status'];


  Map<String, dynamic> toJson() =>
      {
        'status': status,
      };
}
