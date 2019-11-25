class FirebaseModel {
  String reporting;

  FirebaseModel(this.reporting);

  FirebaseModel.fromJson(Map<String, dynamic> json)
      : reporting = json['reporting'];

  Map<String, dynamic> toJson() => {
        'reporting': reporting,
      };
}
