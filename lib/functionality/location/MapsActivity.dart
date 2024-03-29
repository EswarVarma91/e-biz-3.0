import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:Ebiz/main.dart';
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
import 'package:intl/intl.dart' as intl;

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
  bool polyCheck = false;
  GoogleMapController con;
  Completer<GoogleMapController> _controllerCompleter = Completer();
  String _mapStyle;
  String result = "0", dataId, dataName;
  MediaQuery queryData;
  static Dio dio = Dio(Config.options);

  LatLng SOURCE_LOCATION = LatLng(17.6918918, 83.2011254);
  LatLng DEST_LOCATION = LatLng(17.6918918, 83.2011254);

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
    setSourceAndDestinationIcons();
    rootBundle.loadString('assets/map_style.txt').then((st) {
      _mapStyle = st;
    });
    checkServices();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/driving_pin.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
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
            width: Curves.easeInOut.transform(value) * 670.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
          onTap: () {
            moveCamera();
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
                                Row(
                                  children: <Widget>[
                                    Text(
                                      locationList[index].u_profile_name,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    locationList[index].battery != null
                                        ? Icon(
                                            Icons.battery_alert,
                                            color: lwtColor,
                                            size: 18,
                                          )
                                        : Container(),
                                    locationList[index].battery != null
                                        ? Text(
                                            locationList[index].battery ?? "",
                                            style: TextStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Container()
                                  ],
                                ),
                                Text(
                                  locationList[index].u_department,
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  width: 160.0,
                                  child: Text(
                                    _changeDateFormat(
                                            locationList[index].created_date) ??
                                        " ",
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // locationList[index].battery != null
                                //     ? Container(
                                //         width: 160.0,
                                //         child: Text(
                                //           locationList[index].battery ??
                                //               "" + " %" ??
                                //               " ",
                                //           style: TextStyle(
                                //               fontSize: 11.0,
                                //               fontWeight: FontWeight.bold),
                                //         ),
                                //       )
                                //     : Container()
                              ]),
                        ])))),
          ])),
    );
  }

  _changeDateFormat(String _date) {
    if (_date != null && _date != "") {
      var __date =
          intl.DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.parse(_date));
      return __date;
    } else {
      return "--";
    }
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
                  polyCheck = false;
                  result = "1";
                  checkServices();
                } else if (res == "2") {
                  polyCheck = true;
                  result = "2";
                  checkServices();
                } else {
                  polyCheck = false;
                  result = "0";
                  checkServices();
                }
              },
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            polyCheck
                ? Container(
                    child: GoogleMap(
                        myLocationEnabled: true,
                        compassEnabled: true,
                        tiltGesturesEnabled: false,
                        zoomGesturesEnabled: true,
                        markers: Set.from(allocationListarkers),
                        polylines: _polylines,
                        mapType: MapType.normal,
                        initialCameraPosition:
                            CameraPosition(target: SOURCE_LOCATION, zoom: 4),
                        onMapCreated: mapCreatedPoints),
                  )
                : Container(
                    child: GoogleMap(
                        myLocationEnabled: true,
                        compassEnabled: true,
                        tiltGesturesEnabled: false,
                        zoomGesturesEnabled: true,
                        markers: Set.from(allocationListarkers),
                        mapType: MapType.normal,
                        initialCameraPosition:
                            CameraPosition(target: SOURCE_LOCATION, zoom: 10),
                        onMapCreated: mapCreated),
                  ),
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
            polyCheck
                ? SafeArea(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(280, 440, 10, 10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                                width: 10,
                                child: Container(
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                "Started",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                                width: 10,
                                child: Container(
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                "Ended",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 10)
                        ],
                      ),
                    ),
                  )
                : Container(),
            CollapsingNavigationDrawer("6"),
          ],
        ));
  }

  void mapCreated(GoogleMapController controller) {
    setState(() {
      _controllerCompleter.complete(controller);
      con = controller;
      controller.setMapStyle(_mapStyle);
      // polyCheck ? setMapPins() : check();
      // polyCheck ? setPolylines() : check();
    });
  }

  void mapCreatedPoints(GoogleMapController controller) {
    setState(() {
      _controllerCompleter.complete(controller);
      con = controller;
      controller.setMapStyle(_mapStyle);
      setMapPins();
      setPolylines();
    });
  }

  void setMapPins() {
    setState(() {
      // source pin
      allocationListarkers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: SOURCE_LOCATION,
          icon: sourceIcon));
      // destination pin
      allocationListarkers.add(Marker(
          markerId: MarkerId('destPin'),
          position: DEST_LOCATION,
          icon: destinationIcon));
    });
  }

  setPolylines() async {
    _polylines.clear();
    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
        googleAPIKey,
        SOURCE_LOCATION.latitude,
        SOURCE_LOCATION.longitude,
        DEST_LOCATION.latitude,
        DEST_LOCATION.longitude);
    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    // print(polylineCoordinates);

    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Colors.grey,
          points: polylineCoordinates);
      _polylines.add(polyline);
    });
  }

  moveCamera() {
    con.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: locationList[_pageController.page.toInt()].localCordinates,
      zoom: 15.0,
    )));
  }

  // String _lastSeenTime(String datetime) {
  //   if (datetime.isNotEmpty) {
  //     var now = DateTime.now();
  //     List splitDateTime = datetime.split(" ");
  //     List splitTime = splitDateTime[1].toString().split(":");
  //     var lastSeenTime = intl.DateFormat("yyyy-mm-dd HH:mm:ss").parse(datetime);
  //     var currentTime =
  //         intl.DateFormat("yyyy-mm-dd HH:mm:ss").parse(now.toString());
  //     if (currentTime.difference(lastSeenTime).inSeconds <= 59) {
  //       return currentTime.difference(lastSeenTime).inSeconds.toString() +
  //           " sec ago ";
  //     } else if (currentTime.difference(lastSeenTime).inMinutes <= 60) {
  //       return currentTime.difference(lastSeenTime).inMinutes.toString() +
  //           " min ago ";
  //     } else if (currentTime.difference(lastSeenTime).inHours <= 24) {
  //       return currentTime.difference(lastSeenTime).inHours.toString() +
  //           " hours ago ";
  //     } else if (currentTime.difference(lastSeenTime).inDays <= 7) {
  //       if (currentTime.difference(lastSeenTime).inDays == 0) {
  //         return " yesterday at " +
  //             splitTime[0] +
  //             ":" +
  //             splitTime[1].toString();
  //       } else if (currentTime.difference(lastSeenTime).inDays == 1) {
  //         return currentTime.difference(lastSeenTime).inDays.toString() +
  //             " day ago ";
  //       } else {
  //         return currentTime.difference(lastSeenTime).inDays.toString() +
  //             " days ago ";
  //       }
  //     } else {
  //       return "at " +
  //           splitDateTime[0] +
  //           " " +
  //           splitTime[0] +
  //           ":" +
  //           splitTime[1].toString();
  //     }
  //   } else {
  //     return "--";
  //   }
  // }

  _getuserLocations() async {
    allocationListarkers.clear();
    locationList.clear();
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["u_profile_name"],
            "parameter1": "getUserLocation"
          },
         );
      if (response.statusCode == 200 || response.statusCode == 201) {
        List list = json.decode(response.data) as List;
        List<LocationModel> listModel = [];
        if (list.length != 0) {
          setState(() {
            SOURCE_LOCATION = LatLng(
                double.parse(json.decode(response.data)[0]['lati']),
                double.parse(json.decode(response.data)[0]['longi']));
            // print(SOURCE_LOCATION);
            DEST_LOCATION = LatLng(
                double.parse(
                    json.decode(response.data)[list.length - 1]['lati']),
                double.parse(
                    json.decode(response.data)[list.length - 1]['longi']));
            // print(DEST_LOCATION);
          });
        } else {}
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
                snippet: _changeDateFormat(
                        json.decode(response.data)[i]['created_date']) ??
                    " "),
            draggable: false,
          ));
          // print(json.decode(response.data)[i]['u_profile_name'][0].toUpperCase() +json.decode(response.data)[i]['u_profile_name'].substring(1));

          listModel.add(LocationModel(
              uloc_id: json.decode(response.data)[i]['uloc_id'] ?? "",
              localCordinates: LatLng(
                  double.parse(json.decode(response.data)[i]['lati'] ?? 0.0),
                  double.parse(json.decode(response.data)[i]['longi'])),
              u_department: json.decode(response.data)[i]['u_department'],
              created_date: json.decode(response.data)[i]['created_date'],
              u_profile_name: json
                      .decode(response.data)[i]['u_profile_name'][0]
                      .toUpperCase() +
                  json.decode(response.data)[i]['u_profile_name'].substring(1),
              battery: json.decode(response.data)[i]['battery']));
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
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["u_profile_name"],
            "parameter1": "getUserLocationByID",
            "parameter2": dataId
          },
          );
      if (response.statusCode == 200 || response.statusCode == 201) {
        List list = json.decode(response.data) as List;
        List<LocationModel> listModel = [];
        if (list.length != 0) {
          setState(() {
            SOURCE_LOCATION = LatLng(
                double.parse(json.decode(response.data)[0]['lati']),
                double.parse(json.decode(response.data)[0]['longi']));
            // print(SOURCE_LOCATION);
            DEST_LOCATION = LatLng(
                double.parse(
                    json.decode(response.data)[list.length - 1]['lati']),
                double.parse(
                    json.decode(response.data)[list.length - 1]['longi']));
            // print(DEST_LOCATION);
          });
        } else {}

        for (int i = 0; i < list.length; i++) {
          final Uint8List markerIcon =
              await getBytesFromCanvas(200, 100, i, list.length);
          allocationListarkers.add(Marker(
            markerId:
                MarkerId(json.decode(response.data)[i]['uloc_id'].toString()),
            position: LatLng(
                double.parse(json.decode(response.data)[i]['lati']),
                double.parse(json.decode(response.data)[i]['longi'])),
            icon: BitmapDescriptor.fromBytes(markerIcon),
            infoWindow: InfoWindow(
                title: json
                        .decode(response.data)[i]['u_profile_name'][0]
                        .toUpperCase() +
                    json
                        .decode(response.data)[i]['u_profile_name']
                        .substring(1) +
                    " ",
                snippet: _changeDateFormat(
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
            battery: json.decode(response.data)[i]['battery'],
          ));
        }
        //   for(int i=0;i<list.length;i++){
        //   int j=i+1;
        //   print(json.decode(response.data)[i]['lati']+", "+json.decode(response.data)[i]['longi'] + " destination "+
        //   json.decode(response.data)[j]['lati']+", "+json.decode(response.data)[j]['longi']);
        // }
        // setMapPins();
        // setPolylines();

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
          ));
          setState(() {
            locationList = listModel;
          });
        }
        moveCamera();
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
          );
      if (response.statusCode == 200 || response.statusCode == 201) {
        List list = json.decode(response.data) as List;
        List<LocationModel> listModel = [];

        if (list.length != 0) {
          setState(() {
            SOURCE_LOCATION = LatLng(
                double.parse(json.decode(response.data)[0]['lati']),
                double.parse(json.decode(response.data)[0]['longi']));
            // print(SOURCE_LOCATION);
            DEST_LOCATION = LatLng(
                double.parse(
                    json.decode(response.data)[list.length - 1]['lati']),
                double.parse(
                    json.decode(response.data)[list.length - 1]['longi']));
            // print(DEST_LOCATION);
          });
        } else {}
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
                snippet: _changeDateFormat(
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
            battery: json.decode(response.data)[i]['battery'],
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
          ));
          setState(() {
            locationList = listModel;
          });
        }
        moveCamera();
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

  Future<Uint8List> getBytesFromCanvas(
      int width, int height, int i, int length) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    Paint paint;
    int value = i + 1;
    int finalValue = length - 1;
    if (finalValue == i) {
      paint = Paint()..color = Colors.red;
    } else {
      paint = Paint()..color = value == 1 ? Colors.green : Colors.grey;
    }
    final Radius radius = Radius.circular(60.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(10, 0.9, width * 0.3, height * 0.4),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);

    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: value.toString(),
      style: TextStyle(
          fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.bold),
    );
    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.2) - painter.width * 0.2,
            (height * 0.2) - painter.height * 0.2));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return data.buffer.asUint8List();
  }
}
