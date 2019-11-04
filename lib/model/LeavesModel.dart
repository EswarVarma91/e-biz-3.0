class LeavesModel {
  double el_noofdays;
  String el_reason;
  String el_from_date;
  int el_id;
  int u_id;
  String el_to_date;
  String leave_type;
  int el_status;
  String fullname;
  String el_approved_date;
  String el_modified_date;
  String el_modified_by;
  String el_approvedby;

  LeavesModel(this.el_noofdays, this.el_reason,this.el_from_date,this.el_id,
      this.u_id,this.el_to_date,this.leave_type, this.el_status,this.fullname,this.el_modified_date,
      this.el_approved_date,this.el_approvedby,this.el_modified_by);

  LeavesModel.fromJson(Map<String, dynamic> json)
      : el_noofdays = json['el_noofdays'],
        el_reason = json['el_reason'],
        el_from_date = json['el_from_date'],
        el_id = json['el_id'],
        u_id = json['u_id'],
        el_to_date = json['el_to_date'],
        leave_type = json['leave_type'],
        el_status = json['el_status'],
        fullname = json['fullname'],
        el_approved_date = json['el_approved_date'],
        el_modified_date = json['el_modified_date'],
        el_modified_by = json['el_modified_by'],
        el_approvedby = json['el_approved_by']
  ;


  Map<String, dynamic> toJson() =>
      {
        'el_noofdays':el_noofdays,
        'el_reason':el_reason ,
        'el_from_date': el_from_date ,
        'el_id':el_id ,
        'u_id': u_id ,
        'el_to_date': el_to_date ,
        'leave_type': leave_type ,
        'el_status': el_status,
        'fullname': fullname,
        'el_approved_date': el_approved_date,
        'el_modified_date': el_modified_date,
        'el_modified_by': el_modified_by,
        'el_approved_by': el_approvedby,
      };
}
