import 'dart:convert';
import 'dart:io';

import 'package:Ebiz/activity/HomePage.dart';
import 'package:Ebiz/main.dart';
import 'package:Ebiz/model/SalesIndustrialEntryModel.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesIndustrialEntry extends StatefulWidget {
  @override
  _SalesIndustrialEntryState createState() => _SalesIndustrialEntryState();
}

class _SalesIndustrialEntryState extends State<SalesIndustrialEntry> {
  final _controller1 = TextEditingController();
  String timeStartI = "-", timeEndI = "-";
  static Dio dio = Dio(Config.options);
  String userId;
  List<SalesIndustrialEntryModel> listSalesIndustry = [];

  getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString("userId");
      getSalesIndustrialData(userId);
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Sales Industrial Entry",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()),
                // ModalRoute.withName('/'),
              );
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              onPressed: () {
                if (_controller1.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Enter Company Name");
                } else if (timeStartI == "-") {
                  Fluttertoast.showToast(msg: "Start entry time");
                } else {
                  _callInsertMethodI();
                }
              },
            )
          ],
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: TextFormField(
                controller: _controller1,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.business),
                  labelText: "Company Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: dashboard5(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: dashboard6(),
                  )
                ],
              ),
            ),
            Expanded(
              child: salesIndustrialList(),
            ),
          ],
        )));
  }

  Material dashboard5() {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: () {
          setState(() {
            var now1 = DateTime.now();
            timeStartI = DateFormat("HH:mm:ss").format(now1).toString();
          });
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "Entry Time",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        timeStartI,
                        style: TextStyle(fontSize: 20.0, color: lwtColor),
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

  Material dashboard6() {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: () {
          if (timeStartI != "-") {
            setState(() {
              var now = DateTime.now();
              timeEndI = DateFormat("HH:mm:ss").format(now).toString();
            });
          } else {
            Fluttertoast.showToast(msg: "Start your entry time");
          }
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "Exit Time",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFF272D34),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        timeEndI,
                        style: TextStyle(fontSize: 20.0, color: lwtColor),
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

  salesIndustrialList() {
    return ListView.builder(
        itemCount:
            listSalesIndustry == null ? 0 : listSalesIndustry?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              elevation: 5.0,
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: InkWell(
                child: Container(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(
                      listSalesIndustry[index]?.company_name ?? 'NA',
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
                        Row(
                          children: <Widget>[
                            Text(
                              "Entry Time  : ",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              listSalesIndustry[index]?.entry_time ?? 'NA',
                              style: TextStyle(
                                color: lwtColor,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Exit Time    : ",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              listSalesIndustry[index]?.exit_time ?? 'NA',
                              style: TextStyle(
                                color: lwtColor,
                                fontSize: 10,
                              ),
                            ),
                          ],
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
                      onPressed: () {},
                    ),
                  ),
                )),
              ));
        });
  }

  _callInsertMethodI() async {
    var nowTime = DateTime.now();
    try {
      var response = await dio.post(ServicesApi.updateData,
          data: {
            "parameter1": "insertSalesEntryExitPoint",
            "parameter2": _controller1.text,
            "parameter3": timeStartI,
            "parameter4": timeEndI,
            "parameter5": DateFormat("yyyy-MM-dd hh:mm:ss").format(nowTime),
            "parameter6": userId
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.data);
        getSalesIndustrialData(userId);
        Fluttertoast.showToast(msg: "Sales Entry Successful.");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => SalesIndustrialEntry()),
          ModalRoute.withName('/'),
        );
        // return responseJson;
      } else if (response.statusCode == 401) {
        throw Exception("Incorrect data");
      } else
        throw Exception('Authentication Error');
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception("Check your internet connection.");
      }
    }
  }

  getSalesIndustrialData(String user_id) async {
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["string"],
            "parameter1": "salesIndustrialDataById",
            "parameter2": user_id,
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          listSalesIndustry = (json.decode(response.data) as List)
              .map((data) => new SalesIndustrialEntryModel.fromJson(data))
              .toList();
          // completedCount = listSalesIndustry?.length.toString() ?? '-';
          // print(listSalesIndustry);
        });
      } else if (response.statusCode == 401) {
        throw Exception("Incorrect data");
      } else
        throw Exception('Authentication Error');
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception("Check your internet connection.");
      }
    }
  }
}
