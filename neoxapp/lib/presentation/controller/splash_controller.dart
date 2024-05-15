import 'package:get/get.dart';
import 'package:neoxapp/api/ApiServices.dart';
import 'package:neoxapp/presentation/controller/login_controller.dart';
import 'package:neoxapp/presentation/screen/dashboard/dashboard_page.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/presentation/screen/login/started_screen.dart';
import 'message_controller.dart';

class SplashController extends GetxController {
  MessageController messageController = Get.put(MessageController());
  start() {
    Future.delayed(const Duration(seconds: 3), () async {
      try {
        registeredSip();
        // if(kDebugMode){
        //  Get.to(() => const DesktopScreen());

        // Get.offAll(() => const StartedScreen());
        // Get.to(() => const DesktopScreen());
        // }
        if (storage.read(ApiConfig.loginToken) != null || storage.read(ApiConfig.loginToken).isNotEmpty) {
          // Constants.sendToNext(Routes.dashboardScreen);
          messageController.getMessegeData();
          if (commonSizeForDesktop(Get.context)) {
            Get.to(() => const DesktopScreen());
          } else {
            Get.to(() => const DashboardScreen());
          }
        } else {
          Get.offAll(() => const StartedScreen());
        }
      } catch (e) {
        Get.offAll(() => const StartedScreen());
        // Constants.sendToNext(Routes.startedScreen);
      }
    });
  }
}
