class SalesPendingModel {
  String srCustomerName;
  String srRequirement;
  String srContactName;
  String srDesignation;
  String srPhoneNo;
  String srContactEmail;
  String srNo;
  String srReferedBy;
  int srStatus;
  String referredByFullName;
  int rId;

  SalesPendingModel(
      String srCustomerName,
      String srRequirement,
      String srContactName,
      String srDesignation,
      String srPhoneNo,
      String srContactEmail,
      String srNo,
      String srReferedBy,
      int srStatus,
      String referredByFullName,
      int rId) {
    this.srCustomerName = srCustomerName;
    this.srRequirement = srRequirement;
    this.srContactName = srContactName;
    this.srDesignation = srDesignation;
    this.srPhoneNo = srPhoneNo;
    this.srContactEmail = srContactEmail;
    this.srNo = srNo;
    this.srStatus = srStatus;
    this.srReferedBy = srReferedBy;
    this.referredByFullName = referredByFullName;
    this.rId = rId;
  }

  SalesPendingModel.fromJson(Map<String, dynamic> json)
      : srCustomerName = json['srCustomerName'],
        srRequirement = json['srRequirement'],
        srContactName = json['srContactName'],
        srDesignation = json['srDesignation'],
        srPhoneNo = json['srPhoneNo'],
        srContactEmail = json['srContactEmail'],
        srNo = json['srNo'],
        srStatus = json['srStatus'],
        srReferedBy = json['srReferedBy'],
        referredByFullName = json['referredByFullName'],
        rId = json['rId'];

  Map<String, dynamic> toJson() => {
        'srCustomerName': srCustomerName,
        'srRequirement': srRequirement,
        'srContactName': srContactName,
        'srDesignation': srDesignation,
        'srPhoneNo': srPhoneNo,
        'srContactEmail': srContactEmail,
        'srNo': srNo,
        'srStatus': srStatus,
        'srReferedBy': srReferedBy,
        'referredByFullName': referredByFullName,
        'rId': rId,
      };
}
