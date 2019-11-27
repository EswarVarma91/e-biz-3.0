class TaskListModel {
  int dp_id;
  int dp_status;
  int u_id;
  String dp_type;
  String dp_task;
  String dp_task_desc;
  String dp_given_by;
  String dp_created_by;
  String dp_created_date;
  String dpTaskType;
  int createdUid;
  String fullName;

  TaskListModel(
      this.dp_id,
      this.dp_status,
      this.dp_type,
      this.dp_task,
      this.dp_task_desc,
      this.dp_given_by,
      this.dp_created_by,
      this.dp_created_date,
      this.dpTaskType,
      this.fullName,
      this.createdUid,
      this.u_id);

  TaskListModel.fromJson(Map<String, dynamic> json)
      : dp_id = json['dp_id'],
        dp_status = json['dp_status'],
        dp_type = json['dp_type'],
        dp_task_desc = json['dp_task_desc'],
        dp_given_by = json['dp_given_by'],
        dp_created_date = json['dp_created_date'],
        dp_created_by = json['dp_created_by'],
        dp_task = json['dp_task'],
        dpTaskType = json['dp_task_type'],
        fullName = json['fullName'],
        createdUid = json['createdUid'],
        u_id = json["u_id"];

  Map<String, dynamic> toJson() => {
        'dp_id': dp_id,
        'dp_status': dp_status,
        'dp_type': dp_type,
        'dp_task_desc': dp_task_desc,
        'dp_task': dp_task,
        'dp_given_by': dp_given_by,
        'dp_created_date': dp_created_date,
        'dp_created_by': dp_created_by,
        'dp_task_type': dpTaskType,
        'fullName': fullName,
        'createdUid': createdUid,
        'u_id': u_id,
      };
}
