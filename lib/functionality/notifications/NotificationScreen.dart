import 'dart:convert';
import 'dart:io';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:dio/dio.dart';
import 'package:eaglebiz/functionality/approvals/Approvals.dart';
import 'package:eaglebiz/model/NotificationsModel.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}


class _NotificationScreenState extends State<NotificationScreen> {
  var uidd;
  static Dio dio = Dio(Config.options);
  List<NotificationsModel> _notificationsList=[];
  @override
  void initState() {
    super.initState();
    getUserID().then((val)=>setState((){
      uidd=val;
      getNotifications();
      print(uidd);
    }));


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications",style: TextStyle(color: Colors.white),),
      iconTheme: IconThemeData(color: Colors.white),),
      body: DraggableScrollbar.arrows(
        labelTextBuilder: (double offset) => Text("${offset ~/ 100}"),
        child: ListView.builder(
              padding: EdgeInsets.only(left: 8,right: 8),
              itemCount:_notificationsList ==null ? 0: _notificationsList.length,
              itemBuilder: (BuildContext context,int index){
                return Card(
                  child: ListTile (
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: BoxDecoration(
                          border:
                          Border(right: BorderSide(width: 1.0, color: Colors.grey))),
                      width: 50,
                      child: Column(
                        children: <Widget>[
                          Text(getDateMethod(_notificationsList[index].created_date,"1"),style: TextStyle(color: lwtColor,fontSize: 30,fontWeight: FontWeight.bold),),
                          Text(getDateMethod(_notificationsList[index].created_date,"2"),style: TextStyle(fontSize: 8,),),
                          Text(getDateMethod(_notificationsList[index].created_date,"3"),style: TextStyle(fontSize: 8,)),
                        ],
                      ),
                    ),

                    title: Padding(
                      padding: EdgeInsets.only(top: 4,bottom: 5,left: 10),
                      child: Text(_notificationsList[index].senderName[0].toUpperCase()+_notificationsList[index].senderName.substring(1),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(left: 10,top: 2,bottom: 5),
                      child: Text(_notificationsList[index].notification_type),
                    )
                  ),

                );
              }),
      ),
    );
  }

  void getNotifications() async {
    var response = await dio.post(ServicesApi.GlobalNotificationsData,
        data:
        {
          "actionMode": "GetAllNotificationByUserId",
          "parameter1": uidd,
          "parameter2": "string",
          "parameter3": "string",
          "parameter4": "string",
          "parameter5": "string"
        },
        options: Options(contentType: ContentType.parse('application/json'),
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        _notificationsList = (json.decode(response.data) as List).map((data) => new NotificationsModel.fromJson(data)).toList();
      });
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }

  String getDateMethod(String _created_date,String selectType) {
    List<String> timeStamp=[];
    timeStamp=_created_date.split(" ");
    var timeStampSplit=timeStamp[0].toString();
    List<String> dateSplit;
    dateSplit=timeStampSplit.split("-");
    if(selectType=="1"){
      return dateSplit[2].toString();
    }else if(selectType=="2"){
      return dateSplit[1].toString();
    }else if(selectType=="3"){
      return dateSplit[0].toString();
    }

    return null;

  }
}
