import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:Ebiz/functionality/permissions/LeaveType.dart';
import 'package:Ebiz/functionality/permissions/Permissions.dart';
import 'package:Ebiz/model/LeavesCheckingDatesModel.dart';
import 'package:Ebiz/model/LeavesCheckingModel.dart';
import 'package:Ebiz/model/RestrictPermissionsModel.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
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
                    onTap: () {
                      selectLeaveType(context);
                    },
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
                    onTap: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(y, m - 1, d),
                          maxTime: DateTime(y, m + 2, d),
                          theme: DatePickerTheme(
                              backgroundColor: Colors.white,
                              itemStyle: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                              ),
                              doneStyle:
                                  TextStyle(color: Colors.blue, fontSize: 12)),
                          onChanged: (date) {
                        changeDateF(date);
                      }, onConfirm: (date) {
                        changeDateF(date);
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
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
                            minTime: DateTime(y, m - 2, d),
                            maxTime: DateTime(y, m + 2, d),
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
                          onTap: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                //                            minTime: DateTime(2019, 3, 5),
                                minTime: DateTime(y, m - 2, d),
                                maxTime: DateTime(y, m + 2, d),
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
                                  minTime: DateTime(y, m - 2, d),
                                  maxTime: DateTime(y, m + 2, d),
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
  }

  _checkDay() async {
    if (fromDate.isEmpty) {
      Fluttertoast.showToast(msg: "Choose your 'From Date'.");
    } else if (toDate.isEmpty) {
      Fluttertoast.showToast(msg: "Choose your 'To Date'.");
    } else if (leaveType == 'Leave Type' || leaveType == "null") {
      Fluttertoast.showToast(msg: 'Select the Leave Type.');
    } else if (_controller1.text.isEmpty) {
      Fluttertoast.showToast(msg: "Enter the Purpose for Leave.");
    } else {
      //Service Call
      checkLeavePolicy(branchId, fromDate, toDate, leaveType, uuid);
    }
  }

  _checkhalfday() async {
    if (fromDate.isEmpty) {
      Fluttertoast.showToast(msg: "Choose 'Date' for Application.");
    } else if (leaveType == 'Leave Type' || leaveType == "null") {
      Fluttertoast.showToast(msg: 'Select the Leave Type.');
    } else if (_controller1.text.isEmpty) {
      Fluttertoast.showToast(msg: "Enter the Purpose for Leave.");
    } else {
      //Service Call
      checkLeavePolicy(branchId, fromDate, toDate, leaveType, uuid);
    }
  }

  void checkLeavePolicy(String branchId, String fromDate, String toDate,
      String leaveType, String uuid) async {
    var response = await dio.post(ServicesApi.leavePolicy,
        data: {
          "branchId": branchId,
          "fromDate": fromDate,
          "toDate": toDate,
          "leaveType": leaveType,
          "userId": uuid
        },
        options: Options(contentType: ContentType.parse("application/json")));
    if (response.statusCode == 200 || response.statusCode == 201) {
      // int noofBeforeDays = json.decode(response.data)['NO_OF_BEFORE_DAYS'];
      // int totaleffectiveDays =json.decode(response.data)['TOTAL_EFFECTIVE_DAYS'];

      // List pastContinousDays =json.decode(response.data)['PAST_CONTINOUS_DAYS'];

      if (json.decode(response.data)['IF_IT_IS_HOLIDAY'] == false) {
        if (json.decode(response.data)['ALREADY_ON_LEAVE'] == false) {
          if (json.decode(response.data)['SUFFICIENT_LEAVES'] == true) {
            if (leaveType == "SL") {
              if (json.decode(response.data)['SICK_LEAVE'] == true &&
                  json.decode(response.data)['STATUS'] == 1) {
                //insert data
                callServiceInsert();
              } else {
                Fluttertoast.showToast(
                    msg:
                        "Sick leave should apply previous dates only on joined date.");
              }
            } else if (leaveType == "CAL") {
              if (json.decode(response.data)['EMERGENCY_LEAVES'] == true &&
                  json.decode(response.data)['STATUS'] == 1) {
                //insert data
                callServiceInsert();
              } else {
                if (json.decode(response.data)['BEFORE_5DAYS'] == true) {
                  if (json.decode(response.data)['STATUS'] == 1) {
                    //insert data
                    callServiceInsert();
                  } else {
                    Fluttertoast.showToast(
                        msg:
                            "You are exceeding the maximum number of leave days.");
                  }
                } else {
                  if (json
                          .decode(response.data)['EFFECTIVE_LEAVES_DATES']
                          .length >
                      1) {
                    Fluttertoast.showToast(
                        msg: "You should apply before 6 days of applied date.");
                  } else {
                    Fluttertoast.showToast(
                        msg:
                            "You should apply emergency leave before start time of branch on current date.");
                  }
                }
              }
            } else if (leaveType == "CL") {
              if ("Fixed Term" == "Fixed Term") {
                if (json.decode(response.data)['EMERGENCY_LEAVES'] &&
                    json.decode(response.data)['STATUS'] == 1) {
                  //insert data
                  callServiceInsert();
                } else {
                  if (json.decode(response.data)['BEFORE_5DAYS'] == true) {
                    if (json.decode(response.data)['STATUS'] == 1) {
                      //insert data
                      callServiceInsert();
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              "You are exceeding the maximum number of leave days.");
                    }
                  } else {
                    if (json
                            .decode(response.data)['EFFECTIVE_LEAVES_DATES']
                            .length >
                        1) {
                      Fluttertoast.showToast(
                          msg:
                              "You should apply before 6 days of current date.");
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              "You should apply emergency leave before start time of branch on current date.");
                    }
                  }
                }
              } else {
                if (json.decode(response.data)['EMERGENCY_LEAVES'] == true &&
                    json.decode(response.data)['STATUS'] == 1) {
                  //insert data
                  callServiceInsert();
                } else {
                  if (json.decode(response.data)['BEFORE_5DAYS'] == true &&
                      json.decode(response.data)['STATUS'] == 1) {
                    //insert data
                    callServiceInsert();
                  } else {
                    Fluttertoast.showToast(
                        msg: "You should apply before 6 days of current data.");
                  }
                }
              }
            } else {
              if (json.decode(response.data)['BEFORE_5DAYS'] == true) {
                if (json.decode(response.data)['STATUS'] == 1) {
                  //insert data
                  callServiceInsert();
                } else {
                  Fluttertoast.showToast(
                      msg:
                          'You are exceeding the maximum number of leave days.');
                }
              } else {
                Fluttertoast.showToast(
                    msg: "You should apply before 6 days of current date.");
              }
            }
          } else {
            Fluttertoast.showToast(msg: "You have insufficient leaves.");
          }
        } else {
          Fluttertoast.showToast(msg: "You have already applied leave on these dates.");
        }
      } else {
        Fluttertoast.showToast(msg: "You are applying on leave on holiday.");
      }
    } else if (response.statusCode == 401) {
      throw (Exception);
    }
  }
}
