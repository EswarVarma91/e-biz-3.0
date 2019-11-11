import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eaglebiz/functionality/travel/AddTravelRequest.dart';
import 'package:eaglebiz/main.dart';
import 'package:eaglebiz/model/TravelRequestListModel.dart';
import 'package:eaglebiz/myConfig/Config.dart';
import 'package:eaglebiz/myConfig/ServicesApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TravelRequestList extends StatefulWidget {
  @override
  _TravelRequestListState createState() => _TravelRequestListState();
}

class _TravelRequestListState extends State<TravelRequestList> {
  static Dio dio = Dio(Config.options);
  List<TravelRequestListModel> trlm = List();
  @override
  void initState() {
    super.initState();
    getTravelData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Travel Request',
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
          Container(

            child: ListView.builder(
              itemCount: trlm?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(left: 60, right: 5, top: 6),
                  child: StaggeredGridView.count(
                    crossAxisCount: 6,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 1, top: 1),
                        child: TravelRquestM(trlm[index]),
                      ),
                    ],
                    staggeredTiles: [
                      StaggeredTile.extent(4, 65.0),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  getTravelData() async {
    try {
      String url="http://192.168.2.5:8383/travel.service/travel/get/travel/request";

      var response = await dio.post(url,
          options: Options(
            contentType: ContentType.parse('application/json'),
          ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        trlm = (json.decode(response.data) as List)
            .map((data) => new TravelRequestListModel.fromJson(data))
            .toList();
        Fluttertoast.showToast(msg: trlm.toString());
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(msg: "Please check your internet connection.!");
      }

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

  Material TravelRquestM(TravelRequestListModel trlm) {
    return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Colors.white,
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Text(
                        trlm.reqNo,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: "Roboto",
                          color: lwtColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Text(
                        trlm.fullName,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: "Roboto",
                          color: lwtColor,
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
