class ProjectListModel {
  int project_id;
  String proj_name;
  String proj_oano;
  String ref_type;
  String proj_client_name;

  ProjectListModel(this.project_id, this.proj_name, this.proj_oano,this.ref_type,this.proj_client_name);

  ProjectListModel.fromJson(Map<String, dynamic> json)
      : project_id = json['project_id'],
        proj_name = json['proj_name'],
        proj_oano = json['proj_oano'],
        proj_client_name = json['proj_client_name'],
        ref_type= json['refType'];

  Map<String, dynamic> toJson() => {
        'project_id': project_id,
        'proj_name': proj_name,
        'proj_oano': proj_oano,
        'refType': ref_type,
        'proj_client_name':proj_client_name,
      };
}
