import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:Ebiz/functionality/location/ChooseMapByType.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:dio/dio.dart';
import 'package:Ebiz/commonDrawer/CollapsingNavigationDrawer.dart';
import 'package:Ebiz/model/LocationModel.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class MapsActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ViewMapState();
  }
}

class _ViewMapState extends State<MapsActivity> {
  List<Marker> allocationListarkers = [];
  PageController _pageController;
  List<LocationModel> locationList = [];
  int prevPage;
  GoogleMapController _controller;
  Completer<GoogleMapController> _controllerCompleter = Completer();
  String _mapStyle;
  String result = "0", dataId, dataName;
  MediaQuery queryData;
  static Dio dio = Dio(Config.options);

  Set<Marker> _markers = {};
  // this will hold the generated polylines
  Set<Polyline> _polylines = {};
  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
  // this is the key object - the PolylinePoints
  // which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "AIzaSyBqgribdISpSb392mekKstHkm-bzC9GBTY";
  // for my custom icons
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  void checkServices() {
    if (result == "0") {
      _getuserLocations();
    } else if (result == "1") {
      _getuserLocationsByDepartment(dataId);
    } else if (result == "2") {
      _getUserLocationByUid(dataId);
    }
  }

  @override
  void initState() {
    super.initState();
    //  setSourceAndDestinationIcons();
    rootBundle.loadString('assets/map_style.txt').then((st) {
      _mapStyle = st;
    });
    checkServices();
  }

  

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      moveCamera();
    }
  }

  _employeesList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 650.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
          onTap: () {
            // moveCamera();
          },
          child: Stack(children: [
            Center(
                child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    height: 125.0,
                    width: 275.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0.0, 4.0),
                            blurRadius: 10.0,
                          ),
                        ]),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        child: Row(children: [
                          Container(
                              margin: EdgeInsets.only(
                                  top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                              height: 60.0,
                              width: 60.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0)),
                                  image: DecorationImage(
                                      image:
                                          AssetImage('assets/images/ebiz.png'),
                                      fit: BoxFit.cover))),
                          SizedBox(width: 5.0),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  locationList[index].u_profile_name,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  locationList[index].u_department,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  width: 160.0,
                                  child: Text(
                                    "Last seen: " +
                                            _lastSeenTime(locationList[index]
                                                .created_date) ??
                                        " ",
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                )
                              ])
                        ]))))
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Track",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.filter_list),
              onPressed: () async {
                var data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ChooseMapByType()));
                var res = data.split(" USR_")[0];
                dataId = data.split(" USR_")[1].split(" U_")[0];
                dataName = data.split(" USR_")[1].split(" U_")[1];

                if (res == "1") {
                  // polyCheck = false;
                  result = "1";
                  checkServices();
                } else if (res == "2") {
                  // polyCheck = true;
                  result = "2";
                  checkServices();
                } else {
                  // polyCheck = false;
                  result = "0";
                  checkServices();
                }
              },
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            // polyCheck
            //     ? Container(
            //         child: GoogleMap(
            //           compassEnabled: true,
            //           zoomGesturesEnabled: true,
            //           myLocationEnabled: true,
            //           polylines: _polylines,
            //           initialCameraPosition: CameraPosition(
            //               target: LatLng(17.6918918, 83.2011254), zoom: 10.0),
            //           // markers: Set.from(allocationListarkers),
            //           onMapCreated: mapCreated,
            //         ),
            //       )
            //     :
            Container(
              child: GoogleMap(
                compassEnabled: true,
                zoomGesturesEnabled: true,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                    target: LatLng(17.6918918, 83.2011254), zoom: 10.0),
                markers: Set.from(allocationListarkers),
                onMapCreated: mapCreated,
              ),
            ),
            // polyCheck
            //     ? Container()
            //     :
            Positioned(
              left: 1.0,
              bottom: 1.0,
              child: Container(
                height: 120.0,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: locationList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _employeesList(index);
                  },
                ),
              ),
            ),
            CollapsingNavigationDrawer("6"),
          ],
        ));
  }

  void mapCreated(controller) {
    setState(() {
      _controllerCompleter.complete(controller);
      _controller = controller;
      controller.setMapStyle(_mapStyle);
    });
  }

  moveCamera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: locationList[_pageController.page.toInt()].localCordinates,
        zoom: 10.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

  String _lastSeenTime(String datetime) {
    if (datetime.isNotEmpty) {
      var now = DateTime.now();
      List splitDateTime = datetime.split(" ");
      List splitTime = splitDateTime[1].toString().split(":");
      var lastSeenTime = DateFormat("yyyy-mm-dd HH:mm:ss").parse(datetime);
      var currentTime = DateFormat("yyyy-mm-dd HH:mm:ss").parse(now.toString());
      if (currentTime.difference(lastSeenTime).inSeconds <= 59) {
        return currentTime.difference(lastSeenTime).inSeconds.toString() +
            " sec ago ";
      } else if (currentTime.difference(lastSeenTime).inMinutes <= 60) {
        return currentTime.difference(lastSeenTime).inMinutes.toString() +
            " min ago ";
      } else if (currentTime.difference(lastSeenTime).inHours <= 24) {
        return currentTime.difference(lastSeenTime).inHours.toString() +
            " hours ago ";
      } else if (currentTime.difference(lastSeenTime).inDays <= 7) {
        if (currentTime.difference(lastSeenTime).inDays == 0) {
          return " yesterday at " +
              splitTime[0] +
              ":" +
              splitTime[1].toString();
        } else if (currentTime.difference(lastSeenTime).inDays == 1) {
          return currentTime.difference(lastSeenTime).inDays.toString() +
              " day ago ";
        } else {
          return currentTime.difference(lastSeenTime).inDays.toString() +
              " days ago ";
        }
      } else {
        return "at " +
            splitDateTime[0] +
            " " +
            splitTime[0] +
            ":" +
            splitTime[1].toString();
      }
    } else {
      return "--";
    }
  }

  _getuserLocations() async {
    allocationListarkers.clear();
    locationList.clear();
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["u_profile_name"],
            "parameter1": "getUserLocation"
          },
          options: Options(contentType: ContentType.parse("application/json")));
      if (response.statusCode == 200 || response.statusCode == 201) {
        List list = json.decode(response.data) as List;
        List<LocationModel> listModel = [];
        for (int i = 0; i < list.length; i++) {
          allocationListarkers.add(Marker(
            markerId:
                MarkerId(json.decode(response.data)[i]['uloc_id'].toString()),
            position: LatLng(
                double.parse(json.decode(response.data)[i]['lati']),
                double.parse(json.decode(response.data)[i]['longi'])),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
                title: json
                        .decode(response.data)[i]['u_profile_name'][0]
                        .toUpperCase() +
                    json
                        .decode(response.data)[i]['u_profile_name']
                        .substring(1),
                snippet: "last seen " +
                        _lastSeenTime(
                            json.decode(response.data)[i]['created_date']) ??
                    " "),
            draggable: false,
          ));

          listModel.add(LocationModel(
            uloc_id: json.decode(response.data)[i]['uloc_id'],
            localCordinates: LatLng(
                double.parse(json.decode(response.data)[i]['lati']),
                double.parse(json.decode(response.data)[i]['longi'])),
            u_department: json.decode(response.data)[i]['u_department'],
            created_date: json.decode(response.data)[i]['created_date'],
            u_profile_name: json
                    .decode(response.data)[i]['u_profile_name'][0]
                    .toUpperCase() +
                json.decode(response.data)[i]['u_profile_name'].substring(1),
            user_id: json.decode(response.data)[i]['user_id'],
          ));
        }
        if (listModel.length != 0) {
          setState(() {
            locationList = listModel;
          });
        } else {
          listModel.add(LocationModel(
            uloc_id: 1,
            u_department: "--",
            localCordinates: LatLng(17.6918918, 83.2011254),
            created_date: "",
            u_profile_name: "--",
            user_id: "1",
          ));
          setState(() {
            locationList = listModel;
          });
        }

        _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
          ..addListener(_onScroll);
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(msg: "Check your internet connection.");
        throw Exception("Connection Failure.");
      } else {
        Fluttertoast.showToast(msg: "Check your internet connection.");
        throw Exception('Connection Failure.');
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

  _getUserLocationByUid(String dataId) async {
    allocationListarkers.clear();
    locationList.clear();
    // latlngSegment1.clear();
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["u_profile_name"],
            "parameter1": "getUserLocationByID",
            "parameter2": dataId
          },
          options: Options(contentType: ContentType.parse("application/json")));
      if (response.statusCode == 200 || response.statusCode == 201) {
        List list = json.decode(response.data) as List;
        List<LocationModel> listModel = [];
        for (int i = 0; i < list.length; i++) {
          allocationListarkers.add(Marker(
            markerId:
                MarkerId(json.decode(response.data)[i]['uloc_id'].toString()),
            position: LatLng(
                double.parse(json.decode(response.data)[i]['lati']),
                double.parse(json.decode(response.data)[i]['longi'])),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
                title: json
                        .decode(response.data)[i]['u_profile_name'][0]
                        .toUpperCase() +
                    json
                        .decode(response.data)[i]['u_profile_name']
                        .substring(1),
                snippet: "last seen " +
                        _lastSeenTime(
                            json.decode(response.data)[i]['created_date']) ??
                    " "),
            draggable: false,
          ));

          // print("LatLong(" +
          //     double.parse(json.decode(response.data)[i]['lati']).toString() +
          //     " " +
          //     double.parse(json.decode(response.data)[i]['longi']).toString() +
          //     ")");

          // latlngSegment1.add(LatLng(
          //     double.parse(json.decode(response.data)[i]['lati']),
          //     double.parse(json.decode(response.data)[i]['longi'])));

          listModel.add(LocationModel(
            uloc_id: json.decode(response.data)[i]['uloc_id'],
            localCordinates: LatLng(
                double.parse(json.decode(response.data)[i]['lati']),
                double.parse(json.decode(response.data)[i]['longi'])),
            u_department: json.decode(response.data)[i]['u_department'],
            created_date: json.decode(response.data)[i]['created_date'],
            u_profile_name: json
                    .decode(response.data)[i]['u_profile_name'][0]
                    .toUpperCase() +
                json.decode(response.data)[i]['u_profile_name'].substring(1),
            user_id: json.decode(response.data)[i]['user_id'],
          ));
        }

        // _polylines.add(Polyline(
        //   polylineId: PolylineId('line1'),
        //   visible: true,
        //   //latlng is List<LatLng>
        //   points: latlngSegment1,
        //   color: Colors.blue,
        // ));
        // print(_polylines);
        if (listModel.length != 0) {
          setState(() {
            locationList = listModel;
          });
        } else {
          listModel.add(LocationModel(
            uloc_id: 1,
            u_department: "--",
            localCordinates: LatLng(17.6918918, 83.2011254),
            created_date: "",
            u_profile_name: dataName,
            user_id: "1",
          ));
          setState(() {
            locationList = listModel;
          });
        }
        _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
          ..addListener(_onScroll);
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(msg: "Check your internet connection.");
        throw Exception("Connection Failure.");
      } else {
        Fluttertoast.showToast(msg: "Check your internet connection.");
        throw Exception('Connection Failure.');
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

  _getuserLocationsByDepartment(String dataId) async {
    allocationListarkers.clear();
    locationList.clear();
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["u_profile_name"],
            "parameter1": "getUserLocationByDepartment",
            "parameter2": dataId
          },
          options: Options(contentType: ContentType.parse("application/json")));
      if (response.statusCode == 200 || response.statusCode == 201) {
        List list = json.decode(response.data) as List;
        List<LocationModel> listModel = [];
        for (int i = 0; i < list.length; i++) {
          allocationListarkers.add(Marker(
            markerId:
                MarkerId(json.decode(response.data)[i]['uloc_id'].toString()),
            position: LatLng(
                double.parse(json.decode(response.data)[i]['lati']),
                double.parse(json.decode(response.data)[i]['longi'])),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
                title: json
                        .decode(response.data)[i]['u_profile_name'][0]
                        .toUpperCase() +
                    json
                        .decode(response.data)[i]['u_profile_name']
                        .substring(1),
                snippet: "last seen " +
                        _lastSeenTime(
                            json.decode(response.data)[i]['created_date']) ??
                    " "),
            draggable: false,
          ));

          listModel.add(LocationModel(
            uloc_id: json.decode(response.data)[i]['uloc_id'],
            localCordinates: LatLng(
                double.parse(json.decode(response.data)[i]['lati']),
                double.parse(json.decode(response.data)[i]['longi'])),
            u_department: json.decode(response.data)[i]['u_department'],
            created_date: json.decode(response.data)[i]['created_date'],
            u_profile_name: json
                    .decode(response.data)[i]['u_profile_name'][0]
                    .toUpperCase() +
                json.decode(response.data)[i]['u_profile_name'].substring(1),
            user_id: json.decode(response.data)[i]['user_id'],
          ));
        }
        if (listModel.length != 0) {
          setState(() {
            locationList = listModel;
          });
        } else {
          listModel.add(LocationModel(
            uloc_id: 1,
            u_department: dataName,
            localCordinates: LatLng(17.6918918, 83.2011254),
            created_date: "",
            u_profile_name: "--",
            user_id: "1",
          ));
          setState(() {
            locationList = listModel;
          });
        }
        _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
          ..addListener(_onScroll);
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(msg: "Check your internet connection.");
        throw Exception("Connection Failure.");
      } else {
        Fluttertoast.showToast(msg: "Check your internet connection.");
        throw Exception('Connection Failure.');
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

  @override
  void dispose() {
    _pageController.removeListener(_onScroll);
    super.dispose();
  }
}
