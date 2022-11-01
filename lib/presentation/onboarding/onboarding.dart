import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_prefs.dart';
import 'package:flutter_application_1/app/di.dart';
import 'package:flutter_application_1/presentation/resources/color_manager.dart';
import 'package:flutter_application_1/presentation/resources/routes_manager.dart';
import 'package:flutter_application_1/presentation/resources/strings_manager.dart';
import 'package:flutter_application_1/presentation/resources/values_manager.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  _OnBoardingViewState createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final CarouselController _controller = CarouselController();
  AppPreferences _appPreferences = instance<AppPreferences>();
  int _current = 0;

  @override
  void initState() {
    _appPreferences.setOnBordingScreenViewed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> list = [
      'assets/images/logo.png',
      'assets/images/logo.png',
      'assets/images/logo.png',
    ];
    return MaterialApp(
      home: InteractiveViewer(
        maxScale: 5.0,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(children: [
            const SizedBox(
              height: AppSize.s40,
            ),
            InteractiveViewer(
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(0, 3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: CarouselSlider(
                    options: CarouselOptions(
                        height: 500,
                        autoPlay: true,
                        viewportFraction: 1.0,
                        aspectRatio: 2.0,
                        autoPlayInterval: Duration(seconds: 4),
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                    items: list
                        .map((item) => Container(
                              height: 80,
                              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x40000000),
                                    offset: Offset(0, 3),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child:
                                  Center(child: Image.asset(item.toString())),
                            ))
                        .toList(),
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(right: AppSize.s12),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, Routes.loginRoute);
                    },
                    child: Text(
                      AppStrings.skip,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  )),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: list.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? ColorManager.white
                                  : ColorManager.primary)
                              .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
