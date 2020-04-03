import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Ebiz/activity/HomePage.dart';
import 'package:Ebiz/functionality/salesLead/SearchSalesIndustrialEntry.dart';
import 'package:Ebiz/functionality/salesLead/UpdateSalesInsutrialEntry.dart';
import 'package:Ebiz/main.dart';
import 'package:Ebiz/model/SalesIndustrialEntryModel.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocation/geolocation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesIndustrialEntry extends StatefulWidget {
  @override
  _SalesIndustrialEntryState createState() => _SalesIndustrialEntryState();
}

class _SalesIndustrialEntryState extends State<SalesIndustrialEntry> {
  String timeStartI = "-", timeEndI = "-", nameofBusiness = "";
  String datetimeStart = "-", datetimeEnd = "-";
  static Dio dio = Dio(Config.options);
  String userId;
  String entry_lat, entry_longi, exit_lati, exit_longi;
  List<SalesIndustrialEntryModel> listSalesIndustry = [];
  LocationResult result;
  GeolocationResult georesult;
  TextEditingController _controller1 = new TextEditingController();

  getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString("userId");
      getSalesIndustrialData(userId);
    });
  }

  locationSetState(String data) async {
    if (data == "1") {
      result = await Geolocation.lastKnownLocation();
      StreamSubscription<LocationResult> subscription =
          Geolocation.currentLocation(accuracy: LocationAccuracy.best)
              .listen((result) {
        if (result.isSuccessful) {
          setState(() {
            entry_lat = result.location.latitude.toString();
            entry_longi = result.location.longitude.toString();
          });
          if (timeStartI == "-") {
            if (nameofBusiness != "") {
              if (entry_lat != null) {
                setState(() {
                  var now1 = DateTime.now();
                  datetimeStart =
                      DateFormat("yyyy-MM-dd HH:mm:ss").format(now1);
                  timeStartI = DateFormat("HH:mm:ss").format(now1).toString();
                });
              } else {
                Fluttertoast.showToast(msg: "Please turn on GPS");
              }
            } else {
              Fluttertoast.showToast(
                  msg: "Please Enter your Place of Business");
            }
          } else {
            Fluttertoast.showToast(
                msg: "You have already entered the Entry Time");
          }
        }
      });
    } else if (data == "2") {
      result = await Geolocation.lastKnownLocation();
      StreamSubscription<LocationResult> subscription =
          Geolocation.currentLocation(accuracy: LocationAccuracy.best)
              .listen((result) {
        if (result.isSuccessful) {
          setState(() {
            exit_lati = result.location.latitude.toString();
            exit_longi = result.location.longitude.toString();
          });
          if (timeStartI != "-") {
            if (timeEndI == "-") {
              if (exit_lati != null) {
                roundedAlertDialog();
              } else {
                Fluttertoast.showToast(msg: "Please turn on GPS");
              }
            } else {
              Fluttertoast.showToast(
                  msg: "You have already entered the Exit Time");
            }
          } else {
            Fluttertoast.showToast(msg: "Please Start your entry time");
          }
        }
      });
    }
  }

  askPermission(String result) async {
    georesult = await Geolocation.requestLocationPermission(
        permission: const LocationPermission(
            android: LocationPermissionAndroid.fine,
            ios: LocationPermissionIOS.always),
        openSettingsIfDenied: true);
    if (georesult.isSuccessful) {
      locationSetState(result);
    }
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
        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        ModalRoute.withName('/'),
      ),
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Sales Industrial Entry",
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
                      builder: (BuildContext context) => HomePage()),
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
                  if (nameofBusiness == "") {
                    Fluttertoast.showToast(msg: "Enter Company Name");
                  } else if (timeStartI == "-") {
                    Fluttertoast.showToast(msg: "Start Entry Time");
                  } else if (_controller1.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Enter Purpose");
                  } else {
                    roundedCreateAlertDialog();
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
              ListTile(
                onTap: () async {
                  var data = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              SearchSalesIndustrialEntry("Place of Business")));
                  if (data != null) {
                    setState(() {
                      nameofBusiness = data;
                    });
                  }
                },
                title: TextFormField(
                  enabled: false,
                  controller: TextEditingController(text: nameofBusiness),
                  maxLength: 40,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.business),
                    labelText: "Place of Business",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              ListTile(
                title: TextFormField(
                  controller: _controller1,
                  maxLength: 60,
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.business),
                    labelText: "Purpose of visit",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
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
              Expanded(
                child: salesIndustrialList(),
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
      child: InkWell(
        onTap: () {
          locationSetState("1");
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
          locationSetState("2");
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

  salesIndustrialList() {
    return ListView.builder(
        itemCount:
            listSalesIndustry == null ? 0 : listSalesIndustry?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              elevation: 5.0,
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: InkWell(
                child: Container(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(
                      listSalesIndustry[index]?.company_name ?? 'NA',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Entry Time  : ",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              listSalesIndustry[index]?.entry_time ?? '-',
                              style: TextStyle(
                                color: lwtColor,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Exit Time    : ",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              listSalesIndustry[index]?.exit_time ?? '-',
                              style: TextStyle(
                                color: lwtColor,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        listSalesIndustry[index].status.toString() == "1"
                            ? Icons.edit
                            : Icons.check,
                        color: lwtColor,
                        size: 25,
                      ),
                      onPressed: () {
                        listSalesIndustry[index].status.toString() == "1"
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        UpdateSalesInsutrialEntry(
                                            listSalesIndustry[index])))
                            : Container();
                      },
                    ),
                  ),
                )),
              ));
        });
  }

  _callInsertMethodI(String purpose) async {
    Navigator.pop(context);
    var nowTime = DateTime.now();
    var data;
    if (timeEndI == "-") {
      data = 1;
    } else {
      data = 0;
    }

    try {
      var response = await dio.post(ServicesApi.updateData,
          data: {
            "parameter1": "insertSalesEntryExitPoint",
            "parameter2": nameofBusiness,
            "parameter3": datetimeStart,
            "parameter4": datetimeEnd,
            "parameter5": DateFormat("yyyy-MM-dd HH:mm:ss").format(nowTime),
            "parameter6": userId,
            "parameter7": data,
            "parameter8": entry_lat,
            "parameter9": entry_longi,
            "parameter10": exit_lati,
            "parameter11": exit_longi,
            "parameter12": purpose
          },);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(msg: "Sales Entry Successful.");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => SalesIndustrialEntry()),
          ModalRoute.withName('/'),
        );
        // return responseJson;
      } else if (response.statusCode == 401) {
        throw Exception("Incorrect data");
      }
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

  getSalesIndustrialData(String user_id) async {
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["string"],
            "parameter1": "salesIndustrialDataById",
            "parameter2": user_id,
          },);
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          listSalesIndustry = (json.decode(response.data) as List)
              .map((data) => new SalesIndustrialEntryModel.fromJson(data))
              .toList();
        });
      } else if (response.statusCode == 401) {
        throw Exception("Incorrect data");
      }
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

  roundedCreateAlertDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              'Generate a new request?',
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
                  if (_controller1.text.isNotEmpty) {
                    _callInsertMethodI(_controller1.text);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Please provide the purpose of visit.");
                  }
                },
                child: new Text('Yes'),
              ),
            ],
          );
        });
  }
}
