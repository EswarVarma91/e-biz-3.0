import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eaglebiz/functionality/hotel/DownTeamMembers.dart';
import 'package:eaglebiz/functionality/hotel/HotelRequestList.dart';
import 'package:eaglebiz/functionality/hotel/PackageSelection.dart';
import 'package:eaglebiz/functionality/travel/ProjectSelection.dart';
import 'package:eaglebiz/main.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddHotelRequest extends StatefulWidget {
  @override
  _AddHotelRequestState createState() => _AddHotelRequestState();
}

class _AddHotelRequestState extends State<AddHotelRequest> {
  String TtravelName,
      multiUser,
      TravelNameId,
      _userRating,
      checkIn,
      checkIns,
      checkOut,
      checkOuts,
      TcomplaintTicketNo,
      TcomplaintId,
      TcomplaintRefType,
      _packages;
  double ratingBar;
  TextEditingController _controllerLocation = new TextEditingController();
  TextEditingController _controllerPurpose = new TextEditingController();
  TextEditingController _controllerRating = new TextEditingController();
  int y, m, d;
  String toA, toB, toC, profilename;
  static Dio dio = Dio(Config.options);
  String text = "Nothing to show";

  getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    profilename = preferences.getString("profileName");
  }

  @override
  void initState() {
    super.initState();
    var now = new DateTime.now();
    y = now.year;
    m = now.month;
    d = now.day;
    getUserDetails();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Hotel Request',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () {
              if (TravelNameId.isEmpty) {
                Fluttertoast.showToast(msg: "Please select traveller name!");
              } else if (_controllerLocation.text.isEmpty) {
                Fluttertoast.showToast(msg: "Please enter location!");
              } else if (_controllerRating.text.isEmpty) {
                Fluttertoast.showToast(msg: "Please Enter rating!");
              } else if (checkIn.isEmpty) {
                Fluttertoast.showToast(msg: "Please select check-in time!");
              } else if (checkOut.isEmpty) {
                Fluttertoast.showToast(msg: "Please select check-out time!");
              } else if (_controllerPurpose.text.isEmpty) {
                Fluttertoast.showToast(msg: "Please Enter Purpose!");
              } else if (TcomplaintTicketNo.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Please select complaint ticket no.!");
              } else if (multiUser.isEmpty) {
                Fluttertoast.showToast(msg: "Please Select Members!");
              } else {
                insertHotelRequest();
              }
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 0, top: 5),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: TtravelName),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Traveller Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: Icon(Icons.add),
              onTap: () async {
                var data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DownTeamMembers("Traveller Name")));
                if (data != null) {
                  setState(() {
                    TtravelName = data.split(" USR_")[0].toString();
                    TravelNameId = data.split(" USR_")[1].toString();
                  });
                }
              },
            ),
            ListTile(
              title: TextFormField(
                controller: _controllerLocation,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Hotel Location",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
                title: TextFormField(
              controller: _controllerRating,
              keyboardType: TextInputType.number,
              maxLength: 1,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.star),
                border: OutlineInputBorder(),
                labelText: "Enter Rating",
              ),
            )),
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: checkIns),
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.event),
                  labelText: "Check In",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.calendar_today,
                ),
                onPressed: () {
                  setState(() {
                    checkOut = "";
                    checkOuts = "";
                  });
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(y, m, d),
                      maxTime: DateTime(y, m + 3, d),
                      theme: DatePickerTheme(
                          backgroundColor: Colors.white,
                          itemStyle: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                          doneStyle:
                              TextStyle(color: Colors.blue, fontSize: 12)),
                      onChanged: (date) {
                    changeDateF(date);
                  }, onConfirm: (date) {
                    changeDateF(date);
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
              ),
            ),
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: checkOuts),
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.event),
                  labelText: "Check Out",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.calendar_today,
                ),
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(
                          int.parse(toA), int.parse(toB), int.parse(toC)),
                      maxTime: DateTime(y, m + 3, d),
                      theme: DatePickerTheme(
                          backgroundColor: Colors.white,
                          itemStyle: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                          doneStyle:
                              TextStyle(color: Colors.blue, fontSize: 12)),
                      onChanged: (date) {
                    changeDateT(date);
                  }, onConfirm: (date) {
                    changeDateT(date);
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
              ),
            ),
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: TcomplaintTicketNo),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "OA/Complaint Ticket No.",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: Icon(Icons.add),
              onTap: () async {
                var data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ProjectSelection("OA/Complaint Ticket No.")));
                if (data != null) {
                  setState(() {
                    TcomplaintTicketNo = data.split(" P_")[0].toString();
                    TcomplaintId = data.split(" P_")[1].toString();
                    TcomplaintRefType = data.split(" P_")[2].toString();
                  });
                }
              },
            ),
            ListTile(
              title: TextFormField(
                controller: _controllerPurpose,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Purpose",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: TextEditingController(text: _packages),
                keyboardType: TextInputType.text,
                maxLines: 3,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Package",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: Icon(Icons.add),
              onTap: () async {
                var data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PackageSelection("Package Selection")));
                multiUser = data.split(" U")[0].toString();
                if (data.split(" U")[1].toString() == null) {
                  _packages = _packages;
                } else {
                  _packages = data.split(" U")[1].toString();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void changeDateF(DateTime date) {
    String newDate = date.toString();
    List<String> d = [];
    d = newDate.split(" ");
    // print(d[0]);
    setState(() {
      List<String> aa = [];
      aa = d[0].split("-");
      toA = aa[0].toString();
      toB = aa[1].toString();
      toC = aa[2].toString();
      checkIn = d[0].toString();
      checkIns = toC + "-" + toB + "-" + toA;
    });
  }

  void changeDateT(DateTime date) {
    String newDate = date.toString();
    List<String> d = [];
    d = newDate.split(" ");

    var display = d[0].toString();
    List<String> a = display.split("-");

    // print(d[0]);
    setState(() {
      checkOut = d[0].toString();
      checkOuts = a[2] + "-" + a[1] + "-" + a[0];
    });
  }

  insertHotelRequest() async {
    var now = DateTime.now();
    var response = await dio.post(ServicesApi.insert_hotel,
        data: {
          "actionMode": "insert",
          "hotelLocation": _controllerLocation.text,
          "hotelCheckIn": checkIn,
          "hotelCheckOut": checkOut,
          "hotelRating": _controllerRating.text,
          "hotelPurpose": _controllerPurpose.text,
          "hotelCreatedBy": profilename,
          "hotelModifiedBy": profilename,
          "list" : multiUser.toString(),
          "refId": TcomplaintId,
          "refType": TcomplaintRefType,
          "uId": TravelNameId,
          "hotelCreatedDate": DateFormat("yyyy-MM-dd").format(now)
        },
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));
    if (response.statusCode == 200 || response.statusCode == 201) {
      Fluttertoast.showToast(msg: "Success");

      var navigator = Navigator.of(context);
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => HotelRequestList()),
        ModalRoute.withName('/'),
      );
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }
}
