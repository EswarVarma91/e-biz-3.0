class HotelRequestByTId{
  String travellerName;
  String u_grade;
  String hotel_his_location;
  String hotel_his_check_in;
  String hotel_his_check_out;
  double hotel_his_rating;
  String hotel_his_name;
  String hotel_his_address;
  String hotel_his_purpose;
  String proj_oano;
  String hotel_created_by;
  String approved_by;
  String hotel_cancelled_by;
  double hotel_cancelled_charges;
  String hotel_cancelled_payment_mode;
  String hotel_cancelled_source;
  int approved_status;

  HotelRequestByTId(this.travellerName,this.u_grade,this.hotel_his_location,this.hotel_his_check_in,this.hotel_his_check_out,this.hotel_his_rating,this.hotel_his_name,this.hotel_his_address,
  this.hotel_his_purpose,this.proj_oano,this.hotel_created_by,this.hotel_cancelled_by,this.hotel_cancelled_charges,this.hotel_cancelled_payment_mode,this.hotel_cancelled_source,this.approved_by,
  this.approved_status);

    HotelRequestByTId.fromJson(Map<String, dynamic> json)
      : travellerName = json['travellerName'],
        u_grade = json['u_grade'],
        hotel_his_location = json['hotel_location'],
        hotel_his_check_in = json['hotel_check_in'],
        hotel_his_check_out = json['hotel_check_out'],
        hotel_his_rating = json['hotel_rating'],
        hotel_his_name = json['hotel_his_name'],
        hotel_his_address = json['hotel_his_address'],
        hotel_his_purpose = json['hotel_purpose'],
        proj_oano = json['proj_oano'],
        hotel_created_by = json['hotel_created_by'],
        hotel_cancelled_by = json['hotel_cancelled_by'],
        hotel_cancelled_charges = json['hotel_cancelled_charges'],
        hotel_cancelled_payment_mode = json['hotel_cancelled_payment_mode'],
        hotel_cancelled_source = json['hotel_cancelled_source'],
        approved_by = json['approved_by'],
        approved_status=json['approved_status'];
}