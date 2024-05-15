import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart' as imagePicker;
import 'package:image_picker/image_picker.dart';
import 'package:neoxapp/api/databaseHelper.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/model/restore_data_model.dart';
import 'package:neoxapp/model/user_group_message_model.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/controller/dashboard_controller.dart';
import 'package:neoxapp/presentation/controller/new_message_controller.dart';
import 'package:neoxapp/presentation/screen/message/view/forworf_contect_screen.dart';
import 'package:neoxapp/presentation/screen/message/view/group_info_screen.dart';
import 'package:neoxapp/presentation/screen/message/view/new_message_tab.dart';
import '../../../../../core/widget.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/custom_textfield.dart';
import 'add_member_screen.dart';

class GroupMessageScreen extends StatefulWidget {
  final SideBarData? sideBarData;
  final Function? forwordOnTap;
  final Function? groupInfoOnTap;
  const GroupMessageScreen({super.key, this.forwordOnTap, this.groupInfoOnTap, this.sideBarData});

  @override
  State<GroupMessageScreen> createState() => _StatGroupMessageScreen();
}

class _StatGroupMessageScreen extends State<GroupMessageScreen> {
  NewMessagesController controller = Get.put(NewMessagesController());
  DashboardController dashboardController = Get.put(DashboardController());
  RxBool isLoading = false.obs;
  List<ChatModel> chatList = [
    ChatModel(title: "Who was that photographer you shared with me recently?", time: DateTime.now().toString(), isOtherUser: true, isVoise: true),
    ChatModel(title: "video", time: DateTime.now().toString(), image: "https://media.istockphoto.com/id/471674230/photo/portrait-of-an-american-real-man.jpg?s=612x612&w=0&k=20&c=Z5PvQP3jfjeuDRau_SOApsmexDveMblcYyrdVd-BgQE="),
    ChatModel(title: "Who was that photographer you shared with me recently?", time: DateTime.now().toString()),
    ChatModel(title: "Slim Aarons", time: DateTime.now().toString()),
    ChatModel(title: "That’s him! 😃", time: DateTime.now().toString(), isOtherUser: true),
    ChatModel(title: "Who was that photographer you shared with me recently?", time: DateTime.now().toString()),
    ChatModel(title: "What was his vision statement?", time: DateTime.now().toString()),
    ChatModel(title: "Attractive people doing attractive things in attractive places ", time: DateTime.now().toString(), isOtherUser: true),
    ChatModel(title: "Who was that photographer you shared with me recently?", time: DateTime.now().toString(), image: "https://media.istockphoto.com/id/471674230/photo/portrait-of-an-american-real-man.jpg?s=612x612&w=0&k=20&c=Z5PvQP3jfjeuDRau_SOApsmexDveMblcYyrdVd-BgQE="),
    ChatModel(title: "Who was that photographer you shared with me recently?", time: DateTime.now().toString(), isOtherUser: true),
  ];

