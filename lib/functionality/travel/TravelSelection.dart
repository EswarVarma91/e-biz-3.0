import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:Ebiz/model/TravelCodesModel.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';

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
  List<TravelCodesModel> tcm, filtertcm = [];
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
  // final _debouncer = Debouncer( milliseconds: 500);
  TextEditingController _controllerCodes = TextEditingController();

  @override
  void initState() {
    super.initState();
    dynamicData = false;
    _controllerCodes.addListener(_textCount);

    // getAirportCodes();
  }

  _textCount() {
    if (_controllerCodes.text.length >= 2) {
      getAirportCodes();
      print(_controllerCodes.text);
    } else {
      if (tcm != null) {
        setState(() {
          tcm.clear();
          filtertcm.clear();
        });
      }
    }
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
          ? dynamicListView(context)
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
        return "Flight";
      } else if (res == "Train") {
        list = listTrainClassData;
        return "Train";
      } else if (res == "Bus") {
        list = listBusClassData;
        return "Bus";
      }
    } else if (mode == "5") {
      if (res == "Flight") {
        dynamicData = true;
      } else {
        dynamicData = false;
      }
      return "From (Source)";
    } else if (mode == "6") {
      if (res == "Flight") {
        dynamicData = true;
      } else {
        dynamicData = false;
      }
      return "To (Destination)";
    }
  }

  getAirportCodes() async {
    Response response = await dio.post(ServicesApi.getData,
        data: {
          "parameter1": "getAirportCodes",
          "parameter2": _controllerCodes.text + "%"
        },
        options: Options(
          contentType: ContentType.parse('application/json'),
        ));
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        tcm = (json.decode(response.data) as List)
            .map((data) => new TravelCodesModel.fromJson(data))
            .toList();
        filtertcm = tcm;
      });
      // print(tcm);
    }
  }

  dynamicListView(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: _controllerCodes,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                hintText: "Search",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
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
                      onTap: () {
                        Navigator.pop(
                            context,
                            filtertcm[index].stationCode +
                                " U_" +
                                filtertcm[index].stationId.toString());
                      },
                      title: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          filtertcm[index].stationCode.toString() +
                              ", " +
                              filtertcm[index].stationName,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      //                  trailing:Padding(padding:EdgeInsets.all(10),child: Text(fliterReferals[index].uId)),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
