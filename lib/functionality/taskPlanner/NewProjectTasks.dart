import 'dart:convert';
import 'dart:io';
import 'package:eaglebiz/model/RestrictPermissionsModel.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:dio/dio.dart';
import 'package:eaglebiz/functionality/taskPlanner/Projects.dart';
import 'package:eaglebiz/functionality/taskPlanner/Resources.dart';
import 'package:eaglebiz/functionality/taskPlanner/TaskPlanner.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

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
  String profileName;
  ProgressDialog pr;
  var now = DateTime.now();

  @override
  void initState() {
    super.initState();
    getProfileName();
  }

  getProfileName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      profileName = preferences.getString("profileName");
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
                if (chooseProject == "Select Project" ||
                    chooseProject == "null") {
                  Fluttertoast.showToast(msg: "Please select project");
                } else if (chooseResource == "Select Resource" ||
                    chooseResource == "null") {
                  Fluttertoast.showToast(msg: "Please select resource");
                } else if (_controller1.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Enter Task Name");
                } else if (_controller2.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Enter Task Descrption");
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
                      maxLength: 20,
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
                      maxLength: 50,
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
                          Fluttertoast.showToast(
                              msg: "Please choose a project");
                        } else {
                          _navigateresourceMethod(context);
                        }
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
      Fluttertoast.showToast(msg: "Sorry! You are not a project incharge.");
    }
  }

  void CallProjectTaskApi() async {
    pr.show();
    print(projectId);
    var response = await dio.post(ServicesApi.saveDayPlan,
        data: {
          "actionMode": "insert",
          "dpCreatedBy": profileName.toString(),
          "dpGivenBy": profileName,
          "dpStartDate": DateFormat("yyyy-MM-dd hh:mm:ss").format(now),
          "dpTask": _controller1.text.toString(),
          "dpTaskDesc": _controller2.text.toString(),
          "dpType": "Office",
          "dayTaskType": "Project",
          "projectId": projectId,
          "dpModifiedBy": profileName,
          "uId": resourceId,
          "dpStartDate": DateFormat("yyyy-MM-dd hh:mm:ss").format(now)
        },
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
//      var responseJson = json.decode(response.data);
      Fluttertoast.showToast(msg: "Task Created");
      pr.hide();
      var navigator = Navigator.of(context);
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => TaskPlanner()),
        ModalRoute.withName('/'),
      );
    } else {
      pr.hide();
      Fluttertoast.showToast(msg: "Please try after some time.");
    }
  }

  checkProjectIncharge(String uidd, projectId) async {
    var response = await dio.post(ServicesApi.getData,
        data: {
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
      Fluttertoast.showToast(msg: "Please try after some time.");
    }
  }
}
