import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:eaglebiz/functionality/hotel/EditHotelRequest.dart';
import 'package:eaglebiz/functionality/hotel/HotelRequestList.dart';
import 'package:eaglebiz/functionality/travel/TravelRequestList.dart';
import 'package:eaglebiz/main.dart';
import 'package:eaglebiz/model/HotelHistoryModel.dart';
import 'package:eaglebiz/model/HotelRequestByTId.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewHotelRequest extends StatefulWidget {
  int hotel_id;
  String reqNo;
  ViewHotelRequest(this.hotel_id, this.reqNo);

  @override
  _ViewHotelRequestState createState() =>
      _ViewHotelRequestState(hotel_id, reqNo);
}

class _ViewHotelRequestState extends State<ViewHotelRequest> {
  int hotel_id;
  String reqNo, profilename, fullname;
  bool _editEnable = true;
  _ViewHotelRequestState(this.hotel_id, this.reqNo);
  Dio dio = Dio(Config.options);
  List<HotelRequestByTId> hrbtid;
  List<HotelHistoryModel> hrbtidh;

  getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    profilename = preferences.getString("profileName");
    fullname = preferences.getString("fullname");
  }

  @override
  void initState() {
    super.initState();
    getDataHotelrequestbytId(hotel_id);
    getUserDetails();
    getDataHotelrequestHistorybytId(hotel_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            reqNo,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            _editEnable
                ? IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  EditHotelRequest(
                                      hrbtid[0], hotel_id.toString())));
                    },
                  )
                : Container(),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                ///Delete Request
                cancelRequest(hotel_id);
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              child: Expanded(
                child: ListView.builder(
                  itemCount: hrbtid?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(left: 5, right: 5, top: 6),
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Traveller Name",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Text(
                                        hrbtid[index]?.travellerName ?? "-",
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
                                        hrbtid[index]?.hotel_his_location ??
                                            "-",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Check in",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Text(
                                        hrbtid[index]?.hotel_his_check_in ??
                                            "-",
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
                                        "Check out",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Text(
                                        hrbtid[index]?.hotel_his_check_out ??
                                            "-",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            hrbtid[index]?.hotel_his_purpose ??
                                                "-",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          )),
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
                                        hrbtid[index]
                                                ?.hotel_his_rating
                                                .toString() ??
                                            "-",
                                        style: TextStyle(
                                            color: lwtColor,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Text(
                                        "Complaint No.",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Container(
                                          width: 180,
                                          child: Text(
                                            hrbtid[index]?.proj_oano ?? "-",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "Hotel Name",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Text(
                                        hrbtid[index]?.hotel_his_name ?? "-",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Text(
                                        "Created By",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Container(
                                          width: 180,
                                          child: Text(
                                            hrbtid[index]?.hotel_created_by ??
                                                "-",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "Class",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Text(
                                        hrbtid[index]?.hotel_his_address ?? "-",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Text(
                                        "Payment Source",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Container(
                                          width: 180,
                                          child: Text(
                                            hrbtid[index]
                                                    ?.hotel_cancelled_source ??
                                                "-",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "Traveller Grade",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Text(
                                        hrbtid[index]?.u_grade ?? "-",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Text(
                                        "Cancelled By",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Container(
                                          width: 180,
                                          child: Text(
                                            hrbtid[index]?.hotel_cancelled_by ??
                                                "-",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "Payment Mode",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Text(
                                        hrbtid[index]
                                                ?.hotel_cancelled_payment_mode ??
                                            "-",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Text(
                                        "Cancelled Charges",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Container(
                                          width: 180,
                                          child: Text(
                                            hrbtid[index]
                                                    ?.hotel_cancelled_charges
                                                    .toString() ??
                                                "-",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "Approved by",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Text(
                                        hrbtid[index]?.approved_by ?? "-",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              child: Expanded(
                child: ListView.builder(
                  itemCount: hrbtidh?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return ExpansionTile(
                      title: Text(hrbtidh[index].hotelVersion),
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Card(
                                child: Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Traveller Name",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              hrbtidh[index]?.travellerName ??
                                                  "",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              "Location",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              hrbtidh[index]
                                                      ?.hotel_his_location ??
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Check In",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              hrbtidh[index]
                                                      ?.hotel_his_check_in ??
                                                  "",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              "Check Out",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              hrbtidh[index]
                                                      ?.hotel_his_check_out ??
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Text(
                                              "Purpose.",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                width: 180,
                                                child: Text(
                                                  hrbtidh[index]
                                                          ?.hotel_his_purpose ??
                                                      "",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                )),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              "Hotel Name",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              hrbtidh[index]?.hotel_his_name ??
                                                  "",
                                              style: TextStyle(
                                                  color: lwtColor,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Text(
                                              "Complaint No.",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                width: 180,
                                                child: Text(
                                                  hrbtidh[index]?.proj_oano ??
                                                      "",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                )),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              "Hotel Rating",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              hrbtidh[index]
                                                      ?.hotel_his_rating
                                                      .toString() ??
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Hotel Address",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              hrbtidh[index].hotel_his_address,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              "Travel Grade",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              hrbtidh[index].u_grade,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Text(
                                              "Hotel Basic Cost",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                width: 180,
                                                child: Text(
                                                  hrbtidh[index]
                                                          ?.hotel_his_basic_cost
                                                          .toString() ??
                                                      "",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                )),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Text(
                                              "Tax",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                child: Text(
                                              hrbtidh[index]
                                                      ?.hotel_his_tax
                                                      .toString() ??
                                                  "",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            )),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Text(
                                              "Other Charges",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                width: 180,
                                                child: Text(
                                                  hrbtidh[index]
                                                          ?.hotel_his_charges
                                                          .toString() ??
                                                      "",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                )),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Text(
                                              "Total Cost",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                child: Text(
                                              hrbtidh[index]
                                                      ?.hotel_his_total_cost
                                                      .toString() ??
                                                  "",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            )),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Text(
                                              "Payment Mode",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                width: 180,
                                                child: Text(
                                                  hrbtidh[index]
                                                          ?.hotel_his_payment_mode ??
                                                      "",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                )),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Text(
                                              "Payment Source",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                child: Text(
                                              hrbtidh[index]
                                                      ?.hotel_his_payment_source ??
                                                  "",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ]),
                            ))
                          ],
                        )
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }

  getDataHotelrequestbytId(int hotel_id) async {
    Response response = await dio.post(ServicesApi.getData,
        data: {"parameter1": "getHotelRequestsbyId", "parameter2": hotel_id},
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));
    if (response.statusCode == 200 || response.statusCode == 201) {
      // print(response.data);
      setState(() {
        hrbtid = (json.decode(response.data) as List)
            .map((f) => HotelRequestByTId.fromJson(f))
            .toList();
      });
      if (hrbtid[0].approved_status == 1) {
        _editEnable = false;
      } else {
        _editEnable = true;
      }
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }

  getDataHotelrequestHistorybytId(int hotel_id) async {
    var response = await dio.post(ServicesApi.getData,
        data: {
          "parameter1": "getHotelRequestHistorybyId",
          "parameter2": hotel_id
        },
        options: Options(
          contentType: ContentType.parse("application/json"),
        ));
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        hrbtidh = (json.decode(response.data) as List)
            .map((f) => HotelHistoryModel.fromJson(f))
            .toList();
      });
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }

  void cancelRequest(int hotel_id) async {
    var response = await dio.post(ServicesApi.updateData,
        data: {
          "parameter1": "cancelHotelRequestStatus",
          "parameter2": hotel_id,
          "parameter3": profilename
        },
        options: Options(
          contentType: ContentType.parse("application/json"),
        ));
    if (response.statusCode == 200 || response.statusCode == 201) {
      // var navigator = Navigator.of(context);
      // navigator.pushAndRemoveUntil(
      //   MaterialPageRoute(
      //       builder: (BuildContext context) => HotelRequestList()),
      //   ModalRoute.withName('/'),
      // );
      getUseridByhotelId(hotel_id.toString());
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }

  void getUseridByhotelId(String hotel_id) async {
    var response = await dio.post(ServicesApi.getData,
        data: {"parameter1": "getTokenbyHotelId", "parameter2": hotel_id},
        options: Options(contentType: ContentType.parse("application/json")));

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data != "null" || response.data != null) {
        var req_no = json.decode(response.data)[0]['hotel_req_no'];
        var token = json.decode(response.data)[0]['token'];
        if (token != null || token != "null") {
          pushNotification(req_no, token);
        } else {
          Fluttertoast.showToast(msg: "Hotel Update Request Generated.");
          var navigator = Navigator.of(context);
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => HotelRequestList()),
            ModalRoute.withName('/'),
          );
        }
      } else {
        Fluttertoast.showToast(msg: "Hotel Update Request Generated.");
        var navigator = Navigator.of(context);
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => HotelRequestList()),
          ModalRoute.withName('/'),
        );
      }
    } else if (response.statusCode == 401) {
      throw (Exception);
    }
  }

  void pushNotification(String reqNo, String to) async {
    Map<String, dynamic> notification = {
      'body': "Hotel request " + reqNo + " has been cancelled by " + fullname,
      'title': 'Hotel Request',
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
    Fluttertoast.showToast(msg: "Hotel Request Cancelled.");
    var navigator = Navigator.of(context);
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => HotelRequestList()),
      ModalRoute.withName('/'),
    );
  }
}
