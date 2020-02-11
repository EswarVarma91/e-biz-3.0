import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:Ebiz/commonDrawer/CollapsingNavigationDrawer.dart';
import 'package:Ebiz/main.dart';
import 'package:Ebiz/model/FirebaseUserModel.dart';
import 'package:Ebiz/model/HotelRequestModel.dart';
import 'package:Ebiz/model/LateEarlyComingModel.dart';
import 'package:Ebiz/model/LeavesModel.dart';
import 'package:Ebiz/model/PermissionModel.dart';
import 'package:Ebiz/model/TravelRequestListModel.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Approvals extends StatefulWidget {
  @override
  _ApprovalsState createState() => _ApprovalsState();
}

Future<String> getUserID() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String id = preferences.getString("userId");
  return id;
}

class _ApprovalsState extends State<Approvals> {
  String uidd,
      profilename,
      leavesCount = "-",
      permissionsCount = "-",
      travelCount = "-",
      hotelCount = "-",
      fullname;
  bool _leavesA, _permissionsA, _travelrequestA, _hotelrequestA;
  static var now = DateTime.now();
  static Dio dio = Dio(Config.options);
  List<LeavesModel> leaveList = List();
  List<PermissionModel> permissionsList = List();
  List<HotelRequestModel> hrlm = List();
  List<LateEarlyComingModel> datacheck = List();
  List<TravelRequestListModel> trlm = List();
  List<FirebaseUserModel> fum;
  ProgressDialog pr;

