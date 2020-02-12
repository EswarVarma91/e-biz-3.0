class SalesIndustrialEntryModel {
  int s_id;
  String entry_time;
  String exit_time;
  String created_date;
  String company_name;
  String u_id;
  int status;

  SalesIndustrialEntryModel(this.s_id, this.entry_time, this.exit_time,this.company_name,this.created_date,this.u_id,this.status);

  SalesIndustrialEntryModel.fromJson(Map<String, dynamic> json)
      : s_id = json['s_id'],
        entry_time = json['entry_time'],
        exit_time = json['exit_time'],
        company_name = json['company_name'],
        created_date = json['created_date'],
        status = json['status'],
        u_id=json['u_id'];
}
