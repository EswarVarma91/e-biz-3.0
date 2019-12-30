class LocationModel {
  int uloc_id;
  String u_department;
  String user_id;
  String u_profile_name;
  String lati;
  String longi;
  String created_date;

  LocationModel(
      {this.uloc_id,
      this.u_department,
      this.user_id,
      this.u_profile_name,
      this.lati,
      this.longi,
      this.created_date});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      uloc_id: json['uloc_id'],
      u_department: json['u_department'],
      user_id: json['user_id'],
      u_profile_name: json['u_profile_name'],
      lati: json['lati'],
      longi: json['longi'],
      created_date: json['created_date'],
    );
  }
}
