import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Ebiz/activity/HomePage.dart';
import 'package:Ebiz/activity/Login.dart';
import 'package:Ebiz/main.dart';
import 'package:Ebiz/model/RestrictPermissionsModel.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launch_review/launch_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  StateSplash createState() => StateSplash();
}

class StateSplash extends State<SplashScreen> {
  List<RestrictPermissionsModel> restrictpermissionModel;
  static Dio dio = Dio(Config.options);

  @override
  void initState() {
    super.initState();
    checkMobileVersion();
    // startTime();
  }

  startTime() async {
    return Timer(Duration(seconds: 3), checkUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  checkUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userCheck = preferences.getString("data");
    if (userCheck == null) {
      var navigator = Navigator.of(context);

      /// Change Home Page to Login Page...
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Login()),
        ModalRoute.withName('/'),
      );
    } else {
      var navigator = Navigator.of(context);
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        ModalRoute.withName('/'),
      );
    }
  }

  checkMobileVersion() async {
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["string"],
            "parameter1": "getMobileVersion"
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        String data = json.decode(response.data)[0]["status"];
        if (data == ServicesApi.versionNew) {
          startTime();
        } else {
          roundedAlertDialog();
        }
        return data;
      } else if (response.statusCode == 401) {
        startTime();
        throw Exception("Incorrect data");
      } else {
        startTime();
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        startTime();
        // Fluttertoast.showToast(msg: "Socket Time out.");
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        startTime();
        // Fluttertoast.showToast(msg: "Check your internet connection.");
        throw Exception("Check your internet connection.");
      } else {
        return null;
      }
    }
  }

  roundedAlertDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Column(
              children: <Widget>[
                Text(
                  'EBiz',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 25,
                      color: lwtColor,
                      decoration: TextDecoration.underline),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Update size : approx. 12MB ',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'EBiz recommends you for update to the latest version for a better experience.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 11),
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Text(
                  'NOT NOW',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Material(
                color: lwtColor,
                shadowColor: lwtColor,
                child: CupertinoButton(
                  onPressed: () async {
                    LaunchReview.launch(
                        androidAppId: "ebiz.lotus.administrator.eaglebiz");
                  },
                  child: Text(
                    'UPDATE',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}

// Agreeing to the Xcode/iOS license requires admin privileges, please run “sudo xcodebuild -license” and then retry this command.
// Launching lib/main.dart on Redmi 6A in debug mode...
// registerResGeneratingTask is deprecated, use registerGeneratedResFolders(FileCollection)
// registerResGeneratingTask is deprecated, use registerGeneratedResFolders(FileCollection)
// registerResGeneratingTask is deprecated, use registerGeneratedResFolders(FileCollection)
