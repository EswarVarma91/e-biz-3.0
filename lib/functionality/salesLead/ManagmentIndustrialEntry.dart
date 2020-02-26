import 'dart:convert';
import 'dart:io';
import 'package:Ebiz/activity/HomePage.dart';
import 'package:Ebiz/functionality/salesLead/ReferedByEnc.dart';
import 'package:Ebiz/main.dart';
import 'package:Ebiz/model/SalesIndustrialEntryModel.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManagmentIndustrialEntry extends StatefulWidget {
  @override
  _ManagmentIndustrialEntryState createState() =>
      _ManagmentIndustrialEntryState();
}

class _ManagmentIndustrialEntryState extends State<ManagmentIndustrialEntry> {
  String nameofPerson = "", dateofSales = "";
  List<SalesIndustrialEntryModel> tcm, filtertcm = [];
  static Dio dio = Dio(Config.options);
  var result = "", referalId = "", totalHours = "";

  @override
  void initState() {
    super.initState();
    getSalesEntryDataAll();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        var navigator = Navigator.of(context);
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          ModalRoute.withName('/'),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Work Visits",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(2.0),
                child: ListTile(
                  onTap: () {
                    _navigatereferMethod(context);
                  },
                  title: TextFormField(
                    enabled: false,
                    controller: TextEditingController(text: result),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      labelText: "Name of the person",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    itemCount: filtertcm == null ? 0 : filtertcm.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                            title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Visited",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12)),
                                      Text(
                                        filtertcm[index]?.company_name ?? "",
                                        style: TextStyle(
                                            color: lwtColor, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Name",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12)),
                                      Text(
                                        filtertcm[index].fullName,
                                        style: TextStyle(
                                            color: lwtColor, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text("Date",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12)),
                                      Text(
                                        filtertcm[index].created_date,
                                        style: TextStyle(
                                            color: lwtColor, fontSize: 12),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Entry Time",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12)),
                                      Text(
                                        filtertcm[index]?.entry_time ?? "",
                                        style: TextStyle(
                                            color: lwtColor, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Hours Spend",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: Text(
                                            filtertcm[index].exit_time != null
                                                ? _timeDiffernece(
                                                    filtertcm[index].entry_time,
                                                    filtertcm[index].exit_time,
                                                  )
                                                : "  --:--:--",
                                            style: TextStyle(
                                                color: lwtColor, fontSize: 15)),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text("Exit Time",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12)),
                                      Text(
                                        filtertcm[index]?.exit_time ??
                                            "--:--:--",
                                        style: TextStyle(
                                            color: lwtColor, fontSize: 12),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Purpose",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12)),
                                      Text(
                                        filtertcm[index]?.purpose ?? "",
                                        style: TextStyle(
                                            color: lwtColor, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Remarks ",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12)),
                                      Text(
                                        filtertcm[index]?.remarks ?? "",
                                        style: TextStyle(
                                            color: lwtColor, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _navigatereferMethod(BuildContext context) async {
    var data = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ReferedByEnc("Name of the person")));
    var string = data.split(" USR_");
    setState(() {
      result = string[0];
      referalId = string[1];
      getSalesEntryDate(referalId);
    });
  }

  getSalesEntryDate(String referalId) async {
    if (referalId != null) {
      filtertcm.clear();
      getSalesIndustrialData(referalId);
    } else {
      getSalesEntryDataAll();
    }
  }

  getSalesIndustrialData(String user_id) async {
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["fullName"],
            "parameter1": "salesIndustrialDataById",
            "parameter2": user_id,
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          tcm = (json.decode(response.data) as List)
              .map((data) => new SalesIndustrialEntryModel.fromJson(data))
              .toList();
          // tcm.removeWhere((element) => element.status==0);
          filtertcm = tcm;
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
        throw Exception("Check your internet connection.");
      }
    }
  }

  getSalesEntryDataAll() async {
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["fullName"],
            "parameter1": "getSalesEntryData",
          },
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          tcm = (json.decode(response.data) as List)
              .map((data) => new SalesIndustrialEntryModel.fromJson(data))
              .toList();
          filtertcm = tcm;
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

  String _timeDiffernece(String entry_time, String exit_time) {
    var entry = DateFormat("HH:mm:ss").parse(entry_time.toString());
    var exit = DateFormat("HH:mm:ss").parse(exit_time.toString());

    var differ = exit.difference(entry);
    var data = DateFormat("HH:mm:ss").parse(differ.toString());
    var response = data.toString().split(" ")[1].split(".")[0].toString();
    // print(response);
    return response;
  }
}
