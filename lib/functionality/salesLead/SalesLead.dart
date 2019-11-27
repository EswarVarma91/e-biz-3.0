import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eaglebiz/functionality/salesLead/SearchDownTeam.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:eaglebiz/activity/HomePage.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:eaglebiz/commonDrawer/CollapsingNavigationDrawer.dart';
import 'package:eaglebiz/functionality/salesLead/EditSalesLead.dart';
import 'package:eaglebiz/functionality/salesLead/InsertSalesLead.dart';
import 'package:eaglebiz/functionality/salesLead/ViewSalesLead.dart';
import 'package:eaglebiz/main.dart';
import 'package:eaglebiz/model/SalesPendingModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesLead extends StatefulWidget {
  @override
  StateSalesLead createState() => StateSalesLead();
}

class StateSalesLead extends State<SalesLead> {
  int pending = 0, completed = 1;
  bool _color1, _color2;
  String uidd;
  bool _isloading = false;
  bool _listDisplay = true;
  List<SalesPendingModel> listpending, listcompleted = [];
  String pendingCount = '-', completedCount = '-';
  static Dio dio = Dio(Config.options);
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> streamSubscription;

  Future<String> getUserID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString("userId");
    return id;
  }

  @override
  void initState() {
    super.initState();
    _color1 = true;
    _color2 = false;
    getUserID().then((val) => setState(() {
          uidd = val;
          print(uidd);
          pendingListM();
          connectivity = Connectivity();
          streamSubscription = connectivity.onConnectivityChanged
              .listen((ConnectivityResult result) {
            if (result != ConnectivityResult.none) {
              pendingListM();
            } else {
              Fluttertoast.showToast(msg: "Check your internet connection.");
            }
          });
        }));
  }

  void checkServices() {
    if (_color1 == true) {
      pendingListM();
    } else if (_color2 == true) {
      completedListM();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        // ignore: missing_return
        var navigator = Navigator.of(context);
        // ignore: missing_return
        navigator.push(
          // ignore: missing_return
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          // ignore: missing_return
          // ModalRoute.withName('/'),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Sales Lead",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
//        leading: Icon(Icons.monetization_on,color: Colors.white,),
        ),
        floatingActionButton: SpeedDial(
          curve: Curves.bounceInOut,
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: lwtColor,
          foregroundColor: Colors.white,
          elevation: 10.0,
          animatedIconTheme: IconThemeData(color: Colors.white),
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
                child: Icon(Icons.add),
                backgroundColor: lwtColor,
                label: "New Sales Lead",
                labelBackgroundColor: lwtColor,
                labelStyle: TextStyle(color: Colors.white),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) => NewSalesLead()),
                  );
                }),
            SpeedDialChild(
                child: Icon(Icons.search),
                backgroundColor: lwtColor,
                label: "Search DownTeam",
                labelBackgroundColor: lwtColor,
                labelStyle: TextStyle(color: Colors.white),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) => SearchDownTeam()),
                  );
                }),
          ],
        ),
