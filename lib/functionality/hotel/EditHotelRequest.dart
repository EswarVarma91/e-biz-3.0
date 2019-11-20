import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eaglebiz/functionality/hotel/DownTeamMembers.dart';
import 'package:eaglebiz/functionality/hotel/HotelRequestList.dart';
import 'package:eaglebiz/functionality/travel/ProjectSelection.dart';
import 'package:eaglebiz/main.dart';
import 'package:eaglebiz/model/HotelRequestByTId.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditHotelRequest extends StatefulWidget {
  HotelRequestByTId hrbtid;
  String hotel_id;
  EditHotelRequest(this.hrbtid, this.hotel_id);

  @override
  _EditHotelRequestState createState() =>
      _EditHotelRequestState(hrbtid, hotel_id);
}

class _EditHotelRequestState extends State<EditHotelRequest> {
  HotelRequestByTId hrbtid;
  String hotel_id;
  _EditHotelRequestState(this.hrbtid, this.hotel_id);

  String checkIn,
      checkIns,
      checkOut,
      checkOuts,
      travelnameH,
      locationH,
      ratingH,
      complaintnoH,
      purposeH;

  int y, m, d;
  String toA, toB, toC, profilename;
  static Dio dio = Dio(Config.options);

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
    checkIns = hrbtid.hotel_his_check_in;
    checkOuts = hrbtid.hotel_his_check_out;
    travelnameH = hrbtid.travellerName;
    locationH = hrbtid.hotel_his_location;
    ratingH = hrbtid.hotel_his_rating.toString();
    complaintnoH = hrbtid.proj_oano.toString();
    purposeH = hrbtid.hotel_his_purpose;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Hotel Request',
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
              if (checkIn.isEmpty) {
              } else if (checkOut.isEmpty) {
              } else {
                edithoteRequestService(checkIn, checkOut);
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
                controller: TextEditingController(text: travelnameH),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Traveller Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: locationH),
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
              enabled: false,
              controller: TextEditingController(text: ratingH),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
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
                  size: 16,
                  color: lwtColor,
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
                  size: 16,
                  color: lwtColor,
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
                controller: TextEditingController(text: complaintnoH),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "OA/Complaint Ticket No.",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: purposeH),
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

  void edithoteRequestService(String checkIn, String checkOut) async {
    var response = await dio.post(ServicesApi.updateData,
        data: {
          "parameter1": "updateHotelRequest",
          "parameter2": hotel_id,
          "parameter3": checkIn,
          "parameter4": checkOut,
          "parameter5": profilename
        },
        options: Options(contentType: ContentType.parse("application/json")));
    if (response.statusCode == 200 || response.statusCode == 201) {
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
