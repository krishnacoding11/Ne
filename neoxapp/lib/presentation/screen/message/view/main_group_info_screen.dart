import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/screen/message/view/add_member_screen.dart';
import 'package:neoxapp/presentation/widgets/custom_image_view.dart';

class MainGroupInfoScreen extends StatefulWidget {
  final Function? backOnTap;
  final Function? addMemberTap;
  const MainGroupInfoScreen({super.key, this.backOnTap, this.addMemberTap});

  @override
  State<MainGroupInfoScreen> createState() => _MainGroupInfoScreenState();
}

class _MainGroupInfoScreenState extends State<MainGroupInfoScreen> {
  RxBool isMessageAdmin = false.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    if (commonSizeForDesktop(context)) {
                      if (widget.backOnTap != null) {
                        widget.backOnTap!();
                      }
                    } else {
                      Get.back();
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 10),
                      Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 20,
                        color: AppColors.getFontColor(context),
                      ),
                      const SizedBox(width: 10),
                      getCustomFont(
                        "Group info",
                        15,
                        AppColors.getFontColor(context),
                        1,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                      )
                    ],
                  ).paddingOnly(top: 20),
                ),
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit,
                        color: AppColors.getFontColor(context),
                      ))
                ],
              ),
            ),
            body: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            "https://media.istockphoto.com/id/471674230/photo/portrait-of-an-american-real-man.jpg?s=612x612&w=0&k=20&c=Z5PvQP3jfjeuDRau_SOApsmexDveMblcYyrdVd-BgQE=",
                            fit: BoxFit.fill,
                          )),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Group name",
                    style: TextStyle(fontSize: 23, color: AppColors.getFontColor(context), fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Group  ",
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.getFontColor(context),
                        ),
                      ),
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.getFontColor(context),
                        ),
                      ),
                      Text(
                        "  32 members",
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.getFontColor(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                        width: commonSizeForLargDesktop(context) ? 900 : double.infinity,
                        height: MediaQuery.of(context).size.height,
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white,
                          boxShadow: [BoxShadow(color: themeController.isDarkMode ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08), spreadRadius: 2, blurRadius: 20)],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  CustomImageView(
                                    svgPath: 'chatImage.svg',
                                    height: 25,
                                  ),
                                  const SizedBox(width: 25),
                                  Text(
                                    "Messaging admin only",
                                    style: TextStyle(color: AppColors.getFontColor(context), fontSize: 15),
                                  ),
                                  const Spacer(),
                                  StreamBuilder(
                                      stream: isMessageAdmin.stream,
                                      builder: (context, snapshot) {
                                        return CupertinoSwitch(
                                          value: isMessageAdmin.value,
                                          activeColor: Colors.green,
                                          onChanged: (bool? value) {
                                            isMessageAdmin.value = value ?? false;
                                          },
                                        );
                                      }),
                                ],
                              ),
                            ),
                            Divider(
                              color: themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor,
                            ).paddingOnly(right: 20),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                if (commonSizeForDesktop(context)) {
                                  if (widget.addMemberTap != null) {
                                    widget.addMemberTap!();
                                  }
                                } else {
                                  // final List<String> memberIdList = selectContactList.map((city) => city.sId??'').toList();

                                  Get.to(() => const AddMemberScreen());
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: AppColors.primaryColor.withOpacity(0.1),
                                      ),
                                      child: CustomImageView(
                                        svgPath: "add_call_icon.svg",
                                        color: themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor,
                                        // height: 28.h,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      "Add member",
                                      style: TextStyle(fontSize: 15, color: themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor,
                            ).paddingOnly(right: 20),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: 2,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        isDismissible: true,
                                        context: context,
                                        backgroundColor: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                                        builder: (BuildContext context) {
                                          return Container(
                                              height: 300,
                                              padding: const EdgeInsets.all(25),
                                              decoration: BoxDecoration(color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white, borderRadius: BorderRadius.circular(16)),
                                                    margin: const EdgeInsets.only(left: 16, right: 16, top: 15),
                                                    child: Row(
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            Padding(padding: const EdgeInsets.only(top: 6, right: 6), child: Container(height: 30, width: 30, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle), child: getCustomFont(Constants.split("UnKnown"), 12, themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor, 1, fontWeight: FontWeight.w400, textAlign: TextAlign.center))),
                                                            const Positioned(
                                                                right: 1,
                                                                child: Icon(
                                                                  Icons.check_circle,
                                                                  color: Colors.green,
                                                                  size: 18,
                                                                ))
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        Expanded(
                                                          child: getCustomFont(
                                                            "Aren Tanouye",
                                                            15,
                                                            AppColors.getFontColor(context),
                                                            1,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        if (index == 1)
                                                          Text(
                                                            "Admin",
                                                            style: TextStyle(color: AppColors.getSubCardColor(context)),
                                                          )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  const Divider().paddingSymmetric(horizontal: 5),
                                                  const SizedBox(height: 15),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10),
                                                      child: Row(
                                                        children: [
                                                          CustomImageView(
                                                            svgPath: "groupadmin_image.svg",
                                                            // height: 28.h,
                                                          ),
                                                          const SizedBox(width: 15),
                                                          Text(
                                                            "Make group admin",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: AppColors.getFontColor(context),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10),
                                                      child: Row(
                                                        children: [
                                                          CustomImageView(
                                                            svgPath: "delete.svg",
                                                            color: AppColors.callEndColor,
                                                            // height: 28.h,
                                                          ),
                                                          const SizedBox(width: 15),
                                                          Text(
                                                            "Remove from group",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: AppColors.callEndColor,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Center(
                                                      child: InkWell(
                                                          onTap: () {
                                                            Get.back();
                                                          },
                                                          child: Text(
                                                            "Cancel",
                                                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: AppColors.getFontColor(context)),
                                                          )))
                                                ],
                                              ));
                                        },
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white, borderRadius: BorderRadius.circular(16)),
                                      margin: const EdgeInsets.only(left: 16, right: 16, top: 15),
                                      child: Row(
                                        children: [
                                          Stack(
                                            children: [
                                              Padding(padding: const EdgeInsets.only(top: 6, right: 6), child: Container(height: 30, width: 30, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle), child: getCustomFont(Constants.split("UnKnown"), 12, themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor, 1, fontWeight: FontWeight.w400, textAlign: TextAlign.center))),
                                              const Positioned(
                                                  right: 1,
                                                  child: Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 18,
                                                  ))
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: getCustomFont(
                                              "Aren Tanouye",
                                              15,
                                              AppColors.getFontColor(context),
                                              1,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          if (index == 1)
                                            Text(
                                              "Admin",
                                              style: TextStyle(color: AppColors.getSubCardColor(context)),
                                            )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
