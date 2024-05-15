import 'package:flutter/cupertino.dart';
import 'package:neoxapp/presentation/screen/login/login_screen.dart';
import 'package:neoxapp/presentation/screen/login/started_screen.dart';

import '../../presentation/screen/caller/call_screen.dart';
import '../../presentation/screen/dashboard/dashboard_page.dart';
import '../../presentation/screen/detail/detail_screen.dart';
import '../../presentation/screen/login/login_option.dart';
import '../../presentation/screen/message/view/new_message_tab.dart';
import '../../presentation/screen/splash/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const initialRoute = Routes.splashRoute;
  static Map<String, WidgetBuilder> routes = {
    Routes.splashRoute: (context) => const SplashScreen(),
    Routes.startedScreen: (context) => const StartedScreen(),
    Routes.loginScreen: (context) => const LoginScreen(),
    Routes.dashboardScreen: (context) => const DashboardScreen(),
    Routes.detailScreen: (context) => const DetailScreen(),
    Routes.loginOptionScreen: (context) => const LoginOptionScreen(),
    Routes.callScreen: (context) => const CallScreen(),
    Routes.newMessageScreen: (context) => const NewMessageScreen(),
  };
}
