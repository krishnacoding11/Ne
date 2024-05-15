import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:get/get.dart';

class Constants {
  Future<String?> getDeviceName() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.name; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      // return androidDeviceInfo.device; // unique ID on Android
      String device = "${androidDeviceInfo.manufacturer} ${androidDeviceInfo.model}";
      print('device** ${device}');
      return device; //"${androidDeviceInfo.manufacturer} ${androidDeviceInfo.model}"; // unique ID on Android
    }
    return null;
  }

  static String socket_url = 'http://134.122.36.172:5060'; //personal

  Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      // var androidDeviceInfo = await deviceInfo.androidInfo;
      var udid = await FlutterUdid.udid;
      print("udid ^^^^^ ${udid}");
      // print("device ^^^^^ ${androidDeviceInfo.device}");
      // print("brand ^^^^^ ${androidDeviceInfo.brand}");
      // print("manufacturer ^^^^^ ${androidDeviceInfo.manufacturer}");
      // print("display ^^^^^ ${androidDeviceInfo.display}");
      // print("model ^^^^^ ${androidDeviceInfo.model}");
      // print("product ^^^^^ ${androidDeviceInfo.product}");
      // print("CALL ^^^^^ ${deviceInfo.androidInfo.}");
      return udid; // androidDeviceInfo.id; // unique ID on Android
    }
  }

  static split(String string) {
    if (string.contains("+")) {
      return "#";
    }
    if (string.isNotEmpty && string.length > 1) {
      string = string.trim().replaceAll("  ", " ").replaceAll("   ", " ");
      final split = string.split(' ');

      if (split.length > 1 && split[1].isNotEmpty) {
        string = string[0] + split[1][0];
      } else {
        string = string[0];
      }

      return string.toUpperCase();
    }

    return string.toUpperCase();
  }

  static String fontFamily = 'Heebo';
  static String fontLato = 'lato';
  static String assetPath = 'assets/images/';

  static const double defScreenWidth = 393;
  static const double defScreenHeight = 852;

  // static void setupSize(BuildContext context,
  //     {double width = defScreenWidth, double height = defScreenHeight}) {
  //     ScreenUtil.init(context,
  //         designSize: Size(width, height), minTextAdapt: true);
  //
  // }

  static sendToNext(
    String route, {
    Object? arguments,
    Function? function,
  }) {
    if (arguments != null) {
      Get.toNamed(route, arguments: arguments);
    } else {
      Get.toNamed(route);
    }
  }
}
