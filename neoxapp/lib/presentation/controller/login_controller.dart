import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/pref_utils.dart';
import 'package:neoxapp/core/route/app_routes.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:neoxapp/presentation/screen/dashboard/dashboard_page.dart';
import 'package:neoxapp/presentation/screen/restore/restore_screen.dart';
import 'package:neoxapp/presentation/widgets/globle.dart' as globals;
import 'package:sip_ua/sip_ua.dart';
import '../../core/theme_color.dart';
import '../screen/desktop/desktopscreen.dart';

RxBool isVerified = false.obs;

class LoginController extends GetxController {
  static LoginController get to => Get.find();

  String tempEmail = "kaushik@gmail.com";
  String tempPassword = "112233";
  RxBool isShow = true.obs;
  RxBool isShowPassword = true.obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;

  Rx<TextEditingController> autoProvisioningUrlController = TextEditingController().obs;

  // Rx<TextEditingController> manualProvisioningEmailController = TextEditingController(text: kDebugMode ? "gaurav.k@celloip.com" : "").obs;
  Rx<TextEditingController> manualProvisioningEmailController = TextEditingController(text: kDebugMode ? "gaurav.k@celloip.com" : "").obs;
  // Rx<TextEditingController> manualProvisioningEmailController = TextEditingController(text: "").obs;
  Rx<TextEditingController> manualProvisioningPasswordController = TextEditingController(text: kDebugMode ? "9891875581" : "").obs;
  // Rx<TextEditingController> manualProvisioningPasswordController = TextEditingController(text: kDebugMode ? "9891875581" : "").obs;
  // Rx<TextEditingController> manualProvisioningPasswordController = TextEditingController(text: "").obs;
  Rx<TextEditingController> otpController = TextEditingController().obs;

  Rx<TextEditingController> mobileUserNameController = TextEditingController().obs;
  Rx<TextEditingController> mobilePasswordController = TextEditingController().obs;
  Rx<TextEditingController> mobileRegisterServerController = TextEditingController().obs;
  Rx<TextEditingController> mobileWebRTCController = TextEditingController().obs;
  Rx<TextEditingController> mobileDisplayNameController = TextEditingController().obs;
  RxString selectedViaTransport = "abc".obs;

  Rx<TextEditingController> resetEmailController = TextEditingController().obs;
  Rx<TextEditingController> forgotOtpController = TextEditingController().obs;
  Rx<TextEditingController> createPasswordController = TextEditingController().obs;
  Rx<TextEditingController> createNewPasswordController = TextEditingController().obs;

