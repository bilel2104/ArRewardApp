import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/user_Model.dart';
import 'package:flutter_application_1/presentation/resources/color_manager.dart';
import 'package:flutter_application_1/presentation/resources/values_manager.dart';
import 'package:flutter_application_1/presentation/sidebars/animation_helper.dart';
import 'package:flutter_application_1/presentation/sidebars/notificationSideBar.dart';
import 'package:flutter_application_1/presentation/sidebars/shopsDownBar.dart';
import 'package:flutter_application_1/services/profile_services.dart';
import 'package:provider/src/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSideBar extends StatefulWidget with ChangeNotifier {
  ProfileSideBar({Key? key}) : super(key: key);
  bool _isOpen = false;

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
  State<ProfileSideBar> createState() => _ProfileSideBarState();
}

class _ProfileSideBarState extends State<ProfileSideBar>
    with SingleTickerProviderStateMixin<ProfileSideBar> {
  bool editProfile = false;
  late StreamController<bool> isOpenStreamController;
  late Stream<bool> isOpenStream;
  late StreamSink<bool> isOpenSink;
  late AnimationController _animationControler;
  User? _user;

  final _animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    _animationControler =
        AnimationController(vsync: this, duration: _animationDuration);
    isOpenStreamController = PublishSubject<bool>();
    isOpenStream = isOpenStreamController.stream;
    isOpenSink = isOpenStreamController.sink;
    super.initState();
  }

  String? userId;
  String? token;
  Future tokenandid(userif, aaa) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userif = prefs.getInt('id').toString();
    aaa == prefs.getString('token');
  }

  @override
  void dispose() {
    _animationControler.dispose();
    isOpenStreamController.close();
    isOpenSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return StreamBuilder<bool>(
        initialData: false,
        stream: isOpenStream,
        builder: (context, isOpenAsync) {
          return AnimatedPositioned(
            duration: _animationDuration,
            top: 20,
            bottom: AppSize.s1_5,
            left: isOpenAsync.data == false ? AppSize.s1_5 : AppSize.s1_5,
            right: isOpenAsync.data == false ? width * 0.85 : width * 0.15,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  height: height / 1.24,
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(30)),
                  ),
                  child: FutureBuilder(
                      future: ProfileServices().getUserById(_user),
                      builder: ((context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                          ));
                        } else {
                          _user = snapshot.data as User?;

                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: AppMargin.m18,
                                        right: AppMargin.m18),
                                    width: AppSize.s80,
                                    height: AppSize.s80,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                          'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: AppPadding.p12,
                                      right: AppPadding.p28,
                                      top: AppPadding.p34),
                                  child: TextFormField(
                                    enabled: editProfile,
                                    decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelText: 'full name :',
                                      labelStyle: TextStyle(
                                        color: ColorManager.darkGrey,
                                        fontSize: 10,
                                      ),
                                      hintText: _user?.name,
                                      hintStyle: TextStyle(
                                          color: ColorManager.darkGrey,
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: AppPadding.p12,
                                      right: AppPadding.p28,
                                      top: AppPadding.p34),
                                  child: TextFormField(
                                    enabled: editProfile,
                                    decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelText: 'Email :',
                                      labelStyle: TextStyle(
                                        color: ColorManager.darkGrey,
                                        fontSize: AppSize.s12,
                                      ),
                                      hintText: _user?.email,
                                      hintStyle: TextStyle(
                                          color: ColorManager.darkGrey,
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: AppPadding.p12,
                                      right: AppPadding.p28,
                                      top: AppPadding.p34),
                                  child: TextFormField(
                                    enabled: editProfile,
                                    decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelText: 'Phone Number :',
                                      labelStyle: TextStyle(
                                        color: ColorManager.darkGrey,
                                        fontSize: AppSize.s18,
                                      ),
                                      hintText: _user?.phone,
                                      hintStyle: TextStyle(
                                          color: ColorManager.darkGrey,
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: AppSize.s100,
                                ),
                                isOpenAsync.data == true
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          editProfile == false
                                              ? ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      editProfile = true;
                                                    });
                                                  },
                                                  child: const Text(
                                                      'Edit Profile'))
                                              : ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      editProfile = false;
                                                    });
                                                  },
                                                  child: const Text('save')),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          );
                        }
                      })),
                )),
                Align(
                  alignment: const Alignment(0, -0.8),
                  child: GestureDetector(
                    onTap: () {
                      if (Provider.of<NotificationSideBar>(context,
                                      listen: false)
                                  .isOpen ==
                              false &&
                          Provider.of<ShopsDownBar>(context, listen: false)
                                  .isOpen ==
                              false) {
                        AnimationHelpers().onIconPressed(
                            _animationControler,
                            isOpenSink,
                            context
                                .read<ProfileSideBar>()
                                .isProfileSideBarOpen());
                      }
                    },
                    child: Container(
                      width: width / 8,
                      height: height / 6,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(right: AppPadding.p20),
                      child: Icon(
                        isOpenAsync.data == true ? Icons.close : Icons.person,
                        size: AppSize.S34,
                        color: ColorManager.primary,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(AppSize.S36),
                            topRight: Radius.circular(AppSize.S36)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
