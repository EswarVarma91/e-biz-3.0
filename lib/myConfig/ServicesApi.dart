class ServicesApi {
  //========= New DataBase ebizdb=========//

  static String fcm_Send="https://fcm.googleapis.com/fcm/send";
  static String FCM_KEY= "AAAAS15bmPU:APA91bFKAfKKD0YiHXI37U-iIUg1C0RVWdhvZ6kJyWh6Fd4is70mmfUzGwcFdpIjw-Ytl7pnPwhPvb7bOror0kSgyDLSne9v1uEaa1JgmEH5c_ffV4lI9iP1PHejAmUzVHPoboG4aJsI";

  // static String basic_url = "http://192.168.2.5:8383/"; //dev

  static String basic_url = "http://192.168.3.51:8083/"; //test\
  static String hrms_Service="http://192.168.2.5:8383/hrms.service.prod/";

  static String new_login_url = basic_url + "global.service/validate/user";

  static String global_Service = "global.service/global/";
 
  static String att_Service = "att.service/hrms/";
  static String travel_Service = "travel.service/";
  static String crm = 'crm.service/';

  //leave policy
  static String leavePolicy = basic_url+ "hrms.service/check/leavePolicy";
  //CRM Sales Lead
  static String Pending_Url = basic_url + crm + "crm/get/data";
  static String Sales_Insert_Url = basic_url + crm + 'crm/sales/request/save';

  //
  static String getData =
      basic_url + global_Service + "getAnyGlobalDataForMobile";
  static String updateData =
      basic_url + global_Service + "updateAnyGlobalDataForMobile";

  //Leaves
  static String insertLeave = basic_url + hrms_Service + "hrms/saveEmployeeLeave";
  static String ChangeLeaveStatus =
      basic_url + hrms_Service + "hrms/update/leave/status";
  static String checkLeaveStatus = basic_url + hrms_Service + "hrms/get/hruser/data";

  //Permissions
  static String insertPermission =
      basic_url + hrms_Service + "hrms/saveEmpPermission";
  static String ChangePermissionStatus =
      basic_url + hrms_Service + "hrms/update/Permission/status";
  static String getLeaves =
      basic_url + att_Service + "attendance/get/user/leaves?id=";

  //Day Plan (Insert, Update):- Self, Team, Project
  static String saveDayPlan = basic_url + hrms_Service + "hrms/saveDayPlan";

  //Travel Insertion
  static String insert_travel =
      basic_url + travel_Service + "travel/request/save";
  static String insert_hotel =
      basic_url + travel_Service + "hotel/request/save";

  
}
