import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:geofence_service/models/geofence.dart';
import 'package:geofence_service/models/geofence_radius.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../domain/models/shop_model.dart';

class ShopServices {
  List<Shops> shopsList = [];
  Dio dio = Dio();
  Future<List<Shops>?> fetchShops() async {
    try {
      Response response =
          await dio.get("https://dev-reward.groupado.com/reward/api/v1/shops");
      Shop responseShope = Shop.fromJson(response.data);

      return responseShope.data;
    } on DioError catch (e) {
      print(e);
      SnackBar(
        content: Text(e.response!.data['message']),
        backgroundColor: Colors.blueAccent,
      );
    }
    return null;
  }

  Future setShops(List shopList) async {
    Position position = await GeolocatorPlatform.instance.getCurrentPosition();

    fetchShops().then((value) {
      if (value != null) {
        for (int i = 0; i < value.length; i++) {
          shopList.add(Shops(
              id: value[i].id,
              userId: value[i].userId,
              typeId: value[i].typeId,
              name: value[i].name,
              description: value[i].description,
              address: value[i].address,
              status: value[i].status,
              createdAt: value[i].createdAt,
              updatedAt: value[i].updatedAt,
              marker: value[i].marker,
              distance: GeolocatorPlatform.instance.distanceBetween(
                    position.latitude,
                    position.longitude,
                    double.parse(value[i].marker.lat),
                    double.parse(value[i].marker.lng),
                  ) /
                  1000));
        }
      }

      shopList.sort((a, b) => a.distance.compareTo(b.distance));
    });
    return shopList;
  }

  Future setGeofenceShops(List geoList) async {
    fetchShops().then((value) {
      if (value != null) {
        for (int i = 0; i < value.length; i++) {
          geoList.add(Geofence(
            id: value[i].id.toString(),
            latitude: double.parse(value[i].marker.lat),
            longitude: double.parse(value[i].marker.lng),
            radius: [
              GeofenceRadius(id: 'radius_100m', length: 100),
            ],
          ));
        }
      }
    });
    return geoList;
  }
}

class NewShopServices {
  List<Shops> shopsList = [];
  List<Geofence> geofencingList = [];
  List<Marker> markerList = [];
  Dio dio = Dio();
  Future<List<Marker>> fetchShopsData(
      List shopsListF, geofencingListF, markerListF) async {
    Position position = await GeolocatorPlatform.instance.getCurrentPosition();
    try {
      Response response =
          await dio.get("https://dev-reward.groupado.com/reward/api/v1/shops");
      Shop responseShope = Shop.fromJson(response.data);
      if (markerListF.isEmpty == true) {
        for (int i = 0; i < responseShope.data.length; i++) {
          markerListF.add(Marker(
              //  icon: mapMarker,
              markerId: MarkerId(responseShope.data[i].typeId.toString()),
              position: LatLng(double.parse(responseShope.data[i].marker.lat),
                  double.parse(responseShope.data[i].marker.lng)),
              infoWindow: InfoWindow(
                  title: responseShope.data[i].name,
                  onTap: () {
                    print(
                        "this is the id of the marker $responseShope.data[i].id");
                  })));

          geofencingListF.add(Geofence(
            id: responseShope.data[i].id.toString(),
            latitude: double.parse(responseShope.data[i].marker.lat),
            longitude: double.parse(responseShope.data[i].marker.lng),
            radius: [
              GeofenceRadius(id: 'radius_100m', length: 10),
            ],
          ));

          shopsListF.add(Shops(
              id: responseShope.data[i].id,
              userId: responseShope.data[i].userId,
              typeId: responseShope.data[i].typeId,
              name: responseShope.data[i].name,
              description: responseShope.data[i].description,
              address: responseShope.data[i].address,
              status: responseShope.data[i].status,
              createdAt: responseShope.data[i].createdAt,
              updatedAt: responseShope.data[i].updatedAt,
              marker: responseShope.data[i].marker,
              distance: GeolocatorPlatform.instance.distanceBetween(
                    position.latitude,
                    position.longitude,
                    double.parse(responseShope.data[i].marker.lat),
                    double.parse(responseShope.data[i].marker.lng),
                  ) /
                  1000));
        }
        shopsListF.sort((a, b) => a.distance.compareTo(b.distance));
      }
    } on DioError catch (e) {
      SnackBar(
        content: Text(e.response!.data['message']),
        backgroundColor: Colors.blueAccent,
      );
    }
    return markerList;
  }
}
