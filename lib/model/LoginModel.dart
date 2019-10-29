class LoginModel {
  final  int cnt;
   final int uId;
   final  int uEmpCode;
   final  String fullName;
   final  String profileName;
   final  String downTeamIds;
  final String userId;

  LoginModel(this.cnt, this.uId, this.uEmpCode, this.fullName, this.profileName, this.downTeamIds,this.userId);

  LoginModel.fromJson(Map<String, dynamic> json)
      : cnt = json['cnt'],
        uId = json['uId'],
        uEmpCode = json['uEmpCode'],
        fullName = json['fullName'],
        profileName = json['profileName'],
        downTeamIds = json['downTeamIds'],
        userId = json['userId'];

  Map<String, dynamic> toJson() =>
      {
        'cnt': cnt,
        'uId': uId,
        'uEmpCode': uEmpCode,
        'fullName': fullName,
        'profileName': profileName,
        'downTeamIds': downTeamIds,
        'userId': userId
      };
}