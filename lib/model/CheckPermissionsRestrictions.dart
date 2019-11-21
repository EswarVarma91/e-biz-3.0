class CheckPermissionRestrictions {
  int dayPerCnt;
  int monthPerCnt;
  int checkTime;

  CheckPermissionRestrictions(this.dayPerCnt, this.monthPerCnt,this.checkTime);

  CheckPermissionRestrictions.fromJson(Map<String, dynamic> json)
      : dayPerCnt = json['dayPerCnt'],
        monthPerCnt = json['monthPerCnt'],
        checkTime = json['checkTime'];

  Map<String, dynamic> toJson() => {
        'dayPerCnt': dayPerCnt,
        'monthPerCnt': monthPerCnt,
        'checkTime' : checkTime
      };
}
