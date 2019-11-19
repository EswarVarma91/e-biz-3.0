class DownTeamMembersModel {
  int u_id;
  String FullName;

  DownTeamMembersModel(
      this.u_id,this.FullName,);

  DownTeamMembersModel.fromJson(Map<String, dynamic> json)
      : u_id = json['u_id'],
        FullName = json['fullName'];

  Map<String, dynamic> toJson() => {
        'u_id': u_id,
        'fullName': FullName,
      };
}
