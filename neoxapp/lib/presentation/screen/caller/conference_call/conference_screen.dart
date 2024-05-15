import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:neoxapp/generated/l10n.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/controller/conference_call_controller.dart';
import 'package:neoxapp/presentation/screen/dashboard/model/history_model.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';

class ConferenceScreen extends StatefulWidget {
  const ConferenceScreen({Key? key}) : super(key: key);

  @override
  State<ConferenceScreen> createState() => _ConferenceScreenState();
}

class _ConferenceScreenState extends State<ConferenceScreen> {
  ConferenceCallController controller = Get.put(ConferenceCallController());

  late final HistoryModel historyModel;
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (controller) => Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        decoration: commonSizeForDesktop(context) ? BoxDecoration(color: AppColors.subCardColor) : BoxDecoration(image: DecorationImage(image: AssetImage(themeController.isDarkMode ? Constants.assetPath + "dark_dashboard.png" : Constants.assetPath + "history_bg.png"), fit: BoxFit.fill)),
        child: Stack(
          children: [
            if (commonSizeForDesktop(context))
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
                preferredSize: const Size.fromHeight(80),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  title: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 20,
                          color: AppColors.getFontColor(context),
                        ),
                        const SizedBox(width: 10),
                        getCustomFont(
                          S.of(context).conferenceCall,
                          15,
                          AppColors.getFontColor(context),
                          1,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                        )
                      ],
                    ).paddingOnly(top: 20),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(color: themeController.isDarkMode ? Color(0xff272A2F) : Colors.white, borderRadius: BorderRadius.circular(16)),
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: Column(
                        children: [
                          ListView.builder(
                            itemCount: 3,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // Get.to(MultipalCall());
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 38,
                                          width: 38,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(color: Color(0xffEBF0FF), shape: BoxShape.circle),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            getCustomFont(
                                              "hello",
                                              16,
                                              AppColors.getFontColor(context),
                                              1,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Row(
                                                  children: [
                                                    getCustomFont("2m 22s", 13, AppColors.getSubFontColor(context), 1, fontWeight: FontWeight.w400),
                                                  ],
                                                )),
                                              ],
                                            ),
                                          ],
                                        )),
                                      ],
                                    ).paddingSymmetric(horizontal: 16, vertical: 8),
                                  ),
                                  Divider(
                                    thickness: 2,
                                    color: Color(0xffF4F4F5),
                                  )
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ).paddingSymmetric(horizontal: 20)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      init: ConferenceCallController(),
    );
  }
}
