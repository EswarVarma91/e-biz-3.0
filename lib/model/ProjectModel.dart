class ProjectModel {
  String project_id;
  String proj_name;
  String proj_oano;

  ProjectModel(this.project_id, this.proj_name,this.proj_oano);

  ProjectModel.fromJson(Map<String, dynamic> json)
      : project_id = json['project_id'],
        proj_name = json['proj_name'],
        proj_oano = json['proj_oano'];


  Map<String, dynamic> toJson() =>
      {
        'project_id': project_id,
        'proj_name': proj_name,
        'proj_oano': proj_oano,
      };
}
