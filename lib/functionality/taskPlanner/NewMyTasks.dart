import 'dart:io';
import 'package:Ebiz/functionality/taskPlanner/ReasonType.dart';
import 'package:dio/dio.dart';
import 'package:Ebiz/functionality/taskPlanner/TaskPlanner.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class NewMyTasks extends StatefulWidget {
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewMyTasks> {
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  final _controller4 = TextEditingController();
  String reasonType = "Reason";
  bool office, onsite;
  var referalPerson;
  String profileName, fullname, startDate, startDates, endDate, endDates;
  ProgressDialog pr;
  String uidd;
  int y, m, d, hh, mm;
  int year, month, day, hour, minute;
  static Dio dio = Dio(Config.options);

  Future<String> getUserID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString("userId");
    return id;
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
    office = true;
    onsite = false;
    getUserID().then((val) => setState(() {
          uidd = val;
          print(uidd);
        }));
    getProfileName();
  }

  void getProfileName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      profileName = preferences.getString("profileName");
      fullname = preferences.getString("fullname");
    });
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        // ignore: missing_return
        var navigator = Navigator.of(context);
        // ignore: missing_return
        navigator.pushAndRemoveUntil(
          // ignore: missing_return
          MaterialPageRoute(builder: (BuildContext context) => TaskPlanner()),
          // ignore: missing_return
          ModalRoute.withName('/'),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Self Activity ',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              var navigator = Navigator.of(context);
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => TaskPlanner()),
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
                //Service Call
                if (office == true) {
                  if (_controller1.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Enter 'Task Name'");
                  } else if (_controller2.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Enter 'Task Details'");
                  } else {
                    myTaskService("1");
                  }
//                    Fluttertoast.showToast(msg: "Office");
                } else if (onsite == true) {
                  if (_controller1.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Enter 'Task Name'");
                  } else if (_controller2.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Enter 'Task Details'");
                  } else if (_controller3.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Enter 'Location'");
                  } else if (_controller4.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Enter 'Contact Person'");
                  } else if (reasonType == "Reason" || reasonType == "null") {
                    Fluttertoast.showToast(msg: "Enter 'Reason'");
                  } else {
                    myTaskService("2");
                  }
//                    Fluttertoast.showToast(msg: "Instation");
                }
              },
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 6),
              child: StaggeredGridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: officeM(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: onsiteM(),
                  ),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(2, 60.0),
                  StaggeredTile.extent(2, 60.0),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 80, left: 5, right: 5),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: SafeArea(
                      child: TextFormField(
                        controller: _controller1,
                        maxLength: 100,
                        maxLines: 2,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.chrome_reader_mode),
                          labelText: "Task Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: SafeArea(
                      child: TextFormField(
                        controller: _controller2,
                        maxLength: 500,
                        maxLines: 4,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.chrome_reader_mode),
                          labelText: "Task Details",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ListTile(
                  //   onTap: () {
                  //     setState(() {
                  //       endDate = "";
                  //       endDates = "";
                  //     });
                  //     DatePicker.showDateTimePicker(context,
                  //         showTitleActions: true,
                  //         minTime: DateTime(y, m, d, hh, mm),
                  //         maxTime: DateTime(y + 1, m, d, hh, mm),
                  //         onChanged: (date) {
                  //       changeDateF(date);
                  //     }, onConfirm: (date) {
                  //       changeDateF(date);
                  //     }, locale: LocaleType.en);
                  //   },
                  //   title: TextFormField(
                  //     enabled: false,
                  //     controller: TextEditingController(text: startDates),
                  //     keyboardType: TextInputType.text,
                  //     decoration: InputDecoration(
                  //       prefixIcon: Icon(Icons.chrome_reader_mode),
                  //       labelText: "Start Date",
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10.0),
                  //       ),
                  //     ),
                  //   ),
                  //   trailing: IconButton(
                  //     icon: Icon(Icons.calendar_today),
                  //     onPressed: () {
                  //       setState(() {
                  //         endDate = "";
                  //         endDates = "";
                  //       });
                  //       DatePicker.showDateTimePicker(context,
                  //           showTitleActions: true,
                  //           minTime: DateTime(y, m, d, hh, mm),
                  //           maxTime: DateTime(y + 1, m, d, hh, mm),
                  //           onChanged: (date) {
                  //         changeDateF(date);
                  //       }, onConfirm: (date) {
                  //         changeDateF(date);
                  //       }, locale: LocaleType.en);
                  //     },
                  //   ),
                  // ),
                  // ListTile(
                  //   onTap: () {
                  //     DatePicker.showDateTimePicker(context,
                  //         showTitleActions: true,
                  //         minTime: DateTime(year, month, day, hour, minute + 1),
                  //         maxTime: DateTime(y + 1, m, d, hh, mm),
                  //         onChanged: (date) {
                  //       changeDateT(date);
                  //     }, onConfirm: (date) {
                  //       changeDateT(date);
                  //     }, locale: LocaleType.en);
                  //   },
                  //   title: TextFormField(
                  //     enabled: false,
                  //     controller: TextEditingController(text: endDates),
                  //     keyboardType: TextInputType.text,
                  //     decoration: InputDecoration(
                  //       prefixIcon: Icon(Icons.chrome_reader_mode),
                  //       labelText: "End Date",
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10.0),
                  //       ),
                  //     ),
                  //   ),
                  //   trailing: IconButton(
                  //     icon: Icon(Icons.calendar_today),
                  //     onPressed: () {
                  //       DatePicker.showDateTimePicker(context,
                  //           showTitleActions: true,
                  //           minTime:
                  //               DateTime(year, month, day, hour, minute + 1),
                  //           maxTime: DateTime(y + 1, m, d, hh, mm),
                  //           onChanged: (date) {
                  //         changeDateT(date);
                  //       }, onConfirm: (date) {
                  //         changeDateT(date);
                  //       }, locale: LocaleType.en);
                  //     },
                  //   ),
                  // ),
                  onsite
                      ? ListTile(
                          title: TextFormField(
                            controller: _controller3,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.chrome_reader_mode),
                              labelText: "Location",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  onsite
                      ? ListTile(
                          title: TextFormField(
                            controller: _controller4,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.chrome_reader_mode),
                              labelText: "Contact Person",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  onsite
                      ? ListTile(
                          onTap: () {
                            reasonTypeM(context);
                          },
                          title: TextFormField(
                            enabled: false,
                            controller: TextEditingController(text: reasonType),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.view_list),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: lwtColor,
                            ),
                            onPressed: () {
                              reasonTypeM(context);
                            },
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            //ListView.builder(itemBuilder: null)
          ],
        ),
      ),
    );
  }

  officeM() {
    return Material(
      color: office ? lwtColor : Colors.white,
      elevation: 10.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: office ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            office = !office;
            if (office == true) {
              onsite = !onsite;
            } else if (office == false) {
              onsite = !onsite;
            }
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "office".toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: "Roboto",
                          color: office ? Colors.white : lwtColor,
                        ),
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

  onsiteM() {
    return Material(
      color: onsite ? lwtColor : Colors.white,
      elevation: 10.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: onsite ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            onsite = !onsite;
            if (onsite == true) {
              office = !office;
            } else if (onsite == false) {
              office = !office;
            }
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "Out-of Office".toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: "Roboto",
                          color: onsite ? Colors.white : lwtColor,
                        ),
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

//  void _navigatereferMethod(BuildContext context) async {
//    var data= await Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => ReferedBy(result)));
//    try {
//      var string = data.split(" USR_");
//      result = string[0];
//      referalPerson = "USR_"+string[1];
//    }catch(Exception){
//
//    }
//  }

  myTaskService(String s) async {
    pr.show();
    var now = DateTime.now();
    if (s == "1") {
      var response = await dio.post(ServicesApi.saveDayPlan,
          data: {
            "actionMode": "insert",
            "dpCreatedBy": profileName.toString(),
            "dpGivenBy": profileName,
            "dpStartDate": DateFormat("yyyy-MM-dd hh:mm:ss").format(now),
            "dpTask": _controller1.text.toString(),
            "dpTaskDesc": _controller2.text.toString(),
            "dpType": "Office",
            "dayTaskType": "Self",
            "dpModifiedBy": profileName,
            "uId": uidd,
            "dpTaskStartDateTime": "",
            "dpTaskEndDateTime": ""
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));

      if (response.statusCode == 200 || response.statusCode == 201) {
//        var responseJson = json.decode(response.data);
        pr.hide();
        Fluttertoast.showToast(msg: "Task Created");
        var navigator = Navigator.of(context);
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => TaskPlanner()),
          ModalRoute.withName('/'),
        );
      } else {
        pr.hide();
        Fluttertoast.showToast(msg: "Check your internet connection.");
      }
    } else if (s == "2") {
      var response = await dio.post(ServicesApi.saveDayPlan,
          data: {
            "actionMode": "insert",
            "dpCreatedBy": profileName.toString(),
            "dpGivenBy": fullname,
            "dpStartDate": DateFormat("yyyy-MM-dd hh:mm:ss").format(now),
            "dpStatus": 0,
            "dpTask": _controller1.text.toString(),
            "dpTaskDesc": _controller2.text.toString(),
            "dpType": "Instation",
            "dayTaskType": "Self",
            "dpModifiedBy": profileName,
            "uId": uidd,
            "dpTaskStartDateTime": startDate,
            "dpTaskEndDateTime": endDate
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));

      if (response.statusCode == 200 || response.statusCode == 201) {
//        var responseJson = json.decode(response.data);
        pr.hide();
        Fluttertoast.showToast(msg: "Task Created");
        var navigator = Navigator.of(context);
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => TaskPlanner()),
          ModalRoute.withName('/'),
        );
      } else {
        pr.hide();
        Fluttertoast.showToast(msg: "Check your internet connection.");
      }
    }
  }

  reasonTypeM(BuildContext context) async {
    var data = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => ReasonType()));
    print(data.toString());
    reasonType = data.toString();
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

      startDate = d[0].toString();
      startDates = day.toString() +
          "-" +
          month.toString() +
          "-" +
          year.toString() +
          " " +
          time;
    });
  }

  void changeDateT(DateTime date) {
    String newDate = date.toString();
    List<String> d = [];
    var day, month, year;
    d = newDate.split(".");
    // print(d[0]);
    setState(() {
      endDate = d[0].toString();
      endDates = d[0]
              .toString()
              .split(" ")[0]
              .toString()
              .split("-")[2]
              .toString() +
          "-" +
          d[0].toString().split(" ")[0].toString().split("-")[1].toString() +
          "-" +
          d[0].toString().split(" ")[0].toString().split("-")[0].toString() +
          " " +
          d[0].toString().split(" ")[1].toString();
    });
  }
}
