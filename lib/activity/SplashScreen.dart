import 'dart:async';
import 'package:Ebiz/activity/HomePage.dart';
import 'package:Ebiz/activity/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  StateSplash createState() => StateSplash();
}

class StateSplash extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    return Timer(Duration(seconds: 5), checkUser);
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
}
