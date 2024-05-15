import 'package:get/get.dart';
import 'package:neoxapp/api/ApiServices.dart';
import 'package:neoxapp/core/api_constant.dart';
import 'package:neoxapp/presentation/screen/login/manual_provisioning/manual_provisioning_screen.dart';
import '../../api/databaseHelper.dart';
import 'new_socket_controller.dart';

class SettingController extends GetxController {
  logoutCall() {
    Api().call(
        url: ApiConstants.logoutUrl,
        isProgressShow: true,
        success: (data) async {
          storage.erase();

          await deleteDb();
          NewSocketController socket = Get.find();
          socket.socketDisconnect();
          Get.offAll(() => ManualProvisioningScreen());
        });
  }
}
