class HotelRequestModel {
  int hotel_id;
  String hotel_ref_no;
  String proj_oano;
  String travellerName;
  double hotel_rating;
  String hotel_location;
  String hotel_check_in;
  String hotel_check_out;
  String hotel_purpose;
  int hotel_status;
  int hotel_is_cancelled;
  int approved_status;
  int hotel_is_cancel_req;
  int u_id;

  HotelRequestModel(
      this.hotel_id,
      this.hotel_ref_no,
      this.proj_oano,
      this.travellerName,
      this.hotel_rating,
      this.hotel_location,
      this.hotel_check_in,
      this.hotel_check_out,
      this.hotel_purpose,
      this.hotel_status,
      this.approved_status,
      this.hotel_is_cancelled,
      this.u_id,
      this.hotel_is_cancel_req);

  HotelRequestModel.fromJson(Map<String, dynamic> json)
      : hotel_id = json['hotel_id'],
        hotel_ref_no = json['hotel_ref_no'],
        proj_oano = json['proj_oano'],
        travellerName = json['travellerName'],
        hotel_rating = json['hotel_rating'],
        hotel_location = json['hotel_location'],
        hotel_check_in = json['hotel_check_in'],
        hotel_check_out = json['hotel_check_out'],
        hotel_purpose = json['hotel_purpose'],
        hotel_status = json['hotel_status'],
        hotel_is_cancelled = json['hotel_is_cancelled'],
        approved_status = json['approved_status'],
        hotel_is_cancel_req = json['hotel_is_cancel_req'],
        u_id = json['u_id'];

  HotelRequestModel.fromMap(Map<String, dynamic> map) {
    hotel_id = map['hotel_id'];
        hotel_ref_no = map['hotel_ref_no'];
        proj_oano = map['proj_oano'];
        travellerName = map['travellerName'];
        hotel_rating = map['hotel_rating'];
        hotel_location = map['hotel_location'];
        hotel_check_in = map['hotel_check_in'];
        hotel_check_out = map['hotel_check_out'];
        hotel_purpose = map['hotel_purpose'];
        hotel_status = map['hotel_status'];
        hotel_is_cancelled = map['hotel_is_cancelled'];
        approved_status = map['approved_status'];
        hotel_is_cancel_req = map['hotel_is_cancel_req'];
        u_id = map['u_id'];
  }
}
