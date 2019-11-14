class TravelCodesModel {
int stationId;
String stationCode;

  TravelCodesModel(this.stationId,this.stationCode);

  TravelCodesModel.fromJson(Map<String, dynamic> json)
      : stationId = json['stationId'],
        stationCode = json['stationCode'];
}
