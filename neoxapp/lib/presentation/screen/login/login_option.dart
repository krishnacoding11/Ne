import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/presentation/controller/login_controller.dart';
import 'package:sip_ua/sip_ua.dart';
import '../../../core/widget.dart';
import '../../widgets/custom_image_view.dart';
import 'auto_provisioning/login_auto_provisioning.dart';
import 'manual_provisioning/manual_provisioning_screen.dart';

class LoginOptionScreen extends StatefulWidget {
  const LoginOptionScreen({Key? key}) : super(key: key);

  @override
  State<LoginOptionScreen> createState() => _StateLoginOptionScreen();
}

class _StateLoginOptionScreen extends State<LoginOptionScreen> implements SipUaHelperListener {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SIPUAHelper helper = SIPUAHelper();
    if (helper.registered) {
      registeredSip();
    }

    helper.addSipUaHelperListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Constants.assetPath + (commonSizeForDesktop(context) ? "appbackgroud.png" : "bg.png")), fit: BoxFit.fill)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 70),
                  child: CustomImageView(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    imagePath: "${Constants.assetPath}logo_3.png",
                    height: 50,
                    alignment: Alignment.topCenter,
                  )),
              const SizedBox(
                height: 50,
              ),
              getCustomFont('Login through', 36, Colors.white, 1, fontWeight: FontWeight.w700, fontFamily: Constants.fontLato),
              const SizedBox(height: 40),
              getCell(
                  title: 'Auto Provisioning',
                  function: () {
                    Get.to(() => const LoginScreenAutoProvisioning());
                  }),
              getCell(
                  title: 'Manual Provisioning',
                  function: () {
                    Get.to(() => const ManualProvisioningScreen());
                  }),
              // getCell(
              //     title: 'Mobile and Email',
              //     function: () {
              //       Get.to(() => const MobileEmailScreen());
              //     }),
              // getCell(
              //     title: 'Forgot password?',
              //     function: () {
              //       Get.to(() => const ForGotScreen());
              //     }),
            ],
          ).marginSymmetric(horizontal: 50),
        ),
      ),
      onWillPop: () => exit(0),
    );
  }

  getCell({required String title, required Function function}) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        height: 65,
        width: commonSizeForDesktop(context) ? 500 : null,
        decoration: BoxDecoration(color: const Color(0xff1B47C5), borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: getCustomFont(
                title,
                16,
                Colors.white,
                1,
                fontWeight: FontWeight.w400,
              ),
            ),
            CustomImageView(
              svgPath: "next_1.svg",
              height: 20,
              alignment: Alignment.centerLeft,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void callStateChanged(Call call, CallState state) {
    // TODO: implement callStateChanged
  }

  @override
  void onNewMessage(SIPMessageRequest msg) {
    print("regisrerd===msg");
    // TODO: implement onNewMessage
  }

  @override
  void onNewNotify(Notify ntf) {
    // TODO: implement onNewNotify

    print("regisrerd===ntf");
  }

  @override
  void registrationStateChanged(RegistrationState state) {
    // TODO: implement registrationStateChanged

    print("regisrerd===true");
  }

  @override
  void transportStateChanged(TransportState state) {
    print("regisrerd===state");
    // TODO: implement transportStateChanged
  }
}
