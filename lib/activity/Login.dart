import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:device_id/device_id.dart';
import 'package:Ebiz/activity/HomePage.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:Ebiz/model/LoginModel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocation/geolocation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:permission_handler/permission_handler.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  bool _isLoading = false;
  String deviceId, latiL, longiL;
  List<LoginModel> loginList = [];
  static Dio dio = Dio(Config.options);
  var _controller1 = TextEditingController();
  var _controller2 = TextEditingController();
  LocationResult result;
  GeolocationResult georesult;
  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  checkPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.locationAlways]);
  }

  @override
  void initState() {
    super.initState();
    checkPermission();

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        // print('on message $message');
        // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
        displayNotification(message);
        // print(message);
        // _showItemDialog(message);
      },
      onResume: (Map<String, dynamic> message) {
        // print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        // print('on launch $message');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      // print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      // print(token);
    });
  }

  Future displayNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'channelid',
      'flutterfcm',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    // await Fluttertoast.showToast(
    //     msg: "Notification Clicked",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIos: 1,
    //     backgroundColor: Colors.black54,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
    /*Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    );*/
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Fluttertoast.showToast(
                  msg: "Notification Clicked",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: _isLoading
              ? CircularProgressIndicator()
              : Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),
                      SizedBox(
                        height: 55,
                      ),
                      Container(
                        child: Image.asset(
                          'assets/images/ebiz.png',
                          height: 80,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 32),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 45,
                              padding: EdgeInsets.only(
                                  top: 4, left: 16, right: 16, bottom: 4),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12, blurRadius: 5),
                                  ]),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: _controller1,
                                style: TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    Icons.fiber_pin,
                                    color: Colors.grey,
                                  ),
                                  hintText: 'Employee Code',
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 45,
                              margin: EdgeInsets.only(top: 22),
                              padding: EdgeInsets.only(
                                  top: 4, left: 16, right: 16, bottom: 4),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12, blurRadius: 5)
                                  ]),
                              child: TextFormField(
                                controller: _controller2,
                                obscureText: _obscureText,
                                style: TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(
                                      Icons.vpn_key,
                                      color: Colors.grey,
                                    ),
                                    hintText: 'Password',
                                    suffixIcon: GestureDetector(
                                      dragStartBehavior: DragStartBehavior.down,
                                      onTap: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      child: Icon(
                                        _obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        semanticLabel: _obscureText
                                            ? 'show password'
                                            : 'hide password',
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Material(
                              color: lwtColor,
                              borderRadius: BorderRadius.circular(32.0),
                              shadowColor: Colors.grey,
                              elevation: 15.0,
                              child: MaterialButton(
                                minWidth: 300.0,
                                height: 42.0,
                                onPressed: () async {
                                  locationSetState();
                                },
                                child: Text('Login'.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            SizedBox(
                              height: 150,
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/eaglebiz.png',
                                width: 150,
                                height: 60,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  locationSetState() async {
    result = await Geolocation.lastKnownLocation();
    StreamSubscription<LocationResult> subscription =
        Geolocation.currentLocation(accuracy: LocationAccuracy.best)
            .listen((result) {
      if (result.isSuccessful) {
        setState(() {
          latiL = result.location.latitude.toString();
          longiL = result.location.longitude.toString();
        });
        if (latiL != null) {
          _loginmethod();
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

  _loginmethod() async {
    String email = _controller1.text.toString();
    String password = _controller2.text.toString();
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: "Enter Employee Code");
    } else if (password.isEmpty) {
      Fluttertoast.showToast(msg: "Enter Password");
    } else {
      _makePostRequest(email, password);
    }
  }

  _makePostRequest(String email, String password) async {
    var now = DateTime.now();
    deviceId = await DeviceId.getID;
    try {
      var response = await dio.post(ServicesApi.new_login_url,
          data: {
            "empCode": email,
            "password": password,
            "type": "LOG_IN",
            "deviceId": deviceId,
            "dateTime": DateFormat("yyyy-MM-dd HH:mm:ss").format(now),
            "latitude": latiL,
            "longitude": longiL,
          },
          );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if ((json.decode(response.data)['cnt'] == 1)) {
          _writeData(
            json.decode(response.data)['empEmail'],
            json.decode(response.data)['userId'],
            json.decode(response.data)['empFullName'],
            json.decode(response.data)['empCode'],
            json.decode(response.data)['hrCnt'],
            json.decode(response.data)['travelCnt'],
            json.decode(response.data)['salesCnt'],
            json.decode(response.data)['empProfileName'],
            json.decode(response.data)['empDownTeamIds'],
            "",
            json.decode(response.data)['brnachId'],
            json.decode(response.data)['empEmail'],
            json.decode(response.data)['empDepartment'],
            json.decode(response.data)['empDesignation'],
            json.decode(response.data)['fixedTerm'],
            json.decode(response.data)['picPath'],
            json.decode(response.data)['mgmtCnt'],
          );
          var navigator = Navigator.of(context);
          navigator.pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => HomePage()),
              ModalRoute.withName('/'));
        } else if (json.decode(response.data)['cnt'] == 0) {
          Fluttertoast.showToast(msg: "Invalid Credentials");
        } else {
          Fluttertoast.showToast(
              msg: "Please logout your active session.");
        }
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(msg: "Please check you internet connection.");
        throw Exception("Please check you internet connection.");
      } else {
        Fluttertoast.showToast(msg: "Please check you internet connection.");
        throw Exception('Authentication Error');
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        Fluttertoast.showToast(
          msg: "Socket time out.",
        );
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception("Check your internet connection.");
      } else {
        return null;
      }
    }
  }

  void _writeData(
      String userEmail,
      int uId,
      String fullName,
      String uEmpCode,
      int hrCnt,
      int travelCnt,
      int salesCnt,
      String profileName,
      String downTeamId,
      String mobilenumber,
      int branchid,
      String emailId,
      String department,
      String designation,
      int fixedTerm,
      String picPath,
      int mgmtCnt) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("data", userEmail.toString());
    preferences.setString("userId", uId.toString());
    preferences.setString("fullname", fullName.toString());
    preferences.setString("uEmpCode", uEmpCode.toString());
    preferences.setString("hrCnt", hrCnt.toString());
    preferences.setString("travelCnt", travelCnt.toString());
    preferences.setString("salesCnt", salesCnt.toString());
    preferences.setString("profileName", profileName.toString());
    preferences.setString("downTeamId", downTeamId.toString());
    preferences.setString("mobilenumber", mobilenumber.toString());
    preferences.setString("branchid", branchid.toString());
    preferences.setString("emailId", emailId.toString());
    preferences.setString("department", department.toString());
    preferences.setString("designation", designation.toString());
    preferences.setString("fixedTerm", fixedTerm.toString());
    preferences.setString("picPath", picPath.toString());
    preferences.setString("mgmtCnt", mgmtCnt.toString());
  }
}
