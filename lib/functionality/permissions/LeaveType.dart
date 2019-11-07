import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:eaglebiz/functionality/approvals/Approvals.dart';
import 'package:eaglebiz/main.dart';
import 'package:eaglebiz/model/LeavesCountModel.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';

class LeaveType extends StatefulWidget {
  @override
  _LeaveTypeState createState() => _LeaveTypeState();
}

class _LeaveTypeState extends State<LeaveType> {
  List<LeavesCountModel> listcountLeaves=new List();
  String uidd;
  static Dio dio = Dio(Config.options);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserID().then((val) => setState(() {
      uidd = val;
      getLeavesCount(uidd);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Leave Type',style: TextStyle(color: Colors.white),),
      iconTheme: IconThemeData(color: Colors.white),),
      body: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("CAL  :  "+listcountLeaves[0].cal,style: TextStyle(color: Colors.black),),
              onTap: (){
                Navigator.pop(context, listcountLeaves[0].cal.toString());
              },
            ),
            ListTile(
              title: Text("CL   :  "+listcountLeaves[0].cl,style: TextStyle(color: Colors.black),),
              onTap: (){
                Navigator.pop(context, listcountLeaves[0].cl.toString());
              },
            ),
            ListTile(
              title: Text("CO   :  "+listcountLeaves[0].co,style: TextStyle(color: Colors.black),),
              onTap: (){
                Navigator.pop(context, listcountLeaves[0].co.toString());
              },
            ),
            ListTile(
              title: Text("ML   :  "+listcountLeaves[0].ml,style: TextStyle(color: Colors.black),),
              onTap: (){
                Navigator.pop(context, listcountLeaves[0].ml.toString());
              },
            ),
            ListTile(
              title: Text("SL   :  "+listcountLeaves[0].sl,style: TextStyle(color: Colors.black),),
              onTap: (){
                Navigator.pop(context, listcountLeaves[0].sl.toString());
              },
            ),
            ListTile(
              title: Text("LOP  :  ",style: TextStyle(color: Colors.black),),
              onTap: (){
                Navigator.pop(context, "lop");
              },
            ),
          ],
        ),
      )
    );
  }

  getLeavesCount(String uidd) async {

    var response = await http.post(ServicesApi.getLeaves+uidd);
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        listcountLeaves = (json.decode(response.body) as List).map((data) => new LeavesCountModel.fromJson(data)).toList();
        print(listcountLeaves);
      });
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }
}


//
