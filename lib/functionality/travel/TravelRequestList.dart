import 'dart:convert';
import 'dart:io';
import 'package:eaglebiz/commonDrawer/CollapsingNavigationDrawer.dart';
import 'package:eaglebiz/functionality/travel/ViewTravelRequest.dart';
import 'package:dio/dio.dart';
import 'package:eaglebiz/functionality/travel/AddTravelRequest.dart';
import 'package:eaglebiz/main.dart';
import 'package:eaglebiz/model/TravelRequestListModel.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TravelRequestList extends StatefulWidget {
  @override
  _TravelRequestListState createState() => _TravelRequestListState();
}

class _TravelRequestListState extends State<TravelRequestList> {
  static Dio dio = Dio(Config.options);
  List<TravelRequestListModel> trlm = List();
  @override
  void initState() {
    super.initState();
    getTravelData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Travel Request',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: lwtColor,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AddTravelRequest()));
        },
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
          ),
          Container(
            child: ListView.builder(
              itemCount: trlm?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    margin: EdgeInsets.only(left: 60, right: 5, top: 6),
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Request No.",
                                      style: TextStyle(
                                          fontSize: 7, color: Colors.black),
                                    ),
                                    Text(
                                      trlm[index].reqNo,
                                      style: TextStyle(
                                          color: lwtColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                                Text(
                                  checkTravelRequestStatus(
                                      trlm[index].tra_status),
                                  style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Traveller Name",
                                      style: TextStyle(
                                          fontSize: 7, color: Colors.black),
                                    ),
                                    Text(
                                      trlm[index].fullName,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "Date",
                                      style: TextStyle(
                                          fontSize: 7, color: Colors.black),
                                    ),
                                    Text(
                                      trlm[index].journeyDate,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "From",
                                      style: TextStyle(
                                          fontSize: 7, color: Colors.black),
                                    ),
                                    Text(
                                      trlm[index].tra_from,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "To",
                                      style: TextStyle(
                                          fontSize: 7, color: Colors.black),
                                    ),
                                    Text(
                                      trlm[index].tra_to,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      "Purpose.",
                                      style: TextStyle(
                                          fontSize: 7, color: Colors.black),
                                    ),
                                    Container(
                                        width: 180,
                                        child: Text(
                                          trlm[index].tra_purpose,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        )),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      "Complaint Ticket No.",
                                      style: TextStyle(
                                          fontSize: 7, color: Colors.black),
                                    ),
                                    Container(
                                        width: 180,
                                        child: Text(
                                          trlm[index].proj_oano,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 70,
                                  child: Material(
                                    elevation: 2.0,
                                    shadowColor: Colors.grey,
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: lwtColor,
                                    child: MaterialButton(
                                      height: 22.0,
                                      padding: EdgeInsets.all(3),
                                      child: Text(
                                        "View",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ViewTravelRequest(
                                                            trlm[index].tra_id,
                                                            trlm[index]
                                                                .reqNo)));
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      color: Colors.white,
                    ));
              },
            ),
          ),
          CollapsingNavigationDrawer("7"),
        ],
      ),
    );
  }

  getTravelData() async {
    var response = await dio.post(ServicesApi.getData,
        data: {"parameter1": "GetAllTravelRequests"},
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        trlm = (json.decode(response.data) as List)
            .map((f) => TravelRequestListModel.fromJson(f))
            .toList();
      });
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }

  String checkTravelRequestStatus(int tra_status) {
    if (tra_status == 1) {
      return "Pending";
    } else {
      return "";
    }
  }
}
