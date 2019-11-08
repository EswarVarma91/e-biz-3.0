import 'dart:convert';
import 'dart:io';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:eaglebiz/functionality/permissions/Permissions.dart';
import 'package:eaglebiz/model/CheckPermissionsRestrictions.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../../main.dart';

class NewPermissions extends StatefulWidget {
  @override
  _NewPermissionState createState() => _NewPermissionState();
}

class _NewPermissionState extends State<NewPermissions> {
  bool personal,official;
  String selectDate= " ",selectDateS= " ",fromTime="",toTime="",uidd,typeP,per_status;
  int y,m,d;
  ProgressDialog pr;
  var fullname;
  static Dio dio = Dio(Config.options);
  final _controller1 =TextEditingController();
  List<String> dSplit = [];
  List<String> aSplit = [];
  List<CheckPermissionRestrictions> checkPermissionRestrictions;


  @override
  void initState() {
    super.initState();
    personal=true;
    official=false;
    var now = new DateTime.now();
    y=now.year;
    m=now.month;
    d=now.day;
    getNameandUid();
  }




  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return Scaffold(
        appBar: AppBar(title: Text("Request Permissions",style: TextStyle(color: Colors.white),),

          leading: IconButton(icon: Icon(Icons.close,color: Colors.white,),onPressed: (){
            var navigator = Navigator.of(context);
            navigator.pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => Permissions()),
                        ModalRoute.withName('/'),
            );
          },),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check,color: Colors.white,),
              onPressed: (){

                 var fromtimeCheck=DateFormat("HH:mm:ss").parse(fromTime.toString());
                 var totimeCheck=DateFormat("HH:mm:ss").parse(toTime.toString());


                if(selectDate.isEmpty){
                  Fluttertoast.showToast(msg: "Please Select Date");
                }else if(fromTime.isEmpty){
                  Fluttertoast.showToast(msg: "Please Select From Time");
                }else  if(toTime.isEmpty ) {
                  Fluttertoast.showToast(msg: "Please Select To Time");
                }else if(_controller1.text.isEmpty ){
                  Fluttertoast.showToast(msg: "Please Enter Purpose");
                }else if(!totimeCheck.isAfter(fromtimeCheck)) {
                 Fluttertoast.showToast(msg: "Please check your timings");
                }else if(personal==true) {
                  if(totimeCheck.difference(fromtimeCheck).inMinutes<=120){
                    //Service Call
                    permissionSerivceCall();
                  }else{
                    Fluttertoast.showToast(msg: "Not More than 2Hours.!");
                  }

                }else if(official==true){
                  permissionSerivceCall();
                }
              },
            )
          ],
        ),
        body:Stack(
          children: <Widget>[
            Container(color: Colors.white,),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 6),
              child: StaggeredGridView.count(crossAxisCount: 4,crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 1,top: 1),
                    child:  officeM(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1,top: 1),
                    child:  personalM(),
                  ),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(2, 60.0),
                  StaggeredTile.extent(2, 60.0),
                ],),
            ),
            Container(
                margin: EdgeInsets.only(top: 80),
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: TextFormField(
                        enabled: false,
                        controller: TextEditingController(text: selectDateS),
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.event),
                          labelText: "Select Date".toUpperCase() ,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.event,
                          size: 35,
                          color: lwtColor,
                        ),
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(y, m, d-9),
                              maxTime: DateTime(y, m,d+9),
                              theme: DatePickerTheme(
                                  backgroundColor: Colors.white,
                                  itemStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                  ),
                                  doneStyle: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12)), onChanged: (date)
                              {
                                changeDate(date);
                              }, onConfirm: (date) {
                                changeDate(date);
                              },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                      ),
                    ),

                    ListTile(
                      trailing: IconButton(
                        icon: Icon(
                          Icons.access_time,
                          size: 35,
                          color: lwtColor,
                        ),
                        onPressed: () {
                          DatePicker.showTimePicker(context,
                              showTitleActions: true, onChanged: (time) {
                                changeTime(time,"from");
                              }, onConfirm: (time) {
                                changeTime(time,"from");
                              }, currentTime: DateTime.now());
                        },
                      ),
                      title: TextFormField(
                        enabled: false,
                        controller: TextEditingController(text: fromTime),
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.access_time),
                          labelText:  "From Time"  ,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),

                    ListTile(
                      trailing: IconButton(
                        icon: Icon(
                          Icons.access_time,
                          size: 35,
                          color: lwtColor,
                        ),
                        onPressed: () {
                          DatePicker.showTimePicker(context,
                              showTitleActions: true, onChanged: (time) {
                                changeTime(time,"to");
                              }, onConfirm: (time) {
                                changeTime(time,"to");
                              }, currentTime: DateTime.now());
                        },
                      ),
                      title:TextFormField(
                        enabled: false,
                        controller: TextEditingController(text: toTime),
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.access_time),
                          labelText:  "To Time"  ,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: TextFormField(
                        controller: _controller1,
                        keyboardType: TextInputType.text,
                        maxLength: 50,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.chrome_reader_mode),
                          labelText: "Purpose".toUpperCase(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            )
            //ListView.builder(itemBuilder: null)
          ],
        ),
    );
  }

  Material officeM() {
    return Material(
      color: official ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: official ? lwtColor : Colors.white,
      child: InkWell(
        onTap: (){
          setState(() {
            official = !official;
            if(official==true){
              personal=!personal;
//              CheckServices();
            }else if(official==false){
              personal=!personal;
            }
          });
          /* var navigator = Navigator.of(context);
          navigator.push(
            MaterialPageRoute(builder: (BuildContext context) => SalesLeadDetails()),
//                          ModalRoute.withName('/'),
          );*/
        },
        child: Center(
          child:Padding(
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: <Widget>[

                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child:Text("Official".toUpperCase(),style:TextStyle(
                        fontSize: 12.0,fontFamily: "Roboto",
                        color: official ? Colors.white : lwtColor,
                      ),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Material personalM() {
    return Material(
      color: personal ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: personal ? lwtColor : Colors.white,
      child: InkWell(
        onTap: (){
          setState(() {
            personal = !personal;
            if(personal==true){
              official=!official;
            }else if(personal==false){
              official=!official;
            }
          });
          /* var navigator = Navigator.of(context);
          navigator.push(
            MaterialPageRoute(builder: (BuildContext context) => SalesLeadDetails()),
//                          ModalRoute.withName('/'),
          );*/
        },
        child: Center(
          child:Padding(
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: <Widget>[

                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child:Text("Personal".toUpperCase(),style:TextStyle(
                        fontSize: 12.0,fontFamily: "Roboto",
                        color: personal ? Colors.white : lwtColor,
                      ),),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void changeDate(DateTime date) {
    String newDate = date.toString();
    List<String> d = [];
    d = newDate.split(" ");
    List<String> a=d[0].toString().split("-");
    setState(() {
      selectDate = d[0].toString();
      selectDateS = a[2]+"-"+a[1]+"-"+a[0];
    });
  }
    void changeTime(DateTime date,String result) {
    String newDate = date.toString();
    dSplit = newDate.split(" ");

    String timeSplit=dSplit[1];
    aSplit= timeSplit.split(".");

    setState(() {
      if(result.toString()=="from") {
        fromTime = aSplit[0].toString();
      }else if(result.toString()=="to"){
        toTime = aSplit[0].toString();
      }
    });
  }

  void permissionSerivceCall() async {
pr.show();
    try {
    var response;
      if (official == true) {
        typeP = "Office";
         response = await dio.post(ServicesApi.insertPermission,
            data: {
              "vactionmode": "insert",
              "vperCreatedby": fullname,
              "vperDate": selectDate,
              "vperPurpose": _controller1.text.toString(),
              "vperType": typeP,
              "vperfromTime": fromTime.toString(),
              "vpertoTime": toTime.toString(),
              "vuId": uidd
            },
            options: Options(
              contentType: ContentType.parse('application/json'),));

      } else if (personal == true) {
        typeP = "personal";
        var data= await getUserByPermissionDate(selectDate,uidd);
        // ignore: unrelated_type_equality_checks
        if(data==0){
          if(checkPermissionRestrictions[0].dayPerCnt==0 && checkPermissionRestrictions[0].monthPerCnt<=2){
            response = await dio.post(ServicesApi.insertPermission,
                data: {
                  "vactionmode": "insert",
                  "vperCreatedby": fullname,
                  "vperDate": selectDate,
                  "vperPurpose": _controller1.text.toString(),
                  "vperType": typeP,
                  "vperfromTime": fromTime.toString(),
                  "vpertoTime": toTime.toString(),
                  "vuId": uidd
                },
                options: Options(
                  contentType: ContentType.parse('application/json'),));
          }else{
            pr.hide();
            Fluttertoast.showToast(msg: "Sorry! You have already requested a permission for this date.");
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => Permissions()),
              ModalRoute.withName('/'),);
          }
          }else{
          pr.hide();
          Fluttertoast.showToast(msg: 'Something went wrong.!');
        }
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          pr.hide();
          var responseJson = json.decode(response.data);
          Fluttertoast.showToast(msg: "Permission Applied");
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Permissions()),
            ModalRoute.withName('/'),);
          return responseJson;
        } else if (response.statusCode == 401) {
          pr.hide();
          throw Exception("Incorrect data");
        } else
          pr.hide();
        throw Exception('Authentication Error');
      } on DioError catch (exception) {
        pr.hide();
        if (exception == null ||
            exception.toString().contains('SocketException')) {
          pr.hide();
          throw Exception("Network Error");
        } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
            exception.type == DioErrorType.CONNECT_TIMEOUT) {
          pr.hide();
          throw Exception(
              "Could'nt connect, please ensure you have a stable network.");
        }
      }

  }

    getNameandUid() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        fullname = preferences.getString("fullname");
        uidd = preferences.getString("userId");
      });
//      getUserByPermissionDate(uidd);
    }

   getUserByPermissionDate(String selectedDate,String uiddd) async {
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "parameter1": "getUserPermissionCount",
            "parameter2": selectedDate,
            "parameter3": uiddd,
            "parameter4": "string",
            "parameter5": "string"
          },
          options: Options(contentType: ContentType.parse('application/json'),
          ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        checkPermissionRestrictions = (json.decode(response.data) as List).map((data) => new CheckPermissionRestrictions.fromJson(data)).toList();
      if(checkPermissionRestrictions.isEmpty || checkPermissionRestrictions==null){
        Fluttertoast.showToast(msg: 'Something went wrong.!');
      }else{
       return 0;
      }
      }else{
        return 1;
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        return null;
      }
    }
  }

}
