import 'dart:convert';
import 'dart:io';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:dio/dio.dart';
import 'package:Ebiz/functionality/approvals/Approvals.dart';
import 'package:Ebiz/model/NotificationsModel.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../../main.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var uidd;
  static Dio dio = Dio(Config.options);
  List<NotificationsModel> _notificationsList = [];
  @override
  void initState() {
    super.initState();
    getUserID().then((val) => setState(() {
          uidd = val;
          getNotifications();
          print(uidd);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
          padding: EdgeInsets.only(left: 2, right: 2),
          itemCount: _notificationsList == null ? 0 : _notificationsList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.white,
              child: ListTile(
                  onTap: () {
                    hasseenNotification(_notificationsList[index].not_id);
                  },
                  // trailing: Icon(LineAwesomeIcons.bell,
                  //     size: 25,
                  //     color: _notificationsList[index].status == 0
                  //         ? lwtColor
                  //         : Colors.white),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(width: 1.0, color: Colors.grey))),
                    width: 50,
                    child: Column(
                      children: <Widget>[
                        Text(
                          getDateMethod(
                              _notificationsList[index].created_date, "1"),
                          style: TextStyle(
                              color: lwtColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          getDateMethod(
                              _notificationsList[index].created_date, "2"),
                          style: TextStyle(
                            color: lwtColor,
                            fontSize: 8,
                          ),
                        ),
                        Text(
                            getDateMethod(
                                _notificationsList[index].created_date, "3"),
                            style: TextStyle(
                              color: lwtColor,
                              fontSize: 8,
                            )),
                      ],
                    ),
                  ),
                  title: Padding(
                    padding: EdgeInsets.only(top: 0, bottom: 5, left: 0),
                    child: Text(
                      _notificationsList[index].senderName[0].toUpperCase()+
                          _notificationsList[index].senderName.substring(1)??"",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: _notificationsList[index].status== 0 ?  Colors.black : Colors.grey,
                        fontWeight: _notificationsList[index].status== 0 ? FontWeight.bold : FontWeight.normal
                      ),
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(left: 0, top: 2, bottom: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                      Text(
                      _notificationsList[index].notification_type,
                      style: TextStyle(
                      color: _notificationsList[index].status== 0 ?  Colors.black : Colors.grey,
                      fontWeight: _notificationsList[index].status== 0 ? FontWeight.bold : FontWeight.normal
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      _notificationsList[index].message,
                      style: TextStyle(
                      color: _notificationsList[index].status== 0 ?  Colors.black : Colors.grey,
                      fontWeight: _notificationsList[index].status== 0 ? FontWeight.bold : FontWeight.normal
                      ),
                    ),
                    ],)
                  )),
            );
          }),
    );
  }

  void getNotifications() async {
    var response = await dio.post(ServicesApi.getData,
        data: {
          "encryptedFields": ["senderName"],
          "parameter1": "getAllNotifications",
          "parameter2": uidd,
        },
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        _notificationsList = (json.decode(response.data) as List)
            .map((data) => new NotificationsModel.fromJson(data))
            .toList();
      });
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }

  String getDateMethod(String created_date, String selectType) {
    if(created_date==null){}
    List<String> timeStamp = [];
    timeStamp = created_date.split(" ");
    var timeStampSplit = timeStamp[0].toString();
    List<String> dateSplit;
    dateSplit = timeStampSplit.split("-");
    if (selectType == "1") {
      return dateSplit[2].toString();
    } else if (selectType == "2") {
      return dateSplit[1].toString();
    } else if (selectType == "3") {
      return dateSplit[0].toString();
    }
  }

  void hasseenNotification(int not_id) async {
    var response = await dio.post(ServicesApi.updateData,
        data: {
          "parameter1": "updateNotificationStatus",
          "parameter2": not_id,
        },
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
      getNotifications();
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }
}
