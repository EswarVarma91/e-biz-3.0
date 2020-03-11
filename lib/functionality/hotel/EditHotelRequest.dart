import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:Ebiz/functionality/hotel/DownTeamMembers.dart';
import 'package:Ebiz/functionality/hotel/HotelRequestList.dart';
import 'package:Ebiz/functionality/travel/ProjectSelection.dart';
import 'package:Ebiz/main.dart';
import 'package:Ebiz/model/HotelRequestByTId.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
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
  String toA, toB, toC, profilename, fullname;
  static Dio dio = Dio(Config.options);
  ProgressDialog pr;

  getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    profilename = preferences.getString("profileName");
    fullname = preferences.getString("fullname");
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
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
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
                Fluttertoast.showToast(msg: "Choose Check-In");
              } else if (checkOut.isEmpty) {
                Fluttertoast.showToast(msg: "Choose Check-Out");
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
              onTap: () {
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
                        doneStyle: TextStyle(color: Colors.blue, fontSize: 12)),
                    onChanged: (date) {
                  changeDateF(date);
                }, onConfirm: (date) {
                  changeDateF(date);
                }, currentTime: DateTime.now(), locale: LocaleType.en);
              },
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
              onTap: () {
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
                        doneStyle: TextStyle(color: Colors.blue, fontSize: 12)),
                    onChanged: (date) {
                  changeDateT(date);
                }, onConfirm: (date) {
                  changeDateT(date);
                }, currentTime: DateTime.now(), locale: LocaleType.en);
              },
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
    pr.show();
    var now = DateTime.now();
    var response = await dio.post(ServicesApi.updateData,
        data: {
          "parameter1": "updateHotelRequest",
          "parameter2": hotel_id,
          "parameter3": checkIn,
          "parameter4": checkOut,
          "parameter5": profilename,
          "parameter6": DateFormat("yyyy-MM-dd HH:mm:ss").format(now)
        },
        options: Options(contentType: ContentType.parse("application/json")));

    if (response.statusCode == 200 || response.statusCode == 201) {
      getUseridByhotelId(hotel_id.toString());
    } else if (response.statusCode == 401) {
      pr.hide();
      throw Exception("Incorrect data");
    }
  }

  void getUseridByhotelId(String hotel_id) async {
    var response = await dio.post(ServicesApi.getData,
        data: {
          "encryptedFields": ["string"],
          "parameter1": "getTokenbyHotelId",
          "parameter2": hotel_id
        },
        options: Options(contentType: ContentType.parse("application/json")));
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data != "null" || response.data != null) {
        var req_no = json.decode(response.data)[0]['hotel_req_no'];
        var token = json.decode(response.data)[0]['token'];
        if (token != null) {
          pushNotification(req_no, token);
        } else {
          pr.hide();
          Fluttertoast.showToast(msg: "Hotel Update Request Generated.");
          var navigator = Navigator.of(context);
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => HotelRequestList()),
            ModalRoute.withName('/'),
          );
        }
      } else {
        pr.hide();
        Fluttertoast.showToast(msg: "Hotel Update Request Generated.");
        var navigator = Navigator.of(context);
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => HotelRequestList()),
          ModalRoute.withName('/'),
        );
      }
    } else if (response.statusCode == 401) {
      pr.hide();
      throw (Exception);
    }
  }

  void pushNotification(String reqNo, String to) async {
    Map<String, dynamic> notification = {
      'body': "Hotel request " + reqNo + " has been modified by " + fullname,
      'title': 'Hotel Request',
      //
    };
    Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
    };
    Map<String, dynamic> message = {
      'notification': notification,
      'priority': 'high',
      'data': data,
      'to': to, // this is optional - used to send to one device
    };
    Map<String, String> headers = {
      'Authorization': "key=" + ServicesApi.FCM_KEY,
      'Content-Type': 'application/json',
    };
    // todo - set the relevant values
    http.Response r = await http.post(ServicesApi.fcm_Send,
        headers: headers, body: json.encode(message));
    // print(jsonDecode(r.body)["success"]);
    pr.hide();
    Fluttertoast.showToast(msg: "Hotel Update Request Generated.");
    var navigator = Navigator.of(context);
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => HotelRequestList()),
      ModalRoute.withName('/'),
    );
  }
}
