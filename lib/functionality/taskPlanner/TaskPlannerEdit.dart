import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eaglebiz/functionality/taskPlanner/TaskPlanner.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../../main.dart';

class TaskPlannerEdit extends StatefulWidget {
  String dp_id, profilename;
  TaskPlannerEdit(this.dp_id, this.profilename);

  @override
  _TaskPlannerEditState createState() =>
      _TaskPlannerEditState(dp_id, profilename);
}

class _TaskPlannerEditState extends State<TaskPlannerEdit> {
  String dp_id, mainStatus, profilename;
  ProgressDialog pr;
  _TaskPlannerEditState(this.dp_id, this.profilename);
  TextEditingController _controllerReason = TextEditingController();

  static Dio dio = Dio(Config.options);
  final List<String> listTaskStatus = ['Open', 'Progress', 'Closed'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return Scaffold(
      appBar: AppBar(
          title: Text(
            dp_id.toString(),
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white)),
      body: ListView.builder(
        itemCount: listTaskStatus.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
            child: Card(
              elevation: 0.5,
              child: Material(
                shadowColor: lwtColor,
                child: ListTile(
                  title: Text(listTaskStatus[index]),
                  onTap: () {
                    if (listTaskStatus[index] == "Open") {
                      setState(() {
                        roundedAlertBox(1);
                      });
                    } else if (listTaskStatus[index] == "Progress") {
                      setState(() {
                        roundedAlertBox(2);
                      });
                    } else if (listTaskStatus[index] == "Closed") {
                      setState(() {
                        roundedAlertBox(3);
                      });
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  roundedAlertBox(int _idstatus) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Feedback",
                        style: TextStyle(fontSize: 30.0, color: lwtColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextFormField(
                      controller: _controllerReason,
                      decoration: InputDecoration(
                        hintText: "Task Feedback",
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (_controllerReason.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please Provide your Task Feedback.");
                      } else {
                        _callServiceUpdateStatus(
                            _idstatus, _controllerReason.text);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: lwtColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(24.0),
                            bottomRight: Radius.circular(24.0)),
                      ),
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _callServiceUpdateStatus(int mainStatus, String reason) async {
    pr.show();
    try {
      var response = await dio.post(ServicesApi.saveDayPlan,
          data: {
            "actionMode": "update",
            "dpId": dp_id.toString(),
            "dpModifiedBy": profilename,
            "dpReason": reason.toString(),
            "dpStatus": mainStatus.toString()
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        pr.hide();
        Fluttertoast.showToast(msg: "Status Updated.!");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => TaskPlanner()),
          ModalRoute.withName('/'),
        );
        // getUserIdDayPlan(dp_id, createdUid);
      } else if (response.statusCode == 401) {
        pr.hide();
        throw Exception("Incorrect data");
      } else
        pr.hide();
      throw Exception('Authentication Error');
    } on DioError catch (exception) {
      pr.hide();
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        pr.hide();
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        pr.hide();
        throw Exception(
            "Check your internet connection.");
      }
    }
  }

  void getUserIdDayPlan(String dp_id, createdUid) {}
}
