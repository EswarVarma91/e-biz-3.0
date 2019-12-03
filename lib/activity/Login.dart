import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Connectivity connectivity;
  bool _obscureText = true;
  bool _isLoading = false;
  List<LoginModel> loginList = [];
  static Dio dio = Dio(Config.options);
  var _controller1 = TextEditingController();
  var _controller2 = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    connectivity = Connectivity();
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
        print('on message $message');
        // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
        displayNotification(message);
        // _showItemDialog(message);
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      // print(token);
    });
  }

  Future displayNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channelid', 'flutterfcm', 'your channel description',
        importance: Importance.Max, priority: Priority.High,);
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
                        height: 80,
                      ),
                      Container(
                        child: Image.asset(
                          'assets/images/eaglebiz.png',
                          width: 300,
                          height: 80,
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          'assets/images/ebiz.png',
                          height: 60,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 62),
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
                              margin: EdgeInsets.only(top: 32),
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

                            // Align(
                            //   alignment: Alignment.centerRight,
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(
                            //         top: 16, right: 32
                            //     ),
                            //     child: Text('Forgot Password ?',
                            //       style: TextStyle(
                            //           color: Colors.grey
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Spacer(),
                            SizedBox(height: 80,),

                            Material(
                              borderRadius: BorderRadius.circular(32.0),
                              shadowColor: lwtColor,
                              elevation: 15.0,
                              child: MaterialButton(
                                minWidth: 280.0,
                                height: 42.0,
                                onPressed: () async {
                                  _loginmethod();
                                },
                                child: Text('Login'.toUpperCase(),
                                    style: TextStyle(
                                        color: lwtColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
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

  _loginmethod() async {
    String email = _controller1.text.toString();
    String password = _controller2.text.toString();
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: "Enter Empployee Code");
    } else if (password.isEmpty) {
      Fluttertoast.showToast(msg: "Enter Password");
    } else {
      var response = await _makePostRequest(email, password);
      loginList=(json.decode(response) as List)
              .map((data) => new LoginModel.fromJson(data))
              .toList();
      
      if (loginList[0].cnt==1) {
        String email = _controller1.text;
//        print(email + "," + loginData.userId.toString() + "," +
//            loginData.fullName.toString() + "," +
//            loginData.empCode.toString() + "," +
//            loginData.profileName.toString() + "," +
//            loginData.downTeamId.toString() + "," +
//            loginData.departmentName.toString());
        _writeData(
            email,
            loginList[0].uId,
            loginList[0].fullName,
            loginList[0].uEmpCode.toString(),
            loginList[0].hrCnt.toString(),
            loginList[0].travelCnt.toString(),
            loginList[0].salesCnt.toString(),
            loginList[0].profileName,
            loginList[0].downTeamIds,
            loginList[0].mobileNumber,
            loginList[0].branchid.toString(),
            loginList[0].emailId,
            loginList[0].department,
            loginList[0].designation,
            loginList[0].fixedTerm.toString());

        var navigator = Navigator.of(context);

        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          ModalRoute.withName('/'),
        );
      } else if (loginList[0].cnt == 0) {
        Fluttertoast.showToast(msg: "Invalid credentials.");
      }
    }
  }

  _makePostRequest(String email, String password) async {
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {"parameter1": "checkUserLogin", "parameter2": email,"parameter3":password});
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        return response.data;
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(msg: "Invalid credentials.");
        throw Exception("Invalid Credentials");
      } else {
        Fluttertoast.showToast(msg: "Invalid credentials.");
        throw Exception('Authentication Error');
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        Fluttertoast.showToast(msg: "Check your internet connection.");
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        Fluttertoast.showToast(msg: "Check your internet connection.");
        throw Exception(
            "Check your internet connection.");
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
      String hrCnt,
      String travelCnt,
      String salesCnt,
      String profileName,
      String downTeamId,
      String mobilenumber,
      String branchid,
      String emailId,
      String department,
      String designation,String fixedTerm) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("data", userEmail);
    preferences.setString("userId", uId.toString());
    preferences.setString("fullname", fullName);
    preferences.setString("uEmpCode", uEmpCode);
    preferences.setString("hrCnt", hrCnt);
    preferences.setString("travelCnt", travelCnt);
    preferences.setString("salesCnt", salesCnt);
    preferences.setString("profileName", profileName.toString());
    preferences.setString("downTeamId", downTeamId.toString());
    preferences.setString("mobilenumber", mobilenumber.toString());
    preferences.setString("branchid", branchid.toString());
    preferences.setString("emailId", emailId.toString());
    preferences.setString("department", department.toString());
    preferences.setString("designation", designation.toString());
    preferences.setString("fixedTerm",fixedTerm.toString());
  }
}
