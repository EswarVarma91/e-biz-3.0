class ServicesApi{

  static String baseUrl= 'http://192.168.1.122:8180/';

  static String Referedby_Url = baseUrl + 'Eagle_HR_Dev/get/userinfo';

  //Self, project, // need to develop (day start and day end)
  static String Task= baseUrl + 'Eagle_EMP_Dev/emp/dayplan/insert';
  //Self, project, // need to develop (day start and day end)
  static String Task_Update= baseUrl + 'Eagle_EMP_Dev/emp/dayplan/update';

  static String emp_Data= baseUrl + 'Eagle_EMP_Dev/get/empdata';
  static String leavesInsert= baseUrl + 'Eagle_EMP_Dev/emp/leave/insert';
  static String permissionsInsert= baseUrl + 'Eagle_EMP_Dev/emp/permission/insert';
  static String leaves_Permissions_daytime_approvals_userLocation= baseUrl + 'Eagle_EMP_Dev/set/empupdate';
  static String lateComing= baseUrl + 'Eagle_HR_Dev/hr/attendance/update';
  static String GlobalNotificationsData= baseUrl + 'Eagle_HR_Dev/get/anydata';



//  static String eagle_emp_main= 'http://192.168.2.5:8383/'; //live
  static String eagle_emp_main= 'http://192.168.2.3:8080/'; // testing

  static String Login_Url= eagle_emp_main + "global.service/global/get/any/data";
  static String crm='crm.service/';
  static String Pending_Url = eagle_emp_main + crm +"crm/get/data";
  static String Sales_Insert_Url= eagle_emp_main + crm +'crm/sales/request/save';



              //========= New DataBase ebizdb=========//

  static String basic_url="http://192.168.2.5:8383/";
  static String new_login_url=basic_url + "hrms.service/encryption/getValidateUser?empCode=";


}