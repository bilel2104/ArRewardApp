import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_prefs.dart';
import 'package:flutter_application_1/app/di.dart';
import 'package:flutter_application_1/presentation/resources/routes_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  VideoState createState() => VideoState();
}

class VideoState extends State<SplashView> with SingleTickerProviderStateMixin {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  var _visible = true;

  AnimationController? animationController;
  Animation<double>? animation;

  startTime() async {
    var _duration = const Duration(seconds: 6);
    return Timer(_duration, _goNext);
  }

  _goNext() async {
    _appPreferences.isUserLoggedIn().then((isUserLoggedIn) => {
          if (isUserLoggedIn)
            {
              Navigator.pushReplacementNamed(context, Routes.mainRoute),
            }
          else if (isUserLoggedIn != true)
            {
              Navigator.pushReplacementNamed(context, Routes.loginRoute),
            }
          else
            {
              _appPreferences
                  .isOnBordingScreenViewed()
                  .then((isOnBordingScreenViewed) => {
                        if (isOnBordingScreenViewed)
                          {
                            Navigator.pushReplacementNamed(
                                context, Routes.mainRoute)
                          }
                        else
                          {
                            Navigator.pushReplacementNamed(
                                context, Routes.onBoardingRoute)
                          }
                      })
            }
        });
  }

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation =
        CurvedAnimation(parent: animationController!, curve: Curves.easeOut);

    animation?.addListener(() => setState(() {}));
    animationController?.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                width: animation!.value * 250,
                height: animation!.value * 250,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
