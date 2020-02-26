import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationModel {
  int uloc_id;
  String u_department;
  String u_profile_name;
  String lati;
  String longi;
  LatLng localCordinates;
  String created_date;
  String battery;

  LocationModel(
      {this.uloc_id,
      this.u_department,
      this.u_profile_name,
      this.localCordinates,
      this.created_date,this.battery});

  // factory LocationModel.fromJson(Map<String, dynamic> json) {
  //   return LocationModel(
  //     uloc_id: json['uloc_id'],
  //     u_department: json['u_department'],
  //     user_id: json['user_id'],
  //     u_profile_name: json['u_first_name'],
  //     lati:  json['lati'],
  //     longi: json['longi'],
  //     created_date: json['created_date'],
  //   );
  // }
}
