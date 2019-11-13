class TravelHistoryModel{
String fullName,tra_from,tra_to,tra_class,tra_journey_date,tra_purpose,tra_mode,
tra_mode_type,tra_tck_class,proj_oano,u_grade,tra_required_datetime,
tra_tck_quota,tra_tck_info,tra_tck_seat_no,tra_tck_pnr,tra_tck_payment_mode,tra_tck_card_no,tra_tck_booking_status,tckVersion;

double tra_tck_cost,tra_tck_tax,tra_tck_other_charges,tra_tck_total;



TravelHistoryModel(this.fullName,this.tra_from,this.tra_to,this.tra_class,this.tra_journey_date,this.tra_purpose,this.tra_mode,this.tra_required_datetime,
this.tra_mode_type,this.tra_tck_class,this.proj_oano,this.u_grade,this.tra_tck_booking_status,this.tra_tck_card_no,this.tra_tck_cost,
this.tra_tck_info,this.tra_tck_other_charges,this.tra_tck_payment_mode,this.tra_tck_pnr,this.tra_tck_quota,this.tra_tck_seat_no,this.tra_tck_tax,
this.tra_tck_total,this.tckVersion);

  TravelHistoryModel.fromJson(Map<String, dynamic> json)
      : fullName = json['fullName'],
        tra_from = json['tra_from'],
        u_grade = json['u_grade'],
        tra_to = json['tra_to'],
        tra_class = json['tra_class'],
        tra_journey_date = json['journeyDate'],
        tra_required_datetime = json['requiredDateTime'],
        tra_purpose = json['tra_purpose'],
        tra_mode = json['tra_mode'],
        tra_mode_type = json['tra_mode_type'],
        tra_tck_class = json['tra_tck_class'],
        tra_tck_quota = json['tra_tck_quota'],
        tra_tck_info = json['tra_tck_info'],
        tra_tck_seat_no = json['tra_tck_seat_no'],
        tra_tck_pnr = json['tra_tck_pnr'],
        tra_tck_payment_mode = json['tra_tck_payment_mode'],
        tra_tck_card_no = json['tra_tck_card_no'],
        tra_tck_booking_status = json['tra_tck_booking_status'],
        tra_tck_cost = json['tra_tck_cost'],
        tra_tck_tax = json['tra_tck_tax'],
        tra_tck_other_charges = json['tra_tck_other_charges'],
        tra_tck_total = json['tra_tck_total'],
        tckVersion = json['tckVersion']
        ;
        

}