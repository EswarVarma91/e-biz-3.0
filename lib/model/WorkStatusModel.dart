class WorkStatusModel {
  String _user_id = "-";
  String _workstatus = "-";

  WorkStatusModel(this._user_id, this._workstatus);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'user_id': _user_id,
      'workstatus': _workstatus,
    };
    return map;
  }

  WorkStatusModel.fromMap(Map<String, dynamic> map) {
    _user_id = map['user_id'];
    _workstatus = map['workstatus'];
  }

  WorkStatusModel.fromJson(Map<String, dynamic> json)
      : _user_id = json['user_id'],
        _workstatus = json['workstatus'];

  WorkStatusModel.map(dynamic obj) {
    this._user_id = obj['user_id'];
    this._workstatus = obj['workstatus'];
  }

  String get user_id => _user_id;
  String get workstatus => _workstatus;
}