  Rx<RestoreDataModel> restoreDataModel = RestoreDataModel().obs;
  RxList<UserGroupChatDataModel> chatDataModelList = <UserGroupChatDataModel>[].obs;
  getMessageData() async {
    List<Map<String, dynamic>> data = await getRestoreData();
    List<Map<String, dynamic>> sideBarData = await getRestoreSideBarData();
    List<Map<String, dynamic>> userChatDataData = await getRestoreUserChatData();
    List<Map<String, dynamic>> userUserGroupChatData = await getRestoreUserGroupChatData();
    print("userUserGroupChatData==============>>>>>${userUserGroupChatData}");
    print("==============>>>>>${data.length}==${sideBarData.length}==${userChatDataData.length}==${userUserGroupChatData.length}");

    Map<String, dynamic> tData = {"success": data[0]["success"], "userChatDataLength": data[0]["userChatDataLength"], "UserGroupChatDataLength": data[0]["UserGroupChatDataLength"], "sideBarData": sideBarData, "userChatData": userChatDataData, "UserGroupChatData": userUserGroupChatData};
    restoreDataModel.value = RestoreDataModel.fromJson(tData);
    print("=============widget===========${widget.sideBarData?.sId}");
    restoreDataModel.value.userGroupChatData?.forEach((element) {
      if ((widget.sideBarData?.sId == element.groupId) || (widget.sideBarData?.sId == element.groupId)) {
        chatDataModelList.add(element);
      }
    });
    print("restoreDataModel===${chatDataModelList..length}");
    print("restoreDataModel===${restoreDataModel.value.userChatData!.length}");

    print("==============>>>>>${tData["sideBarData"]}");
    print("==============>>>>>${tData["UserGroupChatData"]}");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    print("call==${size.height}");

    return GetBuilder(
      builder: (controller) => Container(
        decoration: BoxDecoration(
          color: themeController.isDarkMode ? AppColors.color1F222A : AppColors.ColorF4F4F5,
          // image: DecorationImage(image: AssetImage(themeController.isDarkMode ? Constants.assetPath + "dark_history_bg.png" : Constants.assetPath + "history_bg.png"), fit: BoxFit.fill)
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 58,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: AppColors.getCardColor(context),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (commonSizeForDesktop(context)) {
                              if (widget.groupInfoOnTap != null) {
                                widget.groupInfoOnTap!();
                              }
                            } else {
                              if (widget.sideBarData!.isGroup == 1) {
                                dashboardController.getGroupDetailsApi(
                                  id: widget.sideBarData?.sId,
                                  callBack: (p0) {
                                    Get.to(GroupInfoScreen(
                                      groupDetailModel: p0,
                                    ));
                                  },
                                );
                              }
                            }
                          },
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    color: AppColors.getFontColor(context),
                                    size: 15,
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                height: 28,
                                width: 28,
                                padding: const EdgeInsets.all(1),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle),
                                child: const Icon(Icons.person),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: getCustomFont(
                                  '36 Members',
                                  16,
                                  AppColors.getFontColor(context),
                                  1,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuButton<int>(
                        color: const Color(0xffFFFFFF),
                        // iconColor: AppColors.getFontColor(context),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        position: PopupMenuPosition.under,
                        itemBuilder: (context) => [
                          PopupMenuItem<int>(
                              value: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Row(
                                  children: [
                                    CustomImageView(
                                      svgPath: 'addcontect.svg',
                                      height: 25,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text("Add contacts"),
                                  ],
                                ),
                              )),
                          PopupMenuItem<int>(
                              value: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Row(
                                  children: [
                                    CustomImageView(
                                      svgPath: 'chatImage.svg',
                                      height: 25,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text("Clear chat"),
                                  ],
                                ),
                              )),
                          PopupMenuItem<int>(
                              value: 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Row(
                                  children: [
                                    CustomImageView(
                                      svgPath: 'clear_image.svg',
                                      height: 25,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text("Group info"),
                                  ],
                                ),
                              )),
                          PopupMenuItem<int>(
                              value: 3,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Row(
                                  children: [
                                    CustomImageView(
                                      svgPath: 'notifation_icon.svg',
                                      height: 25,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text("Mute notification"),
                                  ],
                                ),
                              )),
                          PopupMenuItem<int>(
                              value: 4,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Row(
                                  children: [
                                    CustomImageView(
                                      svgPath: 'leaveimage.svg',
                                      height: 25,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text("Leave group"),
                                  ],
                                ),
                              )),
                          PopupMenuItem<int>(
                              value: 4,
                              child: Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.redColor.withOpacity(0.1)),
                                child: Row(
                                  children: [
                                    CustomImageView(
                                      svgPath: 'delete_icon.svg',
                                      height: 25,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Delete group",
                                      style: TextStyle(color: AppColors.redColor),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                        onSelected: (item) {
                          if (item == 4) {
                            deleteChatDailog();
                          } else if (item == 0) {
                            Get.to(() => const AddMemberScreen());
                          }
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    padding: const EdgeInsets.only(bottom: 20),
                    decoration: commonSizeForDesktop(context)
                        ? BoxDecoration(color: AppColors.colorFFFFFF)
                        : ShapeDecoration(
                            image: DecorationImage(image: AssetImage(themeController.isDarkMode ? Constants.assetPath + "dark_dashboard.png" : Constants.assetPath + "history_bg.png"), fit: BoxFit.fill),
                            color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white,
                            // color: AppColors.getCardColor(context),
                            shape: const RoundedRectangleBorder(
                                // borderRadius: BorderRadius.only(topRight: Radius.circular(16.r), topLeft: Radius.circular(16.r)),
                                ),
                          ),
                    child: Stack(
                      children: [
                        if (commonSizeForDesktop(context))
                          SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                    child: Image.asset(
                                  "assets/images/backgorundimage.png",
                                  height: 350,
                                  width: 350,
                                  fit: BoxFit.fill,
                                )),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          child: ListView.builder(
                              itemCount: chatList.length,
                              shrinkWrap: true,
                              reverse: true,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 20, left: (chatList[index].isOtherUser ?? false) ? 50 : 0, right: (chatList[index].isOtherUser ?? false) ? 0 : 50),
                                  child: Align(
                                    alignment: (chatList[index].isOtherUser ?? false) ? Alignment.centerRight : Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment: (chatList[index].isOtherUser ?? false) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onLongPressStart: (LongPressStartDetails details) {
                                            final left = details.globalPosition.dx;
                                            final top = details.globalPosition.dy;
                                            showMenu<MenuItem>(
                                              context: context,
                                              position: RelativeRect.fromLTRB(left, top, left, top),
                                              items: [
                                                ...EditMenuItems.firstItems.map(
                                                  (item) => PopupMenuItem(
                                                    value: item,
                                                    onTap: () {
                                                      if (item == EditMenuItems.Reply) {
                                                        chatList[index].isReply = true;
                                                        selectChatModel.value = chatList[index];
                                                      } else if (item == EditMenuItems.Forward) {
                                                        if (commonSizeForDesktop(context)) {
                                                          if (widget.forwordOnTap != null) {
                                                            widget.forwordOnTap!();
                                                          }
                                                        } else {
                                                          Get.to(() => const ForwardContactScreenScreen());
                                                        }
                                                      }
                                                    },
                                                    child: MenuItems.buildItem(item),
                                                  ),
                                                ),
                                              ],
                                              color: AppColors.colorFFFFFF,
                                            );
                                          },
                                          child: DecoratedBox(
                                            // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            // margin: EdgeInsets.only(bottom: 20),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: const Radius.circular(15), topLeft: const Radius.circular(15), bottomRight: Radius.circular((chatList[index].isOtherUser ?? false) ? 0 : 15), bottomLeft: Radius.circular((chatList[index].isOtherUser ?? false) ? 15 : 0)), color: AppColors.colorD4DFFF),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                              child: (chatList[index].title == "video")
                                                  ? ClipRRect(
                                                      borderRadius: BorderRadius.circular(15),
                                                      child: SizedBox(
                                                        width: 200,
                                                        height: 150,
                                                        child: Stack(
                                                          children: [
                                                            Image.network(
                                                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgdZpEDslKnjBmPC6dlF6pf9Q2m1o5aMdHwg&usqp=CAU",
                                                              height: 150,
                                                              width: 200,
                                                              fit: BoxFit.fill,
                                                            ),
                                                            Center(
                                                                child: Icon(
                                                              Icons.play_circle_fill_outlined,
                                                              color: AppColors.ColorF4F4F5,
                                                              size: 30,
                                                            ))
                                                          ],
                                                        ),
                                                      ))
                                                  : (chatList[index].isVoise ?? false)
                                                      ? Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              "Dhaval Patel",
                                                              style: TextStyle(color: AppColors.color1F222A, fontWeight: FontWeight.w400, fontSize: 15),
                                                            ),
                                                            const SizedBox(width: 10),
                                                            Container(
                                                              height: 40,
                                                              width: 40,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(100),
                                                                color: AppColors.color1B47C5.withOpacity(0.5),
                                                              ),
                                                              child: const Center(
                                                                  child: Text(
                                                                "DP",
                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                                              )),
                                                            ),
                                                            const SizedBox(width: 10),
                                                            const Icon(Icons.arrow_forward_ios)
                                                          ],
                                                        )
                                                      : (chatList[index].image?.isEmpty ?? true)
                                                          ? Text(
                                                              chatList[index].title ?? "",
                                                              style: TextStyle(color: AppColors.color1F222A, fontWeight: FontWeight.w400, fontSize: 15),
                                                            )
                                                          : ClipRRect(
                                                              borderRadius: BorderRadius.circular(15),
                                                              child: Image.network(
                                                                chatList[index].image ?? "",
                                                                height: 150,
                                                              )),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "3:00PM",
                                          style: TextStyle(color: AppColors.subFontColor),
                                        ).paddingOnly(left: (chatList[index].isOtherUser ?? false) ? 0 : 10, right: (chatList[index].isOtherUser ?? false) ? 10 : 0)
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                customTextField()
              ],
            ),
          ),
        ),
        // child: Container(),
      ),
      init: NewMessagesController(),
    );
  }

