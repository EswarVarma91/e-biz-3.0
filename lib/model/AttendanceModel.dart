class AttendanceModel{
  int _id;
  String _user_id;
  String _starttime;
  String _startlat;
  String _startlong;
  String _endtime;
  String _endlat;
  String _endlong;
  String _work_status;
  String _date;

  AttendanceModel(this._user_id,this._starttime,this._startlat,this._startlong,this._endtime,this._endlat,this._endlong);



  Map<String,dynamic> toMap(){
    var map=<String,dynamic>{
      'id' : _id,
      'user_id' : _user_id,
      'starttime' : _starttime,
      'startlat' : _startlat,
      'startlong' : _startlong,
      'endtime' : _endtime,
      'endlat' : _endlat,
      'endlong' : _endlong,
      'work_status' : _work_status,
      'day' : _date,
    };
    return map;
  }

  AttendanceModel.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _user_id = map['user_id'];
    _starttime = map['starttime'];
    _startlat = map['startlat'];
    _startlong = map['startlong'];
    _endtime = map['endtime'];
    _endlat = map['endlat'];
    _endlong = map['endlong'];
    _work_status = map['work_status'];
    _date = map['date'];
  }

  AttendanceModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _user_id = json['user_id'],
        _starttime = json['starttime'],
        _startlat = json['startlat'],
        _startlong = json['startlong'],
        _endtime = json['endtime'],
        _endlat = json['endlat'],
        _endlong = json['endlong'],
        _work_status = json['work_status'],
        _date = json['date']
  ;


  AttendanceModel.map(dynamic obj) {
    this._id = obj['id'];
    this._user_id = obj['user_id'];
    this._starttime = obj['starttime'];
    this._startlat = obj['startlat'];
    this._startlong = obj['startlong'];
    this._endtime = obj['endtime'];
    this._endlat = obj['endlat'];
    this._endlong = obj['endlong'];
    this._date = obj['date'];
  }

  int get id => _id;
  String get user_id => _user_id;
  String get starttime => _starttime;
  String get startlat => _startlat;
  String get startlong => _startlong;
  String get endtime => _endtime;
  String get endlat => _endlat;
  String get endlong => _endlong;
  String get work_status => _work_status;
  String get date => _date;

}