import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Ebiz/activity/Login.dart';
import 'package:Ebiz/functionality/notifications/NotificationScreen.dart';
import 'package:Ebiz/functionality/salesLead/ManagmentIndustrialEntry.dart';
import 'package:Ebiz/functionality/salesLead/SalesIndutrialEntry.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_id/device_id.dart';
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
import 'package:geolocation/geolocation.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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
      profilePic,
      deviceId,
      mgmtCnt,
      profilename = "-",
      fullname = "-",
      userId = "-",
      timeStart = "-",
      timeEnd = "-",
      workStatus = "-",
      monthA = "           ",
      yearA = "         ",
      yearB = "         ";
  var dbHelper = DatabaseHelper();
  var now = DateTime.now();
  String siecnt, msiecnt;
  LocationResult lresult;
  GeolocationResult georesult;
  List<AttendanceModel> atteModel = [];
  Future<List<AttendanceModel>> attList;
  Connectivity connectivity;
  static double lati = 0.0, longi = 0.0;
  StreamSubscription<ConnectivityResult> streamSubscription;
  StreamProvider<UserLocationModel> userlocationstrem;
  String latiL, longiL;
  List<TaskListModel> tasklistModel = [];
  var userlocation;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  getEmpCode() async {
    deviceId = await DeviceId.getID;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      empCode = preferences.getString("uEmpCode").toString();
      profilename = preferences.getString("profileName");
      fullname = preferences.getString("fullname");
      userId = preferences.getString("userId");
      profilePic = preferences.getString("picPath");
      mgmtCnt = preferences.getString("mgmtCnt");

      getSessionTimeout(userId);
      getPaidCount(empCode);
      getPendingCount(userId);
      getSalesIndustrialDataCount(userId);
      getSalesIndustrialMangmentDataCount();
      // getCurrentDate();
      AttendanceModel attendanceModel =
          AttendanceModel(userId, "-", "-", "-", "-", "-", "-");
      dbHelper.save(attendanceModel);
      _firebaseMessaging.getToken().then((String token) {
        assert(token != null);
        insertToken(userId, token);
      });
      // insertDeviceID(deviceId, userId);
    });
  }

  _localGet() async {
    var now = DateTime.now();
    var checkDate = DateFormat("yyyy-MM-dd").format(now).toString();
    atteModel = await dbHelper.getCurrentDateTime();
    // attList = dbHelper.getCurrentDateTime();
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

  getSessionTimeout(String userNo) async {
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["string"],
            "parameter1": "getSessionTimeout",
            "parameter2": userNo,
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        int data = json.decode(response.data)[0]["cnt"];
        if (data == 0) {
          insertmobileSession(userId);
        }
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception("Check your internet connection.");
      } else {
        return null;
      }
    }
  }

  logoutSession(String userNo) async {
    var response = await dio.post(ServicesApi.updateData,
        data: {
          "parameter1": "logoutSession",
          "parameter2": userNo,
          "parameter3": latiL,
          "parameter4": longiL,
        },
        options: Options(contentType: ContentType.parse('application/json')));
    if (response.statusCode == 200 || response.statusCode == 201) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      var navigator = Navigator.of(context);
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Login()),
        ModalRoute.withName('/'),
      );
    } else if (response.statusCode == 401) {
      throw (Exception);
    }
  }

  insertmobileSession(String userNo) async {
    var response = await dio.post(ServicesApi.updateData,
        data: {
          "parameter1": "insertMobileSession",
          "parameter2": userNo,
        },
        options: Options(contentType: ContentType.parse('application/json')));
    if (response.statusCode == 200 || response.statusCode == 201) {
      locationSetState(userId);
    } else if (response.statusCode == 401) {
      throw (Exception);
    }
  }

  locationSetState(String userID) async {
    lresult = await Geolocation.lastKnownLocation();
    StreamSubscription<LocationResult> subscription =
        Geolocation.currentLocation(accuracy: LocationAccuracy.best)
            .listen((result) {
      if (result.isSuccessful) {
        setState(() {
          latiL = result.location.latitude.toString();
          longiL = result.location.longitude.toString();
        });
        if (latiL != null) {
          logoutSession(userId);
        } else {
          Fluttertoast.showToast(msg: "Please turn on gps");
          openSettings();
        }
      } else {
        Fluttertoast.showToast(msg: "Please turn on gps");
        openSettings();
      }
    });
  }

  openSettings() async {
    bool isOpened = await PermissionHandler().openAppSettings();
  }

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    var checkDate = DateFormat("yyyy-MMMM-dd").format(now).toString();
    monthA = checkDate.split("-")[1].toString().substring(0, 3);
    yearA = checkDate.split("-")[0].toString().substring(0, 2);
    yearB = checkDate.split("-")[0].toString().substring(2, 4);
    getEmpCode();
    _localGet();
    pushAttendance();
    connectivity = Connectivity();
    streamSubscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        getPaidCount(empCode);
        pushAttendance();
      } else {
        _localGet();
        Fluttertoast.showToast(msg: "Data Disconnected.");
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
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: IconButton(
                        icon: Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      NotificationScreen()));
                        },
                      ),
                    ),
                    Positioned(
                      top: 15,
                      left: 26,
                      child: Icon(
                        Icons.brightness_1,
                        color: Colors.red,
                        size: 12.0,
                      ),
                    )
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(right: 5),
              child: IconButton(
                icon: Icon(
                  Icons.account_circle,
                  size: 35,
                  color: Colors.white,
                ),
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
        body: stackWidget(context));
  }

  stackWidget(BuildContext context) {
    return Scrollbar(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 5, right: 5),
            alignment: Alignment.bottomRight,
            child: Image.asset(
              'assets/images/ebiz.png',
              color: lwtColor,
              height: 80,
              width: 80,
            ),
          ),
          RefreshIndicator(
            child: Container(
              margin: EdgeInsets.only(left: 57, right: 0, top: 0),
              child: StaggeredGridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 10, top: 10, left: 10),
                    child: dashboard1(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5),
                    child: dashboard2(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5),
                    child: dashboard3(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5),
                    child: dashboard5(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5),
                    child: dashboard6(),
                  ),
                  mgmtCnt == "1"
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8, left: 8),
                          child: managmentSIEntry(),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(right: 8, left: 8),
                          child: salesIndustryEntry(),
                        ),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(4, 100.0),
                  StaggeredTile.extent(2, 80.0),
                  StaggeredTile.extent(2, 80.0),
                  StaggeredTile.extent(2, 80.0),
                  StaggeredTile.extent(2, 80.0),
                  StaggeredTile.extent(4, 80.0),
                ],
              ),
            ),
            onRefresh: () async {
              pushAttendance();
              // getAttendance();
              getPendingCount(userId);
            },
          ),
          CollapsingNavigationDrawer("1"),
        ],
      ),
    );
  }

  _empty() {}

  Material dashboard1() {
    return Material(
      color: Colors.white,
      elevation: 6.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: lwtColor,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Text(
                          yearA,
                          style: TextStyle(
                              fontSize: 24.0,
                              color: Color(0xFF272D34),
                              fontFamily: "Cormorant"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Text(
                          yearB,
                          style: TextStyle(
                              fontSize: 65.0,
                              color: Color(0xFF272D34),
                              fontFamily: "Cormorant",
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                  //
                ],
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      "Attendance".toUpperCase(),
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Color(0xFF272D34),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      paidCount != null ? paidCount : "".toString(),
                      style: TextStyle(fontSize: 30.0, color: lwtColor),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Text(
                      "Days",
                      style: TextStyle(fontSize: 12.0, color: lwtColor),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Text(
                      monthA,
                      style: TextStyle(
                          fontSize: 40.0,
                          color: Color(0xFF272D34),
                          fontFamily: "Cormorant",
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 5,
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
      child: InkWell(
        onTap: () async {
          if (workStatus == "-" || workStatus == "") {
            var data = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => WorkStatus()));
            if (data == "1") {
              setState(() {
                workStatus = "Tour";
              });
            } else {
              setState(() {
                workStatus = "-";
              });
            }
          } else {
            Fluttertoast.showToast(
                msg: "Work status once confirmed, cannot be changed.");
          }
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        "Work Location".toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
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
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      "Task Pending".toUpperCase(),
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Color(0xFF272D34),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.0),
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
      child: InkWell(
        onTap: () {
          // if (workStatus != "At-Office") {
          if (workStatus == "Tour" || workStatus == "At-Office") {
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
                  Fluttertoast.showToast(
                      msg:
                          "Please Turn on GPS, to mark attendance., to mark attendance.");
                }
              });
            } else {
              Fluttertoast.showToast(msg: 'Day Start has already been marked');
            }
          } else {
            Fluttertoast.showToast(
                msg: "Choose your work status, to mark attendance.");
          }
          // }
          // else {
          //   Fluttertoast.showToast(
          //       msg: "Attendace accept through Bio-Metric only.");
          // }
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Day Start".toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
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
      child: InkWell(
        onTap: () {
          // if (workStatus != "At-Office") {
          if (workStatus == "Tour" || workStatus == "At-Office") {
            if (timeStart == "-") {
              Fluttertoast.showToast(
                  msg: "Day Start need to be marked before marking day end.");
            } else if (workStatus == "-" ||
                workStatus == " " ||
                workStatus == "") {
              Fluttertoast.showToast(
                  msg: "Choose your work status, to mark attendance.");
            } else if (timeEnd == "-") {
              setState(() {
                if (userlocation != null) {
                  roundedAlertDialog(userlocation);
                } else {
                  Fluttertoast.showToast(
                      msg: "Please Turn on GPS, to mark attendance.");
                }
              });
            } else {
              Fluttertoast.showToast(msg: 'Day End marked sucessfully.');
            }
          } else {
            Fluttertoast.showToast(
                msg: "Choose your work status, to mark attendance.");
          }
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Day End".toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
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

  Material salesIndustryEntry() {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: () {
          var navigator = Navigator.of(context);
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => SalesIndustrialEntry()),
            ModalRoute.withName('/'),
          );
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Work Visit",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Color(0xFF272D34),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        siecnt?.toString() ?? "-",
                        style: TextStyle(fontSize: 25.0, color: lwtColor),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 2),
                  child: IconButton(
                    icon: Icon(
                      Icons.visibility,
                      color: lwtColor,
                      size: 34,
                    ),
                    onPressed: () {
                      var navigator = Navigator.of(context);
                      navigator.pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SalesIndustrialEntry()),
                        ModalRoute.withName('/'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Material managmentSIEntry() {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: () {
          var navigator = Navigator.of(context);
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => ManagmentIndustrialEntry()),
            ModalRoute.withName('/'),
          );
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Work Visit",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Color(0xFF272D34),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        msiecnt?.toString() ?? "-",
                        style: TextStyle(fontSize: 25.0, color: lwtColor),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 2),
                  child: IconButton(
                    icon: Icon(
                      Icons.visibility,
                      color: lwtColor,
                      size: 34,
                    ),
                    onPressed: () {
                      var navigator = Navigator.of(context);
                      navigator.pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ManagmentIndustrialEntry()),
                        ModalRoute.withName('/'),
                      );
                    },
                  ),
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
            "encryptedFields": ["string"],
            "parameter1": "getPaidCount",
            "parameter2": empCodee.toString(),
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        var res = json.decode(response.data);
        PaidCountModel data = PaidCountModel.fromJson(res[0]);
        // print(data.toString());
        setState(() {
          paidCount = checkPaidCount(data.paidCount.toString());
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
        throw Exception("Check your internet connection.");
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
            "encryptedFields": ["string"],
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
          if (attData.in_time != null && attData != null) {
            if (attData.in_time != "" &&
                attData.in_time != null &&
                attData.in_time != "null" &&
                attData.in_time != "-" &&
                attData.in_time != " ") {
              setState(() {
                workStatus = "At-Office";
                timeStart = checkTimeAtt(attData.in_time.toString(), 1);
                timeEnd = checkTimeAtt(attData.out_time.toString(), 2);
              });
              AttendanceGettingModel attendanceModel =
                  AttendanceGettingModel(userId, timeStart, timeEnd);
              dbHelper.updateStartandEnd(attendanceModel);
            }
          }
        });
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception("Check your internet connection.");
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
        // print(res.toString());
      } else {
        Fluttertoast.showToast(msg: "Check your internet connection.");
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception("Check your internet connection.");
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
        // print(res.toString());
      } else {
        Fluttertoast.showToast(msg: "Check your internet connection.");
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception("Check your internet connection.");
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
                  setState(() {
                    timeEnd = DateFormat("HH:mm:ss").format(now1).toString();
                  });
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
            "encryptedFields": ["string"],
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
        throw Exception("Check your internet connection.");
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
      // print(token);
    } else if (response.statusCode == 401) {
      throw (Exception);
    }
  }

  String checkTimeAtt(String data, int status) {
    if (status == 1) {
      if (data == "null") {
        return "-";
      } else {
        return data;
      }
    } else {
      if (data == "null") {
        return "-";
      } else {
        var now = DateTime.now();
        String time = DateFormat("HH").format(now);
        int hour = int.parse(time);
        if (hour >= 22) {
          return data;
        } else {
          return "-";
        }
      }
    }
  }

  getSalesIndustrialDataCount(String user_id) async {
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["string"],
            "parameter1": "salesIndustrialCount",
            "parameter2": user_id,
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          var res = json.decode(response.data);
          PendingCountModel data = PendingCountModel.fromJson(res[0]);
          setState(() {
            siecnt = data.pendingCount.toString();
          });
        });
      } else if (response.statusCode == 401) {
        throw Exception("Incorrect data");
      } else
        throw Exception('Authentication Error');
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception("Check your internet connection.");
      }
    }
  }

  getSalesIndustrialMangmentDataCount() async {
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["string"],
            "parameter1": "getSalesEntryCount",
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          var res = json.decode(response.data);
          PendingCountModel data = PendingCountModel.fromJson(res[0]);
          setState(() {
            msiecnt = data.pendingCount.toString();
          });
        });
      } else if (response.statusCode == 401) {
        throw Exception("Incorrect data");
      } else
        throw Exception('Authentication Error');
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception("Check your internet connection.");
      }
    }
  }

  // insertDeviceID(String deviceId, String userId) async {
  //   var response = await dio.post(ServicesApi.insertDeviceid,
  //       data: {"deviceId": deviceId, "uId": userId},
  //       options: Options(contentType: ContentType.parse('application/json')));
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     // print(token);
  //   } else if (response.statusCode == 401) {
  //     throw (Exception);
  //   }
  // }

  String checkPaidCount(String countP) {
    if (countP.split(".")[1] == "0") {
      return countP.split(".")[0];
    } else if (countP.split(".")[1] == "5") {
      return countP;
    }
  }
}
