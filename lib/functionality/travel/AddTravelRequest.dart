import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eaglebiz/functionality/hotel/DownTeamMembers.dart';
import 'package:eaglebiz/functionality/travel/ProjectSelection.dart';
import 'package:eaglebiz/functionality/travel/TravelRequestList.dart';
import 'package:eaglebiz/functionality/travel/TravelSelection.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddTravelRequest extends StatefulWidget {
  @override
  _AddTravelRequestState createState() => _AddTravelRequestState();
}

class _AddTravelRequestState extends State<AddTravelRequest> {
  TextEditingController _controllerFrom1 = TextEditingController();
  TextEditingController _controllerTo1 = TextEditingController();
  TextEditingController _controllerPurpose1 = TextEditingController();

  String TtravelName,
      Tmode,
      TmodeType,
      Tfrom,
      Tto,
      Tclass,
      TcomplaintNo,
      TrarrivalDateTime,
      TrequiredDateTime,
      TcomaplaintTicketNo,
      TravelNameId,
      TcomaplaintId,
      TcomaplaintRefType;
  bool _isItflight = false;
  static Dio dio = Dio(Config.options);
  int y, m, d, hh, mm, ss;
  int year, month, day, hour, minute;
  String uid, profilename, fullname;

  getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uid = preferences.getString("userId");
    profilename = preferences.getString("profileName");
    fullname = preferences.getString("fullname");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var now = new DateTime.now();
    y = now.year;
    m = now.month;
    d = now.day;
    hh = now.hour;
    mm = now.minute;
    ss = now.second;
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Travel Request',
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
              if (Tmode == "Flight") {
                if (TravelNameId.isEmpty) {
                  Fluttertoast.showToast(msg: "Select 'Traveller Name'.");
                } else if (Tmode.isEmpty) {
                  Fluttertoast.showToast(msg: "Select 'Mode'.");
                } else if (TmodeType.isEmpty) {
                  Fluttertoast.showToast(msg: "Select 'Mode Type'.");
                } else if (Tclass.isEmpty) {
                  Fluttertoast.showToast(msg: "Select 'Class'.");
                } else if (Tfrom.isEmpty) {
                  Fluttertoast.showToast(msg: "Select from 'Station Code'.");
                } else if (Tto.isEmpty) {
                  Fluttertoast.showToast(msg: "Select to 'Station Code'.");
                } else if (TrarrivalDateTime.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Select 'Journey date and time'.");
                } else if (TcomaplaintId.isEmpty) {
                  Fluttertoast.showToast(msg: "Select 'Complaint No'.");
                } else if (_controllerPurpose1.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Select 'Purpose'.");
                } else if (TrequiredDateTime.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Select 'Required date and time'.");
                } else {
                  insertTravelRequest(
                      TravelNameId,
                      Tmode,
                      TmodeType,
                      Tclass,
                      Tfrom,
                      Tto,
                      TrarrivalDateTime,
                      TcomaplaintId,
                      TcomaplaintRefType,
                      TrequiredDateTime,
                      _controllerPurpose1.text);
                }
              } else {
                if (TravelNameId.isEmpty) {
                  Fluttertoast.showToast(msg: "Select 'Traveller Name'.");
                } else if (Tmode.isEmpty) {
                  Fluttertoast.showToast(msg: "Select 'Mode'.");
                } else if (TmodeType.isEmpty) {
                  Fluttertoast.showToast(msg: "Select 'Mode Type'.");
                } else if (Tclass.isEmpty) {
                  Fluttertoast.showToast(msg: "Select 'Class'.");
                } else if (_controllerFrom1.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Enter from 'Address'.");
                } else if (_controllerTo1.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Enter to 'Address'.");
                } else if (TrarrivalDateTime.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Select 'Journey Date and Time'.");
                } else if (TcomaplaintId.isEmpty) {
                  Fluttertoast.showToast(msg: "Select 'Complaint No'.");
                } else if (_controllerPurpose1.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Select 'Purpose'.");
                } else if (TrequiredDateTime.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Select 'Required Date and Time'.");
                } else {
                  insertTravelRequest(
                      TravelNameId,
                      Tmode,
                      TmodeType,
                      Tclass,
                      _controllerFrom1.text,
                      _controllerTo1.text,
                      TrarrivalDateTime,
                      TcomaplaintId,
                      TcomaplaintRefType,
                      TrequiredDateTime,
                      _controllerPurpose1.text);
                }
              }
              // Fluttertoast.showToast(msg: "Saved");
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
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
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
                enabled: false,
                controller: TextEditingController(text: Tmode),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Mode",
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
                              TravelSelection("2", "")));
                  if (data != null) {
                    setState(() {
                      Tmode = data.toString();
                    });
                    if (data.toString() == "Flight") {
                      setState(() {
                        _isItflight = true;
                      });
                    } else {
                      setState(() {
                        _isItflight = false;
                      });
                    }
                  }
                },
              ),
              onTap: () async {
                var data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            TravelSelection("2", "")));
                if (data != null) {
                  setState(() {
                    Tmode = data.toString();
                  });
                  if (data.toString() == "Flight") {
                    setState(() {
                      _isItflight = true;
                    });
                  } else {
                    setState(() {
                      _isItflight = false;
                    });
                  }
                }
              },
            ),
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: TmodeType),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Mode Type",
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
                              TravelSelection("3", "")));
                  if (data != null) {
                    setState(() {
                      TmodeType = data.toString();
                    });
                  }
                },
              ),
              onTap: () async {
                var data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            TravelSelection("3", "")));
                if (data != null) {
                  setState(() {
                    TmodeType = data.toString();
                  });
                }
              },
            ),
            ListTile(
              title: TextFormField(
                enabled: false,
                controller: TextEditingController(text: Tclass),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.chrome_reader_mode),
                  labelText: "Class",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  if (Tmode != null) {
                    var data = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                TravelSelection("4", Tmode)));
                    if (data != null) {
                      setState(() {
                        Tclass = data.toString();
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: " select mode.");
                  }
                },
              ),
              onTap: () async {
                if (Tmode != null) {
                  var data = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              TravelSelection("4", Tmode)));
                  if (data != null) {
                    setState(() {
                      Tclass = data.toString();
                    });
                  }
                } else {
                  Fluttertoast.showToast(msg: " select mode.");
                }
              },
            ),
            _isItflight
                ? ListTile(
                    title: TextFormField(
                      enabled: false,
                      controller: TextEditingController(text: Tfrom),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.chrome_reader_mode),
                        labelText: "From",
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
                                    TravelSelection("5", Tmode)));
                        if (data != null) {
                          setState(() {
                            Tfrom = data.split(" U_")[0].toString();
                            // TfromId = data.split(" U_")[1].toString();
                          });
                        }
                      },
                    ),
                    onTap: () async {
                      var data = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TravelSelection("5", Tmode)));
                      if (data != null) {
                        setState(() {
                          Tfrom = data.split(" U_")[0].toString();
                          // TfromId = data.split(" U_")[1].toString();
                        });
                      }
                    },
                  )
                : ListTile(
                    title: TextFormField(
                      controller: _controllerFrom1,
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
            _isItflight
                ? ListTile(
                    title: TextFormField(
                      enabled: false,
                      controller: TextEditingController(text: Tto),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.chrome_reader_mode),
                        labelText: "To",
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
                                    TravelSelection("6", Tmode)));
                        if (data != null) {
                          setState(() {
                            Tto = data.split(" U_")[0].toString();
                            // TtoId = data.split(" U_")[1].toString();
                          });
                        }
                      },
                    ),
                    onTap: () async {
                      var data = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TravelSelection("6", Tmode)));
                      if (data != null) {
                        setState(() {
                          Tto = data.split(" U_")[0].toString();
                          // TtoId = data.split(" U_")[1].toString();
                        });
                      }
                    },
                  )
                : ListTile(
                    title: TextFormField(
                      controller: _controllerTo1,
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
                controller: TextEditingController(text: TcomaplaintTicketNo),
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
                      TcomaplaintTicketNo = data.split(" P_")[0].toString();
                      TcomaplaintId = data.split(" P_")[1].toString();
                      TcomaplaintRefType = data.split(" P_")[2].toString();
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
                    TcomaplaintTicketNo = data.split(" P_")[0].toString();
                    TcomaplaintId = data.split(" P_")[1].toString();
                    TcomaplaintRefType = data.split(" P_")[2].toString();
                  });
                }
              },
            ),
            ListTile(
              title: TextFormField(
                controller: _controllerPurpose1,
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

  insertTravelRequest(
      String travelNameId,
      String tmode,
      String tmodeType,
      String tclass,
      String tfrom,
      String tto,
      String trarrivalDateTime,
      String tcomaplaintId,
      String tcomaplaintRefType,
      String trequiredDateTime,
      String purpose) async {
    var response = await dio.post(ServicesApi.insert_travel,
        data: {
          "actionMode": "insert",
          "clas": tclass,
          "createdBy": profilename,
          "from": tfrom,
          "journeyDate": trarrivalDateTime,
          "mode": tmode,
          "modeType": tmodeType,
          "modifiedBy": profilename,
          "purpose": purpose,
          "refId": tcomaplaintId,
          "refType": tcomaplaintRefType,
          "reqDateTime": trequiredDateTime,
          "to": tto,
          "uId": travelNameId
        },
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
      getUserRequestNo(travelNameId.toString());
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }

  void getUserRequestNo(String travelNameId) async {
    var response = await dio.post(ServicesApi.getData,
        data: {
          "parameter1": "GetTokenTravelRequest",
          "parameter2": travelNameId
        },
        options: Options(contentType: ContentType.parse("application/json")));
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data != "null" || response.data != null) {
        var req_no = json.decode(response.data)[0]['tra_req_no'];
        var token = json.decode(response.data)[0]['token'];
        if (token != null || token != "null") {
          pushNotification(req_no.toString(), token);
        } else {
          Fluttertoast.showToast(msg: "Travel Request Generated.");
          var navigator = Navigator.of(context);
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => TravelRequestList()),
            ModalRoute.withName('/'),
          );
        }
      } else {
        Fluttertoast.showToast(msg: "Travel Request Generated.");
        var navigator = Navigator.of(context);
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => TravelRequestList()),
          ModalRoute.withName('/'),
        );
      }
    } else if (response.statusCode == 401) {
      throw (Exception);
    }
  }

  void pushNotification(String reqNo, String to) async {
    Map<String, dynamic> notification = {
      'body': "A new travel request " +
          reqNo +
          " has been generated by " +
          fullname,
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
    Fluttertoast.showToast(msg: "Travel Request Generated.");
    var navigator = Navigator.of(context);
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => TravelRequestList()),
      ModalRoute.withName('/'),
    );
  }
}
