class LateEarlyComingModel {
  String att_actual_day_count;
  String att_out_time;
  String att_work_status;
  String att_request_date;
  String att_date;
  String att_actual_paid_count;
  String tl_approval;
  String leastTime;
  int att_id;
  String att_request_remarks;
  String att_tour_out_time;
  String u_emp_code;
  String att_request_type;
  String att_tour_in_time;
  String att_in_time;
  String att_request_by;
  String hr_approval;
  String bt_out_time;

//  LateEarlyComingModel(this.att_actual_day_count, this.att_out_time,this.att_work_status,this.att_request_date);

  LateEarlyComingModel.fromJson(Map<String, dynamic> json)
      : att_actual_day_count = json['att_actual_day_count'],
        att_out_time = json['att_out_time'],
        att_work_status = json['att_actual_work_status'],
        att_request_date = json['att_request_date'],
        att_date = json['att_date'],
        att_actual_paid_count = json['att_actual_paid_count'],
        tl_approval = json['tl_approval'],
        leastTime = json['leastTime'],
        att_id = json['att_id'],
        att_request_remarks = json['att_request_remarks'],
        att_tour_out_time = json['att_tour_out_time'],
        u_emp_code = json['u_emp_code'],
        att_request_type = json['att_request_type'],
        att_tour_in_time = json['att_tour_in_time'],
        att_in_time = json['att_in_time'],
        att_request_by = json['att_request_by'],
        hr_approval = json['hr_approval'],
        bt_out_time = json['bt_out_time'];
}
