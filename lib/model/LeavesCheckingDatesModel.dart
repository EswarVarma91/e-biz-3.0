class LeavesCheckingDatesModel {
  String elc_date;

  LeavesCheckingDatesModel(this.elc_date);

  LeavesCheckingDatesModel.fromJson(Map<String, dynamic> json)
      : elc_date = json['elc_date'];

  Map<String, dynamic> toJson() => {
        'elc_date': elc_date,
      };
}
