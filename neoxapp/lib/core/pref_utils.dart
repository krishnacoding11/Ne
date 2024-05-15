import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

String userSub = '';

class PrefUtils {
  static SharedPreferences? _sharedPreferences;

  static String prefName = "neoxApp_";
  static String keyDarkMode = "${prefName}darkMode";
  static String keyUserId = "${prefName}userId";
  static String keySaveLogin = "${prefName}saveLogin";
  static String keySaveLoginData = "${prefName}saveLoginData";
  static String keySaveLoginAutoProvisioningUrlData = "${prefName}saveAutoProvisioningLoginData";
  static String keySaveLoginManualProvisioningData = "${prefName}saveManualProvisioningLoginData";
  static String keySaveMobileEmailData = "${prefName}saveMobileEmailData";
  static String keyFCMToken = "${prefName}FCMToken";

  PrefUtils() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    setIsDarkMode(WidgetsBinding.instance.window.platformBrightness == Brightness.dark);
    themeController.setTheme();
  }

  Future<SharedPreferences> get getPref async {
    return _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  ///will clear all the data stored in preference
  void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }

  static getIsDarkMode() {
    return _sharedPreferences?.getBool(keyDarkMode) ?? true;
  }

  static setIsDarkMode(bool i) async {
    await _sharedPreferences!.setBool(keyDarkMode, i);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // status bar color

        statusBarIconBrightness: PrefUtils.getIsDarkMode() ? Brightness.light : Brightness.dark // status bar color
        ));
    themeController.update();
  }

  static String getUserId() {
    return _sharedPreferences!.getString(keyUserId) ?? '';
  }

  static setUserId(String i) async {
    await _sharedPreferences!.setString(keyUserId, i);
  }

  static setIsLogin(bool i) {
    _sharedPreferences?.setBool(keySaveLogin, i);
  }

  static setLoginData(String i) {
    _sharedPreferences!.setString(keySaveLoginData, i);
  }

  static setLoginAutoProvisioningUrlData(String i) {
    _sharedPreferences?.setString(keySaveLoginAutoProvisioningUrlData, i);
  }

  static setManualLoginProvisioningData(String i) {
    _sharedPreferences?.setString(keySaveLoginManualProvisioningData, i);
  }

  static setMobileEmailData(String i) {
    _sharedPreferences?.setString(keySaveMobileEmailData, i);
  }

  static setFcmToken(String i) {
    _sharedPreferences!.setString(keyFCMToken, i);
  }

  static getIsLogin() {
    return _sharedPreferences?.getBool(keySaveLogin) ?? false;
  }

  static getFcmToken() {
    return _sharedPreferences!.getString(keyFCMToken);
  }

  static getIsLoginData() {
    return _sharedPreferences?.getString(keySaveLoginData) ?? "{}";
  }
}
