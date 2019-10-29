import 'dart:async';
import 'package:eaglebiz/model/UserLocationModel.dart';
import 'package:location/location.dart';

class LocationService {
  // Keep track of current Location
  UserLocationModel _currentLocation;
  Location location = Location();
  // Continuously emit location updates
  StreamController<UserLocationModel> _locationController = StreamController<UserLocationModel>.broadcast();

  LocationService() {
    location.requestPermission().then((granted) {
      if (granted) {
        location.onLocationChanged().listen((locationData) {
          if (locationData != null) {
            _locationController.add(UserLocationModel(
              latitude: locationData?.latitude??0.0,
              longitude: locationData?.longitude??0.0,
              timeGps: locationData.time,
            ));
          }
        });
      }
    });
  }

  Stream<UserLocationModel> get locationStream => _locationController.stream;

  Future<UserLocationModel> getLocation() async{
    try{
    var userlocation = await location.getLocation();
    _currentLocation=UserLocationModel(
        latitude: userlocation?.latitude??0.0,
        longitude: userlocation?.longitude??0.0,
        timeGps: userlocation.time
    );
    }catch(e){
      print('Could not get the location: $e');
    }
    return _currentLocation;
  }

}