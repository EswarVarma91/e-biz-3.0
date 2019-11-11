class TravelRequestListModel{
  String reqNo;
  String oaco;
  String fullName;
  String from;
  String to;
  String journeyDate;
  String purpose;
  int traStatus;

  TravelRequestListModel(this.reqNo,this.oaco,this.fullName,this.from,this.to,this.journeyDate,this.purpose,this.traStatus);

  TravelRequestListModel.fromJson(Map<String, dynamic> json)
      : reqNo = json['reqNo'],
        oaco = json['oaco'],
        fullName = json['fullName'],
        from = json['from'],
        to = json['to'],
        journeyDate = json['journeyDate'],
        purpose = json['purpose'],
        traStatus = json['traStatus'];
}