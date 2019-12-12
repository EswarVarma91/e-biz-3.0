class LoginModel {
  final int cnt, uId, hrCnt, travelCnt, salesCnt, fixedTerm, branchid;
  final String fullName,uEmpCode,
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
      this.designation,
      this.fixedTerm);

  LoginModel.fromJson(Map<String, dynamic> json)
      : cnt = json['cnt'],
        uId = json['userId'],
        uEmpCode = json['empCode'],
        hrCnt = json['hrCnt'],
        travelCnt = json['travelCnt'],
        salesCnt = json['salesCnt'],
        fullName = json['empFullName'],
        profileName = json['empProfileName'],
        downTeamIds = json['empDepartment'],
        mobileNumber = json['mobileNumber'],
        branchid = json['brnachId'],
        emailId = json['empEmail'],
        department = json['empDepartment'],
        designation = json['empDepartment'],
        fixedTerm = json['fixedTerm'];

  Map<String, dynamic> toJson() => {
        'cnt': cnt,
        'uId': uId,
        'uEmpCode': uEmpCode,
        'hrCnt': hrCnt,
        'travelCnt': travelCnt,
        'salesCnt': salesCnt,
        'fullName': fullName,
        'profileName': profileName,
        'downTeamIds': downTeamIds,
        'mobileNumber': mobileNumber,
        'branchId': branchid,
        'emailId': emailId,
        'department': department,
        'designation': designation,
        'fixedTerm': fixedTerm,
      };
}
