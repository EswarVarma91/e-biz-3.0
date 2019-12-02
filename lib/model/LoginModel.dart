class LoginModel {
  final int cnt, uId, uEmpCode,hrCnt,travelCnt,salesCnt,branchid;
  final String fullName,
      profileName,
      downTeamIds,
      mobileNumber,
      emailId,
      department,
      designation;

  LoginModel(
      this.cnt,
      this.uId,
      this.uEmpCode,
      this.hrCnt,
      this.travelCnt,
      this.salesCnt,
      this.fullName,
      this.profileName,
      this.downTeamIds,
      this.mobileNumber,
      this.branchid,
      this.emailId,
      this.department,
      this.designation);

  LoginModel.fromJson(Map<String, dynamic> json)
      : cnt = json['cnt'],
        uId = json['uId'],
        uEmpCode = json['uEmpCode'],
        hrCnt = json['hrCnt'],
        travelCnt = json['travelCnt'],
        salesCnt = json['salesCnt'],
        fullName = json['fullName'],
        profileName = json['profileName'],
        downTeamIds = json['downTeamIds'],
        mobileNumber = json['mobileNumber'],
        branchid = json['branchid'],
        emailId = json['emailId'],
        department = json['department'],
        designation = json['designation'];

  Map<String, dynamic> toJson() => {
        'cnt': cnt,
        'uId': uId,
        'uEmpCode': uEmpCode,
        'hrCnt':hrCnt,
        'travelCnt':travelCnt,
        'salesCnt':salesCnt,
        'fullName': fullName,
        'profileName': profileName,
        'downTeamIds': downTeamIds,
        'mobileNumber': mobileNumber,
        'branchId': branchid,
        'emailId': emailId,
        'department': department,
        'designation': designation,
      };
}
