import 'dart:async';
import 'package:eaglebiz/activity/HomePage.dart';
import 'package:eaglebiz/activity/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  StateSplash createState() => StateSplash();
}

class StateSplash extends State<SplashScreen> {
//  Connectivity connectivity;
//  List<RestrictPermissionsModel> restrictpermissionModel;
//  StreamSubscription<ConnectivityResult> streamSubscription;
//  static Dio dio = Dio(Config.options);

  @override
  void initState() {
    super.initState();
//    connectivity = Connectivity();
//    streamSubscription =
//        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
//          if (result != ConnectivityResult.none)  {
//            checkMobileVersion();
//          } else {
    startTime();
//          }
//        });
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
//   checkMobileVersion() async{
//    var response = await dio.post(ServicesApi.emp_Data,
//        data:
//        {
//          "actionMode": "getMobileVersion"
//        },
//        options: Options(contentType: ContentType.parse('application/json'),
//        ));
//
//    if (response.statusCode == 200 || response.statusCode == 201) {
//      restrictpermissionModel = (json.decode(response.data) as List).map((data) => new RestrictPermissionsModel.fromJson(data)).toList();
//
//      var data = restrictpermissionModel[0].status.toString();
//      if(data=="0.1"){
//        startTime();
//      }else{
//        Fluttertoast.showToast(msg: "Please update your Application!");
//      }
//    } else if (response.statusCode == 401) {
//      throw Exception("Incorrect data");
//    }
//  }
}
