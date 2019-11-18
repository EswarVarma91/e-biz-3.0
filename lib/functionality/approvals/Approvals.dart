import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eaglebiz/commonDrawer/CollapsingNavigationDrawer.dart';
import 'package:eaglebiz/main.dart';
import 'package:eaglebiz/model/LateEarlyComingModel.dart';
import 'package:eaglebiz/model/LeavesModel.dart';
import 'package:eaglebiz/model/PermissionModel.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      earlygoingCount = "-",
      latecomingCount = "-",
      fullname;
  bool _leavesA, _permissionsA, _earlygoingA, _latecomingA;
  static var now = DateTime.now();
  static Dio dio = Dio(Config.options);
  List<LeavesModel> leaveList = new List();
  List<PermissionModel> permissionsList = new List();
  List<LateEarlyComingModel> earlygoingList = new List();
  List<LateEarlyComingModel> datacheck = new List();
  List<LateEarlyComingModel> latecomingList = new List();
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
    _earlygoingA = false;
    _latecomingA = false;
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
      latecomingCount = latecomingList.length?.toString() ?? "0";
      earlygoingCount = earlygoingList.length?.toString() ?? "0";
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
                // Padding(
                //   padding: const EdgeInsets.only(right: 1, top: 1),
                //   child: earlygoingMaterial(),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(right: 1, top: 1),
                //   child: latecomingMaterial(),
                // ),
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
                  margin: EdgeInsets.only(left: 60, right: 2, top: 90),
                  child: leavesAListView(),
                )
              : Container(),
          _permissionsA
              ? Container(
                  margin: EdgeInsets.only(left: 60, right: 2, top: 90),
                  child: permissionsAListView(),
                )
              : Container(),
          // _earlygoingA? Container(
          //   margin: EdgeInsets.only(left: 60, right: 2, top: 180),
          //   child:  earlygoingAListView(),
          // ):Container(),
          // _latecomingA ? Container(
          //   margin: EdgeInsets.only(left: 60, right: 2, top: 180),
          //   child:  latecomingAListView(),
          // ):Container(),
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
            } else if (_earlygoingA == true) {
              _earlygoingA = !_earlygoingA;
              checkServices();
            } else if (_latecomingA == true) {
              _latecomingA = !_latecomingA;
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
            } else if (_earlygoingA == true) {
              _earlygoingA = !_earlygoingA;
              checkServices();
            } else if (_latecomingA == true) {
              _latecomingA = !_latecomingA;
              checkServices();
            } else if (_permissionsA == false) {
              _earlygoingA = !_earlygoingA;
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

  Material earlygoingMaterial() {
    return Material(
      color: _earlygoingA ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: _earlygoingA ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            _earlygoingA = !_earlygoingA;
            checkServices();
            if (_leavesA == true) {
              _leavesA = !_leavesA;
              checkServices();
            } else if (_permissionsA == true) {
              _permissionsA = !_permissionsA;
              checkServices();
            } else if (_latecomingA == true) {
              _latecomingA = !_latecomingA;
              checkServices();
            } else if (_earlygoingA == false) {
              _latecomingA = !_latecomingA;
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
                        "Early Going",
                        style: TextStyle(
                          fontSize: 15.0, fontFamily: "Roboto",
                          color: _earlygoingA ? Colors.white : lwtColor,
                          //Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        earlygoingCount,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "Roboto",
                            color: _earlygoingA ? Colors.white : lwtColor),
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

  Material latecomingMaterial() {
    return Material(
      color: _latecomingA ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: _latecomingA ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            _latecomingA = !_latecomingA;
            checkServices();
            if (_leavesA == true) {
              _leavesA = !_leavesA;
              checkServices();
            } else if (_earlygoingA == true) {
              _earlygoingA = !_earlygoingA;
              checkServices();
            } else if (_permissionsA == true) {
              _permissionsA = !_permissionsA;
              checkServices();
            } else if (_latecomingA == false) {
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
                        "Late Coming",
                        style: TextStyle(
                          fontSize: 15.0, fontFamily: "Roboto",
                          color: _latecomingA ? Colors.white : lwtColor,
                          //Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        latecomingCount,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "Roboto",
                            color: _latecomingA ? Colors.white : lwtColor),
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

  // earlygoingAListView() {
  //   return ListView.builder(
  //       itemCount: earlygoingList == null ? 0 : earlygoingList.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return Card(
  //           elevation: 5.0,
  //           child: Container(
  //             padding: EdgeInsets.only(top: 10,bottom: 10),
  //             child: ListTile(
  //               subtitle: Column(
  //                 children: <Widget>[
  //                   Row(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: <Widget>[
  //                       Container(
  //                         padding: EdgeInsets.all(2),
  //                         child: Text(
  //                           earlygoingList[index]?.att_request_by ?? 'NA',
  //                           style: TextStyle(
  //                               color: lwtColor,
  //                               fontSize: 12,
  //                               fontWeight: FontWeight.bold),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.only(top: 8),
  //                   ),
  //                  Container(
  //                    padding: EdgeInsets.only(left: 5),
  //                    child: Column(
  //                      children: <Widget>[
  //                        Row(
  //                          children: <Widget>[
  //                            Text("Date                      :     ",style: TextStyle(fontSize: 8,),),
  //                            Padding(
  //                              padding: EdgeInsets.only(top: 4),
  //                            ),
  //                            Text(displayDateFormat(earlygoingList[index]?.att_date) ?? 'NA',
  //                              style: TextStyle(
  //                                  color: lwtColor,
  //                                  fontSize: 10,
  //                                  fontWeight: FontWeight.bold
  //                              ),
  //                            ),
  //                          ],
  //                        ),
  //                        Padding(
  //                          padding: EdgeInsets.only(top: 6),
  //                        ),
  //                        Row(
  //                          children: <Widget>[
  //                            Text("Out Time              :     ",style: TextStyle(fontSize: 8,),),
  //                            Padding(
  //                              padding: EdgeInsets.only(top: 4),
  //                            ),
  //                            Text(earlygoingList[index]?.att_out_time ?? 'NA',
  //                              style: TextStyle(
  //                                  color: lwtColor,
  //                                  fontSize: 10,
  //                                  fontWeight: FontWeight.bold
  //                              ),
  //                            ),
  //                          ],
  //                        ),
  //                        Padding(
  //                          padding: EdgeInsets.only(top: 6),
  //                        ),
  //                        Row(
  //                          children: <Widget>[
  //                            Text("Work Status         :     ",style: TextStyle(fontSize: 8,),),
  //                            Padding(
  //                              padding: EdgeInsets.only(top: 4),
  //                            ),
  //                            Text(earlygoingList[index]?.att_work_status ?? '' + "NA.",
  //                              style: TextStyle(
  //                                  color: lwtColor,
  //                                  fontSize: 10,
  //                                  fontWeight: FontWeight.bold
  //                              ),
  //                            ),
  //                          ],
  //                        ),
  //                        Padding(
  //                          padding: EdgeInsets.only(top: 6),
  //                        ),
  //                        Row(
  //                          children: <Widget>[
  //                                  Text("Reason                 :     ",style: TextStyle(fontSize: 8,),),
  //                            Padding(
  //                              padding: EdgeInsets.only(top: 4),
  //                            ),
  //                            Expanded(
  //                              child: Text(earlygoingList[index]?.att_request_remarks ?? '' + "NA.",
  //                                style: TextStyle(
  //                                    color: lwtColor,
  //                                    fontSize: 10,
  //                                    fontWeight: FontWeight.bold
  //                                ),
  //                              ),
  //                            ),
  //                          ],
  //                        ),
  //                      ],
  //                    ),
  //                  )
  //                 ],
  //               ),
  //               trailing: Container(
  //                 padding: EdgeInsets.only(top: 20),
  //                 child: IconButton(
  //                   icon: Icon(Icons.check_circle,color: lwtColor,size: 40,),
  //                   onPressed: (){
  //                     earlygoingRequest(earlygoingList[index]);
  //                   },
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

  // latecomingAListView() {
  //   return ListView.builder(
  //       itemCount: latecomingList == null ? 0 : latecomingList.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return Card(
  //           elevation: 5.0,
  //           child: Container(
  //             padding: EdgeInsets.only(top: 10,bottom: 10),
  //             child: ListTile(
  //               subtitle: Column(
  //                 children: <Widget>[
  //                   Row(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: <Widget>[
  //                       Container(
  //                         padding: EdgeInsets.all(2),
  //                         child: Text(latecomingList[index].att_request_by[0].toUpperCase()+ latecomingList[index].att_request_by.substring(1) ?? 'NA',
  //                               style: TextStyle(
  //                                   color: lwtColor,
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.bold),
  //                             ),
  //                       ),
  //                     ],
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.only(top: 8),
  //                   ),
  //                   Container(
  //                     padding: EdgeInsets.only(left: 5),
  //                     child: Column(
  //                       children: <Widget>[
  //                         Row(
  //                           children: <Widget>[
  //                             Text("Date                      :     ",style: TextStyle(fontSize: 8,),),
  //                             Padding(
  //                               padding: EdgeInsets.only(top: 4),
  //                             ),
  //                             Text(displayDateFormat(latecomingList[index]?.att_date) ?? 'NA',
  //                               style: TextStyle(
  //                                   color: lwtColor,
  //                                   fontSize: 10,
  //                                   fontWeight: FontWeight.bold
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Padding(
  //                           padding: EdgeInsets.only(top: 6),
  //                         ),
  //                         Row(
  //                           children: <Widget>[
  //                             Text("In Time                 :     ",style: TextStyle(fontSize: 8,),),
  //                             Padding(
  //                               padding: EdgeInsets.only(top: 4),
  //                             ),
  //                             Text(latecomingList[index]?.att_tour_in_time ?? 'NA',
  //                               style: TextStyle(
  //                                   color: lwtColor,
  //                                   fontSize: 10,
  //                                   fontWeight: FontWeight.bold
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Padding(
  //                           padding: EdgeInsets.only(top: 6),
  //                         ),
  //                         Row(
  //                           children: <Widget>[
  //                             Text("Work Status         :     ",style: TextStyle(fontSize: 8,),),
  //                             Padding(
  //                               padding: EdgeInsets.only(top: 4),
  //                             ),
  //                             Text(latecomingList[index]?.att_work_status ?? '' + "NA.",
  //                               style: TextStyle(
  //                                   color: lwtColor,
  //                                   fontSize: 10,
  //                                   fontWeight: FontWeight.bold
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Padding(
  //                           padding: EdgeInsets.only(top: 6),
  //                         ),
  //                         Row(
  //                           children: <Widget>[
  //                             Text("Reason                 :     ",style: TextStyle(fontSize: 8,),),
  //                             Padding(
  //                               padding: EdgeInsets.only(top: 4),
  //                             ),
  //                             Expanded(
  //                               child: Text(latecomingList[index]?.att_request_remarks ?? '' + "NA.",
  //                                 style: TextStyle(
  //                                     color: lwtColor,
  //                                     fontSize: 10,
  //                                     fontWeight: FontWeight.bold
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   )
  //                 ],
  //               ),
  //               trailing: Container(
  //                 padding: EdgeInsets.only(top: 20),
  //                 child: IconButton(
  //                   icon: Icon(Icons.check_circle,size: 40,color: lwtColor,),
  //                   onPressed: (){
  //                     latecomingRequest(latecomingList[index]);
  //                   },
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  //       }

  // void earlygoingRequest(LateEarlyComingModel earlygoingList) {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return CupertinoAlertDialog(
  //           title: new Text('Do you want to Approve.?'),
  //           actions: <Widget>[
  //             new CupertinoButton(
  //               onPressed: () {
  //                 cancelLateEarlyServiceCall(earlygoingList);
  //               },
  //               child: new Text('Reject'),
  //             ),
  //             new CupertinoButton(
  //               onPressed: ()  {
  //                 approveLateEarlyServiceCall(earlygoingList);
  //               },
  //               child: new Text('Approve'),),
  //           ],
  //         );
  //       });
  // }

  //  latecomingRequest(LateEarlyComingModel lateearlycomingModel) {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return CupertinoAlertDialog(
  //           title: new Text('Do you want to Approve.?'),
  //           actions: <Widget>[
  //             new CupertinoButton(
  //               onPressed: () {
  //                 cancelLateEarlyServiceCall(lateearlycomingModel);
  //               },
  //               child: new Text('Reject'),
  //             ),
  //             new CupertinoButton(
  //               onPressed: ()  {
  //                 approveLateEarlyServiceCall(lateearlycomingModel);
  //               },
  //               child: new Text('Approve'),),
  //           ],
  //         );
  //       });
  // }

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

//      var response2 = await dio.post(ServicesApi.emp_Data,
//          data: {
//            "actionMode": "GetDownTeamLatecomingByMonth",
//            "parameter1": uidd.toString(),
//            "parameter2": DateFormat("yyyy-MM-").format(now).toString()+"01",
//            "parameter3": "string",
//            "parameter4": "string",
//            "parameter5": "string"
//          },
//          options: Options(contentType: ContentType.parse('application/json'),
//          ));
//      if (response2.statusCode == 200 || response2.statusCode == 201) {
//        setState(() {
//          datacheck=
//              (json.decode(response2.data) as List).map((data) => new LateEarlyComingModel.fromJson(data)).toList();
//          datacheck.removeWhere((a)=> a.att_id=="-");
//          datacheck.removeWhere((a)=>a.tl_approval=="1");
//          datacheck.removeWhere((a)=>a.tl_approval=="2");
//          datacheck.removeWhere((a)=>a.hr_approval=="1");
//          datacheck.removeWhere((a)=>a.hr_approval=="2");
//          latecomingList=datacheck;
//          print(latecomingList);
////          print(list1.toString());
//
//        });
////        CheckServices();
//      }
//      //=======================================================
//      print(DateFormat("yyyy-MM-").format(now).toString()+"01");
//      var response3 = await dio.post(ServicesApi.emp_Data,
//          data: {
//            "actionMode": "GetDownTeamEarlyGoingByMonth",
//            "parameter1": uidd.toString(),
//            "parameter2": DateFormat("yyyy-MM-").format(now).toString()+"01",
//            "parameter3": "string",
//            "parameter4": "string",
//            "parameter5": "string"
//          },
//          options: Options(contentType: ContentType.parse('application/json'),
//          ));
//      if (response3.statusCode == 200 || response3.statusCode == 201) {
//        setState(() {
//          datacheck =
//              (json.decode(response3.data) as List).map((data) => new LateEarlyComingModel.fromJson(data)).toList();
//          datacheck.removeWhere((a)=> a.att_id=="-");
//          datacheck.removeWhere((a)=>a.tl_approval=="1");
//          datacheck.removeWhere((a)=>a.tl_approval=="2");
//          datacheck.removeWhere((a)=>a.hr_approval=="1");
//          datacheck.removeWhere((a)=>a.hr_approval=="2");
//          earlygoingList=datacheck;
////          print(list1.toString());
//
//        });

//      }
//      checkServices();
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
        pr.hide();
        setState(() {
          getPendingApprovals();
        });
        Navigator.pop(context);
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
        pr.dismiss();
        setState(() {
          getPendingApprovals();
        });
        Navigator.pop(context);
//        CheckServices();
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
        pr.hide();
        setState(() {
          getPendingApprovals();
        });
        Navigator.pop(context);
//        CheckServices();
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
        setState(() {
          getPendingApprovals();
        });
        pr.hide();
        Navigator.pop(context);
//        CheckServices();
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
}
