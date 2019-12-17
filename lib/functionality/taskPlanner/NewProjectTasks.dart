import 'dart:convert';
import 'dart:io';
import 'package:Ebiz/model/FirebaseUserModel.dart';
import 'package:Ebiz/model/RestrictPermissionsModel.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:dio/dio.dart';
import 'package:Ebiz/functionality/taskPlanner/Projects.dart';
import 'package:Ebiz/functionality/taskPlanner/Resources.dart';
import 'package:Ebiz/functionality/taskPlanner/TaskPlanner.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import 'package:http/http.dart' as http;

class NewProjectTasks extends StatefulWidget {
  @override
  _NewProjectTasksState createState() => _NewProjectTasksState();
}

class _NewProjectTasksState extends State<NewProjectTasks> {
  String uidd;
  static Dio dio = Dio(Config.options);
  var _controller1 = TextEditingController();
  var _controller2 = TextEditingController();
  var chooseProject = "Select Project";
  var chooseResource = "Select Resource";
  var projectId;
  var resourceId;
  int y, m, d, hh, mm;
  int year, month, day, hour, minute;
  String profileName, fullName, startDate, startDates, endDate, endDates;
  ProgressDialog pr;
  List<FirebaseUserModel> fum;
  var now = DateTime.now();

  @override
  void initState() {
    super.initState();
    var now = new DateTime.now();
    y = now.year;
    m = now.month;
    d = now.day;
    hh = now.hour;
    mm = now.minute;
    getProfileName();
  }