  checkEmailOrPassword() {
    if ((emailController.value.text.isNotEmpty) && (passwordController.value.text.isNotEmpty)) {
      PrefUtils.setIsLogin(true);
      Map<String, dynamic> LoginData = {
        "email": emailController.value.text,
        "password": passwordController.value.text,
      };
      PrefUtils.setLoginData(jsonEncode(LoginData));
      registeredSip();
      Constants.sendToNext(Routes.dashboardScreen);
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: getCustomFont(
          "Enter the value",
          17,
          AppColors.getFontColor(Get.context!),
          1,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  void checkAutoProvisioningUrl() {
    if (autoProvisioningUrlController.value.text.isNotEmpty) {
      PrefUtils.setIsLogin(true);
      Map<String, dynamic> LoginDataAutoProvisioning = {
        "autoProvisioningUrl": autoProvisioningUrlController.value.text,
      };
      PrefUtils.setLoginAutoProvisioningUrlData(jsonEncode(LoginDataAutoProvisioning));
      registeredSip();
      if (commonSizeForDesktop(Get.context)) {
        Get.to(() => const DesktopScreen());
      } else {
        Get.to(() => const DashboardScreen());
      }
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: getCustomFont(
          "Enter the value",
          17,
          AppColors.getFontColor(Get.context!),
          1,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  void checkManualProvisioning({String? email, String? mobile, String? otp}) {
    if ((email?.isNotEmpty ?? false) && (mobile?.isNotEmpty ?? false) && (otp?.isNotEmpty ?? false)) {
      PrefUtils.setIsLogin(true);
      Map<String, dynamic> LoginData = {"email": email, "phone": mobile, "otp": otp};
      print("====$LoginData");
      PrefUtils.setManualLoginProvisioningData(jsonEncode(LoginData));
      registeredSip();
      if (commonSizeForDesktop(Get.context)) {
        Get.to(() => const DesktopScreen());
      } else {
        Get.to(() => const RestoreScreen());
      }

      // Constants.sendToNext(Routes.dashboardScreen);
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: getCustomFont(
          "Enter the value",
          17,
          AppColors.getFontColor(Get.context!),
          1,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  void checkMobileEmail() {
    if (mobileUserNameController.value.text.isNotEmpty && mobilePasswordController.value.text.isNotEmpty && mobileRegisterServerController.value.text.isNotEmpty && mobileWebRTCController.value.text.isNotEmpty && mobileDisplayNameController.value.text.isNotEmpty && selectedViaTransport.value.isNotEmpty) {
      PrefUtils.setIsLogin(true);
      Map<String, dynamic> mobileEmailData = {
        "userName": mobileUserNameController.value.text,
        "password": mobilePasswordController.value.text,
        "registerServer": mobileRegisterServerController.value.text,
        "webRTC": mobileWebRTCController.value.text,
        "viaTransport": selectedViaTransport.value,
        "displayName": mobileDisplayNameController.value.text,
      };
      print("====>>>$mobileEmailData");
      PrefUtils.setMobileEmailData(jsonEncode(mobileEmailData));
      registeredSip();

      if (commonSizeForDesktop(Get.context)) {
        Get.to(() => const DesktopScreen());
      } else {
        Get.to(() => const DashboardScreen());
      }
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: getCustomFont(
          "Enter the value",
          17,
          AppColors.getFontColor(Get.context!),
          1,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  checkForgotPassword() {}
}

registeredSip() async {
  UaSettings settings = UaSettings();
  var sip_user = "v5_eFone_1708342703464_OwgHeVSA";
  // var sip_user = "v5_eFone_1707389628044_bRLnRhRE";
  settings.webSocketUrl = 'wss://devwebrtc.efone.ca:7443';

  settings.webSocketSettings.allowBadCertificate = true;
  var uri = 'sip:${sip_user}@134.122.36.172';

  settings.uri = uri;
  settings.authorizationUser = sip_user;
  // settings.password = "5ASZkRUj";
  settings.password = "ncBof7qI";
  settings.displayName = 'v5_eFone_1708342703464_OwgHeVSA';

  if (globals.helper == null) {
    globals.helper = SIPUAHelper();
  }
  await globals.helper?.start(settings).then((value) {});
}

// registeredSip() async {
//   Map<String, dynamic> userData = jsonDecode(PrefUtils.getIsLoginData());
//   UaSettings settings = UaSettings();
//   var sip_user = "v5_eFone_1706875666572_C5OfMVSE";
//   // settings.webSocketUrl = 'wss://callapi.efone.ca:5060';
//   settings.webSocketUrl = 'wss://devwebrtc.efone.ca:7443';
//   // settings.webSocketUrl = 'wss://xbabblesip01.xaccel.net:7443';
//   // settings.webSocketUrl = 'wss://devwebrtc.efone.ca:7443';
//   // settings.webSocketUrl = 'wss://cluster-100.spotifone.com:7699/ws';
//   settings.webSocketSettings.allowBadCertificate = true;
//   // var uri = 'sip:v5_eFone_1702967744658_AFO3qOHH@134.122.36.172';
//   //var uri = 'sip:${userData["email"]}@134.122.36.172';
//   var uri = 'sip:${sip_user}@134.122.36.172';
//   // var uri = 'sip:2018514201@199.73.108.116';
//   // var uri = 'sip:v5_eFone_1702644671589_marCoJk9@134.122.36.172';
//   settings.uri = uri;
//   // settings.authorizationUser = 'v5_eFone_1703052885505_NOcbsgQV'; //prefs.getString("username").toString();
//   // settings.authorizationUser = userData["email"];
//   settings.authorizationUser = sip_user;
//   // settings.password = '${userData["email"]}';
//   // settings.password = '2018514202';
//   // settings.password = userData["password"];
//   settings.password = "bWFf6lNB";
//   // settings.password = 'OYZh2wjN';
//
//   // settings.dtmfMode = DtmfMode.RFC2833;
//   // settings.iceServers = [
//   //   {
//   //     'url': "devwebrtc.efone.ca",
//   //   },
//   // ];
//   settings.displayName = 'v5_eFone_1705398215393_Z6gJSFHm';
//
//   if (globals.helper == null) {
//     globals.helper = SIPUAHelper();
//   }
//   await globals.helper?.start(settings).then((value) {});
// }

// 919033586550
