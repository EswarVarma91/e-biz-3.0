import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:Ebiz/functionality/travel/EditTravelRequest.dart';
import 'package:Ebiz/functionality/travel/TravelRequestList.dart';
import 'package:Ebiz/main.dart';
import 'package:Ebiz/model/TravelHistoryModel.dart';
import 'package:Ebiz/model/TravelRequestByTId.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String reqNo, profilename, fullname;
  bool _editEnable = true;
  _ViewTravelRequestState(this.tra_id, this.reqNo);
  Dio dio = Dio(Config.options);
  List<TravelRequestByTId> trbtid = List();
  List<TravelHistoryModel> trh = List();
  ProgressDialog pr;

  getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    profilename = preferences.getString("profileName");
    fullname = preferences.getString("fullname");
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
    getDataTravelrequestbytId(tra_id);
    getDataTravelrequestHistorybytId(tra_id);
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
                                  EditTravelRequest(
                                      trbtid[0], tra_id.toString())));

                      ///Edit Request only Journey Date.
                      // Fluttertoast.showToast(msg: "Coming Soon.!");
                    },
                  )
                : Container(),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                alertTravelDialog(tra_id);
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              child: Expanded(
                child: ListView.builder(
                  itemCount: trbtid?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(left: 2, right: 2, top: 2),
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(6),
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
                                        trbtid[index]?.fullName ?? "",
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
                                        "Date",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Text(
                                        trbtid[index]?.tra_journey_date ?? "",
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
                                        "From (Source)",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Text(
                                        trbtid[index]?.tra_from ?? "",
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
                                        "To (Destination)",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Text(
                                        trbtid[index]?.tra_to ?? "",
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
                                            trbtid[index]?.tra_purpose ?? "",
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
                                        "Mode",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Text(
                                        trbtid[index]?.tra_mode ?? "",
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
                                            trbtid[index]?.proj_oano ?? "",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "Model Type",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Text(
                                        trbtid[index]?.tra_mode_type ?? "",
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
                                            trbtid[index]?.tra_created_by ?? "",
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
                                        trbtid[index].tra_class,
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
                                        "Required Arrival Date & Time",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Container(
                                          width: 180,
                                          child: Text(
                                            trbtid[index]?.tra_required_datetime ??
                                                "",
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
                                        trbtid[index].u_grade,
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
                                        "Approval By",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Container(
                                          width: 180,
                                          child: Text(
                                            trbtid[index]?.approved_by ?? "",
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
                                        "Cancelled By",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Text(
                                        trbtid[index]?.tra_cancelled_by ?? "",
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
                                            trbtid[index]
                                                    ?.tra_cancelled_charges
                                                    .toString() ??
                                                "",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "Cancelled Payment Mode",
                                        style: TextStyle(
                                            fontSize: 7, color: Colors.black),
                                      ),
                                      Text(
                                        trbtid[index]
                                                ?.tra_cancelled_payment_mode ??
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
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Text("Booking History",
                style: TextStyle(
                    color: lwtColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            Container(
              child: Expanded(
                child: ListView.builder(
                  itemCount: trh?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return ExpansionTile(
                      title: Text(trh[index].tckVersion),
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
                                              trh[index]?.fullName ?? "",
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
                                              "Date",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              trh[index]?.tra_journey_date ??
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
                                              "From (Source)",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              trh[index]?.tra_from ?? "",
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
                                              "To (Destination)",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              trh[index]?.tra_to ?? "",
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
                                                  trh[index]?.tra_purpose ?? "",
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
                                              "Mode",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              trh[index]?.tra_mode ?? "",
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
                                                  trh[index]?.proj_oano ?? "",
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
                                              "Model Type",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              trh[index]?.tra_mode_type ?? "",
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
                                              "Class",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              trh[index].tra_class,
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
                                              trh[index].u_grade,
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
                                              "Required Arrival Date & Time",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                width: 180,
                                                child: Text(
                                                  trh[index]
                                                          ?.tra_required_datetime ??
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
                                              "Ticket Quota",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                child: Text(
                                              trh[index]?.tra_tck_quota ?? "",
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
                                              "Travel Flight/Train/Bus-Info",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                width: 180,
                                                child: Text(
                                                  trh[index]?.tra_tck_info ??
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
                                              "Seat No",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                child: Text(
                                              trh[index]?.tra_tck_seat_no ?? "",
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
                                              "Trave Ticket PNR No.",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                width: 180,
                                                child: Text(
                                                  trh[index]?.tra_tck_pnr ?? "",
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
                                              "Travel Ticket Cost",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                child: Text(
                                              trh[index]
                                                      ?.tra_tck_cost
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
                                                  trh[index]
                                                          ?.tra_tck_payment_mode
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
                                              "Travel Ticket Other Charges",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                child: Text(
                                              trh[index]
                                                      ?.tra_tck_other_charges
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
                                              "Payment Source",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                width: 180,
                                                child: Text(
                                                  trh[index]
                                                          ?.tra_tck_card_no
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
                                              trh[index]
                                                      ?.tra_tck_tax
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
                                              "Booking Status",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black),
                                            ),
                                            Container(
                                                width: 180,
                                                child: Text(
                                                  trh[index]
                                                          ?.tra_tck_booking_status ??
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
                                              trh[index]
                                                      ?.tra_tck_total
                                                      .toString() ??
                                                  "",
                                              style: TextStyle(
                                                  color: lwtColor,
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

      void alertTravelDialog(int t_id) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Do you want to Cancel.?'),
            actions: <Widget>[
              CupertinoButton(
                onPressed: () {
                  cancelRequest(t_id);
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

  void getDataTravelrequestbytId(int tra_id) async {
    Response response = await dio.post(ServicesApi.getData,
        data: {"encryptedFields": ["string"],"parameter1": "GetTravelRequestById", "parameter2": tra_id},
        );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // print(response.data);
      setState(() {
        trbtid = (json.decode(response.data) as List)
            .map((f) => TravelRequestByTId.fromJson(f))
            .toList();
      });
      if (trbtid[0].approved_status == 1) {
        _editEnable = false;
      } else {
        _editEnable = true;
      }
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }

  void getDataTravelrequestHistorybytId(int tra_id) async {
    Response response = await dio.post(ServicesApi.getData,
        data: {
          "encryptedFields": ["string"],
          "parameter1": "GetTicketHistoryByRequestId",
          "parameter2": tra_id
        },
        );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // print(response.data);
      setState(() {
        trh = (json.decode(response.data) as List)
            .map((f) => TravelHistoryModel.fromJson(f))
            .toList();
      });
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }

  void cancelRequest(int tra_id) async {
    pr.show();
    var response = await dio.post(ServicesApi.canceltravelRequest,
        data: {
          "traCancelReqBy": profilename,
          "traCancelReqRemarks": "",
          "traId": tra_id
        },);
    if (response.statusCode == 200 || response.statusCode == 201) {
      getUseridBytraId(tra_id);
    } else if (response.statusCode == 401) {
      pr.hide();
      throw Exception("Incorrect data");
    }else if(response.statusCode==500){
      pr.hide();
    }
  }

  void getUseridBytraId(int tra_id) async {
    var response = await dio.post(ServicesApi.getData,
        data: {"encryptedFields": ["string"],"parameter1": "getTokenbytraId", "parameter2": tra_id},
        );
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data != "null" || response.data != null) {
        var req_no = json.decode(response.data)[0]['tra_req_no'];
        var token = json.decode(response.data)[0]['token'];
        if (token != null || token != "null") {
          pushNotification(req_no, token);
        } else {
          pr.hide();
          Fluttertoast.showToast(msg: "Travel Request Cancelled.");
          var navigator = Navigator.of(context);
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => TravelRequestList()),
            ModalRoute.withName('/'),
          );
        }
      } else {
        pr.hide();
        Fluttertoast.showToast(msg: "Travel Request Cancelled.");
        var navigator = Navigator.of(context);
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => TravelRequestList()),
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
      'title': 'Travel Request',
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
    Fluttertoast.showToast(msg: "Travel Request Cancelled.");
    var navigator = Navigator.of(context);
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => TravelRequestList()),
      ModalRoute.withName('/'),
    );
  }
}
