class ServicesApi {
  static String versionNew = "2.0";

  static String fcm_Send = "https://fcm.googleapis.com/fcm/send";
  static String FCM_KEY = "AAAASa5BYMA:APA91bETvZbudrnnPOBaf6h395TagXNekYBGMtjJDycZ42_3mjxWEWccnpWpou3hBGsbQQbaSiJTCH1pA5VRo-2QsClDxq7V1wpOw1dNtu8V0Z5H66-NQpwGGnUSnXRlgzTGi584Z0WN";

  // static String basic_url = "http://192.168.2.5:8383/"; //dev
  // static String basic_url = "http://192.168.2.3:8080/"; //test
  static String basic_url = "http://www.e-biz.in:8083/"; //global

  // static String hrms_Service = "http://192.168.2.5:8383/hrms.service/"; //dev
  // static String hrms_Service="http://192.168.2.3:8080/hrms.service/"; //test
  static String hrms_Service = "http://www.e-biz.in:8083/hrms.service/"; //global


  static String new_login_url = hrms_Service + "encryption/getValidateMobileLogIn";

  static String global_Service = "global.service/global/";
  static String att_Service = "att.service/hrms/";
  static String travel_Service = "travel.service/";
  static String crm = 'crm.service/';

  //leave policy
  static String leavePolicy = hrms_Service + "check/leavePolicy";

  //crm Sales Lead
  static String Pending_Url = basic_url + crm + "crm/get/data";
  static String Sales_Insert_Url = basic_url + crm + 'crm/sales/request/save';

  //decryption
  static String getData = hrms_Service + "encryption/getEncryptedDataDecryptedForMobile";
  static String updateData = basic_url + global_Service + "updateAnyGlobalDataForMobile";

  //device id
  static String insertDeviceid= basic_url+"att.service/hrms/attendance/save/device";

  //Leaves
  static String insertLeave = hrms_Service + "hrms/saveEmployeeLeave";
  static String ChangeLeaveStatus = hrms_Service + "hrms/update/leave/status";
  static String checkLeaveStatus = hrms_Service + "hrms/get/hruser/data";
  static String getLeaves = basic_url + att_Service + "attendance/get/user/leaves?id=";

  //Permissions
  static String insertPermission = hrms_Service + "hrms/saveEmpPermission";
  static String ChangePermissionStatus = hrms_Service + "hrms/update/Permission/status";


  //Day Plan (Insert, Update):- Self, Team, Project
  static String saveDayPlan = hrms_Service + "hrms/saveDayPlan";

  //Travel Insertion
  static String insert_travel = basic_url + travel_Service + "travel/request/save";
  static String canceltravelRequest = basic_url + travel_Service + "travel/cancelTravelRequestByUser";
  static String updateTravelRequest = basic_url + travel_Service +"travel/update/mobile/approvals";

  // Hotel Services
  static String insert_hotel = basic_url + travel_Service + "hotel/request/save";
  static String cancelhotelRequest = basic_url + travel_Service + "hotel/cancelHotelRequestByUser";
  static String updateHotelRequest = basic_url + travel_Service +"hotel/update/mobile/approvals";

}



