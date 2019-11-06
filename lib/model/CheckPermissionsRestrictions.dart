class CheckPermissionRestrictions {
  int dayPerCnt;
  int monthPerCnt;

  CheckPermissionRestrictions(this.dayPerCnt,this.monthPerCnt);

  CheckPermissionRestrictions.fromJson(Map<String, dynamic> json)
      : dayPerCnt = json['dayPerCnt'],
        monthPerCnt = json['monthPerCnt'];


  Map<String, dynamic> toJson() =>
      {
        'dayPerCnt': dayPerCnt,
        'monthPerCnt': monthPerCnt,
      };
}
