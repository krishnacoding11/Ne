import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neoxapp/core/theme_color.dart';

class CommonWidget {
  static noneAppBar() {
    return AppBar(
      toolbarHeight: 0,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: AppColors.statusBarColor,
        statusBarIconBrightness: Brightness.light, // For Android (dark icons)
        statusBarBrightness: Brightness.dark, // For iOS (dark icons)
      ),
    );
  }
}
