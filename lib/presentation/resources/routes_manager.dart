import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/ArScreenIos/arScreenIos.dart';
import 'package:flutter_application_1/presentation/home/mainScreen.dart';
import 'package:flutter_application_1/presentation/login/login.dart';
import 'package:flutter_application_1/presentation/onboarding/onboarding.dart';
import 'package:flutter_application_1/presentation/register/register.dart';
import 'package:flutter_application_1/presentation/resources/strings_manager.dart';
import 'package:flutter_application_1/presentation/splash/splash.dart';

import '../ArScreenAndroid/ArScreenAndroid.dart';

class Routes {
  static const String splashRoute = "/";
  static const String onBoardingRoute = "/onBoarding";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String mainRoute = "/main";
  static const String storeDetailsRoute = "/storeDetails";
  static const String arScreen = "/arIos";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      //  case Routes.forgotPasswordRoute:
      //  return MaterialPageRoute(builder: (_) => AppArBody());
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => SplashView());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => LoginView());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => OnBoardingView());
      case Routes.registerRoute:
        return MaterialPageRoute(builder: (_) => RegisterView());
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_) => MainView());
      case Routes.arScreen:
        return MaterialPageRoute(builder: (_) => ArScreenios());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(AppStrings.noRouteFound),
              ),
              body: const Center(child: Text(AppStrings.noRouteFound)),
            ));
  }
}
