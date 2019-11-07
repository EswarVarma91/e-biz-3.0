class LeavesCountModel{
  String cal;
  String cl;
  String co;
  String ml;
  String sl;

  LeavesCountModel(this.cal,this.cl,this.co,this.ml,this.sl);

  LeavesCountModel.fromJson(Map<String, dynamic> json)
      : cal = json['CAL'],
        cl = json['CL'],
        co = json['CO'],
        ml = json['ML'],
        sl = json['SL'];


  Map<String, dynamic> toJson() =>
      {
        'CAL': cal,
        'CL': cl,
        'CO': co,
        'ML': ml,
        'SL': sl,
      };

}