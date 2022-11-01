import 'dart:async';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/notificatin_model.dart';
import 'package:flutter_application_1/presentation/resources/color_manager.dart';
import 'package:flutter_application_1/presentation/resources/values_manager.dart';
import 'package:flutter_application_1/presentation/sidebars/animation_helper.dart';
import 'package:flutter_application_1/presentation/sidebars/profileSideBar.dart';
import 'package:flutter_application_1/presentation/sidebars/shopsDownBar.dart';
import 'package:flutter_application_1/presentation/widgets/notificationWidget.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class NotificationSideBar extends StatefulWidget with ChangeNotifier {
  String? badgecount;
  List<NotificationModel>? notificationlist;
  NotificationSideBar({Key? key, this.badgecount, this.notificationlist})
      : super(key: key);

  bool _isOpen = false;
  //this is the getter for the Provider to get the value of _isOpen
  get isOpen => _isOpen;
  void isProfileSideBarOpen() {
    if (_isOpen == false) {
      _isOpen = true;
    } else {
      _isOpen = false;
    }
    notifyListeners();
  }

  @override
  State<NotificationSideBar> createState() => _NotificationSideBarState();
}

class _NotificationSideBarState extends State<NotificationSideBar>
    with SingleTickerProviderStateMixin<NotificationSideBar> {
  late StreamController<bool> isOpenStreamController;
  late Stream<bool> isOpenNStream;
  late StreamSink<bool> isOpenNSink;
  late AnimationController _animationControler;
  final _animationDuration = const Duration(milliseconds: 500);
  void onIconPressed() {
    final animationStatus = _animationControler.status;
    final isAnimationDone = animationStatus == AnimationStatus.completed;
    if (isAnimationDone) {
      isOpenNSink.add(false);
      _animationControler.reverse();
      context.read<NotificationSideBar>().isProfileSideBarOpen();
    } else {
      isOpenNSink.add(true);
      _animationControler.forward();
      context.read<NotificationSideBar>().isProfileSideBarOpen();
    }
  }

  @override
  void initState() {
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
            top: 20,
            bottom: 0,
            right: isOpenAsync.data == false ? AppSize.s1_5 : AppSize.s1_5,
            left: isOpenAsync.data == false ? width * 0.85 : width * 0.15,
            child: Row(
              children: [
                Align(
                  alignment: const Alignment(AppSize.s1_5, -0.8),
                  child: GestureDetector(
                    onTap: () {
                      if (Provider.of<ProfileSideBar>(context, listen: false)
                                  .isOpen ==
                              false &&
                          Provider.of<ShopsDownBar>(context, listen: false)
                                  .isOpen ==
                              false) {
                        AnimationHelpers().onIconPressed(
                            _animationControler,
                            isOpenNSink,
                            context
                                .read<NotificationSideBar>()
                                .isProfileSideBarOpen());
                      }
                    },
                    child: Container(
                      width: width / 8,
                      height: height / 6,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(right: AppPadding.p20),
                      child: Badge(
                        badgeContent: Text(
                          "${widget.badgecount}",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                        child: Icon(
                          isOpenAsync.data == true
                              ? Icons.close
                              : Icons.notifications,
                          size: AppSize.S34,
                          color: ColorManager.primary,
                        ),
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(AppSize.S36),
                            topLeft: Radius.circular(AppSize.S36)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: height / 1.24,
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(AppSize.S30)),
                    ),
                    child: Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.notificationlist?.length ?? 0,
                            itemBuilder: (context, index) {
                              return NotificatinWidget(
                                  title:
                                      "${widget.notificationlist?.elementAt(index).title}",
                                  message:
                                      "${widget.notificationlist?.elementAt(index).body}");
                            }),
                        Container(
                          margin: const EdgeInsets.only(
                              top: AppPadding.p20,
                              left: AppPadding.p20,
                              right: AppPadding.p20),
                          child: ElevatedButton(
                              onPressed: () {
                                widget.notificationlist?.clear();
                                setState(() {
                                  widget.badgecount = "0";
                                });
                              },
                              child: const Text('delete all')),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
