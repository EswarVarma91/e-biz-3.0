class PaidCountModel {
  final String paidCount;

  PaidCountModel(this.paidCount,);

  PaidCountModel.fromJson(Map<String, dynamic> json)
      : paidCount = json['paidCount'];

  Map<String, dynamic> toJson() =>
      {
        'paidCount': paidCount,
      };
}