  getProfileName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      profileName = preferences.getString("profileName");
      fullName = preferences.getString('fullname');
      uidd = preferences.getString("userId");
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
        navigator.push(
          // ignore: missing_return
          MaterialPageRoute(builder: (BuildContext context) => TaskPlanner()),
          // ignore: missing_return
          // ModalRoute.withName('/'),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Project Activity',
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
              navigator.push(
                MaterialPageRoute(
                    builder: (BuildContext context) => TaskPlanner()),
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
                //Service Call
                if (chooseProject == "Select 'Project'" ||
                    chooseProject == "null") {
                  Fluttertoast.showToast(msg: "select 'project'");
                } else if (chooseResource == "Select 'Resource'" ||
                    chooseResource == "null") {
                  Fluttertoast.showToast(msg: "select 'Resource'");
                } else if (_controller1.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Enter 'Task Name'");
                } else if (startDate.isEmpty) {
                  Fluttertoast.showToast(msg: "Select Start Date");
                } else if (endDate.isEmpty) {
                  Fluttertoast.showToast(msg: "Select End Date");
                } else if (_controller2.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Enter 'Task Descrption'");
                } else {
                  CallProjectTaskApi();
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
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 15),
                  ListTile(
                    onTap: () {
                      _navigatereferMethod(context);
                    },
                    title: TextFormField(
                      enabled: false,
                      controller: TextEditingController(
                          text: chooseProject[0].toUpperCase() +
                              chooseProject.substring(1)),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.chrome_reader_mode),
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
                        _navigatereferMethod(context);
                      },
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
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
                  ListTile(
                    title: TextFormField(
                      controller: _controller2,
                      maxLength: 500,
                      maxLines: 3,
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
                  ListTile(
                    onTap: () {
                      if (projectId == null) {
                        Fluttertoast.showToast(msg: "Choose a 'Project'");
                      } else {
                        _navigateresourceMethod(context);
                      }
                    },
                    title: TextFormField(
                      enabled: false,
                      controller: TextEditingController(
                          text: chooseResource[0].toUpperCase() +
                              chooseResource.substring(1)),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.chrome_reader_mode),
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
                        if (projectId == null) {
                          Fluttertoast.showToast(msg: "Choose a 'Project'");
                        } else {
                          _navigateresourceMethod(context);
                        }
                      },
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        endDate = "";
                        endDates = "";
                      });
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
                    title: TextFormField(
                      enabled: false,
                      controller: TextEditingController(text: startDates),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.chrome_reader_mode),
                        labelText: "Start Date",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        setState(() {
                          endDate = "";
                          endDates = "";
                        });
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
                  ),
                  ListTile(
                    onTap: () {
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
                    title: TextFormField(
                      enabled: false,
                      controller: TextEditingController(text: endDates),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.chrome_reader_mode),
                        labelText: "End Date",
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
                            minTime:
                                DateTime(year, month, day, hour, minute + 1),
                            maxTime: DateTime(y + 1, m, d, hh, mm),
                            onChanged: (date) {
                          changeDateT(date);
                        }, onConfirm: (date) {
                          changeDateT(date);
                        }, locale: LocaleType.en);
                      },
                    ),
                  ),
                ],
              ),
            )
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

  void _navigatereferMethod(BuildContext context) async {
    var data = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Projects(chooseProject)));
    var string = data.split(" PROJ_");
    chooseProject = string[0];
    projectId = string[1];
  }

  void _navigateresourceMethod(BuildContext context) async {
    var data;
    var checkpi = await checkProjectIncharge(uidd, projectId);
    if (checkpi.toString() == '1') {
      data = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  Resources(chooseResource, projectId)));
      var string = data.split(" USR_");
      chooseResource = string[0];
      resourceId = string[1];
    } else {
      Fluttertoast.showToast(msg: "Sorry..! You are not a project incharge.");
    }
  }

  void CallProjectTaskApi() async {
    pr.show();
    print(projectId);
    var response = await dio.post(ServicesApi.saveDayPlan,
        data: {
          "actionMode": "insert",
          "dpCreatedBy": profileName.toString().toLowerCase(),
          "dpGivenBy": profileName.toLowerCase(),
          "dpTask": _controller1.text.toString(),
          "dpTaskDesc": _controller2.text.toString(),
          "dpType": "Office",
          "dayTaskType": "Project",
          "projectId": projectId,
          "dpModifiedBy": profileName.toLowerCase(),
          "uId": resourceId,
          "dpStartDate": DateFormat("yyyy-MM-dd hh:mm:ss").format(now),
          "dpTaskStartDateTime": startDate,
          "dpTaskEndDateTime": endDate
        },
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
      getFirebaseToken(
          fullName, _controller1.text, _controller2.text, resourceId);
    } else {
      pr.hide();
      Fluttertoast.showToast(msg: "Check your internet connection.");
    }
  }

  checkProjectIncharge(String uidd, projectId) async {
    var response = await dio.post(ServicesApi.getData,
        data: {
          "encryptedFields": ["string"],
          "parameter1": "CheckProjectIncharge",
          "parameter2": uidd,
          "parameter3": projectId.toString()
        },
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<RestrictPermissionsModel> dataCheck =
          (json.decode(response.data) as List)
              .map((data) => new RestrictPermissionsModel.fromJson(data))
              .toList();
      return dataCheck[0].status.toString();
    } else {
      pr.hide();
      Fluttertoast.showToast(msg: "Check your internet connection.");
    }
  }

  void getFirebaseToken(String fullName, String taskName,
      String taskDescription, resourceId) async {
    var response = await dio.post(ServicesApi.getData,
        data: {"encryptedFields": ["string"],"parameter1": "getUserToken", "parameter2": resourceId},
        options: Options(contentType: ContentType.parse("application/json")));
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data != null) {
        setState(() {
          fum = (json.decode(response.data) as List)
              .map((data) => new FirebaseUserModel.fromJson(data))
              .toList();
        });
        if (fum.isNotEmpty) {
          var data = fum[0].token.toString();
          // Fluttertoast.showToast(msg: "Stopped");
          if (data != null || data != "null") {
            pushNotification(data, fullName, taskName, taskDescription);
          } else {
            pr.hide();
            Fluttertoast.showToast(msg: "Task Allocated");
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => TaskPlanner()),
              ModalRoute.withName('/'),
            );
          }
        } else {
          pr.hide();
          Fluttertoast.showToast(msg: "Task Allocated");
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => TaskPlanner()),
            ModalRoute.withName('/'),
          );
        }
      } else {
        pr.hide();
        Fluttertoast.showToast(msg: "Task Allocated");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => TaskPlanner()),
          ModalRoute.withName('/'),
        );
      }
    } else if (response.statusCode == 401) {
      throw (Exception);
    }
  }

  void pushNotification(String to, String fullName, String taskName,
      String taskDescription) async {
    Map<String, dynamic> notification = {
      'body':
          fullName + " has assigned a task for you" + " '" + "$taskName" + "'",
      'title': 'PMC Task Allocation',
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
    Fluttertoast.showToast(msg: "Task Allocated");
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => TaskPlanner()),
      ModalRoute.withName('/'),
    );
  }
}

//  Fluttertoast.showToast(msg: "Task Assigned");
//       pr.hide();
//       var navigator = Navigator.of(context);
//       navigator.pushAndRemoveUntil(
//         MaterialPageRoute(builder: (BuildContext context) => TaskPlanner()),
//         ModalRoute.withName('/'),
//       );
