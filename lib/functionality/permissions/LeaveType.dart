import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:eaglebiz/functionality/approvals/Approvals.dart';
import 'package:eaglebiz/main.dart';
import 'package:eaglebiz/model/LeavesCountModel.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';

class LeaveType extends StatefulWidget {
  @override
  _LeaveTypeState createState() => _LeaveTypeState();
}

class _LeaveTypeState extends State<LeaveType> {
  List<LeavesCountModel> listcountLeaves = new List();
  LeavesCountModel lcm;
  String uidd;
  static Dio dio = Dio(Config.options);
  bool lop, sl, ml, co, cl, cal;

  getLeavesCount(String uidd) async {
    var response = await dio.post(ServicesApi.getLeaves + uidd);
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        lcm = LeavesCountModel.fromJson(json.decode(response.data));
      });
    } else if (response.statusCode == 401) {
      throw Exception("Incorrect data");
    }
  }

  @override
  void initState() {
    super.initState();
    lop = false;
    sl = false;
    ml = false;
    co = false;
    cl = false;
    cal = false;
    getUserID().then((val) => setState(() {
          uidd = val;
          getLeavesCount(uidd);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Leave Type',
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
              margin: EdgeInsets.only(left: 15, right: 15, top: 20),
              child: StaggeredGridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: lopM(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: calM(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: clM(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: coM(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: slM(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1, top: 1),
                    child: mlM(),
                  ),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(2, 70.0),
                  StaggeredTile.extent(2, 70.0),
                  StaggeredTile.extent(2, 70.0),
                  StaggeredTile.extent(2, 70.0),
                  StaggeredTile.extent(2, 70.0),
                  StaggeredTile.extent(2, 70.0),
                ],
              ),
            ),
          ],
        ));
  }

  Material lopM() {
    return Material(
      color: lop ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: lwtColor,
      child: InkWell(
        onTap: () {
          Navigator.pop(context, "LOP 60");
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
                        "LOP".toUpperCase(),
                        style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: "Roboto",
                            color: lop ? Colors.white : lwtColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "60",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Roboto",
                          color: lop ? Colors.white : lwtColor,
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

  Material calM() {
    return Material(
      color: cal ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: lwtColor,
      child: InkWell(
        onTap: () {
          if (lcm.cal != "0") {
            if (int.parse(lcm.cal) >= 6) {
              Navigator.pop(context, "CAL 6");
            } else {
              Navigator.pop(context, "CAL " + lcm.cal);
            }
          } else {
            Fluttertoast.showToast(msg: "Sorry..! Insufficient CAL Leaves to proceed with the Request.");
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
                        "CAL".toUpperCase(),
                        style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: "Roboto",
                            color: cal ? Colors.white : lwtColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        lcm?.cal ?? "",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Roboto",
                          color: cal ? Colors.white : lwtColor,
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

  Material clM() {
    return Material(
      color: cl ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Colors.white,
      child: InkWell(
        onTap: () {
          if (lcm.cl != "0") {
            if (int.parse(lcm.cl) >= 6) {
              Navigator.pop(context, "CL 6");
            } else {
              Navigator.pop(context, "CL " + lcm.cl);
            }
          } else {
            Fluttertoast.showToast(msg: "Sorry..! Insufficient CL Leaves to proceed with the request.");
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
                        "CL".toUpperCase(),
                        style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: "Roboto",
                            color: cl ? Colors.white : lwtColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        lcm?.cl ?? "",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Roboto",
                          color: cl ? Colors.white : lwtColor,
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

  Material coM() {
    return Material(
      color: co ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Colors.white,
      child: InkWell(
        onTap: () {
          if (lcm.co != "0") {
            if (int.parse(lcm.co) >= 6) {
              Navigator.pop(context, "CO 6");
            } else {
              Navigator.pop(context, "CO " + lcm.co);
            }
          } else {
            Fluttertoast.showToast(msg: "Sorry..! Insufficient CO Leaves to proceed with the Request.");
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
                        "CO".toUpperCase(),
                        style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: "Roboto",
                            color: co ? Colors.white : lwtColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        lcm?.co ?? "",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Roboto",
                          color: co ? Colors.white : lwtColor,
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

  Material mlM() {
    return Material(
      color: ml ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: lwtColor,
      child: InkWell(
        onTap: () {
          if (lcm.ml != "0") {
            if (int.parse(lcm.ml) >= 6) {
              Navigator.pop(context, "ML 6");
            } else {
              Navigator.pop(context, "CL " + lcm.ml);
            }
          } else {
            Fluttertoast.showToast(msg: "Sorry..! Insufficient ML Leaves to proceed with the Request.");
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
                        "ML".toUpperCase(),
                        style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: "Roboto",
                            color: ml ? Colors.white : lwtColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        lcm?.ml ?? "",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Roboto",
                          color: ml ? Colors.white : lwtColor,
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

  Material slM() {
    return Material(
      color: sl ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: lwtColor,
      child: InkWell(
        onTap: () {
          if (lcm.sl != "0") {
            if (int.parse(lcm.sl) >= 6) {
              Navigator.pop(context, "SL 6");
            } else {
              Navigator.pop(context, "SL " + lcm.sl);
            }
          } else {
            Fluttertoast.showToast(msg: "Sorry..! Insufficient 'SL' Leaves to proceed with the Request.");
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
                        "SL".toUpperCase(),
                        style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: "Roboto",
                            color: sl ? Colors.white : lwtColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        lcm?.sl ?? "",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Roboto",
                          color: sl ? Colors.white : lwtColor,
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
}

// Container(
//         child: ListView(
//           children: <Widget>[
//             ListTile(
//               title: Text("CAL  :  "+lcm?.cal??"-",style: TextStyle(color: Colors.black),),
//               onTap: (){
//                 Navigator.pop(context, lcm?.cal??"-".toString());
//               },
//             ),
//             ListTile(
//               title: Text("CL   :  "+lcm?.cl??"-",style: TextStyle(color: Colors.black),),
//               onTap: (){
//                 Navigator.pop(context, lcm?.cl??"-".toString());
//               },
//             ),
//             ListTile(
//               title: Text("CO   :  "+lcm?.co??"-",style: TextStyle(color: Colors.black),),
//               onTap: (){
//                 Navigator.pop(context, lcm?.co??"-".toString());
//               },
//             ),
//             ListTile(
//               title: Text("ML   :  "+lcm?.ml??"-",style: TextStyle(color: Colors.black),),
//               onTap: (){
//                 Navigator.pop(context, lcm?.ml??"-".toString());
//               },
//             ),
//             ListTile(
//               title: Text("SL   :  "+lcm?.sl??"-",style: TextStyle(color: Colors.black),),
//               onTap: (){
//                 Navigator.pop(context, "SL "+lcm?.sl??"-".toString());
//               },
//             ),
//             ListTile(
//               title: Text("LOP  :  ",style: TextStyle(color: Colors.black),),
//               onTap: (){
//                 Navigator.pop(context, "LOP "+"");
//               },
//             ),
//           ],
//         ),
//       )
// //
