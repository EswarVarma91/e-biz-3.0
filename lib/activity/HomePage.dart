import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:Ebiz/activity/ProfileScreen.dart';
import 'package:Ebiz/activity/WorkStatus.dart';
import 'package:Ebiz/commonDrawer/CollapsingNavigationDrawer.dart';
import 'package:Ebiz/database/DatabaseHelper.dart';
import 'package:Ebiz/functionality/location/LocationService.dart';
import 'package:Ebiz/main.dart';
import 'package:Ebiz/model/AttendanceGettingModel.dart';
import 'package:Ebiz/model/AttendanceModel.dart';
import 'package:Ebiz/model/AttendanceServiceModel.dart';
import 'package:Ebiz/model/EndAttendanceModel.dart';
import 'package:Ebiz/model/PaidCountModel.dart';
import 'package:Ebiz/model/PendingCountModel.dart';
import 'package:Ebiz/model/StartAttendanceModel.dart';
import 'package:Ebiz/model/TaskListModel.dart';
import 'package:Ebiz/model/UserLocationModel.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static const methodChannel = const MethodChannel('eb');

  _MyHomePageState() {
    methodChannel.setMethodCallHandler((call) {
      Fluttertoast.showToast(msg: "Hello Eagle Biz");
      print("test " + call.method);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//        SystemNavigator.pop();
      },
      child: StreamProvider<UserLocationModel>(
        builder: (context) => LocationService().locationStream,
        child: HomePageLocation(),
      ),
    );
  }
}

class HomePageLocation extends StatefulWidget {
  @override
  _HomePageLocationState createState() => _HomePageLocationState();
}

