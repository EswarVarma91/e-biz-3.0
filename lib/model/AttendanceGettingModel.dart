class AttendanceGettingModel{
  int _id;
  String _user_id;
  String _starttime;
  String _endtime;

  AttendanceGettingModel(this._user_id,this._starttime,this._endtime);

  Map<String,dynamic> toMap(){
    var map=<String,dynamic>{
      'id' : _id,
      'user_id' : _user_id,
      'starttime' : _starttime,
      'endtime' : _endtime,
    };
    return map;
  }

  AttendanceGettingModel.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _user_id = map['user_id'];
    _starttime = map['starttime'];
    _endtime = map['endtime'];
  }

  AttendanceGettingModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _user_id = json['user_id'],
        _starttime = json['starttime'],
        _endtime = json['endtime']
  ;


  AttendanceGettingModel.map(dynamic obj) {
    this._id = obj['id'];
    this._user_id = obj['user_id'];
    this._starttime = obj['starttime'];
    this._endtime = obj['endtime'];
  }

  int get id => _id;
  String get user_id => _user_id;
  String get starttime => _starttime;
  String get endtime => _endtime;

}