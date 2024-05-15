import 'package:get/get.dart';
import 'package:neoxapp/core/pref_utils.dart';

class ThemeController extends GetxController {
  bool isDarkMode = false;

  setTheme() {
    isDarkMode = PrefUtils.getIsDarkMode();
    update();
  }

  changeTheme({bool? isDark}) {
    PrefUtils.setIsDarkMode(isDark ?? !isDarkMode);
    setTheme();
  }
}
