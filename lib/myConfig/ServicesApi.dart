class ServicesApi{

  //========= New DataBase ebizdb=========//

  static String basic_url = "http://192.168.2.5:8383/";
  static String new_login_url = basic_url + "global.service/validate/user";

  static String global_Service = "global.service/global/";
  static String hrms_Service = "hrms.service/hrms/";
  static String att_Service = "att.service/hrms/";
  static String travel_Service = "travel.service/travel/";

  static String getData = basic_url + global_Service + "getAnyGlobalDataForMobile";
  static String updateData = basic_url + global_Service + "updateAnyGlobalDataForMobile";

  //leaves
  static String insertLeave = basic_url + hrms_Service +"saveEmpLeave";
  static String ChangeLeaveStatus = basic_url + hrms_Service + "update/leave/status";
  static String checkLeaveStatus = basic_url + hrms_Service + "get/hruser/data";
  //permissions
  static String insertPermission = basic_url + hrms_Service +"saveEmpPermission";
  static String ChangePermissionStatus = basic_url + hrms_Service + "update/Permission/status";
  static String getLeaves = basic_url + att_Service + "attendance/get/user/leaves?id=";

  //Day Plan (Insert, Update):- Self, Team, Project
  static String saveDayPlan = basic_url + hrms_Service + "saveDayPlan";

  //get Travel Request List
  static String getTravelList= basic_url + travel_Service + "get/travel/request";



  //not working not supported error
  static String leavebyUserId = "http://192.168.2.5:8383/hrms.service/hrms/getEmpLeaveByUserId?id=";





//=========================================================================================================
  /// old database ip
  // static String baseUrl= 'http://192.168.1.122:8180/';

  // static String Referedby_Url = baseUrl + 'Eagle_HR_Dev/get/userinfo';

  // //Self, project, // need to develop (day start and day end)
  // static String Task= baseUrl + 'Eagle_EMP_Dev/emp/dayplan/insert';
  // //Self, project, // need to develop (day start and day end)
  // static String Task_Update= baseUrl + 'Eagle_EMP_Dev/emp/dayplan/update';

  // static String emp_Data= baseUrl + 'Eagle_EMP_Dev/get/empdata';
  // static String leavesInsert= baseUrl + 'Eagle_EMP_Dev/emp/leave/insert';
  // static String permissionsInsert= baseUrl + 'Eagle_EMP_Dev/emp/permission/insert';
  // static String leaves_Permissions_daytime_approvals_userLocation= baseUrl + 'Eagle_EMP_Dev/set/empupdate';
  // static String lateComing= baseUrl + 'Eagle_HR_Dev/hr/attendance/update';
  // static String GlobalNotificationsData= baseUrl + 'Eagle_HR_Dev/get/anydata';



//  static String eagle_emp_main= 'http://192.168.2.5:8383/'; //live
  static String eagle_emp_main= 'http://192.168.2.3:8080/'; // testing

  static String Login_Url= eagle_emp_main + "global.service/global/get/any/data";
  static String crm='crm.service/';
  static String Pending_Url = eagle_emp_main + crm +"crm/get/data";
  static String Sales_Insert_Url= eagle_emp_main + crm +'crm/sales/request/save';





}