  deleteChatDailog() {
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
                    Icons.clear,
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
                  "Do you really want to delete these item? This process cannot be undone.",
                  style: TextStyle(color: AppColors.hintColor, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
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
                    const SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.callEndColor,
                        ),
                        child: Center(
                            child: Text(
                          "Delete",
                          style: TextStyle(color: AppColors.subFont1),
                        )),
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

  blockDailog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            // insetPadding: EdgeInsets.symmetric(horizontal: 25),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                Text(
                  "Unblock Aren Tanouye to send a message.",
                  style: TextStyle(color: AppColors.hintColor, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      child: InkWell(
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
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.primaryColor,
                          ),
                          child: Center(
                              child: Text(
                            "Unblock",
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

  textReplyView() {
    return Container(
      // height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.colorD4DFFF,
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Text(
            selectChatModel.value.title ?? "",
            style: TextStyle(color: AppColors.fontColor),
          )),
          InkWell(
              onTap: () {
                selectChatModel.value = ChatModel();
              },
              child: const Icon(Icons.clear))
        ],
      ),
    );
  }

  docView() {
    return Container(
        // height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.colorD4DFFF,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 62,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryColor,
                  ),
                ),
                Container(
                  // height: 65,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.colorFFFFFF,
                  ),
                  margin: const EdgeInsets.only(left: 5),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              " Aren Tanouye",
                              style: TextStyle(fontSize: 14, color: AppColors.fontColor, fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                CustomImageView(
                                  svgPath: 'other_otion_image.svg',
                                  onTap: null,
                                  height: 20,
                                  color: AppColors.colorA2A6AE,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "New Document.pdf",
                                  style: TextStyle(fontSize: 14, color: AppColors.colorA2A6AE, fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  "  1.2 MB",
                                  style: TextStyle(fontSize: 14, color: AppColors.primaryColor, fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Stack(
                        children: [
                          Container(
                            height: 62,
                            width: 60,
                            decoration: BoxDecoration(color: AppColors.ColorEBF0FF, borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
                            padding: const EdgeInsets.all(14),
                            child: CustomImageView(
                              svgPath: 'other_otion_image.svg',
                              onTap: null,
                              height: 23,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Positioned(
                              top: 5,
                              right: 2,
                              child: InkWell(
                                  onTap: () {
                                    selectChatModel.value = ChatModel();
                                  },
                                  child: const Icon(
                                    Icons.clear,
                                    size: 20,
                                  )))
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 9),
            Text(
              "Hi, Jimmy! Any update today?",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.fontColor),
            )
          ],
        ));
  }

  voiceReplyView() {
    return Container(
        // height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.colorD4DFFF,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 62,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryColor,
                  ),
                ),
                Container(
                  // height: 65,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.colorFFFFFF,
                  ),
                  margin: const EdgeInsets.only(left: 5),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              " Aren Tanouye",
                              style: TextStyle(fontSize: 14, color: AppColors.fontColor, fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                CustomImageView(
                                  svgPath: 'mute.svg',
                                  onTap: null,
                                  height: 20,
                                  color: AppColors.colorA2A6AE,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Audio",
                                  style: TextStyle(fontSize: 14, color: AppColors.colorA2A6AE, fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  "  1.2 MB",
                                  style: TextStyle(fontSize: 14, color: AppColors.primaryColor, fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Stack(
                        children: [
                          Container(
                            height: 62,
                            width: 60,
                            decoration: BoxDecoration(color: AppColors.ColorEBF0FF, borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
                            // padding: EdgeInsets.all(14),
                            child: CustomImageView(
                              svgPath: 'voiceImage.svg',
                              onTap: null,
                              height: 23,
                              // color: AppColors.primaryColor,
                            ),
                          ),
                          Positioned(
                              top: 5,
                              right: 2,
                              child: InkWell(
                                  onTap: () {
                                    selectChatModel.value = ChatModel();
                                  },
                                  child: const Icon(
                                    Icons.clear,
                                    size: 20,
                                  )))
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 9),
            Text(
              "Hi, Jimmy! Any update today?",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.fontColor),
            )
          ],
        ));
  }

  imageReplyView() {
    return Container(
        // height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.colorD4DFFF,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 62,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryColor,
                  ),
                ),
                Container(
                  // height: 65,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.colorFFFFFF,
                  ),
                  margin: const EdgeInsets.only(left: 5),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              " Aren Tanouye",
                              style: TextStyle(fontSize: 14, color: AppColors.fontColor, fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                CustomImageView(
                                  svgPath: 'cameraImage.svg',
                                  onTap: null,
                                  height: 20,
                                  color: AppColors.colorA2A6AE,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Photo",
                                  style: TextStyle(fontSize: 14, color: AppColors.colorA2A6AE, fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  "  1.2 MB",
                                  style: TextStyle(fontSize: 14, color: AppColors.primaryColor, fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Stack(
                        children: [
                          Container(
                            height: 62,
                            width: 60,
                            decoration: BoxDecoration(color: AppColors.ColorEBF0FF, borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
                            // padding: EdgeInsets.all(14),
                            child: ClipRRect(
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                child: Image.network(
                                  selectChatModel.value.image ?? "",
                                  fit: BoxFit.fill,
                                )),
                          ),
                          Positioned(
                              top: 5,
                              right: 2,
                              child: InkWell(
                                  onTap: () {
                                    selectChatModel.value = ChatModel();
                                  },
                                  child: Icon(
                                    Icons.clear,
                                    size: 20,
                                    color: AppColors.colorFFFFFF,
                                  )))
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 9),
            Text(
              "Hi, Jimmy! Any update today?",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.fontColor),
            )
          ],
        ));
  }

  Rx<ChatModel> selectChatModel = ChatModel().obs;
  Widget customTextField() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColors.getCardColor(context),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15.0,
                  offset: Offset(0.0, 0.75),
                )
              ],
            ),
            child: StreamBuilder(
                stream: selectChatModel.stream,
                builder: (context, snapshot) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          width: commonSizeForVeryLargDesktop(context) ? 1000 : MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              selectChatModel.value.isReply != null
                                  ? selectChatModel.value.title == "doc"
                                      ? docView()
                                      : (selectChatModel.value.image?.isNotEmpty ?? false)
                                          ? imageReplyView()
                                          : (selectChatModel.value.isVoise ?? false)
                                              ? voiceReplyView()
                                              : textReplyView()
                                  : const SizedBox(),
                              CustomTextField(
                                showCursor: false,
                                height: 50,
                                controller: controller.chatController,
                                hintText: "   Type message here",
                                hintTextColor: AppColors.hintColor,
                                onTap: () {
                                  scrollUp();
                                  setState(() {});
                                },
                                onChanged: (value) {
                                  // print('value $value');
                                  // value = newMessagesController.scrollController
                                  //     .animateTo(
                                  //       newMessagesController.scrollController.position.maxScrollExtent +
                                  //           10.h5,
                                  //       duration: const Duration(milliseconds: 300),
                                  //       curve: Curves.easeOut,
                                  //     )
                                  //     .toString();
                                  // setState(() {});
                                },
                                fillColor: AppColors.subFont1,
                                suffixIcon: controller.chatController.text.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: CustomImageView(svgPath: 'mute.svg', onTap: null, height: 25, color: AppColors.subFontColor),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Container(
                                            // height: 45,
                                            //   width: 45,
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.primaryColor),
                                            child: CustomImageView(svgPath: 'sendicon.svg', onTap: null, height: 17)),
                                      ),
                                // prefixIcon: Padding(
                                //   padding: const EdgeInsets.all(8),
                                //   child: CustomImageView(svgPath: 'other_otion_image.svg', onTap: null, height: 25.h),
                                // ),
                                prefixIcon: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    customButton: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: CustomImageView(svgPath: 'other_otion_image.svg', onTap: null, height: 25),
                                    ),
                                    items: [
                                      ...MenuItems.firstItems.map(
                                        (item) => DropdownMenuItem<MenuItem>(
                                          value: item,
                                          child: MenuItems.buildItem(item),
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (value?.text == MenuItems.camera) {
                                        getFromCamera();
                                      }
                                    },
                                    dropdownStyleData: DropdownStyleData(
                                      width: 300,
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                      ),
                                      direction: DropdownDirection.textDirection,
                                      offset: const Offset(0, 8),
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      // customHeights: [
                                      //   ...List<double>.filled(MenuItems.firstItems.length, 48),
                                      // ],
                                      padding: EdgeInsets.only(left: 16, right: 16),
                                    ),
                                  ),
                                ),
                              ).marginSymmetric(horizontal: 16),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  File? cameraImage;
  getFromCamera() async {
    XFile? image = await imagePicker.ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      cameraImage = File(image.path ?? "");
    }
  }

  void scrollUp() {
    print("new message controller scroll");
    final position = controller.scrollController.position.maxScrollExtent + 40;
    controller.scrollController.jumpTo(position);

    setState(() {});
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final String icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [camera, photosAndVideos, audio, document, contact, location];

  static const camera = MenuItem(text: 'Camera', icon: "cameraImage.svg");
  static const photosAndVideos = MenuItem(text: 'Photos and Videos', icon: "photoicon.svg");
  static const audio = MenuItem(text: 'Audio', icon: "audioicon.svg");
  static const document = MenuItem(text: 'Document', icon: "docicon.svg");
  static const contact = MenuItem(text: 'Contact', icon: "cantacticon.svg");
  static const location = MenuItem(text: 'Location', icon: "locationicon.svg");

  static Widget buildItem(MenuItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          CustomImageView(svgPath: item.icon, onTap: null, height: 22),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              item.text,
              style: TextStyle(color: AppColors.fontColor, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.camera:
        //Do something
        break;
      case MenuItems.photosAndVideos:
        //Do something
        break;
      case MenuItems.audio:
        //Do something
        break;
      case MenuItems.location:
        break;
      case MenuItems.document:
        //Do something
        break;
    }
  }
}

abstract class EditMenuItems {
  static const List<MenuItem> firstItems = [Reply, Forward, Share, Copy, Edit, Delete];

  static const Reply = MenuItem(text: 'Reply', icon: "replyImage.svg");
  static const Forward = MenuItem(text: 'Forward', icon: "forwordimage.svg");
  static const Share = MenuItem(text: 'Share', icon: "shareimage.svg");
  static const Copy = MenuItem(text: 'Copy message', icon: "copyimage.svg");
  static const Edit = MenuItem(text: 'Edit message', icon: "editmessageimage.svg");
  static const Delete = MenuItem(text: 'Delete Message', icon: "delete_icon.svg");

  static Widget buildItem(MenuItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          CustomImageView(svgPath: item.icon, onTap: null, height: 22),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              item.text,
              style: TextStyle(color: item.text == "Delete Message" ? AppColors.callEndColor : AppColors.fontColor, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.camera:
        //Do something
        break;
      case MenuItems.photosAndVideos:
        //Do something
        break;
      case MenuItems.audio:
        //Do something
        break;
      case MenuItems.location:
        break;
      case MenuItems.document:
        //Do something
        break;
    }
  }
}
