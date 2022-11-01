import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_prefs.dart';
import 'package:flutter_application_1/app/di.dart';
import 'package:flutter_application_1/domain/models/model.dart';
import 'package:flutter_application_1/presentation/errorDialogHendler/dialog.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/resources/routes_manager.dart';

class AuthServices {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  Dio dio = Dio();
  Future<UserModel?> login(email, password) async {
    try {
      Response response = await dio.post(
        "https://dev-reward.groupado.com/reward/api/v1/auth/signin",
        data: {'email': email, 'password': password},
      );
      print(response.data);
      return UserModel.fromJson(response.data);
    } on DioError catch (e) {
      print("------------------------->>>>>>>> ${e.response!.data['message']}");
      Fluttertoast.showToast(
          msg: "${e.response!.data['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 20.0);
    }
  }

  Future forgetpassword(email) async {
    try {
      return await dio.post(
          'http://192.168.1.24:9001/api/v1/auth/resetpassword',
          data: {'email': email});
    } on DioError catch (e) {
      print('-------------< <<<<<<<<<  $e');
    }
  }

  register(
      email, password, fullName, phone, birthday, userStatus, address) async {
    try {
      return await dio.post(
        "https://dev-reward.groupado.com/reward/api/v1/auth/signup",
        data: {
          'email': email,
          'password': password,
          "fullName": fullName,
          "phone": phone,
          "birthday": birthday,
          "userStatus": userStatus,
          "address": address
        },
      );
    } on DioError catch (e) {
      print(e);
    }
  }
}
