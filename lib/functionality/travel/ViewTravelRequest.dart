import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eaglebiz/model/TravelRequestByTId.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';

class ViewTravelRequest extends StatefulWidget {
  int tra_id;
  String reqNo;
  ViewTravelRequest(this.tra_id, this.reqNo);

  @override
  _ViewTravelRequestState createState() =>
      _ViewTravelRequestState(this.tra_id, this.reqNo);
}

class _ViewTravelRequestState extends State<ViewTravelRequest> {
  int tra_id;
  String reqNo;
  _ViewTravelRequestState(this.tra_id, this.reqNo);
  Dio dio=Dio(Config.options);
  List<TravelRequestByTId> trbtid =List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataTravelrequestbytId(tra_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          reqNo,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: trbtid?.length??0,
          itemBuilder: (BuildContext context,int index){
            return Container(
              margin: EdgeInsets.only(left: 5, right: 5, top: 6),
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: Column(children: <Widget>[
                    Text(trbtid[index].fullName)
                  ],),
                ),),
            );
          },
        ),
      )
    );
  }

  void getDataTravelrequestbytId(int tra_id) async {
    Response response=await dio.post(ServicesApi.getData,data: {"parameter1": "GetTravelRequestById","parameter2":tra_id},options: Options(contentType: ContentType.parse('application/json'),));
    if(response.statusCode==200 || response.statusCode==201){
      print(response.data);
      setState(() {
      trbtid= (json.decode(response.data) as List).map((f)=> TravelRequestByTId.fromJson(f)).toList();  
      });
    }else if(response.statusCode==401){
      throw Exception("Incorrect data");
    }
  }
}
