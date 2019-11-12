class TravelRequestByTId{
String fullName,tra_from,tra_to,tra_class,tra_journey_date,tra_purpose,tra_mode,tra_mode_type,tra_tck_class,tckVersion,proj_oano,try_created_by,
approved_by,tra_cancelled_by,u_grade,tra_required_datetime;


TravelRequestByTId(this.fullName,this.tra_from,this.tra_to,this.tra_class,this.tra_journey_date,this.tra_purpose,this.tra_mode,this.tra_required_datetime,
this.tra_mode_type,this.tra_tck_class,this.tckVersion,this.proj_oano,this.try_created_by,this.approved_by,this.tra_cancelled_by,this.u_grade);

  TravelRequestByTId.fromJson(Map<String, dynamic> json)
      : fullName = json['fullName'],
        tra_from = json['tra_from'],
        u_grade = json['u_grade'],
        tra_to = json['tra_to'],
        tra_class = json['tra_class'],
        tra_journey_date = json['tra_journey_date'],
        tra_required_datetime = json['tra_required_datetime'],
        tra_purpose = json['tra_purpose'],
        tra_mode = json['tra_mode'],
        tra_mode_type = json['tra_mode_type'],
        tra_tck_class = json['tra_tck_class'],
        tckVersion = json['tckVersion'],
        proj_oano = json['proj_oano'],
        try_created_by = json['try_created_by'],
        approved_by = json['approved_by'],
        tra_cancelled_by = json['tra_cancelled_by'];

}