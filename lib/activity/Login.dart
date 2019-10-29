import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:eaglebiz/activity/HomePage.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:eaglebiz/model/LoginModel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> streamSubscription;
  bool _obscureText = true;
  bool _isLoading = false;
  List<LoginModel> loginList = [];
  static Dio dio = Dio(Config.options);
  var _controller1=TextEditingController();
  var _controller2=TextEditingController();

  @override
  void initState() {
    super.initState();
    connectivity=Connectivity();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: (){
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        body: Center(
          child: _isLoading ? CircularProgressIndicator() : Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 120,),
                Container(
                  child: Image.asset('assets/images/ebiz.png',width: 300,),
                ),
                SizedBox(height: 50,),
                Container(
                  height: MediaQuery.of(context).size.height/2,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 62),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width/1.2,
                        height: 45,
                        padding: EdgeInsets.only(
                            top: 4,left: 16, right: 16, bottom: 4
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(50)
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5
                              ),]
                        ),
                        child: TextField(
                          controller: _controller1,
                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(Icons.email,
                              color: Colors.grey,
                            ),
                            hintText: 'Email',
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/1.2,
                        height: 45,
                        margin: EdgeInsets.only(top: 32),
                        padding: EdgeInsets.only(
                            top: 4,left: 16, right: 16, bottom: 4
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(50)
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow (
                                  color: Colors.black12,
                                  blurRadius: 5
                              )
                            ]
                        ),
                        child: TextFormField (
                          controller: _controller2,
                          obscureText:_obscureText,
                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.vpn_key,
                                color: Colors.grey,
                              ),
                              hintText: 'Password',
                              suffixIcon:GestureDetector(
                                dragStartBehavior: DragStartBehavior.down,
                                onTap: (){
                                  setState(() {
                                    _obscureText=!_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText ? Icons.visibility : Icons.visibility_off,
                                  semanticLabel: _obscureText ? 'show password' : 'hide password',
                                ),
                              )
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 16, right: 32
                          ),
                          child: Text('Forgot Password ?',
                            style: TextStyle(
                                color: Colors.grey
                            ),
                          ),
                        ),
                      ),
                      Spacer(),

                      Material(/*
                        color: lwtColor,*/
                        borderRadius: BorderRadius.circular(32.0),
                        shadowColor: lwtColor,
                        elevation: 15.0,
                        child: MaterialButton(
                          minWidth: 280.0,
                          height: 42.0,
                          onPressed: () async {
                            /*streamSubscription=connectivity.onConnectivityChanged.listen((ConnectivityResult result){
                            if(result!=ConnectivityResult.none){*/
                            LoginMethod();
                            /*}else{
                              Fluttertoast.showToast(msg: "No Internet.!");
                            }
                          });*/
                          },
                          child: Text('Login'.toUpperCase(), style: TextStyle(color: lwtColor,fontSize: 16,fontWeight: FontWeight.bold)),
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


  LoginMethod() async {
    String email=_controller1.text.toString();
    String password=_controller2.text.toString();
    if(email.isEmpty){
      Fluttertoast.showToast(msg: "Enter Email");
    }else if(password.isEmpty){
      Fluttertoast.showToast(msg: "Enter Password");
    }else {
      var response = await _makePostRequest(email, password);
      LoginModel loginData = LoginModel.fromJson(response[0]);
      if (loginData.cnt == 1) {
        String email = _controller1.text;
        print(email + "," + loginData.uId.toString() + "," +
            loginData.fullName.toString() + "," +
            loginData.uEmpCode.toString() + "," +
            loginData.profileName.toString() + "," +
            loginData.downTeamIds.toString() + "," +
            loginData.userId.toString());
        _writeData(
            email,
            loginData.uId,
            loginData.fullName,
            loginData.uEmpCode,
            loginData.profileName,
            loginData.downTeamIds,
            loginData.userId);

        var navigator = Navigator.of(context);
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          ModalRoute.withName('/'),
        );
        setState(() => _isLoading = false);
      }else if(loginData.cnt == 0){
        Fluttertoast.showToast(msg: "Please check the credentials.!");
        setState(() => _isLoading = false);
      }
    }
  }

  _makePostRequest(String email,String password) async {
    setState(() => _isLoading = true);
    try{
      var response = await dio.post(ServicesApi.Login_Url,
          data: {
            "actionMode": "CheckUserLoginByCode",
            "refCode": password.toString(),
            "refName": email.toString()
          },
          options: Options(responseType: ResponseType.json,
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
//      var responseJson =json.decode(response.data[0]);

        return response.data;

      } else if (response.statusCode == 401) {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(msg: "Incorrect Email/Password");
        throw Exception("Incorrect Email/Password");
      } else {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(msg: "Incorrect Email/Password");
        throw Exception('Authentication Error');
      }
    }on DioError catch(exception){
      setState(() => _isLoading = false);
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(msg: "No Internet.!");
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception("Could'nt connect, please ensure you have a stable network.");
      } else {
        setState(() => _isLoading = false);
        return null;
      }
    }
  }





  void _writeData(String userEmail, int uId, String fullName, int uEmpCode, String profileName, String downTeamId,String userId) async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.setString("data", userEmail);
    preferences.setString("fullname", fullName);
    preferences.setInt("uEmpCode", uEmpCode);
    preferences.setString("uId", uId.toString());
    preferences.setString("profileName", profileName.toString());
    preferences.setString("downTeamId", downTeamId.toString());
    preferences.setString("userId", userId.toString());
  }
}