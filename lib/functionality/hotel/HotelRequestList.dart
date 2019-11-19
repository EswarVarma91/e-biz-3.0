import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eaglebiz/commonDrawer/CollapsingNavigationDrawer.dart';
import 'package:eaglebiz/functionality/hotel/AddHotelRequest.dart';
import 'package:eaglebiz/functionality/hotel/ViewHotelRequest.dart';
import 'package:eaglebiz/main.dart';
import 'package:eaglebiz/model/HotelRequestModel.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';

class HotelRequestList extends StatefulWidget {
  @override
  _HotelRequestListState createState() => _HotelRequestListState();
}

class _HotelRequestListState extends State<HotelRequestList> {
  static Dio dio = Dio(Config.options);
  List<HotelRequestModel> trlm = List();

  @override
  void initState() {
    super.initState();
    getHotelData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hotel Requests',
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
                  builder: (BuildContext context) => AddHotelRequest()));
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
                                      trlm[index]?.hotel_ref_no.toString() ??
                                          "",
                                      style: TextStyle(
                                          color: lwtColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                                Text(
                                  checkHotelRequestStatus(
                                      trlm[index].hotel_status),
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
                                      trlm[index]?.travellerName ?? "",
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
                                      "Hotel Rating",
                                      style: TextStyle(
                                          fontSize: 7, color: Colors.black),
                                    ),
                                    Text(
                                      trlm[index]?.hotel_rating.toString() ??
                                          "",
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
                                      "Hotel Check In",
                                      style: TextStyle(
                                          fontSize: 7, color: Colors.black),
                                    ),
                                    Text(
                                      trlm[index]?.hotel_check_in ?? "",
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
                                      "Hotel Check Out",
                                      style: TextStyle(
                                          fontSize: 7, color: Colors.black),
                                    ),
                                    Text(
                                      trlm[index]?.hotel_check_out ?? "",
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
                                      "Purpose",
                                      style: TextStyle(
                                          fontSize: 7, color: Colors.black),
                                    ),
                                    Text(
                                      trlm[index]?.hotel_purpose ?? "",
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
                                      "Location",
                                      style: TextStyle(
                                          fontSize: 7, color: Colors.black),
                                    ),
                                    Text(
                                      trlm[index]?.hotel_location ?? "",
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
                                      "Complaint No.",
                                      style: TextStyle(
                                          fontSize: 7, color: Colors.black),
                                    ),
                                    Text(
                                      trlm[index]?.proj_oano ?? "",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 6,
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
                                                builder: (BuildContext
                                                        context) =>
                                                    ViewHotelRequest(
                                                        trlm[index].hotel_id,
                                                        trlm[index]
                                                            .hotel_ref_no)));
                                      },
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      color: Colors.white,
                    ));
              },
            ),
          ),
          CollapsingNavigationDrawer("8"),
        ],
      ),
    );
  }

  getHotelData() async {
    var response = await dio.post(ServicesApi.getData,
        data: {"parameter1": "getHotelRequests"},
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        trlm = (json.decode(response.data) as List)
            .map((f) => HotelRequestModel.fromJson(f))
            .toList();
      });
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }

  String checkHotelRequestStatus(int tra_status) {
    if (tra_status == 1) {
      return "Pending";
    } else {
      return "";
    }
  }
}
