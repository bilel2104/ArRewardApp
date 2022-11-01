import 'dart:ffi';

import 'package:flutter_application_1/presentation/resources/language_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String PREFS_KEY_ONBORDING_SCREEN = "PREFS_KEY_ONBORDING_SCREEN";
const String PREFS_KEY_IS_USER_LOGGED = "PREDS_KEY_IS_USER_LOGGED";
const String idUser = "id";

class AppPreferences {
  SharedPreferences _sharedPreferences;
//get token from shared preferences
  Future<int?> getToken() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    print(_sharedPreferences.getInt('id'));
    return _sharedPreferences.getInt("id");
  }

  Future<int> setId(int id) async {
    await _sharedPreferences.setInt('id', id);

    return id;
  }

  Future<String> setToken(String token) async {
    await _sharedPreferences.setString('token', token);

    return token;
  }

  Future<String> setEmail(String email) async {
    await _sharedPreferences.setString('email', email);

    return email;
  }

  AppPreferences(this._sharedPreferences);

  Future<void> setOnBordingScreenViewed() async {
    _sharedPreferences.setBool(PREFS_KEY_ONBORDING_SCREEN, true);
  }

  Future<bool> isOnBordingScreenViewed() async {
    return _sharedPreferences.getBool(PREFS_KEY_ONBORDING_SCREEN) ?? false;
  }

  Future<void> setIsUserLoggedIn() async {
    _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED, true);
  }

  Future<void> setIsUserLoggedOut() async {
    _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED, false);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(PREFS_KEY_IS_USER_LOGGED) ?? false;
  }

  Future<String> setIdUser(int id) async {
    _sharedPreferences.setInt(idUser, id);
    return id.toString();
  }
}
