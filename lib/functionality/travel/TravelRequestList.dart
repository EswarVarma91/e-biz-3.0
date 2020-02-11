import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Ebiz/commonDrawer/CollapsingNavigationDrawer.dart';
import 'package:Ebiz/functionality/travel/ViewTravelRequest.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:Ebiz/functionality/travel/AddTravelRequest.dart';
import 'package:Ebiz/main.dart';
import 'package:Ebiz/model/TravelRequestListModel.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TravelRequestList extends StatefulWidget {
  @override
  _TravelRequestListState createState() => _TravelRequestListState();
}

class _TravelRequestListState extends State<TravelRequestList> {
  static Dio dio = Dio(Config.options);
  List<TravelRequestListModel> trlm = List();
  List<TravelRequestListModel> trlmList = List();
  bool pending, approved, cancel;
  ProgressDialog pr;
  bool offlineA;
  String pendingCount = "-",
      approvedCount = "-",
      cancelledCount = "-",
      uidd,
      profilename;
  StreamSubscription<ConnectivityResult> streamSubscription;
  Connectivity connectivity;

  getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      profilename = preferences.getString("profileName");
      uidd = preferences.getString("userId");
    });
    getTravelData(uidd);
    connectivity = Connectivity();
    streamSubscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult event) {
      if (event != ConnectivityResult.none) {
        getTravelData(uidd);
      } else {
        offlineA = true;
        Fluttertoast.showToast(msg: "Offline");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
    pending = true;
    approved = false;
    cancel = false;
    offlineA = false;
    // checkServices();
  }

  checkServices() {
    trlmList.clear();
    if (pending == true) {
      setState(() {
        trlmList = trlm
            .where((item) =>
                item.approved_status != 1 && item.tra_is_cancel_req != 1)
            .toList();
      });
    } else if (approved == true) {
      setState(() {
        trlmList = trlm
            .where((item) =>
                item.approved_status == 1 && item.tra_is_cancel_req == 0)
            .toList();
      });
    } else if (cancel == true) {
      setState(() {
        trlmList = trlm
            .where((item) =>
                item.tra_is_cancel_req == 1 && item.approved_status == 0)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Travel Requests',
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
          RefreshIndicator(
            child: Container(
              margin: EdgeInsets.only(left: 60, right: 5, top: 5),
              child: StaggeredGridView.count(
                crossAxisCount: 9,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: pendingTravel(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: approvedTravel(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: cancelledTravel(),
                  ),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(3, 85.0),
                  StaggeredTile.extent(3, 85.0),
                  StaggeredTile.extent(3, 85.0),
                ],
              ),
            ),
            onRefresh: () async {
              offlineA ? "" : getTravelData(uidd);
            },
          ),
          Container(
            margin: EdgeInsets.only(left: 0, right: 5, top: 90),
            child: ListView.builder(
              itemCount: trlmList?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    margin: EdgeInsets.only(left: 60, right: 5, top: 5),
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
                                      trlmList[index].reqNo,
                                      style: TextStyle(
                                          color: lwtColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                                // Text(
                                //   checkTravelRequestStatus(
                                //       trlmList[index].tra_status),
                                //   style: TextStyle(
                                //       color: Colors.amber,
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 10),
                                // ),
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
                                      trlmList[index].fullName,
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
                                      displayDateFormat(
                                          trlmList[index].journeyDate),
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
                                      "From (Source)",
                                      style: TextStyle(
                                          fontSize: 7, color: Colors.black),
                                    ),
                                    Text(
                                      trlmList[index]
                                              .tra_from?.split("-")[0]??"",
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
                                      trlmList[index].tra_to?.split("-")[0]??"",
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
                                          trlmList[index]
                                                  .tra_purpose[0]
                                                  .toUpperCase() +
                                              trlmList[index]
                                                  .tra_purpose
                                                  .substring(1),
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        )),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      "OA/Complaint Ticket No.",
                                      style: TextStyle(
                                          fontSize: 7, color: Colors.black),
                                    ),
                                    Container(
                                        width: 180,
                                        child: Text(
                                          trlmList[index].proj_oano,
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
                                offlineA
                                    ? Container()
                                    : pending
                                        ? SizedBox(
                                            height: 30,
                                            width: 70,
                                            child: Material(
                                              elevation: 2.0,
                                              shadowColor: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: lwtColor,
                                              child: MaterialButton(
                                                height: 22.0,
                                                padding: EdgeInsets.all(3),
                                                child: Text(
                                                  "View",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              ViewTravelRequest(
                                                                  trlmList[
                                                                          index]
                                                                      .tra_id,
                                                                  trlmList[
                                                                          index]
                                                                      .reqNo)));
                                                },
                                              ),
                                            ),
                                          )
                                        : Container(),
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

  Material pendingTravel() {
    return Material(
      color: pending ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: pending ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            pending = !pending;
            checkServices();
            if (approved == true) {
              approved = false;
              checkServices();
            } else if (cancel == true) {
              cancel = false;
              checkServices();
            } else if (pending == false) {
              pending = true;
              checkServices();
            }
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "Pending".toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.0,
                          fontFamily: "Roboto",
                          color: pending ? Colors.white : lwtColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        pendingCount,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontFamily: "Roboto",
                          color: pending ? Colors.white : lwtColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Material approvedTravel() {
    return Material(
      color: approved ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: approved ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          approved = !approved;
          checkServices();
          if (pending == true) {
            pending = false;
            checkServices();
          } else if (cancel == true) {
            cancel = false;
            checkServices();
          } else if (approved == false) {
            approved = true;
            checkServices();
          }
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "Approved".toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.0,
                          fontFamily: "Roboto",
                          color: approved ? Colors.white : lwtColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        approvedCount,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontFamily: "Roboto",
                          color: approved ? Colors.white : lwtColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Material cancelledTravel() {
    return Material(
      color: cancel ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: cancel ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          cancel = !cancel;
          checkServices();
          if (approved == true) {
            approved = false;
            checkServices();
          } else if (pending == true) {
            pending = false;
            checkServices();
          } else if (cancel == false) {
            cancel = true;
            checkServices();
          }
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "Cancelled".toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.0,
                          fontFamily: "Roboto",
                          color: cancel ? Colors.white : lwtColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        cancelledCount,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontFamily: "Roboto",
                          color: cancel ? Colors.white : lwtColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  displayDateFormat(String elFromDate) {
    List<String> a = elFromDate.split("-");
    return a[2] + "-" + a[1] + "-" + a[0];
  }

  getTravelData(String uidd) async {
    var response = await dio.post(ServicesApi.getData,
        data: {
          "encryptedFields": ["string"],
          "parameter1": "GetAllTravelRequests",
          "parameter2": uidd
        },
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        trlm = (json.decode(response.data) as List)
            .map((f) => TravelRequestListModel.fromJson(f))
            .toList();
      });
      checkandfilterList(trlm);
      checkServices();
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

  checkandfilterList(List<TravelRequestListModel> trlm) {
    setState(() {
      pendingCount = trlm
          .where((item) =>
              item.approved_status != 1 && item.tra_is_cancel_req != 1)
          .length
          .toString();
      approvedCount = trlm
          .where((item) =>
              item.approved_status == 1 && item.tra_is_cancel_req == 0)
          .length
          .toString();
      cancelledCount = trlm
          .where((item) =>
              item.tra_is_cancel_req == 1 && item.approved_status == 0)
          .length
          .toString();
    });
  }
}
