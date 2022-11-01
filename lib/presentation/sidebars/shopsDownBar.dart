import 'dart:async';
import 'dart:io';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/domain/models/rewards_model.dart';
import 'package:flutter_application_1/domain/models/shop_model.dart';
import 'package:flutter_application_1/presentation/ArScreenAndroid/ArScreenAndroid.dart';
import 'package:flutter_application_1/presentation/ArScreenIos/arScreenIos.dart';
import 'package:flutter_application_1/presentation/errorDialogHendler/dialog.dart';
import 'package:flutter_application_1/presentation/sidebars/animation_helper.dart';
import 'package:flutter_application_1/presentation/sidebars/notificationSideBar.dart';
import 'package:flutter_application_1/presentation/widgets/shopsFlipCard.dart';
import 'package:flutter_application_1/services/localNotification.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/resources/assets_manager.dart';
import 'package:flutter_application_1/presentation/resources/color_manager.dart';
import 'package:flutter_application_1/presentation/resources/values_manager.dart';
import 'package:flutter_application_1/presentation/sidebars/profileSideBar.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ShopsDownBar extends StatefulWidget with ChangeNotifier {
  List<Geofence>? geofences;
  List<Shops>? shops;

  ShopsDownBar({Key? key, this.geofences, this.shops}) : super(key: key);
  bool _isOpen = false;
  get isOpen => _isOpen;
  //----- animation  function -----//
  void isProfileSideBarOpen() {
    if (_isOpen == false) {
      _isOpen = true;
    } else {
      _isOpen = false;
    }
    notifyListeners();
  }

  @override
  State<ShopsDownBar> createState() => _ShopsDownBarState();
}

class _ShopsDownBarState extends State<ShopsDownBar>
    with SingleTickerProviderStateMixin<ShopsDownBar> {
  late StreamController<bool> isOpenStreamController;
  late Stream<bool> isOpenNStream;
  late StreamSink<bool> isOpenNSink;
  late AnimationController _animationControler;
  final _animationDuration = const Duration(milliseconds: 500);
  List<Reward> rewards = [];
  int? idgroshop;

//-----------------------------geofencing services
  final _geofenceStreamController = StreamController<Geofence>();
  final geofenceService = GeofenceService.instance.setup(
      interval: 500,
      accuracy: 100,
      loiteringDelayMs: 6000,
      statusChangeDelayMs: 1000,
      useActivityRecognition: true,
      allowMockLocations: false,
      printDevLog: true,
      geofenceRadiusSortType: GeofenceRadiusSortType.DESC);
  Future<void> onGeofenceStatusChanged(
    Geofence geofence,
    GeofenceRadius geofenceRadius,
    GeofenceStatus geofenceStatus,
    Location location,
  ) async {
    print('geofence: ${geofence.status}');
    print('geofence: ${geofence.id}');

    if (geofence.status == GeofenceStatus.ENTER) {
      idgroshop = int.parse(geofence.id);
      await service.showNotification(id: 0, title: '', body: geofence.id);
    }
    _geofenceStreamController.sink.add(geofence);
  }

  void onError(error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      print('Undefined error: $error');
      return;
    }

    print('ErrorCode: $errorCode');
  }

//--------------------------------------------------------
  late final LocalNotificationService service;
  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();

    _animationControler =
        AnimationController(vsync: this, duration: _animationDuration);
    isOpenStreamController = PublishSubject<bool>();
    isOpenNStream = isOpenStreamController.stream;
    isOpenNSink = isOpenStreamController.sink;

    super.initState();
  }

  @override
  void dispose() {
    _animationControler.dispose();
    isOpenStreamController.close();
    isOpenNSink.close();
    _geofenceStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return StreamBuilder<bool>(
        initialData: false,
        stream: isOpenNStream,
        builder: (context, isOpenAsync) {
          return AnimatedPositioned(
            duration: _animationDuration,
            top: isOpenAsync.data == false ? height * 0.92 : height * 0.24,
            bottom: 0,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Align(
                  child: GestureDetector(
                    onTap: () async {
                      //   print(shops);
                      if (Provider.of<ShopsDownBar>(context, listen: false)
                              .isOpen ==
                          false) {
                        geofenceService.addGeofenceStatusChangeListener(
                            onGeofenceStatusChanged);
                        geofenceService.addStreamErrorListener(onError);
                        geofenceService.start(widget.geofences).catchError(
                            onError); //here i need the geofencing list
                      }
                      if (Provider.of<NotificationSideBar>(context,
                                      listen: false)
                                  .isOpen ==
                              false &&
                          Provider.of<ProfileSideBar>(context, listen: false)
                                  .isOpen ==
                              false) {
                        AnimationHelpers().onIconPressed(
                            _animationControler,
                            isOpenNSink,
                            context
                                .read<ShopsDownBar>()
                                .isProfileSideBarOpen());
                      }
                    },
                    child: Container(
                      //  alignment: Alignment.cen,
                      padding: const EdgeInsets.only(
                        left: AppMargin.m60,
                        right: AppMargin.m60,
                        top: AppMargin.m8,
                      ),
                      child: Icon(
                        isOpenAsync.data == true
                            ? Icons.close
                            : Icons.wallet_giftcard,
                        size: AppSize.S34,
                        color: ColorManager.primary,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppSize.S36),
                            topRight: Radius.circular(AppSize.S36)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(
                            left: AppMargin.m16, right: AppMargin.m16),
                        height: height / 1.5,
                        width: width,
                        decoration: BoxDecoration(
                          color: ColorManager.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(AppSize.S36),
                              topRight: Radius.circular(AppSize.s28)),
                        ),
                        child: ListView.builder(
                          itemCount: widget.shops?.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Cflip(
                            imagePath: ImageAssets.logo1,
                            shopid: widget.shops?[index].id,
                            shopName: widget.shops?[index].name,
                            details: widget.shops?[index].description,
                            address: widget.shops?[index].address,
                            rewardsList:
                                rewards.where((element) => false).toList(),
                            ontap: () {
                              if (idgroshop == widget.shops?[index].id) {
                                if (Platform.isIOS == true) {
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((_) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ArScreenios()),
                                    );
                                  });
                                } else if (Platform.isAndroid == true) {
                                  /*     Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AppArBody()),
                                  );*/
                                }
                              } else {
                                ErrorDialog2().showCustomDialog(
                                  context,
                                  "you have to be in the shop zone to redeem",
                                  'assets/json/location_error.json',
                                );
                              }
                            },
                            distance:
                                '${widget.shops?[index].distance.toString().substring(0, 5)} KM',
                          ),
                        ))),
              ],
            ),
          );
        });
  }
}