//        FloatingActionButton(
//          onPressed: () {
//            // Add your onPressed code here!
//            var navigator = Navigator.of(context);
//            navigator.push(
//              MaterialPageRoute(builder: (BuildContext context) => NewSalesLead()),
////                          ModalRoute.withName('/'),
//            );
//          },
//          child: Icon(Icons.add),
//          backgroundColor: lwtColor,
//        ),
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(left: 60, right: 2, top: 6),
              child: StaggeredGridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 2, left: 2),
                    child: dashboard1(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 2, top: 2),
                    child: dashboard2(),
                  ),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(2, 70.0),
                  StaggeredTile.extent(2, 70.0),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 60, right: 2, top: 80),
              child: _listDisplay ? pendingListView() : completedListView(),
            ),
            CollapsingNavigationDrawer("2"),
            //ListView.builder(itemBuilder: null)
          ],
        ),
      ),
    );
  }

  Material dashboard1() {
    return Material(
      color: _color1 ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: _color1 ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            _color1 = !_color1;
            if (_color1 == true) {
              _color2 = !_color2;
              _listDisplay = !_listDisplay;
              checkServices();
            } else if (_color1 == false) {
              _color2 = !_color2;
              _listDisplay = !_listDisplay;
              checkServices();
            }
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Text(
                        "Pending",
                        style: TextStyle(
                          fontSize: 12.0, fontFamily: "Roboto",
                          color: _color1 ? Colors.white : lwtColor,
                          //Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        pendingCount,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "Roboto",
                            color: _color1 ? Colors.white : lwtColor),
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

  Material dashboard2() {
    return Material(
      color: _color2 ? lwtColor : Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: _color2 ? lwtColor : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            _color2 = !_color2;
            if (_color2 == true) {
              _color1 = !_color1;
              _listDisplay = !_listDisplay;
              checkServices();
            } else if (_color2 == false) {
              _color1 = !_color1;
              _listDisplay = !_listDisplay;
              checkServices();
            }
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Text(
                        "Completed",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: "Roboto",
                          color: _color2 ? Colors.white : lwtColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        completedCount,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "Roboto",
                          color: _color2 ? Colors.white : lwtColor,
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

  //  Service Call of Pending List
  pendingListM() async {
    try {
      var response = await dio.post(ServicesApi.Pending_Url,
          data: {
            "actionMode": "GetSaleRequestListByUserId",
            "refId": uidd.toString()
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          listpending = (json.decode(response.data) as List)
              .map((data) => new SalesPendingModel.fromJson(data))
              .toList();
          pendingCount = listpending?.length.toString() ?? '-';
          completedListM();
        });
      } else if (response.statusCode == 401) {
        throw Exception("Incorrect data");
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception(
            "Check your internet connection.");
      } else {
        return null;
      }
    }
  }

  //  Service Call of Completed List
  completedListM() async {
    print("uidd" + uidd.toString());
    try {
      var response = await dio.post(ServicesApi.Pending_Url,
          data: {
            "actionMode": "GetClosedSaleRequestByUId",
            "refId": uidd.toString()
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          listcompleted = (json.decode(response.data) as List)
              .map((data) => new SalesPendingModel.fromJson(data))
              .toList();
          completedCount = listcompleted?.length.toString() ?? '-';
        });
      } else if (response.statusCode == 401) {
        throw Exception("Incorrect data");
      }
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception(
            "Check your internet connection.");
      } else {
        return null;
      }
    }
  }

  pendingListView() {
    return ListView.builder(
        itemCount: listpending == null ? 0 : listpending.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              elevation: 5.0,
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: InkWell(
                child: Container(
                    /* decoration: BoxDecoration(border: Border.all(color: lwtColor,width: 1),
                        borderRadius: BorderRadius.only(topLeft: const Radius.circular(5.0), topRight: const Radius.circular(5.0),bottomLeft: const Radius.circular(5.0), bottomRight: const Radius.circular(5.0),
                        )),*/
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(
                      listpending[index]?.srNo ?? 'NA',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                        ),
                        Text(
                          listpending[index]?.srCustomerName ?? 'NA',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 10,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2),
                        ),
                        Text(
                          listpending[index]?.srContactEmail ?? '' + "NA.",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 10,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: lwtColor,
                        size: 25,
                      ),
                      onPressed: () {
                        var navigator = Navigator.of(context);
                        navigator.push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  EditSalesLead(listpending[index])),
//                          ModalRoute.withName('/'),
                        );
                      },
                    ),
                  ),
                )),
              ));
        });
  }

  completedListView() {
    return ListView.builder(
        itemCount: listcompleted == null ? 0 : listcompleted.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              elevation: 10.0,
              margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              child: InkWell(
                child: Container(
                    /*decoration: BoxDecoration(border: Border.all(color: lwtColor,width: 1),
                        borderRadius: BorderRadius.only(topLeft: const Radius.circular(5.0), topRight: const Radius.circular(5.0),bottomLeft: const Radius.circular(5.0), bottomRight: const Radius.circular(5.0),
                    )),*/
                    child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ListTile(
                    title: Text(
                      listcompleted[index]?.srNo ?? 'NA',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          listcompleted[index]?.srCustomerName ?? 'NA',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_right,
                        color: lwtColor,
                        size: 25,
                      ),
                      onPressed: () {
                        var navigator = Navigator.of(context);
                        navigator.push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PreviewSalesLead(listcompleted[index])),
//                          ModalRoute.withName('/'),
                        );
                      },
                    ),
                  ),
                )),
              ));
        });
  }
}
