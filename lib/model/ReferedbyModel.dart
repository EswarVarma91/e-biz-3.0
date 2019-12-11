class ReferedbyModel {
  int uId;
  String fullName;
  String u_emp_code;

  ReferedbyModel(this.uId, this.fullName, this.u_emp_code);

  ReferedbyModel.fromJson(Map<String, dynamic> json)
      : uId = json['u_id'],
        fullName = json['u_first_name'],
        u_emp_code = json['u_emp_code'];

  Map<String, dynamic> toJson() => {
        'u_id': uId,
        'u_first_name': fullName,
        'u_emp_code': u_emp_code,
      };
}
