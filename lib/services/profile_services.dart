import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_prefs.dart';
import 'package:flutter_application_1/domain/models/user_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app/di.dart';

class ProfileServices {
  Dio dio = Dio();
  Future<User?> getUserById(User? user1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response response = await dio.get(
          "https://dev-reward.groupado.com/reward/api/v1/auth/" +
              prefs.getInt('id').toString(),
          options: Options(
            headers: {"authorization": prefs.getString('token')},
          ));
      user1 = User.fromJson(response.data);

      return user1;
    } on DioError catch (e) {
      print(e);
    }
  }

  Future upDateUser(String? email, String? fullName, String? phone,
      String? birthday, String? userStatus, String? address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response response = await dio.put(
        "https://dev-reward.groupado.com/reward/api/v1/auth/" +
            prefs.getInt('id').toString(),
        options: Options(
          headers: {"authorization": prefs.getString('token')},
        ),
        data: {
          'email': email,
          "fullName": fullName,
          "phone": phone,
          "birthday": birthday,
          "userStatus": userStatus,
          "address": address
        },
      );
    } on DioError catch (e) {
      print(e);
      SnackBar(
        content: Text(e.response!.data['message']),
        backgroundColor: Colors.blueAccent,
      );
    }
  }
}
