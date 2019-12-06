class ServicesApi {
  static String versionNew = "1.3";

  static String fcm_Send = "https://fcm.googleapis.com/fcm/send";
  static String FCM_KEY =
      "AAAASa5BYMA:APA91bETvZbudrnnPOBaf6h395TagXNekYBGMtjJDycZ42_3mjxWEWccnpWpou3hBGsbQQbaSiJTCH1pA5VRo-2QsClDxq7V1wpOw1dNtu8V0Z5H66-NQpwGGnUSnXRlgzTGi584Z0WN";

  // static String basic_url = "http://192.168.2.5:8383/"; //dev
  // static String basic_url = "http://192.168.2.3:8080/"; //test
  // static String basic_url = "http://192.168.3.51:8083/"; //production
  static String basic_url = "http://49.207.32.34:8083/"; //global

  // static String hrms_Service = "http://192.168.2.5:8383/hrms.service/"; //dev
  // static String hrms_Service="http://192.168.2.3:8080/hrms.service/"; //test
  // static String hrms_Service ="http://192.168.2.5:8383/hrms.service.prod/"; //production
  static String hrms_Service =
      "http://49.207.32.34:8383/hrms.service.prod/"; //global

  static String new_login_url = basic_url + "global.service/validate/user";

  static String global_Service = "global.service/global/";

  static String att_Service = "att.service/hrms/";
  static String travel_Service = "travel.service/";
  static String crm = 'crm.service/';

  //leave policy
  static String leavePolicy = hrms_Service + "check/leavePolicy";
  //CRM Sales Lead
  static String Pending_Url = basic_url + crm + "crm/get/data";
  static String Sales_Insert_Url = basic_url + crm + 'crm/sales/request/save';

  //
  static String getData =
      basic_url + global_Service + "getAnyGlobalDataForMobile";
  static String updateData =
      basic_url + global_Service + "updateAnyGlobalDataForMobile";

  //Leaves
  static String insertLeave = hrms_Service + "hrms/saveEmployeeLeave";
  static String ChangeLeaveStatus = hrms_Service + "hrms/update/leave/status";
  static String checkLeaveStatus = hrms_Service + "hrms/get/hruser/data";

  //Permissions
  static String insertPermission = hrms_Service + "hrms/saveEmpPermission";
  static String ChangePermissionStatus =
      hrms_Service + "hrms/update/Permission/status";
  static String getLeaves =
      basic_url + att_Service + "attendance/get/user/leaves?id=";

  //Day Plan (Insert, Update):- Self, Team, Project
  static String saveDayPlan = hrms_Service + "hrms/saveDayPlan";

  //Travel Insertion
  static String insert_travel =
      basic_url + travel_Service + "travel/request/save";
  static String insert_hotel =
      basic_url + travel_Service + "hotel/request/save";
}
