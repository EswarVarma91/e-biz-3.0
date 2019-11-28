import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eaglebiz/model/WorkStatusModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/DatabaseHelper.dart';
import '../main.dart';
import '../model/AttendanceModel.dart';
import '../myConfig/Config.dart';
import '../myConfig/ServicesApi.dart';

class WorkStatus extends StatefulWidget {
  @override
  _WorkStatusState createState() => _WorkStatusState();
}

class _WorkStatusState extends State<WorkStatus> {
  static Dio dio = Dio(Config.options);
  String empCode, userId;
  bool _isSelectedT, _isSelectedW;
  var dbHelper = DatabaseHelper();
  List<AttendanceModel> atteModel;
  Future<List<AttendanceModel>> attList;
  String workStatus;

  getEmpCode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      empCode = preferences.getString("uEmpCode").toString();
      userId = preferences.getString("userId").toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _isSelectedT = false;
    _isSelectedW = false;
    getEmpCode();
    _localGet();
  }

  _localGet() async {
    var now = DateTime.now();
    var checkDate = DateFormat("yyyy-MM-dd").format(now).toString();
    atteModel = await dbHelper.getCurrentDateTime();
    attList = dbHelper.getCurrentDateTime();
    if (atteModel.length != null) {
      for (int i = 0; i < atteModel.length; i++) {
        if (atteModel[i].date == checkDate && atteModel[i].user_id == userId) {
          setState(() {
            workStatus = atteModel[i].work_status;
            if (workStatus == "Tour") {
              _isSelectedW = false;
              _isSelectedT = true;
            } else if (workStatus == "At-Office") {
              _isSelectedT = false;
              _isSelectedW = true;
            }
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Work Location",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        child: StaggeredGridView.count(
          crossAxisCount: 8,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 1, top: 10, left: 10),
              child: tour(),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 10),
              child: working(),
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(4, 75.0),
            StaggeredTile.extent(4, 75.0),
          ],
        ),
      ),
    );
  }

  Material tour() {
    return Material(
      color: _isSelectedT ? lwtColor : Colors.white,
      elevation: 14.0,
      shadowColor: _isSelectedT ? lwtColor : Colors.white,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: () {
          WorkStatusModel wm = WorkStatusModel(userId, "Tour");
          dbHelper.updateWStatus(wm);
          _callworkStatus("1");
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "Tour".toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: _isSelectedT ? Colors.white : lwtColor,
                        ),
                      ),
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

  Material working() {
    return Material(
      color: _isSelectedW ? lwtColor : Colors.white,
      elevation: 14.0,
      shadowColor: _isSelectedW ? lwtColor : Colors.white,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: () {
          WorkStatusModel wm = WorkStatusModel(userId, "At-Office");
          dbHelper.updateWStatus(wm);
          _callworkStatus("2");
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "At-Office".toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: _isSelectedW ? Colors.white : lwtColor,
                        ),
                      ),
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

  void _callworkStatus(String s) async {
    var now = DateTime.now();
    var currDate = DateFormat("yyyy-MM-dd").format(now).toString();
    var response;
    if (s == "1") {
      response = await dio.post(ServicesApi.updateData,
          data: {
            "parameter1": "UpdateEmpTourinAttendance",
            "parameter2": empCode.toString(),
            "parameter3": currDate.toString(),
            "parameter4": "Tour"
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
    } else if (s == "2") {
      response = await dio.post(ServicesApi.updateData,
          data: {
            "parameter1": "UpdateEmpTourinAttendance",
            "parameter2": empCode.toString(),
            "parameter3": currDate.toString(),
            "parameter4": "At-Office"
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pop(context, s);
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    } else
      Fluttertoast.showToast(msg: "Check your internet connection.");
//        Navigator.pop(context,s);
    throw Exception('Authentication Error');
  }
}
