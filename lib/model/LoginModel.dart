class LoginModel {
   final  int count;
   final int userId;
   final  String empCode;
   final  String departmentName;
   final  String designation;
   final  String fullName;
   final  String profileName;
   final  String downTeamId;

  LoginModel(this.count, this.userId, this.empCode, this.departmentName, this.designation, this.fullName, this.profileName, this.downTeamId);

  LoginModel.fromJson(Map<String, dynamic> json)
      : count = json['count'],
        userId = json['userId'],
        empCode = json['empCode'],
        departmentName = json['departmentName'],
        designation = json['designation'],
        fullName = json['fullName'],
        profileName = json['profileName'],
        downTeamId = json['downTeamId'];

  Map<String, dynamic> toJson() =>
      {
        'count': count,
        'userId': userId,
        'empCode': empCode,
        'departmentName': departmentName,
        'designation': designation,
        'fullName': fullName,
        'profileName': profileName,
        'downTeamId': downTeamId
      };
}