class _HomePageLocationState extends State<HomePageLocation> {
  String paidCount = '', taskPending = "-", shortcut = "no action set";
  static Dio dio = Dio(Config.options);
  String empCode = "-",
      profilename = "-",
      fullname = "-",
      userId = "-",
      timeStart = "-",
      timeEnd = "-",
      workStatus = "-";
  var dbHelper = DatabaseHelper();
  var now = DateTime.now();
  List<AttendanceModel> atteModel = [];
  Future<List<AttendanceModel>> attList;
  Connectivity connectivity;
  static double lati = 0.0, longi = 0.0;
  StreamSubscription<ConnectivityResult> streamSubscription;
  StreamProvider<UserLocationModel> userlocationstrem;
  List<TaskListModel> tasklistModel = [];
  var userlocation;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  getEmpCode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      empCode = preferences.getString("uEmpCode").toString();
      profilename = preferences.getString("profileName");
      fullname = preferences.getString("fullname");
      userId = preferences.getString("userId");
      getPaidCount(empCode);
      getPendingCount(userId);
      AttendanceModel attendanceModel =
          AttendanceModel(userId, "-", "-", "-", "-", "-", "-");
      dbHelper.save(attendanceModel);
      _firebaseMessaging.getToken().then((String token) {
        assert(token != null);
        insertToken(userId, token);
      });
    });
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
            timeStart = atteModel[i].starttime;
            timeEnd = atteModel[i].endtime;
          });
          _writeEnd(atteModel[i].endtime);
          _writeStart(atteModel[i].starttime);
        } else {
          _writeStart("-");
          _writeEnd("-");
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    getEmpCode();
    _localGet();
    connectivity = Connectivity();
    streamSubscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        getPaidCount(empCode);
        pushAttendance();
      } else {
        _localGet();
        Fluttertoast.showToast(msg: "Check your internet connection.");
      }
    });
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userlocation = Provider.of<UserLocationModel>(context);
    setState(() {
      if (userlocation != null) {
        lati = userlocation.latitude;
        longi = userlocation.longitude;
        //        var currentTime=DateFormat("HH:mm").format(now);
        //        var checkCurrentTime=DateFormat("HH:mm").parse(currentTime.toString());
        //        var checkMorningTime=DateFormat("HH:mm").parse("08:00");
        //        var checkNightTime=DateFormat("HH:mm").parse("20:00");
        //        checkCurrentTime.difference(checkMorningTime).inMinutes.toString();
        //        if(checkCurrentTime.difference(checkMorningTime).inMinutes>=-1 && checkCurrentTime.difference(checkNightTime).inMinutes<=1)
        //        {
        //          const oneMin = const Duration(minutes:15);
        //          new Timer.periodic(oneMin, (Timer t) => sendUserLocation(lati,longi));
        //        }
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          fullname,
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 0),
            child: IconButton(
              icon: Icon(Icons.account_circle, color: Colors.white, size: 35),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ProfileScreen()));
              },
            ),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
          ),
          Container(
            margin: EdgeInsets.only(left: 65, right: 5, top: 0),
            child: StaggeredGridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 5, top: 10),
                  child: dashboard1(),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: dashboard2(),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: dashboard3(),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: dashboard5(),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: dashboard6(),
                ),
              ],
              staggeredTiles: [
                StaggeredTile.extent(4, 120.0),
                StaggeredTile.extent(2, 100.0),
                StaggeredTile.extent(2, 100.0),
                StaggeredTile.extent(2, 100.0),
                StaggeredTile.extent(2, 100.0),
              ],
            ),
          ),
          CollapsingNavigationDrawer("1"),
        ],
      ),
    );
  }

  Material dashboard1() {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: lwtColor,
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
                      "Attendance".toUpperCase(),
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Color(0xFF272D34),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      paidCount != null ? paidCount : "".toString(),
                      style: TextStyle(fontSize: 25.0, color: lwtColor),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Text("Days",
                      style: TextStyle(fontSize: 12.0, color: lwtColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Material dashboard2() {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0xFF272D34),
      child: InkWell(
        onTap: () async {
          if (workStatus == "-" ||
              workStatus == "" ||
              workStatus == " " ||
              workStatus == null) {
            var data = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => WorkStatus()));
            if (data == "1") {
              setState(() {
                workStatus = "Tour";
              });
            } else if (data == "2") {
              setState(() {
                workStatus = "At-Office";
              });
            } else {
              setState(() {
                workStatus = "-";
              });
            }
          } else {
            Fluttertoast.showToast(msg: "Work status once confirmed, cannot be changed.");
          }
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
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Work Location".toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        workStatus != null ? workStatus : "",
                        style: TextStyle(fontSize: 20.0, color: lwtColor),
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

  Material dashboard3() {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0xFF272D34),
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
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Task Pending".toUpperCase(),
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Color(0xFF272D34),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      taskPending != null ? taskPending : "",
                      style: TextStyle(fontSize: 25.0, color: lwtColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Material dashboard5() {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: lwtColor,
      child: InkWell(
        onTap: () {
          if(workStatus != "At-Office"){
          if (workStatus == "Tour") {
            if (timeStart == "-") {
              var now1 = DateTime.now();
              setState(() {
                if (userlocation != null) {
                  timeStart = DateFormat("HH:mm:ss").format(now1).toString();
                  StartAttendanceModel am = StartAttendanceModel(
                      userId,
                      timeStart,
                      userlocation.latitude.toString(),
                      userlocation.longitude.toString());
                  dbHelper.updateStart(am);

                  _insertStartTimeService(
                      timeStart,
                      userlocation.latitude.toString(),
                      userlocation.longitude.toString(),
                      DateFormat("yyyy-MM-dd").format(now1).toString());
                } else {
                  Fluttertoast.showToast(msg: "Please Turn on GPS, to mark attendance., to mark attendance.");
                }
              });
            } else {
              Fluttertoast.showToast(msg: 'Day Start has already been marked');
            }
          } else {
            Fluttertoast.showToast(msg: "Choose your work status, to mark attendance.");
          }
        }else{
          Fluttertoast.showToast(msg: "Attendace accept through Bio-Metric only.");
        }
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
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Day Start".toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        timeStart != null ? timeStart : "",
                        style: TextStyle(fontSize: 25.0, color: lwtColor),
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

  Material dashboard6() {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: lwtColor,
      child: InkWell(
        onTap: () {
          if(workStatus!="At-Office"){
          if(workStatus=="Tour"){
          if (timeStart == "-") {
            Fluttertoast.showToast(msg: "Day Start need to be marked before marking day end.");
          } else if (workStatus == "-" ||
              workStatus == " " ||
              workStatus == "") {
            Fluttertoast.showToast(msg: "Choose your work status, to mark attendance.");
          } else if (timeEnd == "-") {
            setState(() {
              if (userlocation != null) {
                roundedAlertDialog(userlocation);
              } else {
                Fluttertoast.showToast(msg: "Please Turn on GPS, to mark attendance.");
              }
            });
          } else {
            Fluttertoast.showToast(msg: 'Day End marked sucessfully.');
          }
          }else{
            Fluttertoast.showToast(msg: "Choose your work status, to mark attendance.");
          }
          }else{
            Fluttertoast.showToast(msg:"Attendace accept through Bio-Metric only.");
          }
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
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Day End".toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        timeEnd != null ? timeEnd : "",
                        style: TextStyle(fontSize: 25.0, color: lwtColor),
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

  getPaidCount(String empCodee) async {
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "parameter1": "getPaidCount",
            "parameter2": empCodee.toString(),
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        var res = json.decode(response.data);
        PaidCountModel data = PaidCountModel.fromJson(res[0]);
        print(data.toString());
        setState(() {
          paidCount = data.paidCount.toString();
        });
      } else {
        Fluttertoast.showToast(msg: "Check your internet connection.");
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception(
            "Check your internet connection.");
      } else {
        return null;
      }
    }
  }

  void getAttendance() async {
    var now = DateTime.now();
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "parameter1": "GetEmpDayStatus",
            "parameter2": userId,
            "parameter3": DateFormat("yyyy-MM-dd").format(now).toString(),
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        var res = json.decode(response.data);
        AttendanceServiceModel attData =
            AttendanceServiceModel.fromJson(res[0]);
        setState(() {
          timeStart = attData.in_time.toString();
          timeEnd = attData.out_time.toString();
          if (attData.in_time != null && attData != null) {
            AttendanceGettingModel attendanceModel =
                AttendanceGettingModel(userId, timeStart, timeEnd);
            dbHelper.updateStartandEnd(attendanceModel);
          }
        });
      } else {
        Fluttertoast.showToast(msg: "Check your internet connection.");
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception(
            "Check your internet connection.");
      } else {
        return null;
      }
    }
  }

  void _writeStart(String timeStart) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("timeStart", timeStart);
  }

  void _writeEnd(String timeEnd) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("timeEnd", timeEnd);
  }

  void pushAttendance() async {
    List<AttendanceModel> completeattList = await dbHelper.getAllAttendance();
    if (completeattList.length != null) {
      for (int i = 0; i < completeattList.length; i++) {
        if (completeattList[i].user_id == userId &&
            completeattList[i].starttime != "-" &&
            completeattList[i].startlat != "-" &&
            completeattList[i].startlong != "-") {
          _insertStartTimeService(
              completeattList[i].starttime.toString(),
              completeattList[i].startlat.toString(),
              completeattList[i].startlong.toString(),
              completeattList[i].date.toString());
        }
        if (completeattList[i].user_id == userId &&
            completeattList[i].endtime != "-" &&
            completeattList[i].endlat != "-" &&
            completeattList[i].endlong != "-") {
          _insertEndTimeService(
              completeattList[i].endtime.toString(),
              completeattList[i].endlat.toString(),
              completeattList[i].endlong.toString(),
              completeattList[i].date.toString());
        }
      }
    }
    getAttendance();
  }

  _insertStartTimeService(
      String timeStarta, String lat, String long, String datest) async {
    try {
      var response = await dio.post(ServicesApi.updateData,
          data: {
            "parameter1": "UpdtEmpDayStartByCodeDate",
            "parameter2": empCode.toString(),
            "parameter3": lat.toString(),
            "parameter4": long.toString(),
            "parameter5": timeStarta.toString(),
            "parameter6": datest,
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        var res = json.decode(response.data);
        print(res.toString());
        Fluttertoast.showToast(msg:"Day Start marked sucessfully.");
      } else {
        Fluttertoast.showToast(msg: "Check your internet connection.");
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception(
            "Check your internet connection.");
      } else {
        return null;
      }
    }
  }

  void _insertEndTimeService(
      String timeEnda, String lat, String long, String dateen) async {
    try {
      var response = await dio.post(ServicesApi.updateData,
          data: {
            "parameter1": "UpdtEmpDayEndByCodeDate",
            "parameter2": empCode.toString(),
            "parameter3": lat.toString(),
            "parameter4": long.toString(),
            "parameter5": timeEnda.toString(),
            "parameter6": dateen,
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        var res = json.decode(response.data);
        print(res.toString());
      } else {
        Fluttertoast.showToast(msg: "Check your internet connection.");
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception(
            "Check your internet connection.");
      } else {
        return null;
      }
    }
  }

  void sendUserLocation(double lati, double longi) async {
    var now = DateTime.now();
    var dateNow = DateFormat("yyyy-MM-dd hh:mm:ss").format(now);
    try {
      var response = await dio.put(ServicesApi.updateData,
          data: {
            "parameter1": "insertUserLocations",
            "parameter2": userId,
            "parameter3": lati.toString(),
            "parameter4": longi.toString(),
            "parameter5": dateNow
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        var res = json.decode(response.data);
        print(res.toString());
      } else {
        Fluttertoast.showToast(msg: "Check your internet connection.");
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception(
            "Check your internet connection.");
      } else {
        return null;
      }
    }
  }

  roundedAlertDialog(userLocation) {
    var now1 = DateTime.now();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: new Text(
              'Do you want to end the day.!',
              style: TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              new CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('No'),
              ),
              new CupertinoButton(
                onPressed: () async {
                  timeEnd = DateFormat("HH:mm:ss").format(now1).toString();
                  EndAttendanceModel am = EndAttendanceModel(
                      userId,
                      timeEnd,
                      userlocation.latitude.toString(),
                      userlocation.longitude.toString());
                  dbHelper.updateEnd(am);

                  ///LocationService
                  _insertEndTimeService(
                      timeEnd,
                      userlocation.latitude.toString(),
                      userlocation.longitude.toString(),
                      DateFormat("yyyy-MM-dd").format(now1).toString());
                  Navigator.of(context).pop();
                },
                child: new Text('Yes'),
              ),
            ],
          );
        });
  }

  void getPendingCount(String userIdd) async {
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "parameter1": "getPendingCount",
            "parameter2": userIdd.toString(),
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        var res = json.decode(response.data);
        PendingCountModel data = PendingCountModel.fromJson(res[0]);
        setState(() {
          taskPending = data.pendingCount.toString();
        });
      } else {
        Fluttertoast.showToast(msg: "Check your internet connection.");
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception(
            "Check your internet connection.");
      } else {
        return null;
      }
    }
  }

  insertToken(String uid, String token) async {
    var response = await dio.post(ServicesApi.updateData,
        data: {
          "parameter1": "insertToken",
          "parameter2": uid,
          "parameter3": token
        },
        options: Options(contentType: ContentType.parse('application/json')));
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(token);
    } else if (response.statusCode == 401) {
      throw (Exception);
    }
  }
}
