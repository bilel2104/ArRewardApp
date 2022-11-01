import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class loctionServices {
  late LatLng userLocation;
  // check the permission to access the divce location
  Future<Position> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    // check if the location service is enabled
    serviceEnabled =
        await GeolocatorPlatform.instance.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    // check the permission to access the location
    permission = await GeolocatorPlatform.instance.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.denied) {
      permission = await GeolocatorPlatform.instance.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await GeolocatorPlatform.instance.getCurrentPosition();
  }

  getUserLocation(LatLng location) async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
    location = LatLng(position.latitude, position.longitude);

    return location;
  }
}
