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

  HotelRequestModel(this.hotel_id,this.hotel_ref_no,this.proj_oano,this.travellerName,this.hotel_rating,this.hotel_location,
  this.hotel_check_in,this.hotel_check_out,this.hotel_purpose,this.hotel_status);

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
        hotel_status = json['hotel_status'];
}



  // String hotel_created_by;
  // String hotel_created_date;
  // String hotel_modified_by;
  // String hotel_modified_date;
  // int submit_status;
  // String submit_by;
  // String submit_date;
  // int approved_status;
  // String approved_by;
  // String approved_date;
  // int hotel_is_cancelled;
  // int hotel_cancelled_charges;
  // String hotel_cancelled_payment_mode;
  // String hotel_cancelled_source;
  // String hotel_cancelled_by;
  // String hotel_cancelled_date;