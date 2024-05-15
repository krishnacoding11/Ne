import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/presentation/screen/login/manual_provisioning/manual_provisioning_screen.dart';
import '../../../core/widget.dart';
import '../../../generated/l10n.dart';
import '../../widgets/custom_image_view.dart';

class StartedScreen extends StatefulWidget {
  const StartedScreen({Key? key}) : super(key: key);

  @override
  State<StartedScreen> createState() => _StateStartedScreen();
}

class _StateStartedScreen extends State<StartedScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Constants.assetPath + (commonSizeForDesktop(context) ? "appbackgroud.png" : "bg.png")), fit: BoxFit.fill)),
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              // Expanded(
              //   child: Container(
              //     child: CustomImageView(
              //       onTap: () {
              //         Navigator.pop(context);
              //       },
              //       imagePath: "${Constants.assetPath}neox.png",
              //       height: 35,
              //       alignment: Alignment.bottomCenter,
              //     ),
              //   ),
              //   flex: 2,
              // ),
              const SizedBox(height: 100),
              Container(
                height: commonSizeForDesktop(context) ? 120 : 80,
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage("${Constants.assetPath}logo_3.png"), fit: BoxFit.fitHeight)),
              ),
              Expanded(
                flex: 4,
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    getMultilineCustomFont(S.of(context).onlineCallsAndMessagingMadeEasy, 28, Colors.white, fontWeight: FontWeight.w400, textAlign: TextAlign.center, fontFamily: Constants.fontFamily),
                    getVerSpace(16),
                    // getMultilineCustomFont(S.of(context).weWillProvideAllBestCallStreamingInOneClick, 16.sp, Colors.white, fontWeight: FontWeight.w400, textAlign: TextAlign.center, fontFamily: Constants.fontFamily),
                  ],
                ).marginSymmetric(horizontal: 47)),
              ),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () {
                    Get.offAll(() => const ManualProvisioningScreen());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getMultilineCustomFont(S.of(context).getStarted, 16, Colors.white, fontWeight: FontWeight.w400, textAlign: TextAlign.center, fontFamily: Constants.fontLato),
                      getHorSpace(10),
                      CustomImageView(
                        svgPath: "next.svg",
                        width: 40,
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () => exit(0),
    );
  }
}
