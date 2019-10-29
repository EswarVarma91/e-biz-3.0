class StartAttendanceModel{
  String _user_id;
  String _starttime;
  String _startlat;
  String _startlong;
  String _date;

  StartAttendanceModel(this._user_id,this._starttime,this._startlat,this._startlong);

  Map<String,dynamic> toMap(){
    var map=<String,dynamic>{
      'user_id' : _user_id,
      'starttime' : _starttime,
      'startlat' : _startlat,
      'startlong' : _startlong,
      'day' : _date,
    };
    return map;
  }

  StartAttendanceModel.fromMap(Map<String, dynamic> map) {
    _user_id = map['user_id'];
    _starttime = map['starttime'];
    _startlat = map['startlat'];
    _startlong = map['startlong'];
    _date = map['date'];
  }

  StartAttendanceModel.fromJson(Map<String, dynamic> json)
       : _user_id = json['user_id'],
        _starttime = json['starttime'],
        _startlat = json['startlat'],
        _startlong = json['startlong'],
        _date = json['date'];


  StartAttendanceModel.map(dynamic obj) {
    this._user_id = obj['user_id'];
    this._starttime = obj['starttime'];
    this._startlat = obj['startlat'];
    this._startlong = obj['startlong'];
    this._date = obj['date'];
  }
  String get user_id => _user_id;
  String get starttime => _starttime;
  String get startlat => _startlat;
  String get startlong => _startlong;
  String get date => _date;

}