import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eaglebiz/functionality/permissions/LeaveType.dart';
import 'package:eaglebiz/functionality/permissions/Permissions.dart';
import 'package:eaglebiz/model/RestrictPermissionsModel.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class NewLeave extends StatefulWidget {
  @override
  _NewLeaveState createState() => _NewLeaveState();
}

class _NewLeaveState extends State<NewLeave> {

  final _controller1 =TextEditingController();

  bool _color1;
  String fromDate = "",fromDateS="";
  String toDate= "",toDateS="";
  int y,m,d;
  String toA,toB,toC;
  var _isloading;
  String uuid,leaveType="Leave Type",status;
  List<RestrictPermissionsModel> restrictpermissionModel;
  static Dio dio = Dio(Config.options);
  ProgressDialog pr;
  Future<String> getUserID() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    String id=preferences.getString("uId");
    return id;
  }

  @override
  void initState() {
    super.initState();
    _color1 = false;
    var now = new DateTime.now();
    y=now.year;
    m=now.month;
    d=now.day;
    getUserID().then((val)=>setState((){
      uuid="USR_"+val;
      print(uuid);
    }));
  }
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return Scaffold(
      appBar: AppBar(title: Text("Request Leave".toUpperCase(),style: TextStyle(color: Colors.white),),

        leading: IconButton(icon: Icon(Icons.close,color: Colors.white,),onPressed: (){
          var navigator = Navigator.of(context);
          navigator.push(
            MaterialPageRoute(builder: (BuildContext context) => Permissions()),
//                          ModalRoute.withName('/'),
          );
        },),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check,color: Colors.white,),
            onPressed: (){
              _color1 ?  CheckHalfDay() : CheckDay();
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(color: Colors.white,),
          Container(
            margin: EdgeInsets.only(left: 10,right: 10,top: 6),
            child: StaggeredGridView.count(crossAxisCount: 4,crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 2,left: 2),
                  child:  dashboard1(),
                ),
              ],
              staggeredTiles: [
                StaggeredTile.extent(4, 60.0),
              ],),
          ),
          Container(
            margin: EdgeInsets.only(top: 75),
             child: ListView(
                children: <Widget>[
                  ListTile(
                    title: TextFormField(
                      enabled: false,
                      controller: TextEditingController(text: fromDateS),
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.event),
                        labelText: _color1 ? "Select Date": "From" ,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: lwtColor,
                      ),
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(y, m, d-4),
                            maxTime: DateTime(y, m+3,d),
                            theme: DatePickerTheme(
                                backgroundColor: Colors.white,
                                itemStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                ),
                                doneStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12)), onChanged: (date) {
                              changeDateF(date);
                            }, onConfirm: (date) {
                               changeDateF(date);
                            },
                            currentTime: DateTime.now(),
                            locale: LocaleType.en);
                      },
                    ),
                  ),
                  _color1 ? Container() : ListTile(
                    title: TextFormField(
                      enabled: false,
                      controller: TextEditingController(text: toDateS),
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.event),
                        labelText:  "To"  ,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: lwtColor,
                      ),
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
//                            minTime: DateTime(2019, 3, 5),
                            minTime: DateTime(int.parse(toA), int.parse(toB), int.parse(toC)),
                            maxTime: DateTime(y, m,d+5),
                            theme: DatePickerTheme(
                                backgroundColor: Colors.white,
                                itemStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                ),
                                doneStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12)), onChanged: (date) {
                              changeDateT(date);
                            }, onConfirm: (date) {
                              changeDateT(date);
                            },
                            currentTime: DateTime.now(),
                            locale: LocaleType.en);
                      },
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      enabled: false,
                      controller: TextEditingController(text: leaveType),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.view_list),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),

                        ),
                      ),
                    ),
                    trailing: IconButton(icon: Icon(Icons.add,color: lwtColor,),onPressed: () {
                      selectLeaveType(context);
                    },),
                  ),
                  ListTile(
                    title: TextFormField(
                      controller: _controller1,
                      maxLength: 50,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.chrome_reader_mode),
                        labelText: "Purpose",
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

  Material dashboard1() {
    return Material(
      color: _color1 ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: _color1 ? lwtColor : Colors.white,
      child: InkWell(
        onTap: (){
          setState(() {
            _color1 = !_color1;
          });
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
                      child:Text("Half-day".toUpperCase(),style:TextStyle(
                        fontSize: 20.0,fontFamily: "Roboto",
                        color: _color1 ?  Colors.white : lwtColor,
                        //Color(0xFF272D34),
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

  void changeDateF(DateTime date) {
    String newDate = date.toString();
    List<String> d = [];
    d = newDate.split(" ");
    // print(d[0]);
    setState(() {
      List<String> aa=[];
      aa=d[0].split("-");
      toA=aa[0].toString();
      toB=aa[1].toString();
      toC=aa[2].toString();
      print("esko C Date"+toA.toString()+"-"+toB.toString()+"-"+toC.toString());
      fromDate = d[0].toString();
      fromDateS =  toC+"-"+toB+"-"+toA;
    });
  }
  void changeDateT(DateTime date) {
    String newDate = date.toString();
    List<String> d = [];
    d = newDate.split(" ");

    var display=d[0].toString();
    List<String> a=display.split("-");

    // print(d[0]);
    setState(() {
      toDate = d[0].toString();
      toDateS = a[2]+"-"+a[1]+"-"+a[0];
    });
  }

  void callServiceInsert() async {
    pr.show();
    print("esko CallInsert : "+fromDate+", "+_controller1.text+", "+toDate+","+leaveType+", "+uuid);
    var response;
    if(_color1==true){
       response = await dio.post(ServicesApi.leavesInsert,
          data:
          {
            "actionMode": "insert",
            "elFromDate": fromDate,
            "elReason": _controller1.text,
            "elStatus": 1,
            "elToDate": fromDate,
            "leaveType": leaveType,
            "numberOfDays": "0.5",
            "toAddress": ["string"],
            "uId": uuid,
          },
          options: Options(
            contentType: ContentType.parse('application/json'),));
    }else {
       response = await dio.post(ServicesApi.leavesInsert,
          data:
          {
            "actionMode": "insert",
            "elFromDate": fromDate,
            "elReason": _controller1.text,
            "elStatus": 1,
            "elToDate": toDate,
            "leaveType": leaveType,
            "toAddress": ["string"],
            "uId": uuid,
          },
          options: Options(
            contentType: ContentType.parse('application/json'),));
    }
    print("Response :-"+response.toString());
    setState(() => _isloading=false);

    if(response.statusCode==200 || response.statusCode==201){
      pr.hide();
//      var responseJson = json.decode(response.data);
      Fluttertoast.showToast(msg: "Leave Created");
      Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => Permissions()));

    }else{
      pr.hide();
      Fluttertoast.showToast(msg: "Please try after some time.");
    }

  }

  void selectLeaveType(BuildContext context) async {
    var data= await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> LeaveType()));
    print(data.toString());
    leaveType=data.toString();
  }

  CheckDay() async {
    if(fromDate.isEmpty){
      Fluttertoast.showToast(msg: 'Choose your Date');
    }else if(toDate.isEmpty){
      Fluttertoast.showToast(msg: 'Choose your To Date');
    }else if(leaveType=='Leave Type' || leaveType=="null"){
      Fluttertoast.showToast(msg: 'Select Leave Type');
    }else if(_controller1.text.isEmpty) {
      Fluttertoast.showToast(msg: "Enter your Purpose");
    }else {
      //Service Call
      var data= await checkleaveStatus(fromDate,toDate,uuid);
      if(data=="0"){
        callServiceInsert();
      }else if(data=="1"){
        Fluttertoast.showToast(msg: "Sorry! You have already requested a leave for this date(s).");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Permissions()),
          ModalRoute.withName('/'),);
      }
    }
  }

  CheckHalfDay() async {
    if(fromDate.isEmpty){
      Fluttertoast.showToast(msg: 'Choose your Date');
    }else if(leaveType=='Leave Type' || leaveType=="null"){
      Fluttertoast.showToast(msg: 'Select Leave Type');
    }else if(_controller1.text.isEmpty) {
      Fluttertoast.showToast(msg: "Enter your Purpose");
    }else {
      //Service Call
      var data =await checkleaveStatus(fromDate,fromDate,uuid);
      if(data=="0"){
        callServiceInsert();
      }else if(data=="1"){
        Fluttertoast.showToast(msg: "Sorry! You have already requested a leave for this date.");
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Permissions()),
        ModalRoute.withName('/'),);
      }
    }
  }

  checkleaveStatus(String fromDate, String toDate, String uuidd) async {
    var response = await dio.post(ServicesApi.emp_Data,
        data:
        {
          "actionMode": "getUserByLeaveDate",
          "parameter1": uuidd,
          "parameter2": fromDate,
          "parameter3": toDate,
          "parameter4": "string",
          "parameter5": "string"
        },
        options: Options(contentType: ContentType.parse('application/json'),
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
      restrictpermissionModel = (json.decode(response.data) as List).map((data) => new RestrictPermissionsModel.fromJson(data)).toList();
      if(restrictpermissionModel.isEmpty || restrictpermissionModel==null){
        return "0";
      }else{
        return restrictpermissionModel[0].status.toString();
      }
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }
}
