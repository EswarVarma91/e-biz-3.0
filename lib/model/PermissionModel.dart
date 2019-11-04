class PermissionModel {
  String per_from_time;
  String per_to_time;
  String per_date;
  String per_fullName;
  int per_status;
  int per_id;
  String per_purpose;
  String per_type;
  String per_created_by;
  String per_modified_by;
  String per_modified_date;
  String per_approved_by;
  String per_approved_date;
  String per_is_approved;
  int u_id;

  PermissionModel(this.per_from_time, this.per_to_time,this.per_date,this.per_fullName,
      this.per_status,this.per_id,this.per_purpose, this.per_type,this.per_created_by,
      this.u_id,this.per_approved_by,
      this.per_approved_date,this.per_is_approved,this.per_modified_by,this.per_modified_date);

  PermissionModel.fromJson(Map<String, dynamic> json)
      : per_from_time = json['per_from_time'],
        per_to_time = json['per_to_time'],
        per_date = json['per_date'],
        per_fullName = json['FUllname'],
        per_status = json['per_status'],
        per_id = json['per_id'],
        per_purpose = json['per_purpose'],
        per_type = json['per_type'],
        u_id = json['u_id'],
        per_approved_by = json['per_approved_by'],
        per_is_approved = json['per_is_approved'],
        per_modified_by = json['per_modified_by'],
        per_modified_date = json['per_modified_date'],
        per_approved_date = json['per_approved_date'],
        per_created_by = json['per_created_by'];

  Map<String, dynamic> toJson() => {
        'per_from_time':per_from_time,
        'per_to_time':per_to_time ,
        'per_date': per_date ,
        'FUllname':per_fullName ,
        'per_status': per_status ,
        'per_id': per_id ,
        'per_purpose': per_purpose ,
        'per_type': per_type,
        'per_created_by': per_created_by,
        'u_id': u_id,
        'per_approved_by': per_approved_by,
        'per_is_approved': per_is_approved,
        'per_modified_by': per_modified_by,
        'per_approved_date': per_approved_date,
        'per_modified_date': per_modified_date,
      };
}
