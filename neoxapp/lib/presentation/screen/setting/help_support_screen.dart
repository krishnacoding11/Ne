import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/presentation/widgets/custom_image_view.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: commonSizeForDesktop(context) ? BoxDecoration(color: AppColors.subCardColor) : BoxDecoration(image: DecorationImage(image: AssetImage(themeController.isDarkMode ? Constants.assetPath + "dark_dashboard.png" : Constants.assetPath + "history_bg.png"), fit: BoxFit.fill)),
      child: Stack(
        children: [
          if (Platform.isWindows)
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/backgorundimage.png",
                    height: 350,
                    width: 350,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          Scaffold(
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
                      Icon(
                        Icons.arrow_back_ios_rounded,
                        color: AppColors.getFontColor(context),
                      ),
                      const SizedBox(width: 10),
                      getCustomFont(
                        "Help and Support",
                        15,
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
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: commonSizeForMidDesktop(context) ? 800 : double.infinity,
                    clipBehavior: Clip.antiAlias,
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
                        const SizedBox(height: 10),
                        commonCardView(image: "mobileImage.svg", title: "Hotline", link: "+91-79-49135778"),
                        const Divider().paddingSymmetric(vertical: 10),
                        commonCardView(image: "emailImage.svg", title: "Email", link: "neox.support@stl.tech "),
                        const Divider().paddingSymmetric(vertical: 10),
                        commonCardView(image: "skypeImage.svg", title: "Skype", link: "neox.support "),
                        const Divider().paddingSymmetric(vertical: 10),
                        commonCardView(image: "facebookmage.svg", title: "Facebook", link: "www.facebook.com/neoxipsolution "),
                        const Divider().paddingSymmetric(vertical: 10),
                        commonCardView(image: "websiteImage.svg", title: "Website", link: "www.stl.tech/solutions/neox/"),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // child: Container(),
    );
  }

  commonCardView({String? image, String? title, Function()? onclick, String? link}) {
    return InkWell(
      onTap: onclick,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          CustomImageView(
            svgPath: image,
            height: 25,
          ),
          const SizedBox(width: 10),
          Text(
            title ?? "",
            style: TextStyle(color: AppColors.getFontColor(context), fontSize: 14),
          ),
          // Spacer(),
          Expanded(
              child: Text(
            link ?? "",
            style: TextStyle(color: themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor, fontSize: 14),
            textAlign: TextAlign.end,
          )),
        ],
      ),
    );
  }
}
