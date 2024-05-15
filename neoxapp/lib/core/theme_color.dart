import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:neoxapp/main.dart';

class AppColors {
  static Color primaryColor = Color(0xff1B47C5);
  static Color greenColor = Color(0xff13C16B);
  static Color color1F222A = Color(0xff1F222A);
  static Color color1B47C5 = Color(0xff1B47C5);
  static Color darkPrimaryColor = Color(0xff91ADFF);
  static Color redColor = Color(0xffEF0000);
  static Color callEndColor = Color(0xffDE5327);
  static Color colorBlack = Color(0xff000000);
  static Color statusBarColor = Color(0xff20222A);
  static Color fontColor = Color(0xff1F222A);
  static Color subFontColor = Color(0xff757A84);
  static Color subCardColor = Color(0xffF4F4F5);
  static Color hintColor = Color(0xff454954);
  static Color grayColor = Color(0xff757A84);
  static Color darkBgColor = Color(0xff272A2F);
  static Color ColorF4F4F5 = Color(0xffF4F4F5);
  static Color ColorEBF0FF = Color(0xffEBF0FF);
  static Color subFont1 = Color(0xffF4F4F5);
  static Color colorD4DFFF = Color(0xffD4DFFF);
  static Color colorFFFFFF = Color(0xffFFFFFF);
  static Color colorA2A6AE = Color(0xffA2A6AE);

  static getCardColor(BuildContext context) {
    return themeController.isDarkMode ? Color(0xff1F222A) : Colors.white;
    // Theme.of(context).cardColor;
  }

  static getFontColor(BuildContext context) {
    return themeController.isDarkMode ? Colors.white : AppColors.fontColor;

    // return Theme.of(context).textTheme.caption!.color ?? Colors.black;
  }

  static getSubFontColor(BuildContext context) {
    return subFontColor;
  }

  static getSubCardColor(BuildContext context) {
    return themeController.isDarkMode ? Colors.white : subCardColor;
  }
  // static Color  statusBarColor="#20232C".toColor();
}

extension StringColorExtensions on String {
  Color toColor() => Color(hexToInteger(this));

  int hexToInteger(String hex) => int.parse(hex, radix: 16);
}

appLightTheme(BuildContext context) {
  ThemeData theme = Theme.of(context);
  return theme.copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,

    cardColor: Colors.white,
    textTheme: TextTheme(caption: TextStyle(color: AppColors.fontColor)),
    // colorScheme: theme.colorScheme.copyWith(
    //  primary: AppColors.primaryColor
    // ),
  );
}

appDarkTheme(BuildContext context) {
  ThemeData theme = Theme.of(context);

  return theme.copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xff1F222A),

    cardColor: Color(0xff1F222A),
    textTheme: TextTheme(caption: TextStyle(color: Colors.white)),
    // colorScheme: theme.colorScheme.copyWith(
    //     primary: AppColors.primaryColor
    // ),
  );
}
