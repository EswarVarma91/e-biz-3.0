class ResourcesModel {
  String u_id;
  String pteam_type;
  String memberName;

  ResourcesModel(this.u_id, this.pteam_type,this.memberName);

  ResourcesModel.fromJson(Map<String, dynamic> json)
      : u_id = json['u_id'],
        pteam_type = json['pteam_type'],
        memberName = json['memberName'];


  Map<String, dynamic> toJson() =>
      {
        'u_id': u_id,
        'pteam_type': pteam_type,
        'memberName': memberName,
      };
}
