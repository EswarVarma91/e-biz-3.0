import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:Ebiz/functionality/salesLead/ReferedBy.dart';
import 'package:Ebiz/functionality/salesLead/SalesLead.dart';
import 'package:Ebiz/model/SalesPendingModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class NewSalesLead extends StatefulWidget {
  @override
  _NewSalesLeadState createState() => _NewSalesLeadState();
}

class _NewSalesLeadState extends State<NewSalesLead> {
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  final _controller4 = TextEditingController();
  final _controller5 = TextEditingController();
  final _controller6 = TextEditingController();
  bool _isLoading = false;
  ProgressDialog pr;
  static Dio dio = Dio(Config.options);
  SalesPendingModel user;
  String profileName;
  var result = "Referred By";
  var referalPerson;

  @override
  void initState() {
    super.initState();
    getProfileName();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Sales Lead",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            var navigator = Navigator.of(context);
            navigator.push(
              MaterialPageRoute(builder: (BuildContext context) => SalesLead()),
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
              if (_controller1.text.isEmpty) {
                Fluttertoast.showToast(msg: "Enter 'Customer Name'");
              } else if (_controller2.text.isEmpty) {
                Fluttertoast.showToast(msg: "Enter 'Requirement'");
              } else if (_controller3.text.isEmpty) {
                Fluttertoast.showToast(msg: "Enter 'Contact Name'");
              } else if (_controller4.text.isEmpty) {
                Fluttertoast.showToast(msg: "Enter 'Contact Designation'");
              } else if (_controller5.text.isEmpty ||
                  validateEmail(_controller5.text) == false) {
                Fluttertoast.showToast(msg: "Enter 'Contact Email'");
              } else if (_controller6.text.isEmpty ||
                  validateMobile(_controller6.text) == false) {
                Fluttertoast.showToast(msg: "Please Enter 'Contact Mobile'");
              } else if (result.toString() == null ||
                  result.toString() == "Referred By") {
                Fluttertoast.showToast(msg: "Choose 'Referred By'");
              } else {
                //Service Call
                _callInsertMethod();
              }
            },
          )
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: TextFormField(
                controller: _controller1,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Customer Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: _controller2,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Requirement",
                  prefixIcon: Icon(Icons.assignment),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: _controller3,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Contact Name",
                  prefixIcon: Icon(Icons.account_box),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: _controller4,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Contact Designation",
                  prefixIcon: Icon(Icons.confirmation_number),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: _controller5,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Contact Email",
                  prefixIcon: Icon(Icons.contact_mail),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: _controller6,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: "Contact Mobile",
                  prefixIcon: Icon(Icons.phone_android),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                _navigatereferMethod(context);
              },
              title: TextFormField(
                controller: TextEditingController(
                    text: result[0].toUpperCase() + result.substring(1)),
                enabled: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.group_add),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.add,
                ),
                onPressed: () {
                  _navigatereferMethod(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

// IconButton(
//                 icon: Icon(Icons.add),
//                 color: lwtColor,
//                 onPressed: () {
//                   _navigatereferMethod(context);
//                 },
//               ),
  void _callInsertMethod() async {
    pr.show();
    try {
      var response = await dio.post(ServicesApi.Sales_Insert_Url,
          data: {
            "actionMode": "insert",
            "createdBy": profileName,
            "modifiedBy": profileName,
            "srContactEmail": _controller5.text.toString(),
            "srContactName": _controller3.text.toString(),
            "srCustomerName": _controller1.text.toString(),
            "srDesignation": _controller4.text.toString(),
            "srId": 0,
            "srNo": "2",
            "srPhoneNo": _controller6.text.toString(),
            "srReferedBy": referalPerson,
            "srRequirement": _controller2.text.toString()
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        pr.hide();
        var responseJson = json.decode(response.data);
        Fluttertoast.showToast(msg: "Sales Request Generated.");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => SalesLead()),
          ModalRoute.withName('/'),
        );
        return responseJson;
      } else if (response.statusCode == 401) {
        pr.hide();
        throw Exception("Incorrect data");
      } else
        throw Exception('Authentication Error');
    } on DioError catch (exception) {
      pr.hide();
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        pr.hide();
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        pr.hide();
        throw Exception("Check your internet connection.");
      }
    }
  }

  void getProfileName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      profileName = preferences.getString("profileName");
    });
  }

  void _navigatereferMethod(BuildContext context) async {
    var data = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ReferedBy(result)));
    var string = data.split(" USR_");
    result = string[0];
    referalPerson = string[1];
  }

  bool validateMobile(String mobile) {
    if (mobile.length != 10)
      return false;
    else
      return true;
  }

  bool validateEmail(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(email))
      return false;
    else
      return true;
  }
}
