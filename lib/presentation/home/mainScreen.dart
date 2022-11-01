import 'dart:async';
import 'package:badges/badges.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_prefs.dart';
import 'package:flutter_application_1/app/di.dart';
import 'package:flutter_application_1/app/functions.dart';
import 'package:flutter_application_1/domain/models/shop_model.dart';
import 'package:flutter_application_1/presentation/sidebars/shopsDownBar.dart';
import 'package:flutter_application_1/presentation/splash/splash.dart';
import 'package:flutter_application_1/services/localNotification.dart';
import 'package:flutter_application_1/services/shop_services.dart';
import 'package:flutter_application_1/presentation/sidebars/notificationSideBar.dart';
import 'package:flutter_application_1/presentation/sidebars/profileSideBar.dart';
import 'package:geofence_service/models/geofence.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import '../../domain/models/notificatin_model.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final LocalNotificationService service;
  final loctionServices _services = instance<loctionServices>();

//----------------current position of user-------------------------

  Future<LatLng?> getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });

    return currentPostion;
  }

  List<Shops> shopsList = [];
  List<Geofence> geofencingList = [];
  List<Marker> markerList = [];
  AppPreferences _appPreferences = instance<AppPreferences>();
  late final FirebaseMessaging _messaging;
  LatLng? currentPostion;
  late int _counter = 0;
  bool test = false;
  NotificationModel? notificationInfo;
  List<NotificationModel> notificationList = [];
  GoogleMapController? _googleMapController;
  //----------------------------firebase services-----------------
  void registerNotification() async {
    await Firebase.initializeApp();
    //instatiate firebase messaging
    _messaging = FirebaseMessaging.instance;
    //notification settings
    NotificationSettings settings = await _messaging.requestPermission(
        alert: true, badge: true, sound: true, provisional: false);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        NotificationModel notification = NotificationModel(
            body: message.notification!.body,
            title: message.notification!.title,
            dataBody: message.data["title"],
            dataTitle: message.data["body"]);
        setState(() {
          _counter++;

          notificationInfo = notification;
          notificationList.add(notification);
          print(notificationList.length);
        });
        showSimpleNotification(
          Text(notificationInfo!.title!),
          background: Colors.red,
          duration: const Duration(seconds: 2),
          trailing: const Icon(Icons.notifications),
          leading: Badge(
            badgeContent: Text(
              _counter.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            child: const Icon(Icons.notifications),
          ),
        );
      });
    } else {
      print("notification not allowed");
    }
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();

    Future.delayed(Duration.zero, () {
      setState(() {});
    });
    registerNotification();
    getUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
        child: MaterialApp(
      home: Scaffold(
        body: Stack(children: [
          FutureBuilder<List<Marker>>(
              future: NewShopServices()
                  .fetchShopsData(shopsList, geofencingList, markerList),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GoogleMap(
                    myLocationEnabled: true,
                    markers: Set<Marker>.of(markerList),
                    initialCameraPosition: const CameraPosition(
                        target: LatLng(36.8, 10.5), zoom: 15),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
          NotificationSideBar(
            badgecount: _counter.toString(),
            notificationlist: notificationList,
          ),
          ProfileSideBar(),
          ShopsDownBar(
            geofences: geofencingList,
            shops: shopsList,
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.05,
              margin: const EdgeInsets.only(top: 25),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _appPreferences.setIsUserLoggedOut();
                      await _appPreferences.setToken("");
                      await _appPreferences.setId(0);
                      await _appPreferences.setEmail('');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashView()));
                    },
                    child: const Text("All"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    child: const Text("food"),
                    onPressed: () {},
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("It"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _appPreferences.getToken();
                    },
                    child: const Text("clothes"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //    print(markerList.length);
                    },
                    child: const Text("Spa"),
                  ),
                ],
              )),
        ]),
      ),
    ));
  }
}
