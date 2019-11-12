class TravelRequestListModel{
  int tra_id;
  String reqNo;
  String proj_oano;
  String fullName;
  String tra_from;
  String tra_to;
  String journeyDate;
  String tra_purpose;
  int tra_status;

  TravelRequestListModel(this.reqNo,this.proj_oano,this.fullName,this.tra_from,this.tra_to,this.journeyDate,this.tra_purpose,this.tra_status);
  
  TravelRequestListModel.fromJson(Map<String, dynamic> json)
      : tra_id = json['tra_id'],
        reqNo = json['tra_req_no'],
        proj_oano = json['proj_oano'],
        fullName = json['fullName'],
        tra_from = json['tra_from'],
        tra_to = json['tra_to'],
        journeyDate = json['journeyDate'],
        tra_purpose = json['tra_purpose'],
        tra_status = json['tra_status'];
}