  getFullName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      fullname = preferences.getString("fullname");
      profilename = preferences.getString("profileName");
    });
  }

  @override
  void initState() {
    super.initState();
    _leavesA = true;
    _permissionsA = false;
    _travelrequestA = false;
    _hotelrequestA = false;
    getFullName();
    getUserID().then((val) => setState(() {
          uidd = val;
          getPendingApprovals();
        }));
  }

  checkServices() {
    setState(() {
      leavesCount = leaveList.length?.toString() ?? "0";
      permissionsCount = permissionsList.length?.toString() ?? "0";
      travelCount = trlm.length?.toString() ?? "0";
      hotelCount = hrlm.length?.toString() ?? "0";
    });
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Approvals",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
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
                crossAxisCount: 8,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: leaveMaterial(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: permissionMaterial(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: travelMaterial(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: hotelMaterial(),
                  ),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(4, 75.0),
                  StaggeredTile.extent(4, 75.0),
                  StaggeredTile.extent(4, 75.0),
                  StaggeredTile.extent(4, 75.0),
                ],
              ),
            ),
            onRefresh: () async {
              getPendingApprovals();
            },
          ),
          _leavesA
              ? Container(
                  margin: EdgeInsets.only(left: 60, right: 2, top: 180),
                  child: leavesAListView(),
                )
              : Container(),
          _permissionsA
              ? Container(
                  margin: EdgeInsets.only(left: 60, right: 2, top: 180),
                  child: permissionsAListView(),
                )
              : Container(),
          _travelrequestA
              ? Container(
                  margin: EdgeInsets.only(left: 60, right: 2, top: 180),
                  child: travelAListView(),
                )
              : Container(),
          _hotelrequestA
              ? Container(
                  margin: EdgeInsets.only(left: 60, right: 2, top: 180),
                  child: hotelAListView(),
                )
              : Container(),
          CollapsingNavigationDrawer("5"),
          //ListView.builder(itemBuilder: null)
        ],
      ),
    );
  }

  Material leaveMaterial() {
    return Material(
      color: _leavesA ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: _leavesA ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            _leavesA = !_leavesA;
            checkServices();
            if (_permissionsA == true) {
              _permissionsA = !_permissionsA;
              checkServices();
            } else if (_travelrequestA == true) {
              _travelrequestA = !_travelrequestA;
              checkServices();
            } else if (_hotelrequestA == true) {
              _hotelrequestA = !_hotelrequestA;
              checkServices();
            } else if (_leavesA == false) {
              _permissionsA = !_permissionsA;
              checkServices();
            }
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "Leaves",
                        style: TextStyle(
                          fontSize: 15.0, fontFamily: "Roboto",
                          color: _leavesA ? Colors.white : lwtColor,
                          //Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        leavesCount,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "Roboto",
                            color: _leavesA ? Colors.white : lwtColor),
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

  Material permissionMaterial() {
    return Material(
      color: _permissionsA ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: _permissionsA ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            _permissionsA = !_permissionsA;
            checkServices();
            if (_leavesA == true) {
              _leavesA = !_leavesA;
              checkServices();
            } else if (_travelrequestA == true) {
              _travelrequestA = !_travelrequestA;
              checkServices();
            } else if (_hotelrequestA == true) {
              _hotelrequestA = !_hotelrequestA;
              checkServices();
            } else if (_permissionsA == false) {
              _travelrequestA = !_travelrequestA;
              checkServices();
            }
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "Permissions",
                        style: TextStyle(
                          fontSize: 15.0, fontFamily: "Roboto",
                          color: _permissionsA ? Colors.white : lwtColor,
                          //Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        permissionsCount,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "Roboto",
                            color: _permissionsA ? Colors.white : lwtColor),
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

  Material travelMaterial() {
    return Material(
      color: _travelrequestA ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: _travelrequestA ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            _travelrequestA = !_travelrequestA;
            checkServices();
            if (_leavesA == true) {
              _leavesA = !_leavesA;
              checkServices();
            } else if (_permissionsA == true) {
              _permissionsA = !_permissionsA;
              checkServices();
            } else if (_hotelrequestA == true) {
              _hotelrequestA = !_hotelrequestA;
              checkServices();
            } else if (_travelrequestA == false) {
              _hotelrequestA = !_hotelrequestA;
              checkServices();
            }
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "Travel",
                        style: TextStyle(
                          fontSize: 15.0, fontFamily: "Roboto",
                          color: _travelrequestA ? Colors.white : lwtColor,
                          //Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        travelCount,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "Roboto",
                            color: _travelrequestA ? Colors.white : lwtColor),
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

  Material hotelMaterial() {
    return Material(
      color: _hotelrequestA ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: _hotelrequestA ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            _hotelrequestA = !_hotelrequestA;
            checkServices();
            if (_leavesA == true) {
              _leavesA = !_leavesA;
              checkServices();
            } else if (_travelrequestA == true) {
              _travelrequestA = !_travelrequestA;
              checkServices();
            } else if (_permissionsA == true) {
              _permissionsA = !_permissionsA;
              checkServices();
            } else if (_hotelrequestA == false) {
              _leavesA = !_leavesA;
              checkServices();
            }
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "Hotel",
                        style: TextStyle(
                          fontSize: 15.0, fontFamily: "Roboto",
                          color: _hotelrequestA ? Colors.white : lwtColor,
                          //Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        hotelCount,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "Roboto",
                            color: _hotelrequestA ? Colors.white : lwtColor),
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

  leavesAListView() {
    return ListView.builder(
        itemCount: leaveList == null ? 0 : leaveList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 5.0,
            child: ListTile(
              subtitle: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 2),
                          child: Text(
                            leaveList[index]?.fullname ?? 'NA',
                            style: TextStyle(
                                color: lwtColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "From Date         :     ",
                                style: TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                              ),
                              Text(
                                displayDateFormat(
                                        leaveList[index]?.el_from_date) ??
                                    'NA',
                                style: TextStyle(
                                    color: lwtColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "To Date              :     ",
                                style: TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                              ),
                              Text(
                                displayDateFormat(
                                        leaveList[index]?.el_to_date) ??
                                    'NA',
                                style: TextStyle(
                                    color: lwtColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "No of Days        :     ",
                                style: TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                              ),
                              Text(
                                checkNoDays(leaveList[index]
                                                ?.el_noofdays
                                                .toString())
                                            .toString() +
                                        // leaveList[index]?.el_noofdays.toString().split(".")[0] +
                                        " Days" ??
                                    "NA.",
                                style: TextStyle(
                                    color: lwtColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Reason              :     ",
                                style: TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                              ),
                              Expanded(
                                child: Text(
                                  leaveList[index]?.el_reason ?? '',
                                  style: TextStyle(
                                      color: lwtColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Leave Type        :     ",
                                style: TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                              ),
                              Expanded(
                                child: Text(
                                  leaveList[index]?.leave_type ?? '',
                                  style: TextStyle(
                                      color: lwtColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Request Date    :     ",
                                style: TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                              ),
                              Expanded(
                                child: Text(
                                  leaveList[index]
                                          ?.el_created_date
                                          .toString() ??
                                      '',
                                  style: TextStyle(
                                      color: lwtColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              trailing: Container(
                padding: EdgeInsets.only(top: 22),
                child: IconButton(
                  icon: Icon(Icons.check_circle, size: 40, color: lwtColor),
                  onPressed: () {
                    alertleavesCheck(leaveList[index]);
                  },
                ),
              ),
            ),
          );
        });
  }

  permissionsAListView() {
    return ListView.builder(
        itemCount: permissionsList == null ? 0 : permissionsList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 5.0,
            child: ListTile(
              subtitle: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 2),
                          child: Text(
                            permissionsList[index]?.per_fullName ?? 'NA',
                            style: TextStyle(
                                color: lwtColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "Permission Date     :     ",
                                style: TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                              ),
                              Text(
                                displayDateFormat(
                                        permissionsList[index]?.per_date) ??
                                    'NA',
                                style: TextStyle(
                                    color: lwtColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Permission Type     :     ",
                                style: TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                              ),
                              Text(
                                permissionsList[index]
                                            ?.per_type[0]
                                            .toUpperCase() +
                                        permissionsList[index]
                                            .per_type
                                            .substring(1) ??
                                    'NA',
                                style: TextStyle(
                                    color: lwtColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "From Time               :     ",
                                style: TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                              ),
                              Text(
                                permissionsList[index]?.per_from_time ?? 'NA',
                                style: TextStyle(
                                    color: lwtColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "To Time                    :     ",
                                style: TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                              ),
                              Text(
                                permissionsList[index]?.per_to_time ?? 'NA',
                                style: TextStyle(
                                    color: lwtColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Reason                     :     ",
                                style: TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                              ),
                              Expanded(
                                child: Text(
                                  permissionsList[index]
                                              ?.per_purpose[0]
                                              .toUpperCase() +
                                          permissionsList[index]
                                              .per_purpose
                                              .substring(1) ??
                                      '',
                                  style: TextStyle(
                                      color: lwtColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              trailing: Container(
                padding: EdgeInsets.only(top: 20),
                child: IconButton(
                  icon: Icon(
                    Icons.check_circle,
                    size: 40,
                    color: lwtColor,
                  ),
                  onPressed: () {
                    alertpermissionCheck(permissionsList[index]);
                  },
                ),
              ),
            ),
          );
        });
  }

  travelAListView() {
    return Container(
      child: ListView.builder(
        itemCount: trlm?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return Container(
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
                            style: TextStyle(fontSize: 7, color: Colors.black),
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
                      // Text(
                      //   checkTravelRequestStatus(trlm[index].tra_status),
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
                            style: TextStyle(fontSize: 7, color: Colors.black),
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
                            style: TextStyle(fontSize: 7, color: Colors.black),
                          ),
                          Text(
                            displayDateFormat(trlm[index].journeyDate),
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
                            style: TextStyle(fontSize: 7, color: Colors.black),
                          ),
                          Text(
                            trlm[index].tra_from?.split("-")[0]??"",
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
                            style: TextStyle(fontSize: 7, color: Colors.black),
                          ),
                          Text(
                            trlm[index].tra_to?.split("-")[0]??"",
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
                            style: TextStyle(fontSize: 7, color: Colors.black),
                          ),
                          Container(
                              width: 180,
                              child: Text(
                                trlm[index].tra_purpose[0].toUpperCase() +
                                    trlm[index].tra_purpose.substring(1),
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
                            style: TextStyle(fontSize: 7, color: Colors.black),
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
                              "Approval",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              travelRequest(trlm[index]);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            color: Colors.white,
          ));
        },
      ),
    );
  }

  hotelAListView() {
    return Container(
      child: ListView.builder(
        itemCount: hrlm?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return Container(
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
                            style: TextStyle(fontSize: 7, color: Colors.black),
                          ),
                          Text(
                            hrlm[index]?.hotel_ref_no.toString() ?? "",
                            style: TextStyle(
                                color: lwtColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      // Text(
                      //   checkHotelRequestStatus(hrlm[index].hotel_status),
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
                            style: TextStyle(fontSize: 7, color: Colors.black),
                          ),
                          Text(
                            hrlm[index]?.travellerName ?? "",
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
                            style: TextStyle(fontSize: 7, color: Colors.black),
                          ),
                          Text(
                            hrlm[index]?.hotel_rating.toString() ?? "",
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
                            style: TextStyle(fontSize: 7, color: Colors.black),
                          ),
                          Text(
                            displayDateFormat(hrlm[index]?.hotel_check_in) ??
                                "",
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
                            style: TextStyle(fontSize: 7, color: Colors.black),
                          ),
                          Text(
                            displayDateFormat(hrlm[index]?.hotel_check_out) ??
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
                            "Purpose",
                            style: TextStyle(fontSize: 7, color: Colors.black),
                          ),
                          Text(
                            hrlm[index]?.hotel_purpose ?? "",
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
                            style: TextStyle(fontSize: 7, color: Colors.black),
                          ),
                          Text(
                            hrlm[index]?.hotel_location ?? "",
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
                            style: TextStyle(fontSize: 7, color: Colors.black),
                          ),
                          Text(
                            hrlm[index]?.proj_oano ?? "",
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
                              "Approval",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              hotelRequest(hrlm[index]);
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
    );
  }

  void travelRequest(TravelRequestListModel trlm) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Do you want to Approve.?'),
            actions: <Widget>[
              CupertinoButton(
                onPressed: () {
                  cancelTravelRequestServiceCall(trlm);
                },
                child: Text('Reject'),
              ),
              CupertinoButton(
                onPressed: () {
                  approveTravelRequestServiceCall(trlm);
                },
                child: Text('Approve'),
              ),
              CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Quit'),
              ),
            ],
          );
        });
  }

  hotelRequest(HotelRequestModel hrm) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Do you want to Approve.?'),
            actions: <Widget>[
              CupertinoButton(
                onPressed: () {
                  cancelHotelRequestServiceCall(hrm);
                },
                child: Text('Reject'),
              ),
              CupertinoButton(
                onPressed: () {
                  approveHotelRequestServiceCall(hrm);
                },
                child: Text('Approve'),
              ),
              CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Quit'),
              ),
            ],
          );
        });
  }

  alertpermissionCheck(PermissionModel permissionModel) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Do you want to Approve.?'),
            actions: <Widget>[
              CupertinoButton(
                onPressed: () {
                  cancelPermissionServiceCall(permissionModel);
                },
                child: Text('Reject'),
              ),
              CupertinoButton(
                onPressed: () {
                  approvePermissionServiceCall(permissionModel);
                },
                child: Text('Approve'),
              ),
              CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Quit'),
              ),
            ],
          );
        });
  }

  alertleavesCheck(LeavesModel leaveList) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Do you want to Approve.?'),
            actions: <Widget>[
              CupertinoButton(
                onPressed: () {
                  cancelLeavesServiceCall(leaveList);
                },
                child: Text('Reject'),
              ),
              CupertinoButton(
                onPressed: () {
                  approveLeavesServiceCall(leaveList);
                },
                child: Text('Approve'),
              ),
              CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Quit'),
              ),
            ],
          );
        });
  }

  String checkTravelRequestStatus(int tra_status) {
    if (tra_status == 1) {
      return "Pending";
    } else {
      return "";
    }
  }

  String checkHotelRequestStatus(int tra_status) {
    if (tra_status == 1) {
      return "Pending";
    } else {
      return "";
    }
  }

  getPendingApprovals() async {
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["fullname"],
            "parameter1": "GetDownTeamPendLeavesByRLId",
            "parameter2": uidd.toString()
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          leaveList = (json.decode(response.data) as List)
              .map((data) => LeavesModel.fromJson(data))
              .toList();
        });
        checkServices();
      }

      //=============================================================

      var response1 = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["fullname"],
            "parameter1": "GetDownTeamPermissionsByRLId",
            "parameter2": uidd.toString()
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response1.statusCode == 200 || response1.statusCode == 201) {
        setState(() {
          permissionsList = (json.decode(response1.data) as List)
              .map((data) => PermissionModel.fromJson(data))
              .toList();
        });
        checkServices();
      }

      ///==================================

      var response2 = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["string"],
            "parameter1": "getTravelRequestByDownTeam",
            "parameter2": uidd
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response2.statusCode == 200 || response2.statusCode == 201) {
        setState(() {
          trlm = (json.decode(response2.data) as List).map((a) => TravelRequestListModel.fromJson(a)).toList();
        });
        checkServices();
      }
      //      //=======================================================
      var response3 = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["string"],
            "parameter1": "getHotelRequestByDownTeam",
            "parameter2": uidd
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response3.statusCode == 200 || response3.statusCode == 201) {
        setState(() {
          hrlm = (json.decode(response3.data) as List)
              .map((data) => HotelRequestModel.fromJson(data))
              .toList();
        });
        checkServices();
      }
      //===================================================
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        return null;
      }
    }
  }

  //===
  cancelLeavesServiceCall(LeavesModel leaveList) async {
    pr.show();
    try {
      var response = await dio.post(ServicesApi.ChangeLeaveStatus,
          data: {
            "leaveId": leaveList.el_id.toString(),
            "modifiedBy": profilename,
            "leaveType": leaveList.leave_type.toString(),
            "noOfDays": leaveList.el_noofdays.toString(),
            "statusId": 3,
            "userId": leaveList.u_id
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // pr.hide();
        // getPendingApprovals();
        // Navigator.pop(context);
        Fluttertoast.showToast(msg: "Leave has been Rejected.");
        getUserLeavesToken(leaveList.el_from_date, leaveList.el_to_date,
            "Rejected", leaveList.u_id.toString());
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        pr.hide();
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        pr.hide();
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        return null;
      }
    }
  }

  void approveLeavesServiceCall(LeavesModel leaveList) async {
    pr.show();
    try {
      var response = await dio.post(ServicesApi.ChangeLeaveStatus,
          data: {
            "leaveId": leaveList.el_id,
            "modifiedBy": profilename,
            "leaveType": leaveList.leave_type,
            "noOfDays": leaveList.el_noofdays,
            "statusId": 2,
            "userId": leaveList.u_id
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(msg: "Leave has been Approved.");
        getUserLeavesToken(leaveList.el_from_date, leaveList.el_to_date,
            "Approved", leaveList.u_id.toString());
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        pr.dismiss();
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        pr.dismiss();
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        return null;
      }
    }
  }
  //===

  approvePermissionServiceCall(PermissionModel permissionModel) async {
    pr.show();
    try {
      var response = await dio.post(ServicesApi.ChangePermissionStatus,
          data: {
            "modifiedBy": profilename,
            "permissionId": permissionModel.per_id,
            "remarks": "string",
            "statusId": 2,
            "tlApprovedBy": profilename,
            "userId": permissionModel.u_id
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // pr.hide();
        // getPendingApprovals();
        // Navigator.pop(context);
        Fluttertoast.showToast(msg: "Permission has been Approved.");
        getUserPermissionToken(permissionModel.per_date, "Approved",
            permissionModel.u_id.toString());
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        pr.hide();
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        pr.hide();
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        return null;
      }
    }
  }

  void cancelPermissionServiceCall(PermissionModel permissionModel) async {
    pr.show();
    try {
      var response = await dio.post(ServicesApi.ChangePermissionStatus,
          data: {
            "modifiedBy": profilename,
            "permissionId": permissionModel.per_id,
            "remarks": "string",
            "statusId": 3,
            "userId": permissionModel.u_id
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // getPendingApprovals();
        // pr.hide();
        // Navigator.pop(context);
        Fluttertoast.showToast(msg: "Permission has been Rejected.");
        getUserPermissionToken(permissionModel.per_date, "Rejected",
            permissionModel.u_id.toString());
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        pr.hide();
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        pr.hide();
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        return null;
      }
    }
  }

  cancelTravelRequestServiceCall(TravelRequestListModel trlm) async {
    var response = await dio.post(ServicesApi.updateTravelRequest,
        data: {"statusId": 2, "traId": trlm.tra_id, "modifiedBy": profilename},
        options: Options(contentType: ContentType.parse("application/json")));
    if (response.statusCode == 200 || response.statusCode == 201) {
      Fluttertoast.showToast(msg: "Travel Request has been Rejected.");
      getUserTravelToken(trlm.reqNo, "Rejected", trlm.u_id.toString());
    } else if (response.statusCode == 401) {
      throw (Exception);
    }
  }

  approveTravelRequestServiceCall(TravelRequestListModel trlm) async {
    var response = await dio.post(ServicesApi.updateTravelRequest,
        data: {"statusId": 1, "traId": trlm.tra_id, "modifiedBy": profilename},
        options: Options(contentType: ContentType.parse("application/json")));
    if (response.statusCode == 200 || response.statusCode == 201) {
      Fluttertoast.showToast(msg: "Travel Request has been Approved.");
      getUserTravelToken(trlm.reqNo, "Approved", trlm.u_id.toString());
    } else if (response.statusCode == 401) {
      throw (Exception);
    }
  }

  cancelHotelRequestServiceCall(HotelRequestModel hrlm) async {
    var response = await dio.post(ServicesApi.updateHotelRequest,
        data: {
          "statusId": 2,
          "hotelId": hrlm.hotel_id,
          "modifiedBy": profilename
        },
        options: Options(contentType: ContentType.parse("application/json")));
    if (response.statusCode == 200 || response.statusCode == 201) {
      Fluttertoast.showToast(msg: "Hotel Request has been Rejected.");
      getUserHotelToken(hrlm.hotel_ref_no, "Rejected", hrlm.u_id.toString());
    } else if (response.statusCode == 401) {
      throw (Exception);
    }
  }

  approveHotelRequestServiceCall(HotelRequestModel hrlm) async {
    var response = await dio.post(ServicesApi.updateHotelRequest,
        data: {
          "statusId": 1,
          "hotelId": hrlm.hotel_id,
          "modifiedBy": profilename
        },
        options: Options(contentType: ContentType.parse("application/json")));
    if (response.statusCode == 200 || response.statusCode == 201) {
      Fluttertoast.showToast(msg: "Hotel Request has been Approved.");
      getUserHotelToken(hrlm.hotel_ref_no, "Approved", hrlm.u_id.toString());
    } else if (response.statusCode == 401) {
      throw (Exception);
    }
  }

  displayDateFormat(String elFromDate) {
    List<String> a = elFromDate.split("-");
    return a[2] + "-" + a[1] + "-" + a[0];
  }

  void getUserPermissionToken(String date, String status, String puidd) async {
    var response = await dio.post(ServicesApi.getData,
        data: {
          "encryptedFields": ["string"],
          "parameter1": "getUserToken",
          "parameter2": puidd
        },
        options: Options(contentType: ContentType.parse("application/json")));
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data != null) {
        setState(() {
          fum = (json.decode(response.data) as List)
              .map((data) => FirebaseUserModel.fromJson(data))
              .toList();
        });
        if (fum.isNotEmpty) {
          var to = fum[0].token.toString();
          // Fluttertoast.showToast(msg: "Stopped");
          if (to != null || to != "null") {
            pushPermissionsNotification(to, date, status);
          } else {
            pr.hide();
            getPendingApprovals();
            Navigator.pop(context);
          }
        } else {
          pr.hide();
          getPendingApprovals();
          Navigator.pop(context);
        }
      } else {
        pr.hide();
        getPendingApprovals();
        Navigator.pop(context);
      }
    } else if (response.statusCode == 401) {
      throw (Exception);
    }
  }

  void pushPermissionsNotification(
      String to, String date, String status) async {
    Map<String, dynamic> notification = {
      'body': fullname +
          " has " +
          status +
          " your permission request for " +
          date +
          ".",
      'title': 'Permission Approval',
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
    await http.post(ServicesApi.fcm_Send,
        headers: headers, body: json.encode(message));
    getPendingApprovals();
    pr.hide();
    Navigator.pop(context);
  }

  void getUserLeavesToken(String el_from_date, String el_to_date, String status,
      String puidd) async {
    var response = await dio.post(ServicesApi.getData,
        data: {
          "encryptedFields": ["string"],
          "parameter1": "getUserToken",
          "parameter2": puidd
        },
        options: Options(contentType: ContentType.parse("application/json")));
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data != null) {
        setState(() {
          fum = (json.decode(response.data) as List)
              .map((data) => FirebaseUserModel.fromJson(data))
              .toList();
        });
        if (fum.isNotEmpty) {
          var to = fum[0].token.toString();
          // Fluttertoast.showToast(msg: "Stopped");
          if (to != "null" || to != null) {
            pushLeavesNotification(to, el_from_date, el_to_date, status);
          } else {
            pr.hide();
            getPendingApprovals();
            Navigator.pop(context);
          }
        } else {
          pr.hide();
          getPendingApprovals();
          Navigator.pop(context);
        }
      } else {
        pr.hide();
        getPendingApprovals();
        Navigator.pop(context);
      }
    } else if (response.statusCode == 401) {
      throw (Exception);
    }
  }

  void pushLeavesNotification(
      String to, String el_from_date, String el_to_date, String status) async {
    Map<String, dynamic> notification = {
      'body': fullname +
          " has " +
          status +
          " your leave request for " +
          el_from_date +
          " to " +
          el_to_date +
          ".",
      'title': 'Leave Approval',
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
    await http.post(ServicesApi.fcm_Send,
        headers: headers, body: json.encode(message));
    pr.hide();
    getPendingApprovals();

    Navigator.pop(context);
  }

  void getUserTravelToken(String reqno, String status, String puidd) async {
    var response = await dio.post(ServicesApi.getData,
        data: {
          "encryptedFields": ["string"],
          "parameter1": "getUserToken",
          "parameter2": puidd
        },
        options: Options(contentType: ContentType.parse("application/json")));
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data != null) {
        setState(() {
          fum = (json.decode(response.data) as List)
              .map((data) => FirebaseUserModel.fromJson(data))
              .toList();
        });
        if (fum.isNotEmpty) {
          var to = fum[0].token.toString();
          // Fluttertoast.showToast(msg: "Stopped");
          if (to != null || to != "null") {
            pushTravelNotification(to, reqno, status);
          } else {
            pr.hide();
            getPendingApprovals();
            Navigator.pop(context);
          }
        } else {
          pr.hide();
          getPendingApprovals();
          Navigator.pop(context);
        }
      } else {
        pr.hide();
        getPendingApprovals();
        Navigator.pop(context);
      }
    } else if (response.statusCode == 401) {
      throw (Exception);
    }
  }

  void pushTravelNotification(String to, String reqno, String status) async {
    Map<String, dynamic> notification = {
      'body': "Your request no. " + reqno + "has been " + status + ".",
      'title': 'Travel Approval',
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
    await http.post(ServicesApi.fcm_Send,
        headers: headers, body: json.encode(message));
    getPendingApprovals();
    pr.hide();
    Navigator.pop(context);
  }

  void getUserHotelToken(String reqno, String status, String puidd) async {
    var response = await dio.post(ServicesApi.getData,
        data: {
          "encryptedFields": ["string"],
          "parameter1": "getUserToken",
          "parameter2": puidd
        },
        options: Options(contentType: ContentType.parse("application/json")));
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data != null) {
        setState(() {
          fum = (json.decode(response.data) as List)
              .map((data) => FirebaseUserModel.fromJson(data))
              .toList();
        });
        if (fum.isNotEmpty) {
          var to = fum[0].token.toString();
          // Fluttertoast.showToast(msg: "Stopped");
          if (to != null || to != "null") {
            pushHotelNotification(to, reqno, status);
          } else {
            pr.hide();
            getPendingApprovals();
            Navigator.pop(context);
          }
        } else {
          pr.hide();
          getPendingApprovals();
          Navigator.pop(context);
        }
      } else {
        pr.hide();
        getPendingApprovals();
        Navigator.pop(context);
      }
    } else if (response.statusCode == 401) {
      throw (Exception);
    }
  }

  void pushHotelNotification(String to, String reqno, String status) async {
    Map<String, dynamic> notification = {
      'body': "Your request no. " + reqno + "has been " + status + ".",
      'title': 'Hotel Approval',
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
    await http.post(ServicesApi.fcm_Send,
        headers: headers, body: json.encode(message));
    pr.hide();
    getPendingApprovals();

    Navigator.pop(context);
  }

  checkNoDays(String noodDays) {
    if (noodDays == "0.5") {
      return noodDays.toString();
    } else {
      List data = noodDays.split(".");
      return data[0].toString();
    }
  }
}



