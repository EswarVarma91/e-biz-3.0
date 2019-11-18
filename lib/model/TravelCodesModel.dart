class TravelCodesModel {
int stationId;
String stationCode;
String stationName;

  TravelCodesModel(this.stationId,this.stationCode,this.stationName);

  TravelCodesModel.fromJson(Map<String, dynamic> json)
      : stationId = json['stationId'],
        stationCode = json['stationCode'],
        stationName = json['stationName'];
}
