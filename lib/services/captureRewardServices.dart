import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CaptureReward {
  Dio dio = Dio();
  capture(rewardId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      return await dio.post(
          "https://dev-reward.groupado.com/reward/api/v1/capturedreward/",
          data: {'userId': prefs.getInt('id').toString(), 'rewardId': rewardId},
          options: Options(
            headers: {
              "authorization": prefs.getString('token'),
            },
          ));
    } on DioError catch (e) {
      SnackBar(
        content: Text(e.response!.data['message']),
        backgroundColor: Colors.blueAccent,
      );
    }
  }
}
