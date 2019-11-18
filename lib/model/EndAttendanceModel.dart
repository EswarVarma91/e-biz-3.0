class EndAttendanceModel {
  String _user_id;
  String _endtime;
  String _endlat;
  String _endlong;
  String _date;

  EndAttendanceModel(this._user_id, this._endtime, this._endlat, this._endlong);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'user_id': _user_id,
      'endtime': _endtime,
      'endlat': _endlat,
      'endlong': _endlong,
      'day': _date,
    };
    return map;
  }

  EndAttendanceModel.fromMap(Map<String, dynamic> map) {
    _user_id = map['user_id'];
    _endtime = map['endtime'];
    _endlat = map['endlat'];
    _endlong = map['endlong'];
    _date = map['date'];
  }

  EndAttendanceModel.fromJson(Map<String, dynamic> json)
      : _user_id = json['user_id'],
        _endtime = json['endtime'],
        _endlat = json['endlat'],
        _endlong = json['endlong'],
        _date = json['date'];

  EndAttendanceModel.map(dynamic obj) {
    this._user_id = obj['user_id'];
    this._endtime = obj['endtime'];
    this._endlat = obj['endlat'];
    this._endlong = obj['endlong'];
    this._date = obj['date'];
  }

  String get user_id => _user_id;
  String get endtime => _endtime;
  String get endlat => _endlat;
  String get endlong => _endlong;
  String get date => _date;
}
