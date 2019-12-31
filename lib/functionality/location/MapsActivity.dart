import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:Ebiz/functionality/location/ChooseMapByType.dart';
import 'package:Ebiz/myConfig/ServicesApi.dart';
import 'package:dio/dio.dart';
import 'package:Ebiz/commonDrawer/CollapsingNavigationDrawer.dart';
import 'package:Ebiz/functionality/location/LocationService.dart';
import 'package:Ebiz/model/LocationModel.dart';
import 'package:Ebiz/model/UserLocationModel.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class MapsActivity extends StatefulWidget {
  @override
  _MapsActivityState createState() => _MapsActivityState();
}

class _MapsActivityState extends State<MapsActivity> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocationModel>(
      builder: (context) => LocationService().locationStream,
      child: ViewMap(),
    );
  }
}

class ViewMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ViewMapState();
  }
}

class _ViewMapState extends State<ViewMap> {
  static double lati = 17.6918918, longi = 83.2011254;
  var userlocation;
  List<Marker> allmarkers = new List();
  List<LocationModel> lm = new List();
  Completer<GoogleMapController> _controller = Completer();
  static Dio dio = Dio(Config.options);
  bool mapDisplay = false;
  ProgressDialog pr;
  String result ="0", dataId;

  @override
  void initState() {
    super.initState();
    checkServices();
    // _getuserLocations();
  }

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
  Widget build(BuildContext context) {
    userlocation = Provider.of<UserLocationModel>(context);
    if (userlocation != null) {
      setState(() {
        mapDisplay = true;
        lati = userlocation?.latitude ?? 0.0;
        longi = userlocation?.longitude ?? 0.0;
      });
    }

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
              print(data);
              var res = data.split(" USR_")[0];
              dataId = data.split(" USR_")[1];

              if (res == "1") {
                result = "1";
                checkServices();
              } else if (res == "2") {
                result = "2";
                checkServices();
              } else {
                result = "0";
                checkServices();
              }
            },
          )
        ],
      ),
      body: Stack(children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 0, right: 0, top: 0),
          child: GoogleMap(
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              myLocationEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: LatLng(lati, longi), zoom: 8),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: Set.from(allmarkers)),
        ),
        CollapsingNavigationDrawer("6"),
      ]),
    );
  }

  String _lastSeenTime(String datetime) {
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
        return " yesterday at " + splitTime[0] + ":" + splitTime[1].toString();
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
  }

  _getuserLocations() async {
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["u_first_name"],
            "parameter1": "getUserLocation"
          },
          options: Options(contentType: ContentType.parse("application/json")));
      if (response.statusCode == 200 || response.statusCode == 201) {
        lm = (json.decode(response.data) as List)
            .map((data) => new LocationModel.fromJson(data))
            .toList();

        for (int i = 0; i < lm.length; i++) {
          setState(() {
            allmarkers.add(Marker(
              markerId: MarkerId(lm[i].uloc_id.toString()),
              position:
                  LatLng(double.parse(lm[i].lati), double.parse(lm[i].longi)),
              icon: BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(
                  title: lm[i].u_profile_name[0].toUpperCase() +
                      lm[i].u_profile_name.substring(1),
                  snippet: "last seen " + _lastSeenTime(lm[i].created_date)),
              draggable: false,
            ));
          });
        }
        print(allmarkers);
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
    allmarkers.clear();
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["u_first_name"],
            "parameter1": "getUserLocationByID",
            "parameter2": dataId
          },
          options: Options(contentType: ContentType.parse("application/json")));
      if (response.statusCode == 200 || response.statusCode == 201) {

        lm = (json.decode(response.data) as List)
            .map((data) => new LocationModel.fromJson(data))
            .toList();

        for (int i = 0; i < lm.length; i++) {
          setState(() {
            allmarkers.add(Marker(
              markerId: MarkerId(lm[i].uloc_id.toString()),
              position:
                  LatLng(double.parse(lm[i].lati), double.parse(lm[i].longi)),
              icon: BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(
                  title: lm[i].u_profile_name[0].toUpperCase() +
                      lm[i].u_profile_name.substring(1),
                  snippet: "last seen " + _lastSeenTime(lm[i].created_date)),
              draggable: false,
            ));
          });
        }
        print(allmarkers);
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
    allmarkers.clear();
    try {
      var response = await dio.post(ServicesApi.getData,
          data: {
            "encryptedFields": ["u_first_name"],
            "parameter1": "getUserLocationByDepartment",
            "parameter2": dataId
          },
          options: Options(contentType: ContentType.parse("application/json")));
      if (response.statusCode == 200 || response.statusCode == 201) {

        lm = (json.decode(response.data) as List)
            .map((data) => new LocationModel.fromJson(data))
            .toList();

        for (int i = 0; i < lm.length; i++) {
          setState(() {
            allmarkers.add(Marker(
              markerId: MarkerId(lm[i].uloc_id.toString()),
              position:
                  LatLng(double.parse(lm[i].lati), double.parse(lm[i].longi)),
              icon: BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(
                  title: lm[i].u_profile_name[0].toUpperCase() +
                      lm[i].u_profile_name.substring(1),
                  snippet: "last seen " + _lastSeenTime(lm[i].created_date)),
              draggable: false,
            ));
          });
        }
        print(allmarkers);
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
}
