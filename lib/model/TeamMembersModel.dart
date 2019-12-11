class TeamMembersModel {
  int u_id;
  String u_emp_code;
  String FullName;
  String u_email;
  int WorkStatus;

  TeamMembersModel(
      this.u_id, this.u_emp_code, this.FullName, this.u_email, this.WorkStatus);

  TeamMembersModel.fromJson(Map<String, dynamic> json)
      : u_id = json['u_id'],
        u_emp_code = json['u_emp_code'],
        u_email = json['u_email'],
        WorkStatus = json['WorkStatus'],
        FullName = json['u_first_name'];

  Map<String, dynamic> toJson() => {
        'u_id': u_id,
        'u_emp_code': u_emp_code,
        'u_email': u_email,
        'u_first_name': FullName,
        'WorkStatus': WorkStatus,
      };
}
