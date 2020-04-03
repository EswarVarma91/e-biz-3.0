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

class EditSalesLead extends StatefulWidget {
  var datalist;
  EditSalesLead(this.datalist);
  @override
  _EditSalesLeadState createState() => _EditSalesLeadState(datalist);
}

class _EditSalesLeadState extends State<EditSalesLead> {
  var dataList;
  _EditSalesLeadState(this.dataList);
  TextEditingController customerName,
      requirement,
      contactName,
      contactDesignation,
      contactEmail,
      contactMobile;
  String rid, srNo;
  bool _isLoading = false;
  static Dio dio = Dio(Config.options);
  SalesPendingModel user;
  String profileName;
  var result = "Refered By";
  var referalPerson;
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    getProfileName();
  }

  void getProfileName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      profileName = preferences.getString("profileName");

      rid = dataList.rId.toString();
      srNo = dataList.srNo.toString();
      customerName = TextEditingController(text: dataList.srCustomerName);
      requirement = TextEditingController(text: dataList.srRequirement);
      contactName = TextEditingController(text: dataList.srContactName);
      contactEmail = TextEditingController(text: dataList.srContactEmail);
      contactDesignation = TextEditingController(text: dataList.srDesignation);
      contactMobile = TextEditingController(text: dataList.srPhoneNo);
      var res = dataList.referredByFullName;
      if (res == null || res == "") {
        result = "Referred By";
      } else {
        result = res;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          dataList.srNo.toString(),
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
              if (customerName.text.isEmpty) {
                Fluttertoast.showToast(msg: "Enter 'Customer Name'");
              } else if (requirement.text.isEmpty) {
                Fluttertoast.showToast(msg: "Enter 'Requirement'");
              } else if (contactName.text.isEmpty) {
                Fluttertoast.showToast(msg: "Enter 'Contact Name'");
              } else if (contactDesignation.text.isEmpty) {
                Fluttertoast.showToast(msg: "Enter 'Contact Designation'");
              } else if (contactEmail.text.isEmpty ||
                  validateEmail(contactEmail.text) == false) {
                Fluttertoast.showToast(msg: "Enter 'Contact Email'");
              } else if (contactMobile.text.isEmpty ||
                  validateMobile(contactMobile.text) == false) {
                Fluttertoast.showToast(msg: "Enter 'Contact Mobile'");
              } else {
                //Service Call
                _callUpdateMethod();
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
                controller: customerName,
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
                controller: requirement,
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
                controller: contactName,
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
                controller: contactDesignation,
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
                controller: contactEmail,
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
                controller: contactMobile,
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
//              trailing: IconButton(icon: Icon(Icons.add),color:lwtColor,onPressed: (){
//                _navigatereferMethod(context);
//              },),
              title: TextFormField(
                controller: TextEditingController(text: result),
                enabled: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.group_add),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _callUpdateMethod() async {
    pr.show();
    try {
      var response = await dio.post(ServicesApi.Sales_Insert_Url,
          data: {
            "actionMode": "updateNoRefer",
            "createdBy": profileName,
            "modifiedBy": profileName,
            "srContactEmail": contactEmail.text,
            "srContactName": contactName.text,
            "srCustomerName": customerName.text,
            "srDesignation": contactDesignation.text,
            "srId": rid,
            "srNo": srNo,
            "srPhoneNo": contactMobile.text,
            "srRequirement": requirement.text
          },);

      if (response.statusCode == 200 || response.statusCode == 201) {
        pr.hide();
        var responseJson = json.decode(response.data);
        Fluttertoast.showToast(msg: "Sales Lead Updated Successfully.");
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
        throw Exception(
            "Check your internet connection.");
      }
    }
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
