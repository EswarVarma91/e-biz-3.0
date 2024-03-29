import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:Ebiz/functionality/hotel/EditHotelRequest.dart';
import 'package:Ebiz/functionality/hotel/HotelRequestList.dart';
import 'package:Ebiz/main.dart';
import 'package:Ebiz/model/HotelHistoryModel.dart';
import 'package:Ebiz/model/HotelRequestByTId.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
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
  ProgressDialog pr;

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
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
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
                alertHotelDialog(hotel_id);
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
                                            color: lwtColor,
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
                                        "OA/Complaint Ticket No.",
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
                                        "Created By",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Text(
                                        hrbtid[index]?.hotel_created_by ?? "-",
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
                                              displayDateFormat(hrbtidh[index]
                                                      ?.hotel_his_check_in) ??
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
                                              displayDateFormat(hrbtidh[index]
                                                      ?.hotel_his_check_out) ??
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
        data: {"encryptedFields": ["string"],"parameter1": "getHotelRequestsbyId", "parameter2": hotel_id},
        );
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
          "encryptedFields": ["string"],
          "parameter1": "getHotelRequestHistorybyId",
          "parameter2": hotel_id
        },
        );
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
    pr.show();
    var response = await dio.post(ServicesApi.cancelhotelRequest,
        data: {
          "hotelCancelReqRemarks": "",
          "hotelId": hotel_id,
          "hotelCancelReqBy": profilename
        },
        );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // var navigator = Navigator.of(context);
      // navigator.pushAndRemoveUntil(
      //   MaterialPageRoute(
      //       builder: (BuildContext context) => HotelRequestList()),
      //   ModalRoute.withName('/'),
      // );
      getUseridByhotelId(hotel_id);
    } else if (response.statusCode == 401) {
      pr.hide();
      throw Exception("Incorrect data");
    }else if(response.statusCode==500){
      pr.hide();
    }
  }


  displayDateFormat(String elFromDate) {
    List<String> a = elFromDate.split("-");
    return a[2] + "-" + a[1] + "-" + a[0];
  }
  

  void getUseridByhotelId(int hotel_id) async {
    var response = await dio.post(ServicesApi.getData,
        data: {"encryptedFields": ["string"],
          "parameter1": "getTokenbyHotelId", "parameter2": hotel_id},
        );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data != "null" || response.data != null) {
        var req_no = json.decode(response.data)[0]['hotel_ref_no'];
        var token = json.decode(response.data)[0]['token'];
        if (token != null ) {
          pushNotification(req_no, token);
        } else {
          pr.hide();
          Fluttertoast.showToast(msg: "Hotel Update Request Generated.");
          var navigator = Navigator.of(context);
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => HotelRequestList()),
            ModalRoute.withName('/'),
          );
        }
      } else {
        pr.hide();
        Fluttertoast.showToast(msg: "Hotel Update Request Generated.");
        var navigator = Navigator.of(context);
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => HotelRequestList()),
          ModalRoute.withName('/'),
        );
      }
    } else if (response.statusCode == 401) {
      pr.hide();
      throw (Exception);
    }else if(response.statusCode==500){
      pr.hide();
    }
  }

  void pushNotification(String reqNo, String to) async {
    Map<String, dynamic> notification = {
      'body': "This Request No: " + reqNo + " has been cancelled by " + fullname,
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
    pr.hide();
    pr.dismiss();
    Fluttertoast.showToast(msg: "Hotel Request Cancelled.");
    var navigator = Navigator.of(context);
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => HotelRequestList()),
      ModalRoute.withName('/'),
    );
  }

  void alertHotelDialog(int hid) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Do you want to Cancel.?'),
            actions: <Widget>[
              CupertinoButton(
                onPressed: () {
                  cancelRequest(hid);
                },
                child: Text('Yes'),
              ),
              CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No'),
              ),
            ],
          );
        });
  }
}
