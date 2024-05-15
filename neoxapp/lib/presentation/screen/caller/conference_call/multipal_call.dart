import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/route/app_routes.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/controller/conference_call_controller.dart';
import 'package:neoxapp/presentation/screen/dialpad/dial_pad.dart';
import 'package:neoxapp/presentation/widgets/custom_image_view.dart';

import '../../dashboard/model/contact_info_model.dart';

Widget multipalCall(ConferenceCallController controller, {ContactInfo? contactInfo, Function(ContactInfo)? hangup, Function(ContactInfo)? holdCall}) {
  if (contactInfo == null) {
    return Container();
  }

  return Container(
    height: 250,
    alignment: Alignment.topCenter,
    child: Container(
      decoration: BoxDecoration(
        color: themeController.isDarkMode ? Color(0xff272A2F) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              itemCount: contactList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Disable scrolling for the inner ListView.builder
              itemBuilder: (context, index) {
                print("cantac====${contactList[index].name}");
                print("cantac====${contactList.length}");
                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 38,
                          width: 38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xffEBF0FF),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getCustomFont(
                                contactList[index].name,
                                16,
                                AppColors.getFontColor(context),
                                1,
                                fontWeight: FontWeight.w700,
                              ),
                              SizedBox(height: 3),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        getCustomFont(
                                          "2m 22s",
                                          13,
                                          AppColors.getSubFontColor(context),
                                          1,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => GestureDetector(
                            onTap: () {
                              if (contactInfo.name == contactList[index].name) {}
                              // controller.holdCall.value = !controller.holdCall.value;
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: contactInfo.name == contactList[index].name ? Color(0xffEBF0FF) : Color(0xff91ADFF),
                                // color: controller.holdCall.value ? Color(0xffEBF0FF) : Color(0xff91ADFF),
                                shape: BoxShape.circle,
                              ),
                              child: CustomImageView(
                                height: 22,
                                width: 22,
                                onTap: () {
                                  if (holdCall != null) {
                                    holdCall(contactList[index]);
                                  }
                                  // controller.holdCall.value = !controller.holdCall.value;
                                },
                                svgPath: 'hold.svg',
                                color: controller.holdCall.value ? Color(0xff91ADFF) : Color(0xffFFFFFF),
                              ).paddingAll(5),
                            ).paddingSymmetric(horizontal: 5),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xffDE5327),
                              shape: BoxShape.circle,
                            ),
                            child: CustomImageView(
                              height: 22,
                              width: 22,
                              onTap: () {
                                if (hangup != null) {
                                  hangup(contactList[index]);
                                  contactList.remove(contactList[index]);
                                }
                              },
                              svgPath: 'cut.svg',
                              color: Color(0xffFFFFFF),
                            ).paddingAll(5),
                          ),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 16, vertical: 6),
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
      ),
    ),
  );
}
