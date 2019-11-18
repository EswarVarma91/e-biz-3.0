class LeavesCheckingModel {
  String date;
  int workingStatus;
  String holidayStatus;

  LeavesCheckingModel(this.date, this.workingStatus, this.holidayStatus);

  LeavesCheckingModel.fromJson(Map<String, dynamic> json)
      : date = json['DATE'],
        workingStatus = json['WorkingStatus'],
        holidayStatus = json['HolidayStatus'];

  Map<String, dynamic> toJson() => {
        'DATE': date,
        'WorkingStatus': workingStatus,
        'HolidayStatus': holidayStatus,
      };
}
