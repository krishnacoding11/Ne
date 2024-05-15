import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:neoxapp/presentation/controller/chat_controller.dart';
import '../../../core/constants.dart';
import '../../widgets/custom_image_view.dart';
import '../dashboard/dashboard_page.dart';

class RestoreScreen extends StatefulWidget {
  const RestoreScreen({Key? key}) : super(key: key);

  @override
  State<RestoreScreen> createState() => _RestoreScreenState();
}

class _RestoreScreenState extends State<RestoreScreen> with SingleTickerProviderStateMixin {
  ChatController chatController = Get.put(ChatController());
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat(reverse: false);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(11.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  ));
  String count = "0";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    chatController.restoreApiCall(
      callBack: () {
        print("object");
        Get.to(() => const DashboardScreen());
      },
      count: (p0) {
        count = p0;
        setState(() {});
      },
    );
    // Future.delayed(Duration(seconds: 5), () {
    //
    //   Get.to(() => const DashboardScreen());
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: Get.height,
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Constants.assetPath + "bg.png"), fit: BoxFit.fill)),
      child: Column(
        children: [
          CustomImageView(
            onTap: () {},
            svgPath: "download.svg",
            height: 75,
            alignment: Alignment.topCenter,
          ).paddingOnly(top: 175),
          getVerSpace(20),
          getCustomFont("Restore backup", 26, AppColors.subCardColor, 1, fontWeight: FontWeight.w600, fontFamily: Constants.fontLato),
          getVerSpace(10),
          getCustomFont("$count messages found", 14, AppColors.subCardColor, 1, fontWeight: FontWeight.w400, fontFamily: Constants.fontLato),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                onTap: () {},
                svgPath: "download.svg",
                height: 45,
                color: AppColors.subCardColor,
                alignment: Alignment.topCenter,
              ),
              Stack(
                children: [
                  CustomImageView(onTap: () {}, svgPath: "dotted_line.svg", height: 30, alignment: Alignment.topCenter, width: MediaQuery.of(context).size.width / 1.5),
                  Positioned(
                      bottom: 5.0,
                      child: SlideTransition(
                        position: _offsetAnimation,
                        child: CustomImageView(
                          onTap: () {},
                          svgPath: "GreenDot.svg",
                          height: 20,
                          alignment: Alignment.topCenter,
                          // width:MediaQuery.of(context).size.width/1.5
                        ), //Icon
                      )),
                ],
              ),
              CustomImageView(
                onTap: () {},
                svgPath: "mobile.svg",
                height: 45,
                color: AppColors.subCardColor,
                alignment: Alignment.topCenter,
              ),
            ],
          ).paddingOnly(top: 175),
          getCustomFont("Restore is in progress.", 16, AppColors.subCardColor, 1, fontWeight: FontWeight.w700, fontFamily: Constants.fontLato).paddingOnly(top: 20),
          getVerSpace(10),
          getCustomFont("Please do not close the application till restore successfully completed.", 13, AppColors.subCardColor, 2, fontWeight: FontWeight.w400, fontFamily: Constants.fontLato, textAlign: TextAlign.center).paddingSymmetric(horizontal: 80),
        ],
      ),
    ));
  }
}
