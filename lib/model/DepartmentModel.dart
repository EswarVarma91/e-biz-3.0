class DepartmentModel {
  int dept_id;
  String dept_name;

  DepartmentModel(
      {this.dept_id,this.dept_name,});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      dept_id: json['dept_id'],
      dept_name: json['dept_name'],
    );
  }
}
