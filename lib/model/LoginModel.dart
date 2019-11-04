class LoginModel {
  final  int cnt;
  final int uId;
  final  int uEmpCode;
  final  String fullName;
  final  String profileName;
  final  String downTeamIds;
  final String mobileNumber;

  LoginModel(this.cnt, this.uId, this.uEmpCode, this.fullName, this.profileName, this.downTeamIds,this.mobileNumber);

  LoginModel.fromJson(Map<String, dynamic> json)
      : cnt = json['cnt'],
        uId = json['uId'],
        uEmpCode = json['uEmpCode'],
        fullName = json['fullName'],
        profileName = json['profileName'],
        downTeamIds = json['downTeamIds'],
        mobileNumber = json['mobileNumber'];

  Map<String, dynamic> toJson() =>
      {
        'cnt': cnt,
        'uId': uId,
        'uEmpCode': uEmpCode,
        'fullName': fullName,
        'profileName': profileName,
        'downTeamIds': downTeamIds,
        'mobileNumber': mobileNumber
      };
}