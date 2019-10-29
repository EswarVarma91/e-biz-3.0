class AttendanceServiceModel {
  final String out_time;
  final String in_time;
  final String att_tour_status;

  AttendanceServiceModel(this.out_time,this.in_time,this.att_tour_status,);

  AttendanceServiceModel.fromJson(Map<String, dynamic> json)
      : out_time = json['out_time'],
       in_time = json['in_time'],
       att_tour_status = json['att_tour_status'];

  Map<String, dynamic> toJson() =>
      {
        'out_time': out_time,
        'in_time': in_time,
        'att_tour_status': att_tour_status,
      };
}