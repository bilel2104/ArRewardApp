import 'dart:async';
import 'package:flutter/material.dart';

class AnimationHelpers with ChangeNotifier {
  AnimationHelpers();

  void onIconPressed(AnimationController animationC,
      StreamSink<bool> isOpenPSink, void close) {
    final animationStatus = animationC.status;
    final isAnimationDone = animationStatus == AnimationStatus.completed;
    if (isAnimationDone) {
      isOpenPSink.add(false);
      animationC.reverse();
      close;
    } else {
      isOpenPSink.add(true);
      animationC.forward();
      close;
    }
  }
}
