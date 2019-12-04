import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:Ebiz/functionality/salesLead/ReferedBy.dart';
import 'package:Ebiz/functionality/travel/ProjectSelection.dart';
import 'package:Ebiz/functionality/travel/TravelRequestList.dart';
import 'package:Ebiz/functionality/travel/TravelSelection.dart';
import 'package:Ebiz/model/TravelRequestByTId.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditTravelRequest extends StatefulWidget {
  TravelRequestByTId trbtid;
  String tra_id;
  EditTravelRequest(this.trbtid, this.tra_id);

  @override
  _EditTravelRequestState createState() =>
      _EditTravelRequestState(trbtid, tra_id);
}

class _EditTravelRequestState extends State<EditTravelRequest> {
  TravelRequestByTId trbtid;
  String tra_id;
  _EditTravelRequestState(this.trbtid, this.tra_id);

  String TrarrivalDateTime, TrequiredDateTime;
  static Dio dio = Dio(Config.options);
  int y, m, d, hh, mm, ss;

  int year, month, day, hour, minute;

  String uid,
      profilename,
      fromT,
      toT,
      nameT,
      complaintNoT,
      modeT,
      modetypeT,
      classT,
      purposeT,
      reftypeT,
      traidT,
      fullname;
  int ref_id;
  ProgressDialog pr;

  getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uid = preferences.getString("userId");
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
    hh = now.hour;
    mm = now.minute;
    ss = now.second;
    getUserDetails();
    setState(() {
      ref_id = trbtid.ref_id;
      complaintNoT = trbtid.proj_oano;
      fromT = trbtid.tra_from;
      toT = trbtid.tra_to;
      nameT = trbtid.fullName;
      modeT = trbtid.tra_mode;
      modetypeT = trbtid.tra_mode_type;
      classT = trbtid.tra_class;
      purposeT = trbtid.tra_purpose;
      traidT = tra_id;
      reftypeT = trbtid.ref_type;
      TrarrivalDateTime = trbtid.tra_journey_date;
      TrequiredDateTime = trbtid.requiredDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Travel Request',
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
              if (TrarrivalDateTime.isEmpty) {
                Fluttertoast.showToast(msg: "Select 'Journey Date'.");
              } else if (TrequiredDateTime.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Select 'Required arrival date and time'.");
              } else {
                updateTravelrequest(TrarrivalDateTime, TrequiredDateTime);
              }
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 0, top: 5),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: nameT),
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
                controller: TextEditingController(text: modeT),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Mode",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: modetypeT),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Mode Type",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: classT),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Class",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: fromT),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "From",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: toT),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "To",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: TrarrivalDateTime),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Journey Date",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () {
                  TrequiredDateTime = "";
                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(y, m, d, hh, mm),
                      maxTime: DateTime(y + 1, m, d, hh, mm),
                      onChanged: (date) {
                    changeDateF(date);
                  }, onConfirm: (date) {
                    changeDateF(date);
                  }, locale: LocaleType.en);
                },
              ),
              onTap: () async {
                TrequiredDateTime = "";
                DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(y, m, d, hh, mm),
                    maxTime: DateTime(y + 1, m, d, hh, mm), onChanged: (date) {
                  changeDateF(date);
                }, onConfirm: (date) {
                  changeDateF(date);
                }, locale: LocaleType.en);
              },
            ),
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: TrequiredDateTime),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Required Arrival Date & Time",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () {
                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(year, month, day, hour, minute + 1),
                      maxTime: DateTime(y + 1, m, d, hh, mm),
                      onChanged: (date) {
                    changeDateT(date);
                  }, onConfirm: (date) {
                    changeDateT(date);
                  }, locale: LocaleType.en);
                },
              ),
              onTap: () async {
                DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(year, month, day, hour, minute + 1),
                    maxTime: DateTime(y + 1, m, d, hh, mm), onChanged: (date) {
                  changeDateT(date);
                }, onConfirm: (date) {
                  changeDateT(date);
                }, locale: LocaleType.en);
              },
            ),
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: complaintNoT),
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
                controller: TextEditingController(text: purposeT),
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
    d = newDate.split(".");

    // print(d[0]);
    setState(() {
      List<String> aa = [];
      aa = d[0].split(" ");
      String date = aa[0].toString();
      String time = aa[1].toString();
      List<String> bb = [];
      bb = date.split("-");
      year = int.parse(bb[0].toString());
      month = int.parse(bb[1].toString());
      day = int.parse(bb[2].toString());
      List<String> cc = [];
      cc = time.split(":");
      hour = int.parse(cc[0].toString());
      minute = int.parse(cc[1].toString());

      TrarrivalDateTime = d[0].toString();
    });
  }

  void changeDateT(DateTime date) {
    String newDate = date.toString();
    List<String> d = [];
    d = newDate.split(".");
    // print(d[0]);
    setState(() {
      TrequiredDateTime = d[0].toString();
    });
  }

  updateTravelrequest(
      String trarrivalDateTime, String trequiredDateTime) async {
    pr.show();
    var now = DateTime.now();
    var response = await dio.post(ServicesApi.updateData,
        data: {
          "parameter1": "updateTravelRequest",
          "parameter2": trarrivalDateTime,
          "parameter3": trequiredDateTime,
          "parameter4": traidT,
          "parameter5": profilename
        },
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Fluttertoast.showToast(msg: "Travel Update Request Generated.");

      // var navigator = Navigator.of(context);
      // navigator.pushAndRemoveUntil(
      //   MaterialPageRoute(
      //       builder: (BuildContext context) => TravelRequestList()),
      //   ModalRoute.withName('/'),
      // );
      getUseridBytraId(tra_id.toString());
    } else if (response.statusCode == 401) {
      pr.hide();
      throw Exception("Incorrect data");
    }
  }

  void getUseridBytraId(String tra_id) async {
    var response = await dio.post(ServicesApi.getData,
        data: {"parameter1": "getTokenbytraId", "parameter2": tra_id},
        options: Options(contentType: ContentType.parse("application/json")));
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data != "null" || response.data != null) {
        var req_no = json.decode(response.data)[0]['tra_req_no'];
        var token = json.decode(response.data)[0]['token'];
        if (token != null || token != "null") {
          pushNotification(req_no, token);
        } else {
          pr.hide();
          Fluttertoast.showToast(msg: "Travel Uodate Request Generated.");
          var navigator = Navigator.of(context);
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => TravelRequestList()),
            ModalRoute.withName('/'),
          );
        }
      } else {
        pr.hide();
        Fluttertoast.showToast(msg: "Travel Uodate Request Generated.");
        var navigator = Navigator.of(context);
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => TravelRequestList()),
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
      'body': "Travel request " + reqNo + " has been modified by " + fullname,
      'title': 'Travel Request',
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
    Fluttertoast.showToast(msg: "Travel Uodate Request Generated.");
    var navigator = Navigator.of(context);
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => TravelRequestList()),
      ModalRoute.withName('/'),
    );
  }
}
