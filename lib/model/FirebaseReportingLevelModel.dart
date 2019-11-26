class FirebaseReportingLevelModel {
  String reporting;

  FirebaseReportingLevelModel(this.reporting);

  FirebaseReportingLevelModel.fromJson(Map<String, dynamic> json)
      : reporting = json['reporting'];

  Map<String, dynamic> toJson() => {
        'reporting': reporting,
      };
}
