import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/presentation/screen/dashboard/dashboard_page.dart';
import 'package:neoxapp/presentation/screen/desktop/contact_desktop_screen.dart';
import 'package:neoxapp/presentation/screen/desktop/dailer_destopscreen.dart';
import '../dashboard/history/history_screen.dart';
import 'desktop_message_tab_screen.dart';
import '../setting/setting_screen.dart';
import '../../widgets/custom_image_view.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({Key? key}) : super(key: key);

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  RxInt selectVerticalBottom = 0.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if ((commonSizeForDesktop(context))) {
      return Scaffold(
        backgroundColor: AppColors.ColorF4F4F5,
        body: Stack(
          children: [
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 100, spreadRadius: 20)]),
                  width: 100,
                ),
                Expanded(
                    child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                            child: Image.asset(
                          "assets/images/backgorundimage.png",
                          height: 350,
                        )),
                      ],
                    ),
                    StreamBuilder(
                        stream: selectVerticalBottom.stream,
                        builder: (context, snapshot) {
                          return selectVerticalBottom.value == 0
                              ? const DailDesktopScreen()
                              : selectVerticalBottom.value == 1
                                  ? const HistoryScreen()
                                  : selectVerticalBottom.value == 2
                                      ? const ContactDesktopScreen()
                                      : selectVerticalBottom.value == 3
                                          ? const DesktopMessageScreen()
                                          : const SettingScreen();
                        })
                  ],
                )),
              ],
            ),
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 100, spreadRadius: 20)]),
                  width: 100,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Image.asset(
                        "assets/images/logo_3.png",
                        color: AppColors.primaryColor,
                        height: 70,
                        width: 70,
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: () {
                          selectVerticalBottom.value = 1;
                        },
                        child: CustomImageView(
                          svgPath: "tab_call.svg",
                          color: AppColors.primaryColor.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 25),
                      CustomImageView(
                        svgPath: "contact.svg",
                        onTap: () {
                          selectVerticalBottom.value = 2;
                        },
                        color: AppColors.primaryColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 25),
                      CustomImageView(
                        svgPath: "chat.svg",
                        onTap: () {
                          selectVerticalBottom.value = 3;
                        },
                        color: AppColors.primaryColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 25),
                      CustomImageView(
                        svgPath: "setting.svg",
                        onTap: () {
                          selectVerticalBottom.value = 4;
                        },
                        color: AppColors.primaryColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 100,
              left: 100 - 35,
              child: InkWell(
                  onTap: () {
                    selectVerticalBottom.value = 0;
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: FloatingActionButton(
                      onPressed: () {
                        selectVerticalBottom.value = 0;
                      },
                      backgroundColor: AppColors.primaryColor,
                      splashColor: AppColors.primaryColor.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: CustomImageView(imagePath: '${Constants.assetPath}dialer.png', height: 30, color: Colors.white),
                    ),
                  )),
            )
          ],
        ),
      );
    }
    return const DashboardScreen();
  }
}

bool commonSizeForDesktop(context) {
  return (MediaQuery.of(context).size.width > 450);
}

bool commonSizeForLargDesktop(context) {
  return (MediaQuery.of(context).size.width > 900);
}

bool commonSizeForVeryLargDesktop(context) {
  return (MediaQuery.of(context).size.width > 1000);
}

bool commonSizeForMidDesktop(context) {
  return (MediaQuery.of(context).size.width > 800);
}
