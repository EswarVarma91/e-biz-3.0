import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eaglebiz/main.dart';
import 'package:eaglebiz/model/TravelHistoryModel.dart';
import 'package:eaglebiz/model/TravelRequestByTId.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  Dio dio = Dio(Config.options);
  List<TravelRequestByTId> trbtid = List();
  List<TravelHistoryModel> trh = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataTravelrequestbytId(tra_id);
    getDataTravelrequestHistorybytId(tra_id);
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
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                Fluttertoast.showToast(msg: "Coming Soon.!");
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                Fluttertoast.showToast(msg: "Coming Soon.!");
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
                                        trbtid[index]?.fullName ?? "",
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
                                        "Complaint No..",
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
                                    height: 10,
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
                                            trbtid[index]
                                                    ?.tra_required_datetime ??
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
                                    height: 10,
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

  void getDataTravelrequestbytId(int tra_id) async {
    Response response = await dio.post(ServicesApi.getData,
        data: {"parameter1": "GetTravelRequestById", "parameter2": tra_id},
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));
    if (response.statusCode == 200 || response.statusCode == 201) {
      // print(response.data);
      setState(() {
        trbtid = (json.decode(response.data) as List)
            .map((f) => TravelRequestByTId.fromJson(f))
            .toList();
      });
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }

  void getDataTravelrequestHistorybytId(int tra_id) async {
    Response response = await dio.post(ServicesApi.getData,
        data: {
          "parameter1": "GetTicketHistoryByRequestId",
          "parameter2": tra_id
        },
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));
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
}
