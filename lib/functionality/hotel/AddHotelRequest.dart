import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eaglebiz/functionality/hotel/DownTeamMembers.dart';
import 'package:eaglebiz/functionality/hotel/HotelRequestList.dart';
import 'package:eaglebiz/functionality/hotel/PackageSelection.dart';
import 'package:eaglebiz/functionality/travel/ProjectSelection.dart';
import 'package:eaglebiz/main.dart';
import 'package:eaglebiz/model/HotelUserDetailsModel.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddHotelRequest extends StatefulWidget {
  @override
  _AddHotelRequestState createState() => _AddHotelRequestState();
}

class _AddHotelRequestState extends State<AddHotelRequest> {
  String TtravelName,
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
  List<HotelUserDetailsModel> multiUser;
  TextEditingController _controllerLocation = new TextEditingController();
  TextEditingController _controllerPurpose = new TextEditingController();
  TextEditingController _controllerRating = new TextEditingController();
  int y, m, d;
  String toA, toB, toC, profilename, fullname;
  static Dio dio = Dio(Config.options);
  String text = "Nothing to show";
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
  }

  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
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
                Fluttertoast.showToast(msg: "Choose Traveller Name.");
              } else if (_controllerLocation.text.isEmpty) {
                Fluttertoast.showToast(msg: "Enter location");
              } else if (_controllerRating.text.isEmpty) {
                Fluttertoast.showToast(msg: "Enter Rating.");
              } else if (checkIn.isEmpty) {
                Fluttertoast.showToast(msg: "Choose Check-In Time.");
              } else if (checkOut.isEmpty) {
                Fluttertoast.showToast(msg: "Choose Check-Out Time.");
              } else if (_controllerPurpose.text.isEmpty) {
                Fluttertoast.showToast(msg: "Enter Purpose.");
              } else if (TcomplaintTicketNo.isEmpty) {
                Fluttertoast.showToast(msg: "Choose Complaint Ticket No.");
              } else if (multiUser.isEmpty) {
                Fluttertoast.showToast(msg: "Choose Members.");
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
              trailing: IconButton(icon:Icon(Icons.add),onPressed: ()async{
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
              },),
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
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
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
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  var data = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              PackageSelection("Package Selection")));
                  SharedPreferences pre = await SharedPreferences.getInstance();
                  var Users = pre.getString("Users");
                  multiUser = data;
                  if (Users == null) {
                    _packages = _packages;
                  } else {
                    _packages = Users;
                  }
                },
              ),
              onTap: () async {
                var data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PackageSelection("Package Selection")));
                SharedPreferences pre = await SharedPreferences.getInstance();
                var Users = pre.getString("Users");
                multiUser = data;
                if (Users == null) {
                  _packages = _packages;
                } else {
                  _packages = Users;
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
    pr.show();
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
          "list": multiUser,
          "refId": TcomplaintId,
          "refType": TcomplaintRefType,
          "uId": TravelNameId,
          "hotelCreatedDate": DateFormat("yyyy-MM-dd").format(now)
        },
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));
    if (response.statusCode == 200 || response.statusCode == 201) {
      getUserRequestNo(TravelNameId.toString());
    } else if (response.statusCode == 401) {
      pr.hide();
      throw Exception("Incorrect data");
    }
  }

  void getUserRequestNo(String travelNameId) async {
    var response = await dio.post(ServicesApi.getData,
        data: {
          "parameter1": "GetTokenHotelRequest",
          "parameter2": travelNameId
        },
        options: Options(contentType: ContentType.parse("application/json")));
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data != "null" || response.data != null) {
        var req_no = json.decode(response.data)[0]['hotel_ref_no'];
        var token = json.decode(response.data)[0]['token'];
        if (token != null || token != "null") {
          pushNotification(req_no.toString(), token);
        } else {
          pr.hide();
          Fluttertoast.showToast(msg: "Hotel Request Generated.");
          SharedPreferences pre = await SharedPreferences.getInstance();
          pre.setString("Users", "");
          var navigator = Navigator.of(context);
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => HotelRequestList()),
            ModalRoute.withName('/'),
          );
        }
      } else {
        pr.hide();
        Fluttertoast.showToast(msg: "Hotel Request Generated.");
        SharedPreferences pre = await SharedPreferences.getInstance();
        pre.setString("Users", "");
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
      'body':
          "A new hotel request " + reqNo + " has been generated by " + fullname,
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
    Fluttertoast.showToast(msg: "Hotel Request Generated.");
    SharedPreferences pre = await SharedPreferences.getInstance();
    pre.setString("Users", "");
    var navigator = Navigator.of(context);
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => HotelRequestList()),
      ModalRoute.withName('/'),
    );
  }
}
