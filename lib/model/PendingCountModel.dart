class PendingCountModel {
  final String pendingCount;

  PendingCountModel(this.pendingCount);

  PendingCountModel.fromJson(Map<String, dynamic> json)
      : pendingCount = json['cnt'];

  Map<String, dynamic> toJson() =>
      {
        'cnt': pendingCount,
      };
}