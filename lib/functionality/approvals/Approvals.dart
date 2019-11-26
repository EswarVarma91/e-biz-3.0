import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eaglebiz/commonDrawer/CollapsingNavigationDrawer.dart';
import 'package:eaglebiz/main.dart';
import 'package:eaglebiz/model/FirebaseUserModel.dart';
import 'package:eaglebiz/model/HotelRequestModel.dart';
import 'package:eaglebiz/model/LateEarlyComingModel.dart';
import 'package:eaglebiz/model/LeavesModel.dart';
import 'package:eaglebiz/model/PermissionModel.dart';
import 'package:eaglebiz/model/TravelRequestListModel.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  List<LeavesModel> leaveList = new List();
  List<PermissionModel> permissionsList = new List();
  List<HotelRequestModel> hrlm = new List();
  List<LateEarlyComingModel> datacheck = new List();
  List<TravelRequestListModel> trlm = new List();
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
    pr = new ProgressDialog(context);
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
          Container(
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
                                leaveList[index]
                                            ?.el_noofdays
                                            .toString()
                                            .split(".")[0] +
                                        " Days" ??
                                    '' + "NA.",
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
                                "From Time            :     ",
                                style: TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
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
                                "To Time                 :     ",
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
                                "Date                       :     ",
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
                                    '' + "NA.",
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
                                "Reason                  :     ",
                                style: TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                              ),
                              Expanded(
                                child: Text(
                                  permissionsList[index]?.per_purpose ??
                                      '' + "NA.",
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
    return ListView.builder(
        itemCount: trlm == null ? 0 : trlm.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 5.0,
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: ListTile(
                subtitle: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(2),
                          child: Text(
                            trlm[index]?.fullName ?? 'NA',
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
                  ],
                ),
                trailing: Container(
                  padding: EdgeInsets.only(top: 20),
                  child: IconButton(
                    icon: Icon(
                      Icons.check_circle,
                      color: lwtColor,
                      size: 40,
                    ),
                    onPressed: () {
                      travelRequest(trlm[index]);
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }

  hotelAListView() {
    return ListView.builder(
        itemCount: hrlm == null ? 0 : hrlm.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 5.0,
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: ListTile(
                subtitle: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(2),
                          child: Text(
                            hrlm[index]?.travellerName??
                                'NA',
                            style: TextStyle(
                                color: lwtColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    
                  ],
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
                      hotelRequest(hrlm[index]);
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }

  void travelRequest(TravelRequestListModel trlm) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: new Text('Do you want to Approve.?'),
            actions: <Widget>[
              new CupertinoButton(
                onPressed: () {
                  // cancelLateEarlyServiceCall(trlm);
                },
                child: new Text('Reject'),
              ),
              new CupertinoButton(
                onPressed: () {
                  // approveLateEarlyServiceCall(trlm);
                },
                child: new Text('Approve'),
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
            title: new Text('Do you want to Approve.?'),
            actions: <Widget>[
              new CupertinoButton(
                onPressed: () {
                  // cancelLateEarlyServiceCall(lateearlycomingModel);
                },
                child: new Text('Reject'),
              ),
              new CupertinoButton(
                onPressed: ()  {
                  // approveLateEarlyServiceCall(lateearlycomingModel);
                },
                child: new Text('Approve'),),
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
            title: new Text('Do you want to Approve.?'),
            actions: <Widget>[
              new CupertinoButton(
                onPressed: () {
                  cancelPermissionServiceCall(permissionModel);
                },
                child: new Text('Reject'),
              ),
              new CupertinoButton(
                onPressed: () {
                  approvePermissionServiceCall(permissionModel);
                },
                child: new Text('Approve'),
              ),
            ],
          );
        });
  }

  void alertleavesCheck(LeavesModel leaveList) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: new Text('Do you want to Approve.?'),
            actions: <Widget>[
              new CupertinoButton(
                onPressed: () {
                  cancelLeavesServiceCall(leaveList);
                },
                child: new Text('Reject'),
              ),
              new CupertinoButton(
                onPressed: () {
                  approveLeavesServiceCall(leaveList);
                },
                child: new Text('Approve'),
              ),
            ],
          );
        });
  }

  getPendingApprovals() async {
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "parameter1": "GetDownTeamPendLeavesByRLId",
            "parameter2": uidd.toString()
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          leaveList = (json.decode(response.data) as List)
              .map((data) => new LeavesModel.fromJson(data))
              .toList();
          print(leaveList.toString());
        });
        checkServices();
      }

      //=============================================================

      var response1 = await dio.post(ServicesApi.getData,
          data: {
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
          print(permissionsList.toString());
        });
        checkServices();
      }

      ///==================================

      var response2 = await dio.post(ServicesApi.getData,
          data: {
            "parameter1": "getTravelRequestByDownTeam",
            "parameter2": uidd
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response2.statusCode == 200 || response2.statusCode == 201) {
        setState(() {
          trlm = (json.decode(response2.data) as List)
              .map((data) => TravelRequestListModel.fromJson(data))
              .toList();
          print(trlm);
        });
        checkServices();
      }
//      //=======================================================
      var response3 = await dio.post(ServicesApi.getData,
          data: {
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
          print(trlm);
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
            "userId": uidd
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // pr.hide();
        // getPendingApprovals();
        // Navigator.pop(context);
        getUserLeavesToken(leaveList.el_from_date, leaveList.el_to_date,
            "Cancelled", leaveList.u_id.toString());
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
            "userId": uidd
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
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
            "tlApprovedBy": profilename
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // pr.hide();
        // getPendingApprovals();
        // Navigator.pop(context);
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
            "tlApprovedBy": profilename
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // getPendingApprovals();
        // pr.hide();
        // Navigator.pop(context);
        getUserPermissionToken(permissionModel.per_date, "Cancelled",
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

  //   ///===============================
  //   void cancelLateEarlyServiceCall(LateEarlyComingModel listdata) async {
  //     try {
  //       var  response = await dio.put(ServicesApi.ChangeLeaveStatus,
  //           data: {
  //             "actionMode": "RejectAttendanceReqByTL ",
  //             "parameter1": listdata.u_emp_code.toString(),
  //             "parameter2": listdata.att_date.toString(),
  //             "parameter3": profilename,
  //             "parameter4": listdata.att_id.toString(),
  //             "parameter5": "string"
  //           },
  //           options: Options(contentType: ContentType.parse('application/json'),
  //           ));
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         setState(() {
  //           getPendingApprovals();
  //         });
  //         Navigator.pop(context);
  // //        CheckServices();
  //       }
  //     } on DioError catch (exception) {
  //       if (exception == null ||
  //           exception.toString().contains('SocketException')) {
  //         throw Exception("Network Error");
  //       } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
  //           exception.type == DioErrorType.CONNECT_TIMEOUT) {
  //         throw Exception(
  //             "Could'nt connect, please ensure you have a stable network.");
  //       } else {
  //         return null;
  //       }
  //     }
  //   }

  //   void approveLateEarlyServiceCall(LateEarlyComingModel listdata) async {
  //     try {
  //       var  response = await dio.put(ServicesApi.leaves_Permissions_daytime_approvals_userLocation,
  //           data: {
  //             "actionMode": "ApproveAttendanceReqByTL",
  //             "parameter1": listdata.u_emp_code.toString(),
  //             "parameter2": listdata.att_date.toString(),
  //             "parameter3": profilename,
  //             "parameter4": listdata.att_id.toString(),
  //             "parameter5": "string"
  //           },
  //           options: Options(contentType: ContentType.parse('application/json'),
  //           ));
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         setState(() {
  //           getPendingApprovals();
  //         });
  //         Navigator.pop(context);
  // //        CheckServices();
  //       }
  //     } on DioError catch (exception) {
  //       if (exception == null ||
  //           exception.toString().contains('SocketException')) {
  //         throw Exception("Network Error");
  //       } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
  //           exception.type == DioErrorType.CONNECT_TIMEOUT) {
  //         throw Exception(
  //             "Could'nt connect, please ensure you have a stable network.");
  //       } else {
  //         return null;
  //       }
  //     }
  //   }

  displayDateFormat(String elFromDate) {
    List<String> a = elFromDate.split("-");
    return a[2] + "-" + a[1] + "-" + a[0];
  }

  void getUserPermissionToken(String date, String status, String puidd) async {
    var response = await dio.post(ServicesApi.getData,
        data: {"parameter1": "getUserToken", "parameter2": puidd},
        options: Options(contentType: ContentType.parse("application/json")));
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data != null) {
        setState(() {
          fum = (json.decode(response.data) as List)
              .map((data) => new FirebaseUserModel.fromJson(data))
              .toList();
        });
        var to = fum[0].token.toString();
        // Fluttertoast.showToast(msg: "Stopped");
        pushPermissionsNotification(to, date, status);
      } else {
        pr.hide();
        Navigator.pop(context);
      }
    } else if (response.statusCode == 401) {
      throw (Exception);
    }
  }

  void pushPermissionsNotification(
      String to, String date, String status) async {
    Map<String, dynamic> notification = {
      'body':
          fullname + " has " + status + " your request on this " + date + ".",
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
    pr.hide();
    Navigator.pop(context);
  }

  void getUserLeavesToken(String el_from_date, String el_to_date, String status,
      String puidd) async {
    var response = await dio.post(ServicesApi.getData,
        data: {"parameter1": "getUserToken", "parameter2": puidd},
        options: Options(contentType: ContentType.parse("application/json")));
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data != null) {
        setState(() {
          fum = (json.decode(response.data) as List)
              .map((data) => new FirebaseUserModel.fromJson(data))
              .toList();
        });
        var to = fum[0].token.toString();
        // Fluttertoast.showToast(msg: "Stopped");
        pushLeavesNotification(to, el_from_date, el_to_date, status);
      } else {
        pr.hide();
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
          " your request on this " +
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
    // todo - set the relevant values
    await http.post(ServicesApi.fcm_Send,
        headers: headers, body: json.encode(message));
    pr.hide();
    Navigator.pop(context);
  }
}
