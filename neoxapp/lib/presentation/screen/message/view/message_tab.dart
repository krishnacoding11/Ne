import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/controller/dashboard_controller.dart';
import 'package:neoxapp/presentation/screen/message/view/new_chat_list_screen.dart';
import 'package:neoxapp/presentation/screen/message/view/new_message_tab.dart';
import '../../../../../core/widget.dart';
import '../../../../../generated/l10n.dart';
import '../../../controller/chat_controller.dart';
import '../../../controller/message_controller.dart';
import '../../../controller/new_socket_controller.dart';
import '../../../widgets/globle.dart';

class MessageScreen extends StatefulWidget {
  final Function(int)? mssageOnTap;
  final Function? newChatOnTap;

  const MessageScreen({super.key, this.mssageOnTap, this.newChatOnTap});

  @override
  State<MessageScreen> createState() => _StateMessageScreen();
}

class _StateMessageScreen extends State<MessageScreen> with WidgetsBindingObserver {
  DashboardController dashboardController = Get.put(DashboardController());
  MessageController messageController = Get.put(MessageController());
  ChatController chatController = Get.put(ChatController());
  NewSocketController newSocketController = Get.find();
  RxBool isLoading = false.obs;
  RxInt selectIndex = 1000.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    messageController.chatSearchList.value = messageController.restoreDataModel.value.sideBarData!;
    chatController.updateUnreadCount.value = "";
  }

  var appLifeState;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('didChangeAppLifecycleState ${state}');
    appLifeState = state;
    if (state == AppLifecycleState.paused) {
      newSocketController.socketDisconnect();
    } else if (state == AppLifecycleState.resumed) {
      newSocketController.socketconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    filterList(String filterString) {
      setState(() {
        messageController.chatSearchList.value = messageController.restoreDataModel.value.sideBarData!.where((u) => u.name!.toLowerCase().contains(filterString.toLowerCase()) || u.name!.toUpperCase().contains(filterString.toUpperCase())).toList();
      });
      // messageController.chatSearchList.refresh();
      messageController.update();
    }

    return GetBuilder(
      builder: (controller) => Container(
        decoration: commonSizeForDesktop(context) ? null : BoxDecoration(image: DecorationImage(image: AssetImage(themeController.isDarkMode ? Constants.assetPath + "dark_dashboard.png" : Constants.assetPath + "history_bg.png"), fit: BoxFit.fill)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (commonSizeForDesktop(context)) {
                if (widget.newChatOnTap != null) {
                  widget.newChatOnTap!();
                }
              } else {
                Get.to(() => const NewChatListScreen());
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            backgroundColor: AppColors.primaryColor,
            child: Icon(Icons.add, color: AppColors.subCardColor, size: 30),
          ).paddingOnly(bottom: commonSizeForDesktop(context) ? 10 : 90, left: 20),
          body: SafeArea(
            child: StreamBuilder(
                stream: controller.restoreDataModel.stream,
                builder: (context, snapshot) {
                  return Column(children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 40,
                        ),
                        Expanded(
                            child: getCustomFont(
                          S.of(context).messaging,
                          24,
                          AppColors.getFontColor(context),
                          1,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                        )),
                        // CustomImageView(
                        //   svgPath: 'search.svg',
                        //   height: 24.h,
                        // ),
                        const SizedBox(
                          width: 16,
                        ),
                      ],
                    ).marginOnly(bottom: 35, top: 30),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: commonSizeForDesktop(context) ? 900 : null,
                        clipBehavior: Clip.antiAlias,
                        padding: const EdgeInsets.only(bottom: 20),
                        decoration: ShapeDecoration(
                          color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white,
                          // color: AppColors.getCardColor(context),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            getSearchTextFiled(
                                textEditingController: controller.textEditingController,
                                suffix: true,
                                suffixIcon: 'search.svg',
                                hint: S.of(context).search,
                                context: context,
                                onChanged: (value) {
                                  filterList(value);
                                  selectIndex.refresh();
                                  // loginController.emailController.refresh();
                                }).marginSymmetric(horizontal: 20, vertical: 20),
                            Container(
                                height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height * 0.4,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: messageController.chatSearchList.length ?? 0,
                                  itemBuilder: (context, index) {
                                    String name = messageController.chatSearchList[index].name ?? "";

                                    // print("token==${messageController.chatSearchList[index].name}==${messageController.chatSearchList[index].sId}");
                                    // 65c333b473c402d04e481ed4
                                    return InkWell(
                                      onTap: () {
                                        //  print("token==${storage.read(ApiConfig.loginToken)}");
                                        if (commonSizeForDesktop(context)) {
                                          selectIndex.value = index;
                                          if (widget.mssageOnTap != null) {
                                            widget.mssageOnTap!(index);
                                          }
                                        } else {
                                          controller.textEditingController.clear();

                                          Get.to(() => NewMessageScreen(sideBarData: messageController.chatSearchList[index]));
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(color: themeController.isDarkMode ? AppColors.darkBgColor : (selectIndex.value == index ? AppColors.colorD4DFFF : Colors.white), borderRadius: BorderRadius.circular(0)),
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                        // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                        child: Row(
                                          children: [
                                            messageController.chatSearchList[index].image!.length > 2
                                                ? ClipOval(
                                                    child: Container(
                                                      height: 38,
                                                      width: 38,
                                                      child: CircleAvatar(
                                                        radius: 50,
                                                        backgroundColor: Colors.white,
                                                        child: Image.network(
                                                          "$mainUrl${messageController.chatSearchList[index].image}",
                                                          fit: BoxFit.fill,
                                                          height: 38,
                                                          width: 38,
                                                          errorBuilder: (context, error, stackTrace) {
                                                            return getEmptyImage(name);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : getEmptyImage(name),

                                            // ClipOval(
                                            //   child: Container(
                                            //       height: 38,
                                            //       width: 38,
                                            //       alignment: Alignment.center,
                                            //       decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle),
                                            //       child: messageController.chatSearchList[index].image!.length > 2
                                            //           ? CircleAvatar(
                                            //               radius: 50,
                                            //               backgroundColor: Colors.white,
                                            //               child: Image.network(
                                            //                 "$mainUrl${messageController.chatSearchList[index].image}",
                                            //                 fit: BoxFit.fill,
                                            //                 height: 38,
                                            //                 width: 38,
                                            //                 errorBuilder: (context, error, stackTrace) {
                                            //                   return Container(
                                            //                       decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle),
                                            //                       child: getCustomFont(name.length < 1 ? "" : controller.restoreDataModel.value.sideBarData?[index].name?.substring(0, 1) ?? "", 12, AppColors.getSubFontColor(context), 1, fontWeight: FontWeight.w400));
                                            //                 },
                                            //               ),
                                            //             )
                                            //           : getCustomFont(name.length < 1 ? "" : controller.restoreDataModel.value.sideBarData?[index].name?.substring(0, 1) ?? "", 12, AppColors.getSubFontColor(context), 1, fontWeight: FontWeight.w400)),
                                            // ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  messageController.chatSearchList[index].name!,
                                                  style: TextStyle(fontSize: 15, color: AppColors.getFontColor(context), fontWeight: FontWeight.w700),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  softWrap: false,
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Row(
                                                  children: [
                                                    // CustomImageView(
                                                    //   height: 14.h,
                                                    //   width: 14.h,
                                                    //   svgPath: 'call_incoming.svg',
                                                    //   color: smsMessage.status == 1
                                                    //       ? AppColors.greenColor
                                                    //       : smsMessage.status == 0
                                                    //       ? AppColors.redColor
                                                    //       : Color(
                                                    //     0xff91ADFF,
                                                    //   ),
                                                    // ),

                                                    Expanded(
                                                        child: Text(
                                                      messageController.chatSearchList[index].lastMessage ?? "",
                                                      style: TextStyle(fontSize: 12, color: AppColors.getSubFontColor(context), fontWeight: FontWeight.w400),
                                                      maxLines: 1,
                                                    )),
                                                  ],
                                                ),
                                              ],
                                            )),
                                            getCustomFont((messageController.chatSearchList[index].lastMessageTime?.isEmpty ?? true) ? "" : DateFormat().add_jmv().format(DateTime.parse(controller.restoreDataModel.value.sideBarData?[index].lastMessageTime ?? "").toLocal()) ?? "", 13, AppColors.getSubFontColor(context), 1, fontWeight: FontWeight.w400),
                                            messageController.chatSearchList[index].unreadMsgCount! > 0
                                                ? SizedBox(
                                                    height: 25,
                                                    width: 25,
                                                    child: CircleAvatar(
                                                      backgroundColor: AppColors.ColorEBF0FF,
                                                      radius: 50,
                                                      child: getCustomFont(
                                                        messageController.chatSearchList[index].unreadMsgCount.toString(),
                                                        10,
                                                        AppColors.primaryColor,
                                                        1,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  padding: EdgeInsets.zero,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ]);
                }),
          ),
        ),
        // child: Container(),
      ),
      init: MessageController(),
    );
  }

  getEmptyImage(String name) {
    return Container(height: 38, width: 38, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle), child: getCustomFont(name.length < 1 ? "" : name.substring(0, 1) ?? "", 12, AppColors.getSubFontColor(context), 1, fontWeight: FontWeight.w400));
  }

// getCell(String title, int i) {
//   return InkWell(
//     onTap: () {
//       messageController.onChange(i);
//     },
//     child: Container(
//         decoration: BoxDecoration(color: controller.tabIndex == i ? const Color(0xffEBF0FF) : Colors.transparent, borderRadius: BorderRadius.circular(100)),
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
//         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
//         child: getCustomFont(
//           title,
//           14,
//           controller.tabIndex == i ? AppColors.primaryColor : AppColors.hintColor,
//           1,
//           fontWeight: FontWeight.w600,
//           textAlign: TextAlign.center,
//         )),
//   );
// }
}
