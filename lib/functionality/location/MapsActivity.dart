import 'dart:async';
import 'package:dio/dio.dart';
import 'package:Ebiz/commonDrawer/CollapsingNavigationDrawer.dart';
import 'package:Ebiz/functionality/location/LocationService.dart';
import 'package:Ebiz/model/LocationModel.dart';
import 'package:Ebiz/model/UserLocationModel.dart';
import 'package:Ebiz/myConfig/Config.dart';
import 'package:flutter/material.dart';
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
  static double lati, longi;
  var userlocation;
  List<Marker> allmarkers = new List();
  List<LocationModel> lm = new List();
  Completer<GoogleMapController> _controller = Completer();
  static Dio dio = Dio(Config.options);
  bool mapDisplay = false;
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    //  _getuserLocations();
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
            icon: Icon(Icons.view_list),
            onPressed: () {},
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
          " sec ago";
    } else if (currentTime.difference(lastSeenTime).inMinutes <= 60) {
      return currentTime.difference(lastSeenTime).inMinutes.toString() +
          " min ago";
    } else if (currentTime.difference(lastSeenTime).inHours <= 24) {
      return currentTime.difference(lastSeenTime).inHours.toString() +
          " hours ago";
    } else if (currentTime.difference(lastSeenTime).inDays <= 7) {
      if (currentTime.difference(lastSeenTime).inDays == 0) {
        return "yesterday at" + splitTime[0] + ":" + splitTime[1].toString();
      } else if (currentTime.difference(lastSeenTime).inDays == 1) {
        return currentTime.difference(lastSeenTime).inDays.toString() +
            " day ago";
      } else {
        return currentTime.difference(lastSeenTime).inDays.toString() +
            " days ago";
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

  //   _getuserLocations() async {
  //    try {
  //      var response = await dio.post(ServicesApi.emp_Data,
  //          data: {
  //            "actionMode": "getUserLocation"
  //          },
  //          options: Options(responseType: ResponseType.json,
  //          ));
  //      if (response.statusCode == 200 || response.statusCode == 201) {
  //        setState(()  {
  //          List responseJson = response.data;
  //          lm = responseJson.map((m) => new LocationModel.fromJson(m)).toList();
  //        });
  //        for (int i = 0; i < lm.length; i++) {
  //          setState(() {
  //            allmarkers.add(Marker(markerId: MarkerId("marker"),
  //              position: LatLng(double.parse(lm[i].lati.substring(0,10)), double.parse(lm[i].longi.substring(0,10))),
  //              icon: BitmapDescriptor.defaultMarker,
  //              infoWindow: InfoWindow(title: lm[i].u_profile_name[0].toUpperCase()+lm[i].u_profile_name.substring(1),snippet: "last seen "+_lastSeenTime(lm[i].created_date)),
  //              draggable: false,
  //            ));
  //          });

  //        }
  //      } else if (response.statusCode == 401) {
  //        Fluttertoast.showToast(msg: "Incorrect Email/Password");
  //        throw Exception("Incorrect Email/Password");
  //      } else {

  //        Fluttertoast.showToast(msg: "Incorrect Email/Password");
  //        throw Exception('Authentication Error');
  //      }
  //    } on DioError catch (exception) {
  //      if (exception == null ||
  //          exception.toString().contains('SocketException')) {
  //        throw Exception("Network Error");
  //      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
  //          exception.type == DioErrorType.CONNECT_TIMEOUT) {
  //        throw Exception(
  //            "Could'nt connect, please ensure you have a stable network.");
  //      } else {
  //        return null;
  //      }
  //    }
  //  }

}
