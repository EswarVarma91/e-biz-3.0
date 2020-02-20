import 'dart:io';

import 'package:Ebiz/activity/HomePage.dart';
import 'package:Ebiz/functionality/salesLead/SalesIndutrialEntry.dart';
import 'package:Ebiz/main.dart';
import 'package:Ebiz/model/SalesIndustrialEntryModel.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps/gps.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateSalesInsutrialEntry extends StatefulWidget {
  var lsi;
  UpdateSalesInsutrialEntry(this.lsi);

  @override
  _UpdateSalesInsutrialEntryState createState() =>
      _UpdateSalesInsutrialEntryState(lsi);
}

class _UpdateSalesInsutrialEntryState extends State<UpdateSalesInsutrialEntry> {
  final _controller1 = TextEditingController();
  var lsi;
  String timeStartI = "-", timeEndI = "-", datetimeEnd = "-";
  static Dio dio = Dio(Config.options);
  String userId, exit_lati, exit_longi;
  List<SalesIndustrialEntryModel> listSalesIndustry = [];
  _UpdateSalesInsutrialEntryState(this.lsi);
  GpsLatlng latlong;

  getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString("userId");
      // getSalesIndustrialData(userId);
      timeStartI = lsi?.entry_time ?? "-";
      timeEndI = lsi?.exit_time ?? "-";
    });
    latlong = await Gps.currentGps();
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => SalesIndustrialEntry()),
        ModalRoute.withName('/'),
      ),
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              lsi?.company_name ?? "",
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          SalesIndustrialEntry()),
                  ModalRoute.withName('/'),
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
                  if (timeEndI == "-") {
                    Fluttertoast.showToast(msg: "Please end your exit time");
                  } else {
                    if(exit_lati!=null){
                    _callInsertMethodU();
                    }else{
                      Fluttertoast.showToast(msg: "Please turn on GPS");
                    }
                  }
                },
              )
            ],
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Container(
              child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: dashboard5(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: dashboard6(),
                    )
                  ],
                ),
              ),
            ],
          ))),
    );
  }

  Material dashboard5() {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      "Entry Time",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF272D34),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      timeStartI,
                      style: TextStyle(fontSize: 20.0, color: lwtColor),
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

  Material dashboard6() {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: () {
          if (timeEndI == "-") {
            if(exit_lati!=null){
              roundedAlertDialog();
            }else{
              Fluttertoast.showToast(msg: "Please turn on GPS");
            }
          } else {
            Fluttertoast.showToast(msg: "You have already entered the Exit Time");
          }
          // roundedAlertDialog();
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "Exit Time",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        timeEndI,
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

  roundedAlertDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: new Text(
              'Do you want to exit the business location?',
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
                    var now = DateTime.now();
                    exit_lati = latlong?.lat.toString() ?? "";
                    exit_longi = latlong?.lng.toString() ?? "";
                    datetimeEnd = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);
                    timeEndI = DateFormat("HH:mm:ss").format(now).toString();
                  });
                  Navigator.pop(context);
                },
                child: new Text('Yes'),
              ),
            ],
          );
        });
  }

  _callInsertMethodU() async {
    try {
      var response = await dio.post(ServicesApi.updateData,
          data: {
            "parameter1": "updateSalesEntry",
            "parameter2": datetimeEnd,
            "parameter3": lsi.s_id,
            "parameter4": exit_lati,
            "parameter5": exit_longi
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(msg: "Sales Entry Updated");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => SalesIndustrialEntry()),
          ModalRoute.withName('/'),
        );
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
}
