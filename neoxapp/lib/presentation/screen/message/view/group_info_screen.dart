import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/controller/chat_controller.dart';
import 'package:neoxapp/presentation/controller/group_info_controller.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import '../../../../core/globals.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/group_detail_model.dart';
import '../../../controller/dashboard_controller.dart';
import '../../../controller/new_socket_controller.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/globle.dart';
import 'add_member_screen.dart';

class GroupInfoScreen extends StatefulWidget {
  final Function? backOnTap;
  final GroupDetailModel? groupDetailModel;

  GroupInfoScreen({required this.groupDetailModel, this.backOnTap});

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  DashboardController dashboardController = Get.find();
  GroupInfoController groupInfoController = Get.put(GroupInfoController());
  NewSocketController newSocketController = Get.find();
  ChatController chatController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bool isAdmin = false;

    groupInfoController.setData(widget.groupDetailModel);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: commonSizeForDesktop(context) ? BoxDecoration(color: AppColors.subCardColor) : BoxDecoration(image: DecorationImage(image: AssetImage(themeController.isDarkMode ? Constants.assetPath + "dark_dashboard.png" : Constants.assetPath + "history_bg.png"), fit: BoxFit.fill)),
      child: GetBuilder<GroupInfoController>(
        init: GroupInfoController(),
        builder: (controller) {
          bool isGroup = controller.groupDetailModel != null;

          GroupDetailModel? groupDetailModel = controller.groupDetailModel;

          print("fgfg====");

          if (groupDetailModel == null) {
            return Container();
          }

          return Stack(
            children: [
              if (commonSizeForDesktop(context))
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      isGroup
                          ? groupDetailModel.groupDetai.groupImage.isEmpty
                              ? getCustomFont(groupDetailModel.groupDetai.groupName.isEmpty ? "" : groupDetailModel.groupDetai.groupName.split(" ")[0].substring(0, 1), 8, AppColors.getSubFontColor(context), 1, fontWeight: FontWeight.w400)
                              : Image.network(
                                  "$mainUrl${groupDetailModel.groupDetai.groupImage}",
                                  height: 26,
                                  width: 26,
                                  fit: BoxFit.fill,
                                )
                          : Image.asset(
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
                        children: [
                          const SizedBox(width: 10),
                          Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 20,
                            color: AppColors.getFontColor(context),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: getCustomFont(
                              S.of(context).groupInfo,
                              15,
                              AppColors.getFontColor(context),
                              1,
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          chatController.isAdmin.value
                              ? GestureDetector(
                                  onTap: () {
                                    if (controller.isEdit.value) {
                                      if (controller.textFiledController.text.isEmpty) {
                                        return;
                                      }

                                      controller.sendData(isImage: true);
                                    } else {
                                      controller.isEdit.value = true;
                                      controller.update();
                                    }
                                  },
                                  child: controller.isEdit.value
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        )
                                      : SvgPicture.asset(
                                          'assets/images/edit_1.svg',
                                          color: themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor,
                                        ),
                                )
                              : Container()
                        ],
                      ).paddingOnly(top: 20),
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            if (controller.isEdit.value) {
                              controller.getImageFromGlarey();
                            }
                          },
                          child: Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: controller.isEdit.value
                                        ? themeController.isDarkMode
                                            ? AppColors.darkPrimaryColor
                                            : AppColors.primaryColor
                                        : Colors.transparent,
                                    width: controller.isEdit.value ? 1 : 0),
                                color: Color(0xffEFEFF1)
                                // color:isGroup
                                //     && groupDetailModel.groupDetai.groupImage.isEmpty ?Colors.white: Colors.transparent
                                ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: controller.path.isNotEmpty
                                    ? Image.file(
                                        new File(controller.path),
                                        height: 26,
                                        width: 26,
                                        fit: BoxFit.fill,
                                      )
                                    : isGroup
                                        ? groupDetailModel.groupDetai.groupImage.isEmpty
                                            ? Center(
                                                child: getCustomFont(Constants.split(groupDetailModel.groupDetai.groupName), 16, AppColors.fontColor, 1, fontWeight: FontWeight.bold),
                                              )
                                            : Image.network(
                                                "$mainUrl${groupDetailModel.groupDetai.groupImage}",
                                                height: 26,
                                                width: 26,
                                                fit: BoxFit.fill,
                                              )
                                        : Center(
                                            child: getCustomFont(Constants.split(groupDetailModel.groupDetai.groupName), 16, AppColors.fontColor, 1, fontWeight: FontWeight.bold),
                                          )

                                // child: Image.network(
                                //   "https://media.istockphoto.com/id/471674230/photo/portrait-of-an-american-real-man.jpg?s=612x612&w=0&k=20&c=Z5PvQP3jfjeuDRau_SOApsmexDveMblcYyrdVd-BgQE=",
                                //   fit: BoxFit.fill,
                                // )
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: controller.textFiledController,
                        enabled: controller.isEdit.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 23, color: AppColors.getFontColor(context), fontWeight: FontWeight.w600),
                        decoration: const InputDecoration(
                          hintText: '',
                          border: InputBorder.none,
                        ),
                      ),
                      // Text(
                      //   isGroup ? groupDetailModel.groupDetai.groupName : "Group name",
                      //   style: TextStyle(fontSize: 23, color: AppColors.getFontColor(context), fontWeight: FontWeight.w600),
                      // ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${S.of(context).group}  ",
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
                            "  ${isGroup ? groupDetailModel.groupDetai.groupUserCount : 0} ${S.of(context).members}",
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.getFontColor(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                          width: commonSizeForLargDesktop(context) ? 900 : double.infinity,
                          // height: MediaQuery.of(context).size.height,
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          padding: EdgeInsets.only(bottom: 50),
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white,
                            boxShadow: [BoxShadow(color: themeController.isDarkMode ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.1), spreadRadius: 2, blurRadius: 20)],
                            borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Obx(
                                () => chatController.isAdmin.value
                                    ? Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              // if (commonSizeForDesktop(context)) {
                                              //   if (widget.createGroupOnTap != null) {
                                              //     widget.createGroupOnTap!();
                                              //   }
                                              // } else {
                                              //   Get.to(() => const CreateGroupListScreen());
                                              // }
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 35,
                                                  width: 35,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(shape: BoxShape.circle),
                                                  child: CustomImageView(
                                                    svgPath: 'message.svg',
                                                    height: 14,
                                                    width: 14,
                                                    color: AppColors.colorA2A6AE,
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                Expanded(
                                                  child: getCustomFont(
                                                    'Messaging admin only',
                                                    15,
                                                    themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor,
                                                    1,
                                                    fontWeight: FontWeight.w600,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                                StreamBuilder(
                                                    stream: controller.isMessageAdmin.stream,
                                                    builder: (context, snapshot) {
                                                      return Transform.scale(
                                                        scale: 0.7,
                                                        child: CupertinoSwitch(
                                                          value: controller.isMessageAdmin.value,
                                                          activeColor: Colors.green,
                                                          onChanged: (bool? value) {
                                                            controller.isMessageAdmin.value = value ?? false;

                                                            controller.sendData(admin: value);
                                                          },
                                                        ),
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ).marginOnly(left: 16, right: 5),
                                          Divider(
                                            color: AppColors.primaryColor.withOpacity(0.3),
                                          ).marginSymmetric(vertical: 8),
                                          GestureDetector(
                                            onTap: () {
                                              if (commonSizeForDesktop(context)) {
                                                // if(widget.addMemberTap!= null ){
                                                //   widget.addMemberTap!();
                                                // }
                                              } else {
                                                final List<String> memberIdList = groupDetailModel.groupDetai.groupUsers.map((city) => city.memberId.id).toList();

                                                Get.to(() => AddMemberScreen(groupId: isGroup ? groupDetailModel.groupDetai.id : "", memberIdList: memberIdList))!.then((value) async {
                                                  if (value) {
                                                    controller.updateData();
                                                  }
                                                });
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: themeController.isDarkMode ? AppColors.darkPrimaryColor.withOpacity(0.5) : AppColors.primaryColor.withOpacity(0.1),
                                                  ),
                                                  padding: const EdgeInsets.all(5),
                                                  child: CustomImageView(
                                                    svgPath: 'add_member.svg',
                                                    color: themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor,
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                getCustomFont(
                                                  S.of(context).addMember,
                                                  15,
                                                  themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor,
                                                  1,
                                                  fontWeight: FontWeight.w600,
                                                  textAlign: TextAlign.start,
                                                )
                                              ],
                                            ),
                                          ).marginSymmetric(horizontal: 16),
                                          Divider(
                                            color: AppColors.primaryColor.withOpacity(0.3),
                                          ).marginSymmetric(vertical: 8),
                                        ],
                                      )
                                    : Container(),
                              ),
                              isGroup && groupDetailModel.groupDetai.groupUsers.isNotEmpty
                                  ? Builder(builder: (context) {
                                      List<GroupUser> list = groupDetailModel.groupDetai.groupUsers;
                                      bool isAdmin = false;
                                      list.forEach((element) {
                                        print(" value ad min ${element.memberId.id}  === ${chatController.uid.value}");
                                        if (element.memberId.id == chatController.uid.value) {
                                          if (element.isAdmin == 1) {
                                            isAdmin = true;
                                            print(" value ad min333 $isAdmin");
                                          }
                                        }
                                        ;
                                      });
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: list.length,
                                          itemBuilder: (context, index) {
                                            GroupUser user = list[index];
                                            String uid = getUserData().sId ?? "";

                                            if (user.isAdmin == 1) {
                                              controller.isAdminId = user.memberId.id;
                                            }

                                            print("l===${uid}==${user.id}-===${user.memberId.id}===${user.isAdmin}=${user.isAdmin == 0 && user.memberId.id == uid}");
                                            return GestureDetector(
                                              onTap: !isAdmin || user.memberId.id == chatController.uid.value && isAdmin
                                                  ? null
                                                  : () async {
                                                      print("l===${controller.isAdminId}==${uid}");
                                                      //
                                                      // if(uid == user.memberId.id){
                                                      //
                                                      // }
                                                      //
                                                      //
                                                      //

                                                      openPopup(user, controller, uid);
                                                    },
                                              child: Container(
                                                decoration: BoxDecoration(color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white, borderRadius: BorderRadius.circular(16)),
                                                margin: const EdgeInsets.only(left: 16, right: 16, top: 15),
                                                child: Row(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        Padding(
                                                            padding: const EdgeInsets.only(top: 6, right: 6),
                                                            child: Container(
                                                                height: 30,
                                                                width: 30,
                                                                alignment: Alignment.center,
                                                                decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle),
                                                                child: (user.memberId.userImage.isEmpty ?? true)
                                                                    ? getCustomFont(Constants.split('${user.memberId.firstName} ${user.memberId.lastName}'), 12, themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor, 1, fontWeight: FontWeight.w400, textAlign: TextAlign.center)
                                                                    : ClipOval(
                                                                        child: Image.network(
                                                                        height: 30,
                                                                        width: 30,
                                                                        mainUrl + (user.memberId.userImage),
                                                                      )))),
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
                                                        '${user.memberId.firstName} ${user.memberId.lastName}',
                                                        15,
                                                        AppColors.getFontColor(context),
                                                        1,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    if (user.isAdmin == 1)
                                                      Text(
                                                        S.of(context).admin,
                                                        style: TextStyle(color: AppColors.subFontColor),
                                                      )
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    })
                                  : Container(),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  openPopup(GroupUser user, controller, uid) {
    showModalBottomSheet(
      isDismissible: true,
      context: context,
      backgroundColor: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (BuildContext context) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white, borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 15),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 6, right: 6),
                              child: Container(
                                  height: 30,
                                  width: 30,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle),
                                  child: (user.memberId.userImage.isEmpty ?? true)
                                      ? getCustomFont(Constants.split('${user.memberId.firstName} ${user.memberId.lastName}'), 12, themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor, 1, fontWeight: FontWeight.w400, textAlign: TextAlign.center)
                                      : ClipOval(
                                          child: Image.network(
                                          height: 30,
                                          width: 30,
                                          mainUrl + (user.memberId.userImage),
                                        )))),
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
                          '${user.memberId.firstName} ${user.memberId.lastName}',
                          15,
                          AppColors.getFontColor(context),
                          1,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (user.isAdmin == 1)
                        Text(
                          S.of(context).admin,
                          style: TextStyle(color: AppColors.getSubCardColor(context)),
                        )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider().paddingSymmetric(horizontal: 5),
                const SizedBox(height: 15),
                if (user.isAdmin == 0 && user.memberId.id != uid)
                  InkWell(
                    onTap: () {
                      newSocketController.sendGroupAdmin(controller.groupDetailModel.groupDetai.id, user.memberId.id);
                      Get.back();
                      controller.updateData();
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
                            S.of(context).makeGroupAdmin,
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
                    // final List<String> memberIdList = selectContactList.map((city) => city.sId??'').toList();
                    newSocketController.removeGroupMembers(controller.groupDetailModel.groupDetai.id, user.memberId.id);
                    Get.back();
                    controller.updateData();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        CustomImageView(
                          svgPath: "delete_1.svg",
                          color: AppColors.callEndColor,
                          // height: 28.h,
                        ),
                        const SizedBox(width: 15),
                        Text(
                          S.of(context).removeFromGroup,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.callEndColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Center(
                    child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          S.of(context).cancel,
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: AppColors.getFontColor(context)),
                        )))
              ],
            ));
      },
    );
  }
}
