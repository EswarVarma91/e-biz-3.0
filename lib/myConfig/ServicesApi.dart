class ServicesApi {
  //========= New DataBase ebizdb=========//

  static String fcm_Send="https://fcm.googleapis.com/fcm/send";
  static String FCM_KEY= "AAAAw1WdJb0:APA91bGlArheK9iRSc6GV-rYXv8x9oxmMqwvPHk0KB5ldHKiJLLCXJKverdMqAFpRZC11brzEbyKgxnolHXw3MgeFP9Vmbk37isb1rz2uKoM2ylJnWrrKxmXHcP-q8w1a4thssxRFqoU";

  static String basic_url = "http://192.168.2.5:8383/"; //Live

  // static String basic_url = "http://192.168.2.3:8080/"; //test

  static String new_login_url = basic_url + "global.service/validate/user";

  static String global_Service = "global.service/global/";
  static String hrms_Service = "hrms.service/hrms/";
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
  static String insertLeave = basic_url + hrms_Service + "saveEmpLeave";
  static String ChangeLeaveStatus =
      basic_url + hrms_Service + "update/leave/status";
  static String checkLeaveStatus = basic_url + hrms_Service + "get/hruser/data";

  //Permissions
  static String insertPermission =
      basic_url + hrms_Service + "saveEmpPermission";
  static String ChangePermissionStatus =
      basic_url + hrms_Service + "update/Permission/status";
  static String getLeaves =
      basic_url + att_Service + "attendance/get/user/leaves?id=";

  //Day Plan (Insert, Update):- Self, Team, Project
  static String saveDayPlan = basic_url + hrms_Service + "saveDayPlan";

  //Travel Insertion
  static String insert_travel =
      basic_url + travel_Service + "travel/request/save";
  static String insert_hotel =
      basic_url + travel_Service + "hotel/request/save";

  
}
