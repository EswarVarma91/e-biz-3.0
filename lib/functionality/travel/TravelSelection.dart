import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eaglebiz/model/TaskListModel.dart';
import 'package:eaglebiz/model/TravelCodesModel.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TravelSelection extends StatefulWidget {
  String mode, res;
  TravelSelection(this.mode, this.res);

  @override
  _TravelSelectionState createState() =>
      _TravelSelectionState(this.mode, this.res);
}

class _TravelSelectionState extends State<TravelSelection> {
  Dio dio = Dio(Config.options);
  String mode, res;
  bool dynamicData;
  String airportCodes;
  List<TravelCodesModel> tcm;
  _TravelSelectionState(this.mode, this.res);
  List<String> listModeData = ['Flight', 'Train', 'Bus'];
  List<String> listModeTypeData = ['Domestic', 'International'];
  List<String> listTrainClassData = [
    '1AC',
    '2AC',
    '3AC',
    'CC',
    'Sleeper',
    '2S',
    'FC',
    'EC'
  ];
  List<String> listBusClassData = ['Sleeper', 'Semi-Sleeper', 'Non-AC'];
  List<String> listFlightClassData = ['Business', 'Economy'];
  List<String> list;

  @override
  void initState() {
    super.initState();
    dynamicData = false;
  
    // getAirportCodes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          checkMode(mode),
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: dynamicData
          ? Container()
          : ListView.builder(
              itemCount: list?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Card(
                    elevation: 5.0,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(list[index].toString()),
                          onTap: () {
                            Navigator.pop(context, list[index]);
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  checkMode(String mode) {
    if (mode == "1") {
      return "Traveller Name";
    } else if (mode == "2") {
      list = listModeData;
      return "Select Mode";
    } else if (mode == "3") {
      list = listModeTypeData;
      return "Mode Type";
    } else if (mode == "4") {
      if (res == "Flight") {
        list = listFlightClassData;
      } else if (res == "Train") {
        list = listTrainClassData;
      } else if (res == "Bus") 
        list = listBusClassData;
      return "Bus";
    } else if (mode == "5") {
      return "From";
    } else if (mode == "6") {
      return "To";
    } else if(mode=="7"){
      return "OA/Complaint Ticket No.";
    } 
  }

  void getAirportCodes() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      airportCodes = preferences.getString("airportCodes");
    });
    if (airportCodes == null) {
      Response response = await dio
          .post(ServicesApi.getData, data: {"parameter1": "getAirportCodes"},
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        tcm = (json.decode(response.data) as List)
            .map((data) => new TravelCodesModel.fromJson(data))
            .toList();
        print(tcm);
      }
    } else {}
  }
}

