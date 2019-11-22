import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eaglebiz/functionality/permissions/LeaveType.dart';
import 'package:eaglebiz/functionality/permissions/Permissions.dart';
import 'package:eaglebiz/model/LeavesCheckingDatesModel.dart';
import 'package:eaglebiz/model/LeavesCheckingModel.dart';
import 'package:eaglebiz/model/RestrictPermissionsModel.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class NewLeave extends StatefulWidget {
  @override
  _NewLeaveState createState() => _NewLeaveState();
}

class _NewLeaveState extends State<NewLeave> {
  final _controller1 = TextEditingController();

  bool _color1;
  String fromDate = "", fromDateS = "";
  String toDate = "", toDateS = "";
  int y, m, d;
  String toA, toB, toC;
  String uuid, leaveType = "Leave Type", status, fullname, leaveCount, branchId;
  List<RestrictPermissionsModel> restrictpermissionModel;
  List<LeavesCheckingDatesModel> lcdm;
  List<LeavesCheckingModel> lcm;
  static Dio dio = Dio(Config.options);
  bool leave_is_Sl = false;
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    _color1 = false;
    var now = new DateTime.now();
    y = now.year;
    m = now.month;
    d = now.day;
    getName();
  }

  getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uuid = preferences.getString("userId");
    fullname = preferences.getString("fullname");
    branchId = preferences.getString("branchid");
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leave request",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            var navigator = Navigator.of(context);
            navigator.push(
              MaterialPageRoute(
                  builder: (BuildContext context) => Permissions()),
              //                          ModalRoute.withName('/'),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () {
              _color1 ? _checkhalfday() : _checkDay();
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 6),
            child: StaggeredGridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 2),
                  child: dashboard1(),
                ),
              ],
              staggeredTiles: [
                StaggeredTile.extent(4, 60.0),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 75),
              child: ListView(
                children: <Widget>[
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
                    trailing: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: lwtColor,
                      ),
                      onPressed: () {
                        selectLeaveType(context);
                      },
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      enabled: false,
                      controller: TextEditingController(text: fromDateS),
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.event),
                        labelText: _color1 ? "Select Date" : "From",
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
                            minTime: leave_is_Sl
                                ? DateTime(y, m, d - 6)
                                : DateTime(y, m, d),
                            maxTime: leave_is_Sl
                                ? DateTime(y, m, d - 1)
                                : DateTime(y, m + 2, d),
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
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                    ),
                  ),
                  _color1
                      ? Container()
                      : ListTile(
                          title: TextFormField(
                            enabled: false,
                            controller: TextEditingController(text: toDateS),
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.event),
                              labelText: "To",
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
                                  minTime: DateTime(int.parse(toA),
                                      int.parse(toB), int.parse(toC)),
                                  maxTime: leave_is_Sl
                                      ? DateTime(y, m, d - 1)
                                      : DateTime(
                                          y, m, d + int.parse(leaveCount)),
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
              ))
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
        onTap: () {
          setState(() {
            _color1 = !_color1;
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "Half-day",
                        style: TextStyle(
                          fontSize: 20.0, fontFamily: "Roboto",
                          color: _color1 ? Colors.white : lwtColor,
                          //Color(0xFF272D34),
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

  void changeDateF(DateTime date) {
    String newDate = date.toString();
    List<String> d = [];
    d = newDate.split(" ");
    // print(d[0]);
    setState(() {
      List<String> aa = [];
      aa = d[0].split("-");
      toA = aa[0].toString();
      toB = aa[1].toString();
      toC = aa[2].toString();
      print("esko C Date" +
          toA.toString() +
          "-" +
          toB.toString() +
          "-" +
          toC.toString());
      fromDate = d[0].toString();
      fromDateS = toC + "-" + toB + "-" + toA;
    });
  }

  void changeDateT(DateTime date) {
    String newDate = date.toString();
    List<String> d = [];
    d = newDate.split(" ");

    var display = d[0].toString();
    List<String> a = display.split("-");

    // print(d[0]);
    setState(() {
      toDate = d[0].toString();
      toDateS = a[2] + "-" + a[1] + "-" + a[0];
    });
  }

  void callServiceInsert() async {
    var response;
    if (_color1 == true) {
      response = await dio.post(ServicesApi.insertLeave,
          data: {
            "vactionmode": "insert",
            "vel_created_by": fullname,
            "vel_from_date": fromDate,
            "vel_noofdays": 1,
            "vel_reason": _controller1.text,
            "vel_to_date": fromDate,
            "vleave_type": leaveType,
            "vu_id": uuid
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
    } else {
      response = await dio.post(ServicesApi.insertLeave,
          data: {
            "vactionmode": "insert",
            "vel_created_by": fullname,
            "vel_from_date": fromDate,
            "vel_noofdays": 0,
            "vel_reason": _controller1.text,
            "vel_to_date": toDate,
            "vleave_type": leaveType,
            "vu_id": uuid
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
    }
    // print("Response :-"+response.toString());

    if (response.statusCode == 200 || response.statusCode == 201) {
      pr.hide();
      //      var responseJson = json.decode(response.data);
      Fluttertoast.showToast(msg: response.data.toString());
      // Fluttertoast.showToast(msg: "Leave Created");
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (BuildContext context) => Permissions()));
    } else {
      pr.hide();
      Fluttertoast.showToast(msg: "Please try after some time.");
    }
  }

  void selectLeaveType(BuildContext context) async {
    fromDate = "";
    fromDateS = "";
    toDate = "";
    toDateS = "";
    toA = "";
    toB = "";
    toC = "";

    var data = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => LeaveType()));
    List res = data.split(" ");
    leaveType = res[0].toString();
    if (leaveType == "SL") {
      leave_is_Sl = true;
    } else {
      leave_is_Sl = false;
    }
    var result = int.parse(res[1]) - 1;
    leaveCount = result.toString();
  }

  _checkDay() async {
    if (fromDate.isEmpty) {
      Fluttertoast.showToast(msg: 'Choose your From Date');
    } else if (toDate.isEmpty) {
      Fluttertoast.showToast(msg: 'Choose your To Date');
    } else if (leaveType == 'Leave Type' || leaveType == "null") {
      Fluttertoast.showToast(msg: 'Select Leave Type');
    } else if (_controller1.text.isEmpty) {
      Fluttertoast.showToast(msg: "Enter your Purpose");
    } else {
      //Service Call
      if (leaveType == "CAL") {
        var now = DateTime.now();

        // if (fromDate == toDate) {
        //   var data = await dio.post(ServicesApi.getData,
        //       data: {"parameter1": "getCurrentTime"},
        //       options:
        //           Options(contentType: ContentType.parse("application/json")));
        //   if (data.statusCode == 200 || data.statusCode == 201) {
        //      print(DateFormat("HH:mm:ss").parse(json.decode(data.data["timeC"].toString()).toString()).difference(DateFormat("HH:mm:ss").parse("09:00:00")));
        //   } else if (data.statusCode == 401) {
        //     throw Exception("Exception");
        //   }
        // }

        checkleaveStatus(fromDate, toDate, uuid);
      }
    }
  }

  _checkhalfday() async {
    if (fromDate.isEmpty) {
      Fluttertoast.showToast(msg: 'Choose your Date');
    } else if (leaveType == 'Leave Type' || leaveType == "null") {
      Fluttertoast.showToast(msg: 'Select Leave Type');
    } else if (_controller1.text.isEmpty) {
      Fluttertoast.showToast(msg: "Enter your Purpose");
    } else {
      //Service Call
      checkleaveStatus(fromDate, fromDate, uuid);
    }
  }

  checkleaveStatus(String fromDate, String toDate, String uuidd) async {
    pr.show();
    print(branchId);
    List list = [];
    var response = await dio.post(ServicesApi.checkLeaveStatus,
        data: {
          "actionmode": "GetAppliedLeaveDaysStatus",
          "refid": branchId,
          "refstart": fromDate,
          "refend": toDate,
        },
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
      lcm = (json.decode(response.data) as List)
          .map((data) => new LeavesCheckingModel.fromJson(data))
          .toList();
      for (int i = 0; i < lcm.length; i++) {
        if (lcm[i].workingStatus == 0) {
          print(lcm[i].date.toString());
          list.add(lcm[i].date.toString());
        }
      }
      if (list.length > 0) {
        pr.hide();
        roundedAlertDialog(list, toDate);
      } else {
        getUserLeaves(fromDate, toDate, uuidd);
      }
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data,!");
    }
  }

  roundedAlertDialog(List list, String toDate) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              "Leave Alert",
              style: TextStyle(color: lwtColor),
            ),
            content: Container(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(child: Text("Please check this dates ")),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          list.toString(),
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              CupertinoButton(
                child: Text("Yes"),
                onPressed: () {
                  getUserLeaves(fromDate, toDate, uuid);
                },
              ),
              CupertinoButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  getUserLeaves(String fromDate, String toDate, String uuid) async {
    List dlist = [];
    var response = await dio.post(ServicesApi.getData,
        data: {
          "parameter1": "getUserLeaveDates",
          "parameter2": uuid,
          "parameter3": fromDate,
        },
        options: Options(contentType: ContentType.parse('application/json')));
    if (response.statusCode == 200 || response.statusCode == 201) {
      lcdm = (json.decode(response.data) as List)
          .map((data) => new LeavesCheckingDatesModel.fromJson(data))
          .toList();
      for (int i = 0; i < lcdm.length; i++) {
        if (lcdm[i].elc_date == fromDate || lcdm[i].elc_date == toDate) {
          dlist.add(lcdm[i].elc_date);
        }
      }
      if (dlist.length <= 0) {
        // callServiceInsert();
      } else {
        pr.hide();
        Fluttertoast.showToast(
            msg: "Sorry! You have already requested a leave for this date(s).");
      }
    } else if (response.statusCode == 401) {
      throw Exception("Something went wrong.!");
    }
  }
}
