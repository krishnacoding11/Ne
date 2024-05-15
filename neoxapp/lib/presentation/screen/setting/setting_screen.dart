import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:neoxapp/presentation/controller/setting_controller.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/screen/setting/block_contacts_screen.dart';
import 'package:neoxapp/presentation/screen/setting/help_support_screen.dart';
import 'package:neoxapp/presentation/widgets/custom_image_view.dart';
import '../../controller/chat_controller.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  ChatController cChatController = Get.find();

  SettingController settingController = Get.put(SettingController());
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: commonSizeForDesktop(context) ? BoxDecoration() : BoxDecoration(image: DecorationImage(image: AssetImage(themeController.isDarkMode ? Constants.assetPath + "dark_dashboard.png" : Constants.assetPath + "history_bg.png"), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            title: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  getCustomFont(
                    "Settings",
                    20,
                    AppColors.getFontColor(context),
                    1,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                  )
                ],
              ).paddingOnly(top: 30),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  width: commonSizeForMidDesktop(context) ? 800 : double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white,
                    // color: AppColors.getCardColor(context),
                    boxShadow: [BoxShadow(color: themeController.isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.08), spreadRadius: 2, blurRadius: 10)],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.check_circle, color: AppColors.grayColor, size: 18),
                                  Text(
                                    "${cChatController.useremail.value}",
                                    style: TextStyle(color: AppColors.getFontColor(context), fontSize: 15),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 22),
                                  Text(
                                    "STLneox",
                                    style: TextStyle(color: themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor, fontSize: 15),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    "(STLneox.com)",
                                    style: TextStyle(color: themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor, fontSize: 15),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: AppColors.subFontColor,
                          ),
                        ],
                      ),
                      const Divider().paddingSymmetric(vertical: 10),
                      commonCardView(
                          image: "call.svg",
                          title: "Call handling",
                          onclick: () {
                            Get.to(() => const BlockContactScreen());
                          }),
                      const Divider().paddingSymmetric(vertical: 10),
                      commonCardView(image: "lock.svg", title: "Security"),
                      const Divider().paddingSymmetric(vertical: 10),
                      commonCardView(image: "backupImage.svg", title: "Backup"),
                      const Divider().paddingSymmetric(vertical: 10),
                      commonCardView(image: "notifation_icon.svg", title: "Notifications"),
                      const Divider().paddingSymmetric(vertical: 10),
                      commonCardView(
                          image: "helpImage.svg",
                          title: "Help and Support",
                          onclick: () {
                            Get.to(() => const HelpSupportScreen());
                          }),
                      const Divider().paddingSymmetric(vertical: 10),
                      commonCardView(image: "setting.svg", title: "System test"),
                      const Divider().paddingSymmetric(vertical: 10),
                      InkWell(
                        onTap: () {
                          logoutDailog();
                        },
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Icon(
                              Icons.logout,
                              color: AppColors.subFontColor,
                              size: 25,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Log out",
                              style: TextStyle(color: AppColors.getFontColor(context), fontSize: 14),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: AppColors.subFontColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // child: Container(),
    );
  }

  logoutDailog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 25),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 25),
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.redColor.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.logout,
                    color: AppColors.redColor,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Are you sure?",
                  style: TextStyle(color: AppColors.fontColor, fontSize: 25),
                ),
                const SizedBox(height: 15),
                Text(
                  "Do you really want to log out?",
                  style: TextStyle(color: AppColors.hintColor, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.ColorF4F4F5,
                          ),
                          child: Center(
                              child: Text(
                            "Cancel",
                            style: TextStyle(color: AppColors.fontColor),
                          )),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                          settingController.logoutCall();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.callEndColor,
                          ),
                          child: Center(
                              child: Text(
                            "Log out",
                            style: TextStyle(color: AppColors.subFont1),
                          )),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                )
              ],
            ),
          );
        });
  }

  commonCardView({String? image, String? title, Function()? onclick}) {
    return InkWell(
      onTap: onclick,
      child: Row(
        children: [
          const SizedBox(width: 10),
          CustomImageView(
            svgPath: image,
            color: AppColors.subFontColor,
            height: 20,
          ),
          const SizedBox(width: 10),
          Text(
            title ?? "",
            style: TextStyle(color: AppColors.getFontColor(context), fontSize: 14),
          ),
          const Spacer(),
          Icon(
            Icons.keyboard_arrow_down_outlined,
            color: AppColors.subFontColor,
          ),
        ],
      ),
    );
  }
}
