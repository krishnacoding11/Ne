import 'dart:convert' as json;
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart' as size;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart' as audioPlayer;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart' as getTimeAudio;
import 'package:moment_dart/moment_dart.dart';
import 'package:neoxapp/presentation/screen/message/view/share_Contact_Screen.dart';
// import 'package:rxdart/rxdart.dart' as audioRx;
import 'package:shimmer/shimmer.dart';
import 'package:record/record.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart' as imagePicker;
import 'package:image_picker/image_picker.dart';
import 'package:neoxapp/api/databaseHelper.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/globals.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:geolocator/geolocator.dart';
import 'package:neoxapp/model/chat_data_model.dart';
import 'package:neoxapp/presentation/controller/new_socket_controller.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/controller/dashboard_controller.dart';
import 'package:neoxapp/presentation/controller/new_message_controller.dart';
import 'package:neoxapp/presentation/screen/login/model/verify_model.dart';
import 'package:neoxapp/presentation/screen/message/view/forworf_contect_screen.dart';
import 'package:neoxapp/presentation/screen/message/view/image_text_send_screen.dart';
import 'package:neoxapp/presentation/screen/message/view/image_view_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_filex/open_filex.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:share_plus/share_plus.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import '../../../../../core/route/app_routes.dart';
import '../../../../../core/widget.dart';
// import 'package:path/path.dart' as p;
import '../../../../../generated/l10n.dart';
import '../../../../model/restore_data_model.dart';
import '../../../controller/chat_controller.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/globle.dart';
import 'group_info_screen.dart';
import 'video_play_screen.dart';
import 'package:mime/mime.dart';

const String dateFormatter = 'MMM dd, y';

extension DateHelper on DateTime {
  String formatDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }

  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month && this.day == other.day;
  }

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    return now.difference(this).inDays;
  }
}

class NewMessageScreen extends StatefulWidget {
  final SideBarData? sideBarData;

  const NewMessageScreen({super.key, this.sideBarData});

  @override
  State<NewMessageScreen> createState() => _StateNewMessageScreen();
}

class _StateNewMessageScreen extends State<NewMessageScreen> {
  // SocketController? _socketController;
  NewSocketController newSocketController = Get.put(NewSocketController());
  NewMessagesController controller = Get.put(NewMessagesController());
  DashboardController dashboardController = Get.put(DashboardController());
  ChatController chatController = Get.put(ChatController());

  RxBool isLoading = false.obs;
  RxBool isReply = false.obs;
  Directory appDirectory = Directory("");
  RxList<ChatDataModel> selectChatList = <ChatDataModel>[].obs;
  Rx<ChatDataModel> selectChatModel = ChatDataModel().obs;
  Rx<ChatDataModel> selectReplyChatModel = ChatDataModel().obs;
  RxBool isSelect = false.obs;
  RxBool isdelete = false.obs;
  RxBool isSenderr = false.obs;

  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    bool isGroup = controller.sideBarData?.isGroup == 1;
    UserDetails userDetails = await getUserData();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      print("postion ${position.latitude}");
      var id = (Random().nextInt(900000000) + 100000000).toString();
      var url = "https://maps.googleapis.com/maps/api/staticmap?center=\(${position.latitude}),\(${position.longitude})&zoom=13&size=400x400&markers=color:red%7Clabel:%7C\(${position.latitude}),\(${position.latitude})&key=";
      newSocketController.send_message(id, isGroup ? 1 : 0, controller.sideBarData!.sId, url, isGroup ? controller.sideBarData!.sId : null, 0, 6, selectChatModel.value.id, null, "", null, () async {
        getMessageData(i: true);
      }, firstName: userDetails.firstName ?? "", lastName: userDetails.lastName ?? "");

      setState(() => _currentPosition = position);
      selectChatModel.value = ChatDataModel();
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Rx<RestoreDataModel> restoreDataModel = RestoreDataModel().obs;
  RxList<ChatDataModel> chatDataModelList = <ChatDataModel>[].obs;

  getMessageData({bool i = false}) async {
    // chatDataModelList = <ChatDataModel>[].obs;

    // List<Map<String, dynamic>> data = await getRestoreData();
    // List<Map<String, dynamic>> sideBarData = await getRestoreSideBarData();
    List<Map<String, dynamic>> userChatDataData = await getRestoreUserChatData();
    List<Map<String, dynamic>> userUserGroupChatData = await getRestoreUserGroupChatData();

    // print("==============>>>>>${data.length}==${sideBarData.length}==${userChatDataData.length}==${userUserGroupChatData.length}");

    Map<String, dynamic> tData = {"userChatData": userChatDataData, "UserGroupChatData": userUserGroupChatData};
    restoreDataModel.value = RestoreDataModel.fromJson(tData);
    RxList<ChatDataModel> tempChatDataModelList = <ChatDataModel>[].obs;
    if (controller.sideBarData!.isGroup == 1) {
      print("===== insert 444 ${DateTime.now()}");
      restoreDataModel.value.userGroupChatData?.forEach((element) {
        if ((controller.sideBarData?.sId == element.groupId)) {
          Map<String, dynamic> map = {
            "_id": element.id,
            "MSG_ID": element.MSG_ID,
            "broadcast_id": null,
            "broadcast_msg_id": null,
            "originalName": element.originalName,
            "message": element.message,
            "message_caption": element.message_caption,
            "message_type": element.messageType,
            "media_type": element.mediaType,
            "filePath": element.filePath ?? "",
            "delivery_type": element.deliveryType,
            "reply_message_id": element.replyMessageId,
            "schedule_time": element.scheduleTime,
            "block_message_users": (element.blockMessageUsers),
            "delete_message_users": (element.deleteMessageUsers),
            "is_deleted": element.isDeleted,
            "message_reaction_users": json.jsonEncode(element.messageReactionUsers),
            "message_dissapear_time": json.jsonEncode(element.messageDissapearTime),
            "cid": element.cid,
            "sender_id": element.senderId.id,
            "senderFirstName": element.senderId.firstName,
            "senderLastName": element.senderId.lastName,
            "receiver_id": "",
            "group_id": element.groupId,
            "createdAt": element.createdAt.toString(),
            "updatedAt": element.updatedAt.toString(),
            "__v": element.v,
            "is_edited": element.isEdited,
          };
          tempChatDataModelList.add(ChatDataModel.fromJson(map, fromDatabase: true));
        }
      });
      var i = tempChatDataModelList.reversed.toList();

      tempChatDataModelList = <ChatDataModel>[].obs;
      tempChatDataModelList.addAll(i);
      chatDataModelList.value = tempChatDataModelList;
    } else {
      RxList<ChatDataModel> tempChatDataModelList = <ChatDataModel>[].obs;
      // chatDataModelList.clear();
      restoreDataModel.value.userChatData?.forEach((element) {
        if ((controller.sideBarData?.sId == element.senderId) || (controller.sideBarData?.sId == element.receiverId || controller.sideBarData?.sId == element.groupId)) {
          tempChatDataModelList.add(element);

          // if (element.deliveryType == 2 && element.MSG_ID != null) {
          //   newSocketController.sendDeliveryStatus(controller.sideBarData?.isGroup ?? 0, controller.sideBarData?.sId, element.MSG_ID as String, controller.sideBarData?.sId, 3);
          // }
        }
      });
      chatDataModelList.value = tempChatDataModelList;
    }

    // chatDataModelList.refresh();

    if (i) {
      controller.update();
    }
    print("restoreDataModel===${restoreDataModel.value.userChatData!.length}");
    // print("==============>>>>>${tData["sideBarData"]}");
    // print("==============>>>>>${tData["UserGroupChatData"]}");
  }

  @override
  void initState() {
    GetPermission();
    controller.setSideBarData(widget.sideBarData!);

    init();

    getMessageData();

    chatController.updateUnreadCount.value = controller.sideBarData!.sId!;
    chatController.GetIsBlock(controller.sideBarData!.sId);

    chatController.updateUnreadMessageCount(controller.sideBarData!.sId, true);
    chatController.getOnlineStatus(controller.sideBarData!.sId);
    if (controller.sideBarData?.isGroup == 0) {
      newSocketController.checkuserOnelineStatus(controller.sideBarData!.sId ?? "");
    }
    BackButtonInterceptor.add(myInterceptor);

    super.initState();
  }

  GetPermission() async {
    await Permission.photos.request();
    await Permission.mediaLibrary.request();
    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        // Permission.location,
        Permission.storage,
      ].request();
    }
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    chatController.updateUnreadCount.value = ""; // Do some stuff.
    return false;
  }

  final ScrollController _controller = ScrollController();
  void _scrollDown() {
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: Duration(microseconds: 6),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    print("call==${size.height}");
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: themeController.isDarkMode ? Colors.black : Colors.white, statusBarBrightness: themeController.isDarkMode ? Brightness.light : Brightness.dark, statusBarIconBrightness: themeController.isDarkMode ? Brightness.light : Brightness.dark));
    return SafeArea(
      child: GetBuilder(
        builder: (controller) => Container(
          decoration: BoxDecoration(
            color: themeController.isDarkMode ? AppColors.color1F222A : AppColors.ColorF4F4F5,
            // image: DecorationImage(image: AssetImage(themeController.isDarkMode ? Constants.assetPath + "dark_history_bg.png" : Constants.assetPath + "history_bg.png"), fit: BoxFit.fill)
          ),
          child: Stack(
            children: [
              // if (commonSizeForDesktop(context))
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Image.asset(
                      themeController.isDarkMode ? "${Constants.assetPath}dark_dashboard.png" : "${Constants.assetPath}history_bg.png",
                      height: MediaQuery.of(context).size.height - 100,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    )),
                  ],
                ),
              ).paddingOnly(top: 20),
              Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: Container(
                    decoration: commonSizeForDesktop(context)
                        ? null
                        : const ShapeDecoration(
                            // image: DecorationImage(image: AssetImage(themeController.isDarkMode ? "${Constants.assetPath}dark_dashboard.png" : "${Constants.assetPath}history_bg.png"), fit: BoxFit.fill),
                            // color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white,
                            color: Colors.transparent,
                            // color: AppColors.getCardColor(context),
                            shape: RoundedRectangleBorder(
                                // borderRadius: BorderRadius.only(topRight: Radius.circular(16.r), topLeft: Radius.circular(16.r)),
                                ),
                          ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 58,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              color: AppColors.getCardColor(context),
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
                                  ClipOval(
                                    child: Container(
                                        height: 26,
                                        width: 26,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle),
                                        child: controller.sideBarData!.image!.length > 1
                                            ? CircleAvatar(
                                                radius: 50,
                                                backgroundColor: Colors.white,
                                                child: Image.network(
                                                  "$mainUrl${controller.sideBarData!.image}",
                                                  height: 26,
                                                  width: 26,
                                                  fit: BoxFit.fill,
                                                ),
                                              )
                                            : getCustomFont(controller.sideBarData!.name!.isEmpty ? "" : controller.sideBarData!.name!.split(" ")[0].substring(0, 1), 8, AppColors.getSubFontColor(context), 1, fontWeight: FontWeight.w400)),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (controller.sideBarData!.isGroup == 1) {
                                        chatController.isAdmin.value = false;

                                        dashboardController.getGroupDetailsApi(
                                          id: controller.sideBarData?.sId,
                                          callBack: (p0) {
                                            p0.groupDetai.groupUsers.forEach((element) {
                                              if (chatController.uid.value == element.memberId.id && element.isAdmin == 1) {
                                                chatController.isAdmin.value = true;
                                              }
                                            });
                                            Get.to(GroupInfoScreen(
                                              groupDetailModel: p0,
                                            ));
                                          },
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width - 219,
                                      color: Colors.transparent,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: controller.sideBarData!.isGroup != 1 ? 10 : 15,
                                          ),
                                          Text(controller.sideBarData!.name!.trim(), overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: false, style: TextStyle(fontSize: 15, color: AppColors.getFontColor(context), fontWeight: FontWeight.w700)),
                                          controller.sideBarData!.isGroup != 1
                                              ? Obx(
                                                  () => chatController.isOnline.value == 1 && chatController.isTyping.value == true
                                                      ? Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 0.0),
                                                            child: getCustomFont(' Typing....', 12, AppColors.getFontColor(context), 1, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                                          ),
                                                        )
                                                      : chatController.lastseen.value == "" || chatController.lastseen.value == "null" || chatController.lastseen.value == null
                                                          ? Padding(
                                                              padding: const EdgeInsets.only(left: 0.0),
                                                              child: Align(alignment: Alignment.centerLeft, child: getCustomFont('Online', 12, AppColors.getFontColor(context), 1, fontWeight: FontWeight.w500, textAlign: TextAlign.start)),
                                                            )
                                                          : Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 0),
                                                                child: getCustomFont(' Last seen  ${DateTime.parse(chatController.lastseen.value).difference(DateTime.now()).inDays == 1 ? DateFormat("dd-MM-yyyy").format(DateTime.parse(chatController.lastseen.value)) : DateFormat("hh:mm").format(DateTime.parse(chatController.lastseen.value).toLocal())}', 12, AppColors.getFontColor(context), 1, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                                                              ),
                                                            ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  CustomImageView(
                                    height: 20,
                                    width: 20,
                                    onTap: () {
                                      Constants.sendToNext(
                                        Routes.callScreen,
                                      );
                                    },
                                    svgPath: 'call.svg',
                                    color: themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  CustomImageView(
                                    onTap: () {},
                                    svgPath: 'video_call.svg',
                                    color: themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor,
                                  ),
                                  const SizedBox(
                                    width: 0,
                                  ),
                                  controller.isGroup
                                      ? PopupMenuButton<int>(
                                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          onOpened: () => {chatController.GetIsBlock(controller.sideBarData!.sId), chatController.getMute(controller.sideBarData!.sId)},
                                          color: const Color(0xffFFFFFF),
                                          iconColor: themeController.isDarkMode ? const Color(0xffFFFFFF) : AppColors.colorBlack,
                                          ////themeController.iAppColors.primaryColorsDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor,
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
                                                        svgPath: 'search_image.svg',
                                                        height: 25,
                                                      ),
                                                      const SizedBox(width: 10),
                                                      const Text("Search message"),
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
                                                      const Text("Clear chat"),
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
                                                      Obx(() => Text("${chatController.isMute.value ? "Unmute" : "Mute"} notification")),
                                                    ],
                                                  ),
                                                )),
                                            controller.sideBarData?.isGroup == 0
                                                ? PopupMenuItem<int>(
                                                    value: 4,
                                                    child: Container(
                                                      height: 40,
                                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.redColor.withOpacity(0.2)),
                                                      child: Row(
                                                        children: [
                                                          CustomImageView(
                                                            svgPath: 'delete_icon.svg',
                                                            height: 25,
                                                          ),
                                                          const SizedBox(width: 10),
                                                          Text(
                                                            "Delete chat",
                                                            style: TextStyle(color: AppColors.redColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                : PopupMenuItem<int>(
                                                    value: 4,
                                                    child: Container(
                                                      height: 40,
                                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.redColor.withOpacity(0.2)),
                                                      child: Row(
                                                        children: [
                                                          CustomImageView(
                                                            svgPath: 'delete_icon.svg',
                                                            height: 25,
                                                          ),
                                                          const SizedBox(width: 10),
                                                          Text(
                                                            controller.sideBarData?.isGroup == 0
                                                                ? "Delete chat"
                                                                : controller.sideBarData?.isGroup == 1 && controller.sideBarData?.isAdmin == 1 || controller.sideBarData!.ismember == 0
                                                                    ? "Delete Group"
                                                                    : "Leave Group",
                                                            style: TextStyle(color: AppColors.redColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                          ],
                                          onSelected: (item) {
                                            if (item == 4) {
                                              deleteChatDailog();
                                            } else if (item == 1) {
                                              blockDailog();
                                            } else if (item == 2) {
                                              clearDailog();
                                            } else if (item == 3) {
                                              if (chatController.isMute.value) {
                                                chatController.updateMuteNotification(controller.sideBarData?.sId, 0);
                                              } else {
                                                chatController.updateMuteNotification(controller.sideBarData?.sId, 1);
                                              }
                                            }
                                          },

                                          iconSize: 25,
                                        )
                                      : PopupMenuButton<int>(
                                          onOpened: () => {chatController.GetIsBlock(controller.sideBarData!.sId), chatController.getMute(controller.sideBarData!.sId)},
                                          color: const Color(0xffFFFFFF),
                                          iconColor: themeController.isDarkMode ? const Color(0xffFFFFFF) : AppColors.colorBlack,
                                          iconSize: 25,
                                          ////themeController.iAppColors.primaryColorsDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor,
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
                                                        svgPath: 'search_image.svg',
                                                        height: 25,
                                                      ),
                                                      const SizedBox(width: 10),
                                                      const Text("Search message"),
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
                                                        svgPath: 'block_image.svg',
                                                        height: 25,
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Text(chatController.Isblock.value == "0" ? "Block user" : "Unblock user"),
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
                                                      const Text("Clear chat"),
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
                                                      Obx(() => Text("${chatController.isMute.value ? "Unmute" : "Mute"} notification")),
                                                    ],
                                                  ),
                                                )),
                                            controller.sideBarData?.isGroup == 0
                                                ? PopupMenuItem<int>(
                                                    value: 4,
                                                    child: Container(
                                                      height: 40,
                                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.redColor.withOpacity(0.2)),
                                                      child: Row(
                                                        children: [
                                                          CustomImageView(
                                                            svgPath: 'delete_icon.svg',
                                                            height: 25,
                                                          ),
                                                          const SizedBox(width: 10),
                                                          Text(
                                                            "Delete chat",
                                                            style: TextStyle(color: AppColors.redColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                : PopupMenuItem<int>(
                                                    value: 4,
                                                    child: Container(
                                                      height: 40,
                                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.redColor.withOpacity(0.2)),
                                                      child: Row(
                                                        children: [
                                                          CustomImageView(
                                                            svgPath: 'delete_icon.svg',
                                                            height: 25,
                                                          ),
                                                          const SizedBox(width: 10),
                                                          Text(
                                                            controller.sideBarData?.isGroup == 0
                                                                ? "Delete chat"
                                                                : controller.sideBarData?.isGroup == 1 && controller.sideBarData?.isAdmin == 1 || controller.sideBarData!.ismember == 0
                                                                    ? "Delete Group"
                                                                    : "Leave Group",
                                                            style: TextStyle(color: AppColors.redColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                          ],
                                          onSelected: (item) {
                                            if (item == 4) {
                                              deleteChatDailog();
                                            } else if (item == 1) {
                                              blockDailog();
                                            } else if (item == 2) {
                                              clearDailog();
                                            } else if (item == 3) {
                                              if (chatController.isMute.value) {
                                                chatController.updateMuteNotification(controller.sideBarData?.sId, 0);
                                              } else {
                                                chatController.updateMuteNotification(controller.sideBarData?.sId, 1);
                                              }
                                            }
                                          },
                                        ),
                                  const SizedBox(
                                    width: 0,
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
                                    : const ShapeDecoration(
                                        // image: DecorationImage(image: AssetImage(themeController.isDarkMode ? "${Constants.assetPath}dark_dashboard.png" : "${Constants.assetPath}history_bg.png"), fit: BoxFit.fill),
                                        color: Colors.transparent,
                                        // color: AppColors.getCardColor(context),
                                        shape: RoundedRectangleBorder(
                                            // borderRadius: BorderRadius.only(topRight: Radius.circular(16.r), topLeft: Radius.circular(16.r)),
                                            ),
                                      ),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                                      child: StreamBuilder(
                                          stream: chatDataModelList.stream,
                                          // stream: selectChatList.stream,
                                          builder: (context, snapshot) {
                                            print("newlist==${chatDataModelList.length}");

                                            return ListView.builder(
                                                addAutomaticKeepAlives: true,
                                                itemCount: chatDataModelList.length,
                                                controller: _controller,
                                                shrinkWrap: true,
                                                reverse: true,
                                                itemBuilder: (context, index) {
                                                  RxBool isDownLoad = false.obs;
                                                  bool isSender = chatDataModelList[index].senderId == chatController.uid.value;
                                                  // print(" delivery status 11111111 ${chatDataModelList[index].MSG_ID}  AND   ${chatDataModelList[index].isEdited}  AND  ${chatDataModelList[index].message}");
                                                  if (!isSender && chatDataModelList[index].deliveryType == 2 && chatDataModelList[index].MSG_ID != null) {
                                                    newSocketController.sendDeliveryStatus(controller.sideBarData?.isGroup == 1 ? 1 : 0, controller.sideBarData?.isGroup == 1 ? controller.sideBarData?.sId : null, chatDataModelList[index].MSG_ID, 3);
                                                  }
                                                  //todo: 05-02- builder chat check

                                                  chatDataModelList.forEach((element) {
                                                    if (element.MSG_ID == chatDataModelList[index].replyMessageId) {
                                                      chatDataModelList[index].replyMessage = element;
                                                    }
                                                  });
                                                  final player = audioPlayer.AudioPlayer();
                                                  RxBool isAudioPlay = false.obs;

                                                  bool isDateSame = true;
                                                  DateTime? date;
                                                  if (chatDataModelList[index].createdAt != null) {
                                                    final String dateString = chatDataModelList[index].createdAt.toString();
                                                    //DateFormat('dd-MM-yyyy').format(DateTime.parse(message.createdAt.toString()));//list[index]['time'];
                                                    date = DateTime.parse(dateString);
                                                  } else {
                                                    // date = DateTime.parse(DateTime.now().toString());
                                                  }

                                                  if (chatDataModelList.length - 1 == index) {
                                                    // if(widget.conversList.length >1) {
                                                    //   isDateSame = true;
                                                    // }else{
                                                    isDateSame = false;
                                                    //}
                                                  } else {
                                                    // print('${isDateSame.toString() + " date : ${date.formatDate()}"}');
                                                    if (date != null) {
                                                      if (chatDataModelList[index + 1].createdAt != null) {
                                                        final String prevDateString = chatDataModelList[index + 1].createdAt.toString(); // list[index - 1]['time'];
                                                        final DateTime prevDate = DateTime.parse(prevDateString);
                                                        isDateSame = date.isSameDate(prevDate);
                                                      } else {
                                                        isDateSame = false;
                                                      }
                                                    }
                                                  }
                                                  return Column(
                                                    children: [
                                                      date != null
                                                          ? !(isDateSame)
                                                              ? Align(
                                                                  alignment: Alignment.center,
                                                                  child: Container(
                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: !themeController.isDarkMode ? AppColors.darkBgColor : AppColors.colorFFFFFF),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                                                      child: Text(
                                                                        date!.formatDate(),
                                                                        style: TextStyle(
                                                                          color: themeController.isDarkMode ? AppColors.color1F222A : AppColors.colorFFFFFF,
                                                                          fontSize: 12,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container()
                                                          : Container(),
                                                      SizedBox(height: 10),
                                                      Padding(
                                                        padding: chatDataModelList[index].mediaType == 7 ? EdgeInsets.only(bottom: 5, right: MediaQuery.of(context).size.width / 10, left: MediaQuery.of(context).size.width / 10) : EdgeInsets.only(bottom: 5, left: (isSender) ? 50 : 0, right: (isSender) ? 0 : 50),
                                                        child: Align(
                                                          alignment: chatDataModelList[index].mediaType == 7
                                                              ? Alignment.center
                                                              : (isSender)
                                                                  ? Alignment.centerRight
                                                                  : Alignment.centerLeft,
                                                          child: Column(
                                                            crossAxisAlignment: chatDataModelList[index].mediaType == 7
                                                                ? CrossAxisAlignment.center
                                                                : (isSender)
                                                                    ? CrossAxisAlignment.end
                                                                    : CrossAxisAlignment.start,
                                                            children: [
                                                              GestureDetector(
                                                                onLongPressStart: (LongPressStartDetails details) {
                                                                  if (chatDataModelList[index].mediaType != 7) {
                                                                    final left = details.globalPosition.dx;
                                                                    final top = details.globalPosition.dy;
                                                                    isSelect.value = true;
                                                                    if (selectChatList.contains(chatDataModelList[index])) {
                                                                      selectChatList.remove(chatDataModelList[index]);
                                                                    } else {
                                                                      selectChatList.add(chatDataModelList[index]);
                                                                    }

                                                                    chatDataModelList[index].mediaType == 0 && chatDataModelList[index].messageType == 0 && isSender
                                                                        ? showMenu<MenuItem>(
                                                                            context: context,
                                                                            position: RelativeRect.fromLTRB(left, top, left, top),
                                                                            items: [
                                                                              ...EditMenuItems.firstItems.map(
                                                                                (item) => PopupMenuItem(
                                                                                  value: item,
                                                                                  onTap: () {
                                                                                    if (item == EditMenuItems.Reply) {
                                                                                      isReply.value = true;
                                                                                      selectChatModel.value = chatDataModelList[index];
                                                                                    } else if (item == EditMenuItems.Forward) {
                                                                                      Get.back();
                                                                                      Get.to(ForwardContactScreenScreen(
                                                                                        chatDataModel: chatDataModelList[index],
                                                                                      ));
                                                                                    } else if (item == EditMenuItems.Share) {
                                                                                      if (chatDataModelList[index].mediaType == 0) {
                                                                                        shareFile(null, chatDataModelList[index].message);
                                                                                      } else if (chatDataModelList[index].mediaType == 1) {
                                                                                        //print( chatDataModelList[index].filePath );
                                                                                        shareFile(chatDataModelList[index].filePath, chatDataModelList[index].message);
                                                                                      } else {
                                                                                        shareFile(null, chatDataModelList[index].message);
                                                                                      }
                                                                                    } else if (item == EditMenuItems.Delete) {
                                                                                      print("===sender === ${chatDataModelList[index].MSG_ID}  sid ${controller.sideBarData?.sId}");
                                                                                      isSenderr.value = chatDataModelList[index].senderId != controller.sideBarData?.sId;

                                                                                      DeleteDailog(chatDataModelList[index].MSG_ID);
                                                                                      // newSocketController.deleteSingleMessage(controller.sideBarData?.isGroup as int, chatDataModelList[index].id ?? "",controller.sideBarData?.isGroup==1? controller.sideBarData?.sId:null,2,controller.sideBarData?.isGroup==1? null:controller.sideBarData?.sId);
                                                                                    } else if (item == EditMenuItems.Copy) {
                                                                                      copyMSG(chatDataModelList[index].message);
                                                                                    } else if (item == EditMenuItems.Edit) {
                                                                                      controller.chatController.text = chatDataModelList[index].message as String;
                                                                                      chatController.MessageID.value = chatDataModelList[index].MSG_ID ?? "";
                                                                                      chatController.isEdit.value = true;
                                                                                    } else if (item == EditMenuItems.info) {
                                                                                      if (controller.isGroup) {
                                                                                        chatController.GroupInfoApiCall(chatDataModelList[index].MSG_ID == null ? chatDataModelList[index].id : chatDataModelList[index].MSG_ID);
                                                                                      }
                                                                                      ;
                                                                                      infoMessage(chatDataModelList[index], controller.isGroup);
                                                                                    }
                                                                                  },
                                                                                  child: MenuItems.buildItem(item),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                            color: AppColors.colorFFFFFF,
                                                                            surfaceTintColor: AppColors.colorFFFFFF,
                                                                            shadowColor: AppColors.colorFFFFFF,
                                                                            shape: const RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(32.0),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : chatDataModelList[index].mediaType == 0 && chatDataModelList[index].messageType == 2 && isSender
                                                                            ? showMenu<MenuItem>(
                                                                                context: context,
                                                                                position: RelativeRect.fromLTRB(left, top, left, top),
                                                                                items: [
                                                                                  ...EditMenuItems.forwarded.map(
                                                                                    (item) => PopupMenuItem(
                                                                                      value: item,
                                                                                      onTap: () {
                                                                                        if (item == EditMenuItems.Reply) {
                                                                                          isReply.value = true;
                                                                                          selectChatModel.value = chatDataModelList[index];
                                                                                        } else if (item == EditMenuItems.Forward) {
                                                                                          Get.back();
                                                                                          Get.to(ForwardContactScreenScreen(
                                                                                            chatDataModel: chatDataModelList[index],
                                                                                          ));
                                                                                        } else if (item == EditMenuItems.Share) {
                                                                                          if (chatDataModelList[index].mediaType == 0) {
                                                                                            shareFile(null, chatDataModelList[index].message);
                                                                                          } else if (chatDataModelList[index].mediaType == 1) {
                                                                                            //print( chatDataModelList[index].filePath );
                                                                                            shareFile(chatDataModelList[index].filePath, chatDataModelList[index].message);
                                                                                          } else {
                                                                                            shareFile(null, chatDataModelList[index].message);
                                                                                          }
                                                                                        } else if (item == EditMenuItems.Delete) {
                                                                                          print("===sender === ${chatDataModelList[index].MSG_ID}  sid ${controller.sideBarData?.sId}");
                                                                                          isSenderr.value = chatDataModelList[index].senderId != controller.sideBarData?.sId;

                                                                                          DeleteDailog(chatDataModelList[index].MSG_ID);
                                                                                          // newSocketController.deleteSingleMessage(controller.sideBarData?.isGroup as int, chatDataModelList[index].id ?? "",controller.sideBarData?.isGroup==1? controller.sideBarData?.sId:null,2,controller.sideBarData?.isGroup==1? null:controller.sideBarData?.sId);
                                                                                        } else if (item == EditMenuItems.Copy) {
                                                                                          copyMSG(chatDataModelList[index].message);
                                                                                        } else if (item == EditMenuItems.info) {
                                                                                          if (controller.isGroup) {
                                                                                            chatController.GroupInfoApiCall(chatDataModelList[index].MSG_ID == null ? chatDataModelList[index].id : chatDataModelList[index].MSG_ID);
                                                                                          }
                                                                                          ;
                                                                                          infoMessage(chatDataModelList[index], controller.isGroup);
                                                                                        }
                                                                                      },
                                                                                      child: MenuItems.buildItem(item),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                                color: AppColors.colorFFFFFF,
                                                                                surfaceTintColor: AppColors.colorFFFFFF,
                                                                                shadowColor: AppColors.colorFFFFFF,
                                                                                shape: const RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.all(
                                                                                    Radius.circular(32.0),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : chatDataModelList[index].mediaType == 0 && !isSender
                                                                                ? showMenu<MenuItem>(
                                                                                    context: context,
                                                                                    position: RelativeRect.fromLTRB(left, top, left, top),
                                                                                    items: [
                                                                                      ...EditMenuItems.receiver.map(
                                                                                        (item) => PopupMenuItem(
                                                                                          value: item,
                                                                                          onTap: () {
                                                                                            if (item == EditMenuItems.Reply) {
                                                                                              isReply.value = true;
                                                                                              selectChatModel.value = chatDataModelList[index];
                                                                                            } else if (item == EditMenuItems.Forward) {
                                                                                              Get.back();
                                                                                              Get.to(ForwardContactScreenScreen(
                                                                                                chatDataModel: chatDataModelList[index],
                                                                                              ));
                                                                                            } else if (item == EditMenuItems.Share) {
                                                                                              if (chatDataModelList[index].mediaType == 0) {
                                                                                                shareFile(null, chatDataModelList[index].message);
                                                                                              } else if (chatDataModelList[index].mediaType == 1) {
                                                                                                //print( chatDataModelList[index].filePath );
                                                                                                shareFile(chatDataModelList[index].filePath, chatDataModelList[index].message);
                                                                                              } else {
                                                                                                shareFile(null, chatDataModelList[index].message);
                                                                                              }
                                                                                            } else if (item == EditMenuItems.Delete) {
                                                                                              print("===sender === ${chatDataModelList[index].senderId}  sid ${controller.sideBarData?.sId}");
                                                                                              isSenderr.value = chatDataModelList[index].senderId != controller.sideBarData?.sId;
                                                                                              DeleteDailog(chatDataModelList[index].MSG_ID ?? "");
                                                                                              // newSocketController.deleteSingleMessage(controller.sideBarData?.isGroup as int, chatDataModelList[index].id ?? "",controller.sideBarData?.isGroup==1? controller.sideBarData?.sId:null,2,controller.sideBarData?.isGroup==1? null:controller.sideBarData?.sId);
                                                                                            } else if (item == EditMenuItems.Copy) {
                                                                                              copyMSG(chatDataModelList[index].message);
                                                                                            } else if (item == EditMenuItems.Edit) {
                                                                                              controller.chatController.text = chatDataModelList[index].message as String;
                                                                                              chatController.MessageID.value = chatDataModelList[index].MSG_ID ?? "";
                                                                                              chatController.isEdit.value = true;
                                                                                            }
                                                                                          },
                                                                                          child: MenuItems.buildItem(item),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                    color: AppColors.colorFFFFFF,
                                                                                    surfaceTintColor: AppColors.colorFFFFFF,
                                                                                    shadowColor: AppColors.colorFFFFFF,
                                                                                    shape: const RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.all(
                                                                                        Radius.circular(32.0),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                : chatDataModelList[index].mediaType != 0 && isSender
                                                                                    ? showMenu<MenuItem>(
                                                                                        context: context,
                                                                                        position: RelativeRect.fromLTRB(left, top, left, top),
                                                                                        items: [
                                                                                          ...EditMenuItems.MultiItems_Sender.map(
                                                                                            (item) => PopupMenuItem(
                                                                                              value: item,
                                                                                              onTap: () {
                                                                                                if (item == EditMenuItems.Reply) {
                                                                                                  // chatDataModelList[index].isReply = true;
                                                                                                  selectChatModel.value = chatDataModelList[index];
                                                                                                } else if (item == EditMenuItems.Forward) {
                                                                                                  print("66666666=");
                                                                                                  Get.back();
                                                                                                  Get.to(ForwardContactScreenScreen(
                                                                                                    chatDataModel: chatDataModelList[index],
                                                                                                  ));
                                                                                                } else if (item == EditMenuItems.Share) {
                                                                                                  if (chatDataModelList[index].mediaType == 0) {
                                                                                                    shareFile(null, chatDataModelList[index].message);
                                                                                                  } else if (chatDataModelList[index].mediaType == 1) {
                                                                                                    //print( chatDataModelList[index].filePath );
                                                                                                    shareFile(chatDataModelList[index].filePath, chatDataModelList[index].message);
                                                                                                  } else {
                                                                                                    shareFile(null, chatDataModelList[index].message);
                                                                                                  }
                                                                                                } else if (item == EditMenuItems.Delete) {
                                                                                                  print("===sender === ${chatDataModelList[index].senderId}  sid ${controller.sideBarData?.sId}");
                                                                                                  isSenderr.value = chatDataModelList[index].senderId != controller.sideBarData?.sId;
                                                                                                  DeleteDailog(chatDataModelList[index].MSG_ID ?? "");
                                                                                                  //   newSocketController.deleteSingleMessage(controller.sideBarData?.isGroup as int, chatDataModelList[index].id ?? "",controller.sideBarData?.isGroup==1? null:controller.sideBarData?.sId,2,controller.sideBarData?.isGroup==1? controller.sideBarData?.sId:null);
                                                                                                } else if (item == EditMenuItems.Copy) {
                                                                                                  copyMSG(chatDataModelList[index].message);
                                                                                                } else if (item == EditMenuItems.info) {
                                                                                                  if (controller.isGroup) {
                                                                                                    chatController.GroupInfoApiCall(chatDataModelList[index].MSG_ID == null ? chatDataModelList[index].id : chatDataModelList[index].MSG_ID);
                                                                                                  }
                                                                                                  ;
                                                                                                  infoMessage(chatDataModelList[index], controller.isGroup);
                                                                                                }
                                                                                              },
                                                                                              child: MenuItems.buildItem(item),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                        color: AppColors.colorFFFFFF,
                                                                                        surfaceTintColor: AppColors.colorFFFFFF,
                                                                                        shadowColor: AppColors.colorFFFFFF,
                                                                                        shape: const RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.all(
                                                                                            Radius.circular(32.0),
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    : chatDataModelList[index].messageType == 1 && isSender
                                                                                        ? showMenu<MenuItem>(
                                                                                            context: context,
                                                                                            position: RelativeRect.fromLTRB(left, top, left, top),
                                                                                            items: [
                                                                                              ...EditMenuItems.firstItems.map(
                                                                                                (item) => PopupMenuItem(
                                                                                                  value: item,
                                                                                                  onTap: () {
                                                                                                    if (item == EditMenuItems.Reply) {
                                                                                                      isReply.value = true;
                                                                                                      selectChatModel.value = chatDataModelList[index];
                                                                                                    } else if (item == EditMenuItems.Forward) {
                                                                                                      Get.back();
                                                                                                      Get.to(ForwardContactScreenScreen(
                                                                                                        chatDataModel: chatDataModelList[index],
                                                                                                      ));
                                                                                                    } else if (item == EditMenuItems.Share) {
                                                                                                      if (chatDataModelList[index].mediaType == 0) {
                                                                                                        shareFile(null, chatDataModelList[index].message);
                                                                                                      } else if (chatDataModelList[index].mediaType == 1) {
                                                                                                        //print( chatDataModelList[index].filePath );
                                                                                                        shareFile(chatDataModelList[index].filePath, chatDataModelList[index].message);
                                                                                                      } else {
                                                                                                        shareFile(null, chatDataModelList[index].message);
                                                                                                      }
                                                                                                    } else if (item == EditMenuItems.Delete) {
                                                                                                      print("===sender === ${chatDataModelList[index].MSG_ID}  sid ${controller.sideBarData?.sId}");
                                                                                                      isSenderr.value = chatDataModelList[index].senderId != controller.sideBarData?.sId;

                                                                                                      DeleteDailog(chatDataModelList[index].MSG_ID);
                                                                                                      // newSocketController.deleteSingleMessage(controller.sideBarData?.isGroup as int, chatDataModelList[index].id ?? "",controller.sideBarData?.isGroup==1? controller.sideBarData?.sId:null,2,controller.sideBarData?.isGroup==1? null:controller.sideBarData?.sId);
                                                                                                    } else if (item == EditMenuItems.Copy) {
                                                                                                      copyMSG(chatDataModelList[index].message);
                                                                                                    } else if (item == EditMenuItems.info) {
                                                                                                      if (controller.isGroup) {
                                                                                                        chatController.GroupInfoApiCall(chatDataModelList[index].MSG_ID == null ? chatDataModelList[index].id : chatDataModelList[index].MSG_ID);
                                                                                                      }
                                                                                                      ;
                                                                                                      infoMessage(chatDataModelList[index], controller.isGroup);
                                                                                                    }
                                                                                                  },
                                                                                                  child: MenuItems.buildItem(item),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                            color: AppColors.colorFFFFFF,
                                                                                            surfaceTintColor: AppColors.colorFFFFFF,
                                                                                            shadowColor: AppColors.colorFFFFFF,
                                                                                            shape: const RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.all(
                                                                                                Radius.circular(32.0),
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        : showMenu<MenuItem>(
                                                                                            context: context,
                                                                                            position: RelativeRect.fromLTRB(left, top, left, top),
                                                                                            items: [
                                                                                              ...EditMenuItems.MultiItems.map(
                                                                                                (item) => PopupMenuItem(
                                                                                                  value: item,
                                                                                                  onTap: () {
                                                                                                    if (item == EditMenuItems.Reply) {
                                                                                                      // chatDataModelList[index].isReply = true;
                                                                                                      selectChatModel.value = chatDataModelList[index];
                                                                                                    } else if (item == EditMenuItems.Forward) {
                                                                                                      print("66666666=");
                                                                                                      Get.back();
                                                                                                      Get.to(ForwardContactScreenScreen(
                                                                                                        chatDataModel: chatDataModelList[index],
                                                                                                      ));
                                                                                                    } else if (item == EditMenuItems.Share) {
                                                                                                      if (chatDataModelList[index].mediaType == 0) {
                                                                                                        shareFile(null, chatDataModelList[index].message);
                                                                                                      } else if (chatDataModelList[index].mediaType == 1) {
                                                                                                        //print( chatDataModelList[index].filePath );
                                                                                                        shareFile(chatDataModelList[index].filePath, chatDataModelList[index].message);
                                                                                                      } else {
                                                                                                        shareFile(null, chatDataModelList[index].message);
                                                                                                      }
                                                                                                    } else if (item == EditMenuItems.Delete) {
                                                                                                      print("===sender === ${chatDataModelList[index].senderId}  sid ${controller.sideBarData?.sId}");
                                                                                                      isSenderr.value = chatDataModelList[index].senderId != controller.sideBarData?.sId;
                                                                                                      DeleteDailog(chatDataModelList[index].MSG_ID ?? "");
                                                                                                      //   newSocketController.deleteSingleMessage(controller.sideBarData?.isGroup as int, chatDataModelList[index].id ?? "",controller.sideBarData?.isGroup==1? null:controller.sideBarData?.sId,2,controller.sideBarData?.isGroup==1? controller.sideBarData?.sId:null);
                                                                                                    } else if (item == EditMenuItems.Copy) {
                                                                                                      copyMSG(chatDataModelList[index].message);
                                                                                                    } else if (item == EditMenuItems.info) {
                                                                                                      if (controller.isGroup) {
                                                                                                        chatController.GroupInfoApiCall(chatDataModelList[index].MSG_ID == null ? chatDataModelList[index].id : chatDataModelList[index].MSG_ID);
                                                                                                      }
                                                                                                      ;
                                                                                                      infoMessage(chatDataModelList[index], controller.isGroup);
                                                                                                    }
                                                                                                  },
                                                                                                  child: MenuItems.buildItem(item),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                            color: AppColors.colorFFFFFF,
                                                                                            surfaceTintColor: AppColors.colorFFFFFF,
                                                                                            shadowColor: AppColors.colorFFFFFF,
                                                                                            shape: const RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.all(
                                                                                                Radius.circular(32.0),
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                  }
                                                                },
                                                                onTap: () {
                                                                  if (chatDataModelList[index].mediaType != 7) {
                                                                    if (isSelect.value) {
                                                                      if (selectChatList.contains(chatDataModelList[index])) {
                                                                        selectChatList.remove(chatDataModelList[index]);
                                                                      } else {
                                                                        selectChatList.add(chatDataModelList[index]);
                                                                      }
                                                                    }
                                                                    if (selectChatList.isEmpty) {
                                                                      isSelect.value = false;
                                                                    }
                                                                  }
                                                                },
                                                                child: Stack(
                                                                  children: [
                                                                    DecoratedBox(
                                                                      // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                                      // margin: EdgeInsets.only(bottom: 20),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: chatDataModelList[index].mediaType == 7 || chatDataModelList[index].mediaType == 1 || chatDataModelList[index].mediaType == 2 ? BorderRadius.circular(15) : BorderRadius.only(topRight: const Radius.circular(15), topLeft: const Radius.circular(15), bottomRight: Radius.circular((chatDataModelList[index].senderId != controller.sideBarData?.sId) ? 0 : 15), bottomLeft: Radius.circular(chatDataModelList[index].senderId != controller.sideBarData?.sId ? 15 : 0)),
                                                                          color: chatDataModelList[index].mediaType == 7 && themeController.isDarkMode
                                                                              ? AppColors.colorFFFFFF
                                                                              : chatDataModelList[index].mediaType == 7 && !themeController.isDarkMode
                                                                                  ? AppColors.darkBgColor
                                                                                  : AppColors.colorD4DFFF),
                                                                      child: Padding(
                                                                        padding: chatDataModelList[index].mediaType == 7 ? EdgeInsets.fromLTRB(5, 1, 5, 1) : EdgeInsets.symmetric(horizontal: chatDataModelList[index].mediaType == 1 || chatDataModelList[index].mediaType == 2 || chatDataModelList[index].mediaType == 6 ? 1 : 20, vertical: chatDataModelList[index].mediaType == 1 && (chatDataModelList[index].message_caption == null || chatDataModelList[index].message_caption == "") || chatDataModelList[index].mediaType == 2 || chatDataModelList[index].mediaType == 6 ? 1 : 10),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: chatDataModelList[index].mediaType == 7
                                                                              ? CrossAxisAlignment.center
                                                                              : isSender
                                                                                  ? CrossAxisAlignment.start
                                                                                  : CrossAxisAlignment.end,
                                                                          children: [
                                                                            if (chatDataModelList[index].messageType == 2)
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
                                                                                children: [
                                                                                  CustomImageView(svgPath: 'forword.svg', onTap: null, height: 22, color: AppColors.subFontColor),
                                                                                  const SizedBox(width: 6),
                                                                                  Text(
                                                                                    "Forwarded",
                                                                                    style: TextStyle(color: AppColors.subFontColor),
                                                                                  )
                                                                                ],
                                                                              ).paddingOnly(bottom: 5),
                                                                            (chatDataModelList[index].replyMessage?.MSG_ID?.isNotEmpty ?? false)
                                                                                ? chatDataModelList[index].replyMessage?.mediaType == 4
                                                                                    ? Column(
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
                                                                                                    Flexible(
                                                                                                      child: Padding(
                                                                                                        padding: const EdgeInsets.all(10),
                                                                                                        child: Column(
                                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                          children: [
                                                                                                            Text(
                                                                                                              chatDataModelList[index].replyMessage?.senderId != controller.sideBarData?.sId ? "You" : (chatDataModelList[index].replyMessage?.originalName ?? ""),
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
                                                                                                                Expanded(
                                                                                                                  child: Text(
                                                                                                                    ((chatDataModelList[index].replyMessage?.filePath?.isNotEmpty ?? false) ? (chatDataModelList[index].replyMessage?.filePath?.split("/").last ?? "") : (chatDataModelList[index].replyMessage?.message?.split("/").last ?? "UnKnow")),
                                                                                                                    style: TextStyle(fontSize: 14, color: AppColors.colorA2A6AE, fontWeight: FontWeight.w400),
                                                                                                                    maxLines: 1,
                                                                                                                    overflow: TextOverflow.ellipsis,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                FutureBuilder(
                                                                                                                  future: getFileSize((chatDataModelList[index].replyMessage?.filePath ?? ""), 1),
                                                                                                                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshots) {
                                                                                                                    return Text(
                                                                                                                      snapshots.data ?? "",
                                                                                                                      style: TextStyle(fontSize: 14, color: AppColors.primaryColor, fontWeight: FontWeight.w400),
                                                                                                                    );
                                                                                                                  },
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    // const Spacer(),
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
                                                                                                      ],
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                          // const SizedBox(height: 9),
                                                                                          // Text(
                                                                                          //   "Hi, Jimmy! Any update today?",
                                                                                          //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.fontColor),
                                                                                          // )
                                                                                        ],
                                                                                      )
                                                                                    : (chatDataModelList[index].replyMessage?.mediaType == 1)
                                                                                        ? Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Stack(
                                                                                                children: [
                                                                                                  Container(
                                                                                                    height: 62,
                                                                                                    width: 50,
                                                                                                    decoration: BoxDecoration(
                                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                                      color: AppColors.primaryColor,
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    // height: 65,
                                                                                                    // width: double.infinity,
                                                                                                    decoration: BoxDecoration(
                                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                                      color: AppColors.colorFFFFFF,
                                                                                                    ),
                                                                                                    margin: const EdgeInsets.only(left: 5),
                                                                                                    child: Row(
                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                      children: [
                                                                                                        Padding(
                                                                                                          padding: const EdgeInsets.all(10),
                                                                                                          child: Column(
                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                chatDataModelList[index].replyMessage?.senderId != controller.sideBarData?.sId ? "You" : (chatDataModelList[index].replyMessage?.originalName ?? ""),
                                                                                                                style: TextStyle(fontSize: 14, color: AppColors.fontColor, fontWeight: FontWeight.w600),
                                                                                                              ),
                                                                                                              Row(
                                                                                                                mainAxisSize: MainAxisSize.min,
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
                                                                                                                  ).paddingOnly(right: 3),
                                                                                                                  FutureBuilder(
                                                                                                                    future: getFileSize((chatDataModelList[index].replyMessage?.filePath ?? ""), 1, url: (chatDataModelList[index].replyMessage?.filePath?.isEmpty ?? true) ? "$mainUrl${chatDataModelList[index].replyMessage?.message}" : ""),
                                                                                                                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshots) {
                                                                                                                      return Text(
                                                                                                                        snapshots.data ?? "",
                                                                                                                        style: TextStyle(fontSize: 14, color: AppColors.primaryColor, fontWeight: FontWeight.w400),
                                                                                                                      );
                                                                                                                    },
                                                                                                                  ),
                                                                                                                ],
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                        // const Spacer(),
                                                                                                        Stack(
                                                                                                          children: [
                                                                                                            Container(
                                                                                                              height: 62,
                                                                                                              width: 60,
                                                                                                              decoration: BoxDecoration(color: AppColors.ColorEBF0FF, borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
                                                                                                              // padding: EdgeInsets.all(14),
                                                                                                              child: ClipRRect(
                                                                                                                borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                                                                                                child: LocalNetworkMedia().getMedia(url: getThambNelFormUrl((chatDataModelList[index].replyMessage?.message ?? "")), imageFit: BoxFit.contain),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                              const SizedBox(height: 9),
                                                                                              // Text(
                                                                                              //   "Hi, Jimmy! Any update today?",
                                                                                              //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.fontColor),
                                                                                              // )
                                                                                            ],
                                                                                          )
                                                                                        : (chatDataModelList[index].replyMessage?.mediaType == 2)
                                                                                            ? Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Stack(
                                                                                                    children: [
                                                                                                      Container(
                                                                                                        height: 62,
                                                                                                        width: 50,
                                                                                                        decoration: BoxDecoration(
                                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                                          color: AppColors.primaryColor,
                                                                                                        ),
                                                                                                      ),
                                                                                                      Container(
                                                                                                        // height: 65,
                                                                                                        // width: double.infinity,
                                                                                                        decoration: BoxDecoration(
                                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                                          color: AppColors.colorFFFFFF,
                                                                                                        ),
                                                                                                        margin: const EdgeInsets.only(left: 5),
                                                                                                        child: Row(
                                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                                          children: [
                                                                                                            Padding(
                                                                                                              padding: const EdgeInsets.all(10),
                                                                                                              child: Column(
                                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                children: [
                                                                                                                  Text(
                                                                                                                    chatDataModelList[index].replyMessage?.senderId != controller.sideBarData?.sId ? "You" : (chatDataModelList[index].replyMessage?.originalName ?? ""),
                                                                                                                    style: TextStyle(fontSize: 14, color: AppColors.fontColor, fontWeight: FontWeight.w600),
                                                                                                                  ),
                                                                                                                  Row(
                                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                                    children: [
                                                                                                                      CustomImageView(
                                                                                                                        svgPath: 'cameraImage.svg',
                                                                                                                        onTap: null,
                                                                                                                        height: 20,
                                                                                                                        color: AppColors.colorA2A6AE,
                                                                                                                      ),
                                                                                                                      const SizedBox(width: 6),
                                                                                                                      Text(
                                                                                                                        "Video",
                                                                                                                        style: TextStyle(fontSize: 14, color: AppColors.colorA2A6AE, fontWeight: FontWeight.w400),
                                                                                                                      ).paddingOnly(right: 3),
                                                                                                                      FutureBuilder(
                                                                                                                        future: getFileSize((chatDataModelList[index].replyMessage?.filePath ?? ""), 1),
                                                                                                                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshots) {
                                                                                                                          return Text(
                                                                                                                            snapshots.data ?? "",
                                                                                                                            style: TextStyle(fontSize: 14, color: AppColors.primaryColor, fontWeight: FontWeight.w400),
                                                                                                                          );
                                                                                                                        },
                                                                                                                      ),
                                                                                                                    ],
                                                                                                                  ),
                                                                                                                ],
                                                                                                              ),
                                                                                                            ),
                                                                                                            // const Spacer(),
                                                                                                            Stack(
                                                                                                              children: [
                                                                                                                Container(
                                                                                                                  height: 62,
                                                                                                                  width: 60,
                                                                                                                  decoration: BoxDecoration(color: AppColors.ColorEBF0FF, borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
                                                                                                                  // padding: EdgeInsets.all(14),
                                                                                                                  child: ClipRRect(
                                                                                                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                                                                                                    child: LocalNetworkMedia().getMedia(url: getThambNelFormUrl((chatDataModelList[index].replyMessage?.message ?? "")), imageFit: BoxFit.contain),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      )
                                                                                                    ],
                                                                                                  ),
                                                                                                  const SizedBox(height: 9),
                                                                                                  // Text(
                                                                                                  //   "Hi, Jimmy! Any update today?",
                                                                                                  //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.fontColor),
                                                                                                  // )
                                                                                                ],
                                                                                              )
                                                                                            : (chatDataModelList[index].replyMessage?.mediaType == 3)
                                                                                                ? Column(
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
                                                                                                                        chatDataModelList[index].replyMessage?.senderId != controller.sideBarData?.sId ? "You" : (chatDataModelList[index].replyMessage?.originalName ?? ""),
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
                                                                                                                          const SizedBox(width: 4),
                                                                                                                          FutureBuilder(
                                                                                                                            future: getFileSize((chatDataModelList[index].replyMessage?.filePath ?? ""), 1),
                                                                                                                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshots) {
                                                                                                                              return Text(
                                                                                                                                snapshots.data ?? "",
                                                                                                                                style: TextStyle(fontSize: 14, color: AppColors.primaryColor, fontWeight: FontWeight.w400),
                                                                                                                              );
                                                                                                                            },
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
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          )
                                                                                                        ],
                                                                                                      ),
                                                                                                    ],
                                                                                                  )
                                                                                                : Column(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Stack(
                                                                                                        children: [
                                                                                                          Container(
                                                                                                            height: 60,
                                                                                                            width: 30,
                                                                                                            decoration: BoxDecoration(
                                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                                              color: AppColors.primaryColor,
                                                                                                            ),
                                                                                                          ),
                                                                                                          Container(
                                                                                                            // height: 65,
                                                                                                            // width: double.infinity,
                                                                                                            decoration: BoxDecoration(
                                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                                              color: AppColors.colorFFFFFF,
                                                                                                            ),
                                                                                                            margin: const EdgeInsets.only(left: 5),
                                                                                                            child: Row(
                                                                                                              mainAxisSize: MainAxisSize.min,
                                                                                                              children: [
                                                                                                                Flexible(
                                                                                                                  child: Padding(
                                                                                                                    padding: const EdgeInsets.all(10),
                                                                                                                    child: Column(
                                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                      children: [
                                                                                                                        Text(
                                                                                                                          chatDataModelList[index].replyMessage?.senderId != controller.sideBarData?.sId ? "You" : (chatDataModelList[index].replyMessage?.originalName ?? ""),
                                                                                                                          style: TextStyle(fontSize: 14, color: AppColors.fontColor, fontWeight: FontWeight.w600),
                                                                                                                        ),
                                                                                                                        Text(
                                                                                                                          chatDataModelList[index].replyMessage?.message ?? "",
                                                                                                                          maxLines: 1,
                                                                                                                          overflow: TextOverflow.ellipsis,
                                                                                                                          style: TextStyle(fontSize: 14, color: AppColors.colorA2A6AE, fontWeight: FontWeight.w400),
                                                                                                                        ),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                // const Spacer(),
                                                                                                              ],
                                                                                                            ),
                                                                                                          )
                                                                                                        ],
                                                                                                      ),
                                                                                                      // const SizedBox(height: 9),
                                                                                                    ],
                                                                                                  )
                                                                                : const SizedBox(),
                                                                            if (chatDataModelList[index].replyMessage?.id?.isNotEmpty ?? false) const SizedBox(height: 10),
                                                                            chatDataModelList[index].mediaType == 4
                                                                                ? StreamBuilder(
                                                                                    stream: isDownLoad.stream,
                                                                                    builder: (context, snapshot) {
                                                                                      return InkWell(
                                                                                        onTap: () {
                                                                                          if (!((chatDataModelList[index].filePath?.isEmpty ?? true) || (checkGalleryPath(chatDataModelList[index].filePath)))) {
                                                                                            OpenFilex.open(chatDataModelList[index].filePath);
                                                                                          }
                                                                                        },
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          children: [
                                                                                            InkWell(
                                                                                              onTap: () async {
                                                                                                if ((chatDataModelList[index].filePath?.isEmpty ?? true) || (checkGalleryPath(chatDataModelList[index].filePath))) {
                                                                                                  isDownLoad.value = true;
                                                                                                  await chatController.downloadImage(url: "$mainUrl${chatDataModelList[index].message}").then((value) {
                                                                                                    updateUserChatDataRestoreData((value ?? ""), chatDataModelList[index].id ?? "", controller.isGroup);
                                                                                                    chatDataModelList[index].filePath = (value ?? "");
                                                                                                    print("=============${chatDataModelList[index].filePath}");
                                                                                                    isDownLoad.value = false;
                                                                                                  });
                                                                                                } else {
                                                                                                  OpenFilex.open(chatDataModelList[index].filePath);
                                                                                                }
                                                                                              },
                                                                                              child: chatDataModelList[index].deliveryType == 0 && isSender
                                                                                                  ? CircularProgressIndicator(
                                                                                                      color: AppColors.primaryColor,
                                                                                                    )
                                                                                                  : Container(
                                                                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.white),
                                                                                                      child: ((chatDataModelList[index].filePath?.isEmpty ?? true) || (checkGalleryPath(chatDataModelList[index].filePath)))
                                                                                                          ? isDownLoad.value
                                                                                                              ? CircularProgressIndicator(
                                                                                                                  color: AppColors.primaryColor,
                                                                                                                )
                                                                                                              : Icon(
                                                                                                                  Icons.download,
                                                                                                                  color: AppColors.primaryColor,
                                                                                                                  size: 30,
                                                                                                                )
                                                                                                          : CustomImageView(
                                                                                                              height: 30,
                                                                                                              onTap: () {},
                                                                                                              svgPath: 'other_otion_image.svg',
                                                                                                              color: AppColors.primaryColor,
                                                                                                            ),
                                                                                                    ),
                                                                                            ),
                                                                                            const SizedBox(width: 10),
                                                                                            Flexible(
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    chatDataModelList[index].filePath?.split("/").last ?? (chatDataModelList[index].message?.split("/").last ?? ""),
                                                                                                    style: TextStyle(fontSize: 15, color: AppColors.fontColor, fontWeight: FontWeight.w400),
                                                                                                  ),
                                                                                                  const SizedBox(height: 3),
                                                                                                  Container(
                                                                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white),
                                                                                                    child: FutureBuilder(
                                                                                                      future: getFileSize((chatDataModelList[index].filePath ?? ""), 1, url: (chatDataModelList[index].filePath?.isEmpty ?? true) ? "$mainUrl${chatDataModelList[index].message}" : ""),
                                                                                                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshots) {
                                                                                                        return Text(
                                                                                                          snapshots.data ?? "",
                                                                                                          style: TextStyle(fontSize: 14, color: AppColors.primaryColor, fontWeight: FontWeight.w400),
                                                                                                        );
                                                                                                      },
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    })
                                                                                : chatDataModelList[index].mediaType == 2
                                                                                    ? StreamBuilder(
                                                                                        stream: isDownLoad.stream,
                                                                                        builder: (context, snapshot) {
                                                                                          // print("==== url ${chatDataModelList[index].filePath?.isEmpty}");
                                                                                          if ((chatDataModelList[index].filePath?.isEmpty ?? true) && isSender) {
                                                                                            isDownLoad.value = true;
                                                                                            chatController.downloadImage(url: "$mainUrl${chatDataModelList[index].message}").then((value) {
                                                                                              updateUserChatDataRestoreData((value ?? ""), (chatDataModelList[index].id ?? ""), controller.isGroup);
                                                                                              chatDataModelList[index].filePath = (value ?? "");
                                                                                              chatDataModelList[index].deliveryType = 1;
                                                                                              print("=============${chatDataModelList[index].filePath}");
                                                                                              isDownLoad.value = false;
                                                                                            });
                                                                                          }

                                                                                          return ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(15),
                                                                                              child: chatDataModelList[index].deliveryType == 0 && isSender
                                                                                                  ? InkWell(
                                                                                                      onTap: () async {
                                                                                                        print("==== url ${chatDataModelList[index].filePath?.isEmpty}");
                                                                                                        isDownLoad.value = true;
                                                                                                        await chatController.downloadImage(url: "$mainUrl${chatDataModelList[index].message}").then((value) {
                                                                                                          updateUserChatDataRestoreData((value ?? ""), (chatDataModelList[index].id ?? ""), controller.isGroup);
                                                                                                          chatDataModelList[index].filePath = (value ?? "");
                                                                                                          print("=============${chatDataModelList[index].filePath}");
                                                                                                          isDownLoad.value = false;
                                                                                                        });
                                                                                                      },
                                                                                                      child: Container(
                                                                                                        constraints: BoxConstraints(minHeight: 197, minWidth: 240),
                                                                                                        child: Stack(
                                                                                                          children: [
                                                                                                            ImageFiltered(
                                                                                                              imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                                                                                              child: LocalNetworkMedia().getMedia(
                                                                                                                url: getThambNelFormUrl("$mainUrl${chatDataModelList[index].message}"),
                                                                                                                imageFit: BoxFit.cover,
                                                                                                              ),
                                                                                                            ),
                                                                                                            Positioned(
                                                                                                              top: 0,
                                                                                                              bottom: 0,
                                                                                                              left: 0,
                                                                                                              right: 0,
                                                                                                              child: Center(
                                                                                                                  child: CircularProgressIndicator(
                                                                                                                color: AppColors.primaryColor,
                                                                                                              )),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    )
                                                                                                  : (chatDataModelList[index].filePath?.isEmpty ?? true) || (checkGalleryPath(chatDataModelList[index].filePath))
                                                                                                      ? InkWell(
                                                                                                          onTap: () async {
                                                                                                            isDownLoad.value = true;
                                                                                                            await chatController.downloadImage(url: "$mainUrl${chatDataModelList[index].message}").then((value) {
                                                                                                              updateUserChatDataRestoreData((value ?? ""), (chatDataModelList[index].id ?? ""), controller.isGroup);
                                                                                                              chatDataModelList[index].filePath = (value ?? "");
                                                                                                              print("=====44444444========${chatDataModelList[index].filePath}");
                                                                                                              isDownLoad.value = false;
                                                                                                            });
                                                                                                          },
                                                                                                          child: Container(
                                                                                                            constraints: BoxConstraints(minHeight: 197, minWidth: 240),
                                                                                                            child: Stack(
                                                                                                              children: [
                                                                                                                Container(
                                                                                                                  constraints: BoxConstraints(minHeight: 197, minWidth: 240),
                                                                                                                  child: ImageFiltered(
                                                                                                                    imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                                                                                                    child: newSocketController.connected.value
                                                                                                                        ? Image.network(getThambNelFormUrl("$mainUrl${chatDataModelList[index].message}"), fit: BoxFit.cover)
                                                                                                                        : LocalNetworkMedia().getMedia(
                                                                                                                            url: getThambNelFormUrl(("$mainUrl${chatDataModelList[index].message}")),
                                                                                                                            // height: double.parse("${getheight.data?.height ?? 150}"),
                                                                                                                            // width: double.parse("${getheight.data?.width ?? 150}"),
                                                                                                                            imageFit: BoxFit.cover,
                                                                                                                          ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                Positioned(
                                                                                                                  top: 0,
                                                                                                                  bottom: 0,
                                                                                                                  right: 0,
                                                                                                                  left: 0,
                                                                                                                  child: Center(
                                                                                                                    child: isDownLoad.value
                                                                                                                        ? CircularProgressIndicator(
                                                                                                                            color: AppColors.primaryColor,
                                                                                                                          )
                                                                                                                        : Container(
                                                                                                                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                                                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.colorBlack.withOpacity(0.2)),
                                                                                                                            child: Icon(
                                                                                                                              Icons.download,
                                                                                                                              color: AppColors.colorFFFFFF,
                                                                                                                              size: 30,
                                                                                                                            )),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                        )
                                                                                                      : InkWell(
                                                                                                          onTap: () {
                                                                                                            Get.to(() => VideoPlayScreen(
                                                                                                                  url: chatDataModelList[index].filePath,
                                                                                                                ));
                                                                                                          },
                                                                                                          child: Stack(
                                                                                                            children: [
                                                                                                              Container(
                                                                                                                constraints: BoxConstraints(minHeight: 197, minWidth: 240),
                                                                                                                child: newSocketController.connected.value
                                                                                                                    ? Image.network(getThambNelFormUrl("$mainUrl${chatDataModelList[index].message}"), fit: BoxFit.cover)
                                                                                                                    : LocalNetworkMedia().getMedia(
                                                                                                                        url: getThambNelFormUrl("$mainUrl${chatDataModelList[index].message}"),
                                                                                                                        imageFit: BoxFit.cover,
                                                                                                                      ),
                                                                                                              ),
                                                                                                              Positioned(
                                                                                                                bottom: 0.0,
                                                                                                                right: 0.0,
                                                                                                                left: 0.0,
                                                                                                                top: 0.0,
                                                                                                                child: Center(
                                                                                                                  child: Container(
                                                                                                                      height: 60,
                                                                                                                      width: 60,
                                                                                                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: AppColors.colorBlack.withOpacity(0.2)),
                                                                                                                      child: Icon(
                                                                                                                        Icons.play_arrow,
                                                                                                                        color: AppColors.colorFFFFFF,
                                                                                                                        size: 30,
                                                                                                                      )),
                                                                                                                ),
                                                                                                              )
                                                                                                            ],
                                                                                                          ),
                                                                                                        ));
                                                                                        })
                                                                                    : chatDataModelList[index].mediaType == 3
                                                                                        ? StreamBuilder(
                                                                                            stream: isAudioPlay.stream,
                                                                                            builder: (context, snapshot) {
                                                                                              return FutureBuilder<Duration>(
                                                                                                future: getAudioDuration(chatDataModelList[index].filePath),
                                                                                                builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
                                                                                                  return Row(
                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                    children: [
                                                                                                      if (chatDataModelList[index].filePath?.isNotEmpty ?? false)
                                                                                                        Container(
                                                                                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white),
                                                                                                          child: Text(
                                                                                                            "${snapshot.data?.inMinutes.toString().length == 1 ? "0" : ""}${snapshot.data?.inMinutes.toString() ?? "0"}:${snapshot.data?.inSeconds.toString().length == 1 ? "0" : ""}${snapshot.data?.inSeconds.toString() ?? "0"}" ?? "",
                                                                                                            style: TextStyle(color: AppColors.color1F222A, fontWeight: FontWeight.w400, fontSize: 15),
                                                                                                          ),
                                                                                                        ),
                                                                                                      // const SizedBox(width: 2),

                                                                                                      (chatDataModelList[index].filePath?.isNotEmpty ?? false)
                                                                                                          ? WaveBubble(
                                                                                                              path: chatDataModelList[index].filePath,
                                                                                                              isSender: true,
                                                                                                              width: 100,
                                                                                                            )
                                                                                                          : CustomImageView(
                                                                                                              height: 24,
                                                                                                              onTap: () {},
                                                                                                              svgPath: 'voiseImage.svg',
                                                                                                              color: AppColors.primaryColor,
                                                                                                            ),
                                                                                                      // PolygonWaveform(
                                                                                                      //   samples: [],
                                                                                                      //   height: 20,
                                                                                                      //   width: 100,
                                                                                                      //   maxDuration: maxDuration,
                                                                                                      //   elapsedDuration: elapsedDuration,
                                                                                                      // ),
                                                                                                      const SizedBox(width: 10),
                                                                                                      StreamBuilder(
                                                                                                          stream: isDownLoad.stream,
                                                                                                          builder: (context, snapshot) {
                                                                                                            return (chatDataModelList[index].filePath?.isEmpty ?? true)
                                                                                                                ? isDownLoad.value
                                                                                                                    ? InkWell(
                                                                                                                        onTap: () async {},
                                                                                                                        child: Container(
                                                                                                                          height: 40,
                                                                                                                          width: 40,
                                                                                                                          padding: const EdgeInsets.all(6),
                                                                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.primaryColor),
                                                                                                                          child: CircularProgressIndicator(
                                                                                                                            color: AppColors.colorFFFFFF,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      )
                                                                                                                    : InkWell(
                                                                                                                        onTap: () async {
                                                                                                                          isDownLoad.value = true;
                                                                                                                          await chatController.downloadImage(url: "$mainUrl${chatDataModelList[index].message}").then((value) {
                                                                                                                            updateUserChatDataRestoreData((value ?? ""), chatDataModelList[index].id ?? "", controller.isGroup);
                                                                                                                            chatDataModelList[index].filePath = (value ?? chatDataModelList[index].filePath);

                                                                                                                            isDownLoad.value = false;
                                                                                                                            isAudioPlay.refresh();
                                                                                                                          });
                                                                                                                        },
                                                                                                                        child: Container(
                                                                                                                          height: 40,
                                                                                                                          width: 40,
                                                                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.primaryColor),
                                                                                                                          child: Icon(
                                                                                                                            Icons.download,
                                                                                                                            color: AppColors.subCardColor,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      )
                                                                                                                : const SizedBox();
                                                                                                          })
                                                                                                    ],
                                                                                                  );
                                                                                                },
                                                                                              );
                                                                                            })
                                                                                        : chatDataModelList[index].mediaType == 1
                                                                                            ? Container(
                                                                                                child: ClipRRect(
                                                                                                    borderRadius: BorderRadius.circular(15),
                                                                                                    child: chatDataModelList[index].deliveryType == 0 && isSender
                                                                                                        ? chatDataModelList[index].message_caption != null && chatDataModelList[index].message_caption!.isNotEmpty
                                                                                                            ? Stack(
                                                                                                                children: [
                                                                                                                  Column(
                                                                                                                    children: [
                                                                                                                      Container(
                                                                                                                        constraints: BoxConstraints(minHeight: 197, minWidth: 270, maxHeight: 300),
                                                                                                                        child: ClipRRect(
                                                                                                                          borderRadius: BorderRadius.circular(15),
                                                                                                                          child: ImageFiltered(
                                                                                                                              imageFilter: ImageFilter.blur(sigmaX: 2.0, sigmaY: .0),
                                                                                                                              child: Image.file(
                                                                                                                                File(chatDataModelList[index].filePath ?? ""),
                                                                                                                                fit: BoxFit.cover,
                                                                                                                              )),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      Text(chatDataModelList[index].message_caption ?? "")
                                                                                                                    ],
                                                                                                                  ),
                                                                                                                  Positioned(
                                                                                                                    top: 0,
                                                                                                                    bottom: 0,
                                                                                                                    left: 0,
                                                                                                                    right: 0,
                                                                                                                    child: Center(
                                                                                                                        child: CircularProgressIndicator(
                                                                                                                      color: AppColors.primaryColor,
                                                                                                                    )),
                                                                                                                  ),
                                                                                                                ],
                                                                                                              )
                                                                                                            : Stack(
                                                                                                                children: [
                                                                                                                  Container(
                                                                                                                    constraints: BoxConstraints(minHeight: 197, minWidth: 270, maxHeight: 300),
                                                                                                                    child: ClipRRect(
                                                                                                                      borderRadius: BorderRadius.circular(15),
                                                                                                                      child: ImageFiltered(
                                                                                                                          imageFilter: ImageFilter.blur(sigmaX: 2.0, sigmaY: .0),
                                                                                                                          child: Image.file(
                                                                                                                            File(chatDataModelList[index].filePath ?? ""),
                                                                                                                            fit: BoxFit.cover,
                                                                                                                          )),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  Positioned(
                                                                                                                    top: 0,
                                                                                                                    bottom: 0,
                                                                                                                    left: 0,
                                                                                                                    right: 0,
                                                                                                                    child: Center(
                                                                                                                        child: CircularProgressIndicator(
                                                                                                                      color: AppColors.primaryColor,
                                                                                                                    )),
                                                                                                                  ),
                                                                                                                ],
                                                                                                              )
                                                                                                        : File("${chatDataModelList[index].filePath}").existsSync() && chatDataModelList[index].message_caption != null && chatDataModelList[index].message_caption!.isNotEmpty
                                                                                                            ? Column(
                                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                                children: [
                                                                                                                  Padding(
                                                                                                                    padding: const EdgeInsets.only(left: 8, right: 8, top: 0),
                                                                                                                    child: InkWell(
                                                                                                                      onTap: () {
                                                                                                                        Get.to(() => ImageViewScreen(
                                                                                                                              imageList: [chatDataModelList[index].filePath ?? ""],
                                                                                                                            ));
                                                                                                                      },
                                                                                                                      child: Container(
                                                                                                                        constraints: BoxConstraints(minHeight: 197, minWidth: 270, maxHeight: 300),
                                                                                                                        child: ClipRRect(
                                                                                                                          borderRadius: BorderRadius.circular(15),
                                                                                                                          child: Image.file(File(chatDataModelList[index].filePath ?? ""), fit: BoxFit.cover),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  Text(
                                                                                                                    chatDataModelList[index].message_caption ?? "",
                                                                                                                    style: TextStyle(color: AppColors.darkBgColor, fontSize: 17, fontWeight: FontWeight.w400),
                                                                                                                  ).marginOnly(left: 12)
                                                                                                                ],
                                                                                                              )
                                                                                                            : File("${chatDataModelList[index].filePath}").existsSync()
                                                                                                                ? InkWell(
                                                                                                                    onTap: () {
                                                                                                                      Get.to(() => ImageViewScreen(
                                                                                                                            imageList: [chatDataModelList[index].filePath ?? ""],
                                                                                                                          ));
                                                                                                                    },
                                                                                                                    child: Container(
                                                                                                                      constraints: BoxConstraints(minHeight: 197, minWidth: 270, maxHeight: 300),
                                                                                                                      child: ClipRRect(
                                                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                                                        child: Image.file(File(chatDataModelList[index].filePath ?? ""), fit: BoxFit.cover),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  )
                                                                                                                : StreamBuilder(
                                                                                                                    stream: isDownLoad.stream,
                                                                                                                    builder: (context, snapshots) {
                                                                                                                      return ClipRRect(
                                                                                                                          borderRadius: BorderRadius.circular(15),
                                                                                                                          child: (chatDataModelList[index].filePath?.isEmpty ?? true) && chatDataModelList[index].message_caption != null && chatDataModelList[index].message_caption!.isNotEmpty
                                                                                                                              ? Column(
                                                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                                                                  children: [
                                                                                                                                    Padding(
                                                                                                                                      padding: const EdgeInsets.only(left: 8, right: 8, top: 0),
                                                                                                                                      child: InkWell(
                                                                                                                                        onTap: () async {
                                                                                                                                          print("hello==== 555 ${chatDataModelList[index].filePath?.isEmpty}");
                                                                                                                                          isDownLoad.value = true;
                                                                                                                                          await chatController.downloadImage(url: "$mainUrl${chatDataModelList[index].message}").then((value) {
                                                                                                                                            //  print("hello==== ${value}");
                                                                                                                                            updateUserChatDataRestoreData((value ?? ""), chatDataModelList[index].id ?? "", controller.isGroup);
                                                                                                                                            chatDataModelList[index].filePath = (value ?? chatDataModelList[index].filePath);

                                                                                                                                            isDownLoad.value = false;
                                                                                                                                          });
                                                                                                                                        },
                                                                                                                                        child: Stack(
                                                                                                                                          clipBehavior: Clip.none,
                                                                                                                                          children: [
                                                                                                                                            Container(
                                                                                                                                              constraints: BoxConstraints(minHeight: 197, minWidth: 270, maxHeight: 300),
                                                                                                                                              child: LocalNetworkMedia().getMedia(
                                                                                                                                                url: getThambNelFormUrl(("$mainUrl${chatDataModelList[index].message}")),
                                                                                                                                                imageFit: BoxFit.cover,
                                                                                                                                              ),
                                                                                                                                            ),
                                                                                                                                            Positioned(
                                                                                                                                              top: 0,
                                                                                                                                              bottom: 0,
                                                                                                                                              left: 0,
                                                                                                                                              right: 0,
                                                                                                                                              child: Center(
                                                                                                                                                child: isDownLoad.value
                                                                                                                                                    ? CircularProgressIndicator(
                                                                                                                                                        color: AppColors.primaryColor,
                                                                                                                                                      )
                                                                                                                                                    : Container(
                                                                                                                                                        height: 60,
                                                                                                                                                        width: 60,
                                                                                                                                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                                                                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: AppColors.colorBlack.withOpacity(0.2)),
                                                                                                                                                        child: Icon(
                                                                                                                                                          Icons.download,
                                                                                                                                                          color: AppColors.colorFFFFFF,
                                                                                                                                                          size: 30,
                                                                                                                                                        )),
                                                                                                                                              ),
                                                                                                                                            ),
                                                                                                                                          ],
                                                                                                                                        ),
                                                                                                                                      ),
                                                                                                                                    ),
                                                                                                                                    Text(
                                                                                                                                      chatDataModelList[index].message_caption ?? "",
                                                                                                                                      style: TextStyle(color: AppColors.darkBgColor, fontSize: 17, fontWeight: FontWeight.w400),
                                                                                                                                    ).marginOnly(left: 12)
                                                                                                                                  ],
                                                                                                                                )
                                                                                                                              : (chatDataModelList[index].filePath?.isEmpty ?? true) || (checkGalleryPath(chatDataModelList[index].filePath))
                                                                                                                                  ? InkWell(
                                                                                                                                      onTap: () async {
                                                                                                                                        print("hello==== 555 ${chatDataModelList[index].filePath?.isEmpty}");
                                                                                                                                        isDownLoad.value = true;
                                                                                                                                        await chatController.downloadImage(url: "$mainUrl${chatDataModelList[index].message}").then((value) {
                                                                                                                                          //  print("hello==== ${value}");
                                                                                                                                          updateUserChatDataRestoreData((value ?? ""), chatDataModelList[index].id ?? "", controller.isGroup);
                                                                                                                                          chatDataModelList[index].filePath = (value ?? chatDataModelList[index].filePath);

                                                                                                                                          isDownLoad.value = false;
                                                                                                                                        });
                                                                                                                                      },
                                                                                                                                      child: Stack(
                                                                                                                                        clipBehavior: Clip.none,
                                                                                                                                        children: [
                                                                                                                                          Container(
                                                                                                                                            constraints: BoxConstraints(minHeight: 197, minWidth: 270, maxHeight: 300),
                                                                                                                                            child: LocalNetworkMedia().getMedia(
                                                                                                                                              url: getThambNelFormUrl(("$mainUrl${chatDataModelList[index].message}")),
                                                                                                                                              imageFit: BoxFit.cover,
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                          Positioned(
                                                                                                                                            top: 0,
                                                                                                                                            bottom: 0,
                                                                                                                                            left: 0,
                                                                                                                                            right: 0,
                                                                                                                                            child: Center(
                                                                                                                                              child: isDownLoad.value
                                                                                                                                                  ? CircularProgressIndicator(
                                                                                                                                                      color: AppColors.primaryColor,
                                                                                                                                                    )
                                                                                                                                                  : Container(
                                                                                                                                                      height: 60,
                                                                                                                                                      width: 60,
                                                                                                                                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                                                                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: AppColors.colorBlack.withOpacity(0.2)),
                                                                                                                                                      child: Icon(
                                                                                                                                                        Icons.download,
                                                                                                                                                        color: AppColors.colorFFFFFF,
                                                                                                                                                        size: 30,
                                                                                                                                                      )),
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                        ],
                                                                                                                                      ),
                                                                                                                                    )
                                                                                                                                  : chatDataModelList[index].message_caption != null && chatDataModelList[index].message_caption!.isNotEmpty
                                                                                                                                      ? Column(
                                                                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                                                                          children: [
                                                                                                                                            Padding(
                                                                                                                                              padding: const EdgeInsets.only(left: 8, right: 8, top: 0),
                                                                                                                                              child: InkWell(
                                                                                                                                                onTap: () {
                                                                                                                                                  //  print("hello==== ${chatDataModelList[index].filePath?.isEmpty}");
                                                                                                                                                  Get.to(() => ImageViewScreen(
                                                                                                                                                        imageList: [chatDataModelList[index].filePath ?? ""],
                                                                                                                                                      ));
                                                                                                                                                },
                                                                                                                                                child: Container(
                                                                                                                                                  constraints: BoxConstraints(minHeight: 197, minWidth: 270, maxHeight: 300),
                                                                                                                                                  child: Image.file(File(chatDataModelList[index].filePath ?? ""), fit: BoxFit.cover),
                                                                                                                                                ),
                                                                                                                                              ),
                                                                                                                                            ),
                                                                                                                                            Text(
                                                                                                                                              chatDataModelList[index].message_caption ?? "",
                                                                                                                                              style: TextStyle(color: AppColors.darkBgColor, fontSize: 17, fontWeight: FontWeight.w400),
                                                                                                                                            ).marginOnly(left: 12)
                                                                                                                                          ],
                                                                                                                                        )
                                                                                                                                      : InkWell(
                                                                                                                                          onTap: () {
                                                                                                                                            //  print("hello==== ${chatDataModelList[index].filePath?.isEmpty}");
                                                                                                                                            Get.to(() => ImageViewScreen(
                                                                                                                                                  imageList: [chatDataModelList[index].filePath ?? ""],
                                                                                                                                                ));
                                                                                                                                          },
                                                                                                                                          child: Container(
                                                                                                                                            constraints: BoxConstraints(minHeight: 197, minWidth: 270, maxHeight: 300),
                                                                                                                                            child: Image.file(File(chatDataModelList[index].filePath ?? ""), fit: BoxFit.cover),
                                                                                                                                          ),
                                                                                                                                        ));
                                                                                                                    })))

                                                                                            //     FutureBuilder(
                                                                                            //   future: LocalNetworkMedia().getImageHeightWidth(url: getThambNelFormUrl("$mainUrl${chatDataModelList[index].message}")),
                                                                                            //   builder: (BuildContext context, AsyncSnapshot<Size>getheight)  {
                                                                                            //     String scap="potrate";
                                                                                            //     // if( getheight.data!.width!>getheight.data!.width!){
                                                                                            //     //   scap="land";
                                                                                            //     // }else{
                                                                                            //     //   scap="potrate";
                                                                                            //     // }
                                                                                            //     return chatDataModelList[index].deliveryType == 0 && isSender
                                                                                            //         ? Stack(
                                                                                            //           children: [
                                                                                            //             Column(
                                                                                            //               children: [
                                                                                            //                 Container(
                                                                                            //                   constraints: const BoxConstraints(minHeight: 197, minWidth: 180, maxHeight: 300,maxWidth: 240),
                                                                                            //                   child: ClipRRect(
                                                                                            //                                                                                                   borderRadius: BorderRadius.circular(15),
                                                                                            //                     child: ImageFiltered(
                                                                                            //                         imageFilter: ImageFilter.blur(sigmaX: 2.0, sigmaY: .0),
                                                                                            //                         child: Image.file(
                                                                                            //                           File(chatDataModelList[index].filePath ?? ""),
                                                                                            //                            height: 300,
                                                                                            //                            width:240,
                                                                                            //                           fit: BoxFit.cover,
                                                                                            //                         )),
                                                                                            //                   ),
                                                                                            //                 ),
                                                                                            //                 Text(chatDataModelList[index].message_caption??"")
                                                                                            //               ],
                                                                                            //             ),
                                                                                            //             Positioned(
                                                                                            //               top:0,bottom: 0,left: 0,right: 0,
                                                                                            //               child: Center(
                                                                                            //                   child: CircularProgressIndicator(
                                                                                            //                     color: AppColors.primaryColor,
                                                                                            //                   )),
                                                                                            //             ),
                                                                                            //           ],
                                                                                            //         )
                                                                                            //         : (chatDataModelList[index].filePath?.isEmpty ?? true) || (checkGalleryPath(chatDataModelList[index].filePath))
                                                                                            //         ? StreamBuilder(
                                                                                            //         stream: isDownLoad.stream,
                                                                                            //         builder: (context, snapshots) {
                                                                                            //           return ClipRRect(
                                                                                            //               borderRadius: BorderRadius.circular(15),
                                                                                            //               child: (chatDataModelList[index].filePath?.isEmpty ?? true) || (checkGalleryPath(chatDataModelList[index].filePath))
                                                                                            //                   ? InkWell(
                                                                                            //                 onTap: () async {
                                                                                            //                   print("hello==== 555 ${chatDataModelList[index].filePath?.isEmpty}");
                                                                                            //                   isDownLoad.value = true;
                                                                                            //                   await chatController.downloadImage(url: "$mainUrl${chatDataModelList[index].message}").then((value) {
                                                                                            //                   //  print("hello==== ${value}");
                                                                                            //                     updateUserChatDataRestoreData((value ?? ""), chatDataModelList[index].id ?? "",controller.isGroup);
                                                                                            //                     chatDataModelList[index].filePath = (value ?? chatDataModelList[index].filePath);
                                                                                            //
                                                                                            //                     isDownLoad.value = false;
                                                                                            //                   });
                                                                                            //                 },
                                                                                            //                 child: Container(
                                                                                            //                   constraints: const BoxConstraints(minHeight: 197, minWidth: 180, maxHeight: 300,maxWidth: 240),
                                                                                            //                   child: Stack(
                                                                                            //                     clipBehavior: Clip.none,
                                                                                            //                     // fit: StackFit.passthrough,
                                                                                            //                     children: [
                                                                                            //                       Container(
                                                                                            //                         constraints: const BoxConstraints(minHeight: 197, minWidth: 180, maxHeight: 300,maxWidth: 240),
                                                                                            //                         child: ClipRRect(
                                                                                            //                           borderRadius: BorderRadius.circular(15),
                                                                                            //                           child: LocalNetworkMedia().getMedia(
                                                                                            //                             url: getThambNelFormUrl(("$mainUrl${chatDataModelList[index].message}")),
                                                                                            //                             imageFit: BoxFit.cover,
                                                                                            //                             width: 240,
                                                                                            //                             height: 300
                                                                                            //                           ),
                                                                                            //                         ),
                                                                                            //                       ),
                                                                                            //                       Positioned(
                                                                                            //                         top:0,bottom: 0,left: 0,right: 0,
                                                                                            //                         child: Center(
                                                                                            //                           child: isDownLoad.value
                                                                                            //                               ? CircularProgressIndicator(
                                                                                            //                             color: AppColors.primaryColor,
                                                                                            //                           )
                                                                                            //                               : Container(
                                                                                            //                               height: 60,
                                                                                            //                               width: 60,
                                                                                            //                               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                                                                            //                               decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: AppColors.colorBlack.withOpacity(0.2)),
                                                                                            //                               child: Icon(
                                                                                            //                                 Icons.download,
                                                                                            //                                 color: AppColors.colorFFFFFF,
                                                                                            //                                 size: 30,
                                                                                            //                               )),
                                                                                            //                         ),
                                                                                            //                       ),
                                                                                            //                     ],
                                                                                            //                   ),
                                                                                            //                 ),
                                                                                            //               )
                                                                                            //                   : InkWell(
                                                                                            //                 onTap: () {
                                                                                            //                 //  print("hello==== ${chatDataModelList[index].filePath?.isEmpty}");
                                                                                            //                   Get.to(() => ImageViewScreen(
                                                                                            //                     imageList: [chatDataModelList[index].filePath ?? ""],
                                                                                            //                   ));
                                                                                            //                 },
                                                                                            //                 child: Container(
                                                                                            //                   constraints: const BoxConstraints(minHeight: 197, minWidth: 180, maxHeight: 300,maxWidth: 240),
                                                                                            //                   child: LocalNetworkMedia().getMedia(
                                                                                            //                    // url: "$mainUrl${chatDataModelList[index].message}",
                                                                                            //                    url: getThambNelFormUrl(("$mainUrl${chatDataModelList[index].message}")),
                                                                                            //                     imageFit: BoxFit.cover,
                                                                                            //                       height: 300,
                                                                                            //                     width:240,
                                                                                            //                     // height: double.parse("${getheight.data?.height ?? 150}"),
                                                                                            //                     // width: double.parse("${getheight.data?.width ?? 150}"),
                                                                                            //                   ),
                                                                                            //                 ),
                                                                                            //               ));
                                                                                            //         })
                                                                                            //         : InkWell(
                                                                                            //       onTap: () {
                                                                                            //
                                                                                            //         Get.to(() => ImageViewScreen(
                                                                                            //           imageList: [chatDataModelList[index].filePath ?? ""],
                                                                                            //         ));
                                                                                            //       },
                                                                                            //       child:  Container(
                                                                                            //           constraints: BoxConstraints( minWidth: 180,maxHeight: 300, maxWidth: 240 ),
                                                                                            //         child: ClipRRect(
                                                                                            //           borderRadius: BorderRadius.circular(15),
                                                                                            //           child: Image.file(
                                                                                            //             File(chatDataModelList[index].filePath ?? ""),
                                                                                            //             // height: scap=="land"?120:300,
                                                                                            //             // width : 210,
                                                                                            //             // height: double.parse("${getheight.data?.height ?? 150}"),
                                                                                            //             // width: double.parse("${getheight.data?.width ?? 150}"),
                                                                                            //             //fit: BoxFit.fill,
                                                                                            //               fit: BoxFit.cover
                                                                                            //           ),
                                                                                            //         ),
                                                                                            //       ),
                                                                                            //     );
                                                                                            //   },
                                                                                            // )
                                                                                            : chatDataModelList[index].mediaType == 6
                                                                                                ? StreamBuilder(
                                                                                                    stream: isDownLoad.stream,
                                                                                                    builder: (context, snapshot) {
                                                                                                      return ClipRRect(
                                                                                                          borderRadius: BorderRadius.circular(15),
                                                                                                          child: InkWell(
                                                                                                            onTap: () async {
                                                                                                              print("hello==== ${chatDataModelList[index].message}");

                                                                                                              Uri lunch_url = Uri.parse("https://www.google.com/maps/search/?api=1&query=${chatDataModelList[index].message!.split("(")[1].split(")").first},${chatDataModelList[index].message!.split("(")[2].split(")").first}");
                                                                                                              await launchUrl(lunch_url);

                                                                                                              //
                                                                                                            },
                                                                                                            child: SizedBox(height: 150, child: Image.asset("assets/images/Map.jpg")

                                                                                                                //Image.network(chatDataModelList[index].message ?? ""),

                                                                                                                ),
                                                                                                          ));
                                                                                                    })
                                                                                                : chatDataModelList[index].mediaType == 5
                                                                                                    ? GestureDetector(
                                                                                                        onTap: () => {contact_Details(chatDataModelList[index].message!.split(",")[0], chatDataModelList[index].message!.split(",")[1])},
                                                                                                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                                                                                                          Text(
                                                                                                            chatDataModelList[index].message!.split(",")[0] ?? "",
                                                                                                            style: TextStyle(color: AppColors.color1F222A, fontWeight: FontWeight.w700, fontSize: 15),
                                                                                                          ),
                                                                                                          const SizedBox(width: 10),
                                                                                                          SizedBox(
                                                                                                            height: 30,
                                                                                                            width: 30,
                                                                                                            child: ClipOval(child: CircleAvatar(radius: 50, backgroundColor: AppColors.darkPrimaryColor, child: getCustomFont(chatDataModelList[index].message!.length < 1 ? "" : chatDataModelList[index].message!.split(",")[0].substring(0, 1) ?? "", 12, AppColors.colorFFFFFF, 1, fontWeight: FontWeight.w400))),
                                                                                                          ),
                                                                                                          const SizedBox(width: 5),
                                                                                                          Icon(Icons.arrow_forward_ios, size: 13)
                                                                                                        ]),
                                                                                                      )
                                                                                                    : chatDataModelList[index].mediaType == 7
                                                                                                        ? Align(
                                                                                                            child: Text(chatDataModelList[index].message ?? "",
                                                                                                                style: TextStyle(
                                                                                                                  color: themeController.isDarkMode ? AppColors.color1F222A : AppColors.colorFFFFFF,
                                                                                                                  fontWeight: FontWeight.w400,
                                                                                                                  fontSize: 13,
                                                                                                                ),
                                                                                                                maxLines: 1,
                                                                                                                textAlign: TextAlign.center),
                                                                                                          )
                                                                                                        : !isSender && controller.sideBarData?.isGroup == 1
                                                                                                            ? Column(
                                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                children: [
                                                                                                                  chatDataModelList[index].isEdited != 1
                                                                                                                      ? Text(
                                                                                                                          chatDataModelList[index].senderFirstName ?? "",
                                                                                                                          style: TextStyle(
                                                                                                                            color: AppColors.color1F222A,
                                                                                                                            fontWeight: FontWeight.w700,
                                                                                                                            fontSize: 12,
                                                                                                                            fontStyle: FontStyle.italic,
                                                                                                                          ),
                                                                                                                        )
                                                                                                                      : Row(
                                                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                          children: [
                                                                                                                            Text(
                                                                                                                              chatDataModelList[index].senderFirstName ?? "",
                                                                                                                              style: TextStyle(
                                                                                                                                color: AppColors.color1F222A,
                                                                                                                                fontWeight: FontWeight.w700,
                                                                                                                                fontSize: 12,
                                                                                                                                fontStyle: FontStyle.italic,
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                            const SizedBox(width: 10),
                                                                                                                            Text(
                                                                                                                              " Edited",
                                                                                                                              style: TextStyle(
                                                                                                                                color: AppColors.grayColor,
                                                                                                                                fontWeight: FontWeight.w400,
                                                                                                                                fontSize: 10,
                                                                                                                                fontStyle: FontStyle.italic,
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          ],
                                                                                                                        ),
                                                                                                                  const SizedBox(
                                                                                                                    height: 5,
                                                                                                                  ),
                                                                                                                  Text(
                                                                                                                    chatDataModelList[index].message ?? "",
                                                                                                                    style: TextStyle(color: AppColors.color1F222A, fontWeight: FontWeight.w400, fontSize: 15),
                                                                                                                  )
                                                                                                                ],
                                                                                                              )
                                                                                                            : chatDataModelList[index].isEdited == 1
                                                                                                                ? Column(
                                                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                                                    crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                                                                                                    children: [
                                                                                                                      Text(
                                                                                                                        "Edited",
                                                                                                                        style: TextStyle(
                                                                                                                          color: AppColors.color1F222A,
                                                                                                                          fontWeight: FontWeight.w700,
                                                                                                                          fontSize: 12,
                                                                                                                          fontStyle: FontStyle.italic,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      const SizedBox(
                                                                                                                        height: 5,
                                                                                                                      ),
                                                                                                                      Text(
                                                                                                                        chatDataModelList[index].message ?? "",
                                                                                                                        style: TextStyle(color: AppColors.color1F222A, fontWeight: FontWeight.w400, fontSize: 15),
                                                                                                                      ),
                                                                                                                    ],
                                                                                                                  )
                                                                                                                : Text(
                                                                                                                    chatDataModelList[index].message ?? "",
                                                                                                                    style: TextStyle(color: AppColors.color1F222A, fontWeight: FontWeight.w400, fontSize: 15),
                                                                                                                  ),

                                                                            // Text(
                                                                            //   chatDataModelList[index].message ?? "",
                                                                            //   style: TextStyle(color: AppColors.color1F222A, fontWeight: FontWeight.w400, fontSize: 15),
                                                                            // ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(height: 5),
                                                              isSender
                                                                  ? Row(
                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                      children: [
                                                                        chatDataModelList[index].deliveryType == 0
                                                                            ? Container()
                                                                            : chatDataModelList[index].deliveryType == 1
                                                                                ? SizedBox(height: 15, child: Image.asset("assets/images/singletick.png"))
                                                                                : SizedBox(
                                                                                    height: 15,
                                                                                    child: Image.asset(
                                                                                      "assets/images/doubletick.png",
                                                                                      color: chatDataModelList[index].deliveryType == 3 ? AppColors.greenColor : AppColors.grayColor,
                                                                                    )),
                                                                        const SizedBox(width: 5),
                                                                        Text(
                                                                          DateFormat().add_jmv().format(chatDataModelList[index].createdAt!),
                                                                          style: TextStyle(color: AppColors.subFontColor),
                                                                        )
                                                                      ],
                                                                    )
                                                                  : chatDataModelList[index].mediaType == 7
                                                                      ? Container()
                                                                      : Text(
                                                                          DateFormat().add_jmv().format(chatDataModelList[index].createdAt!),
                                                                          style: TextStyle(color: AppColors.subFontColor),
                                                                        ).paddingOnly(left: chatDataModelList[index].senderId == controller.sideBarData?.sId ? 0 : 10, right: chatDataModelList[index].senderId == controller.sideBarData?.sId ? 10 : 0)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            controller.sideBarData?.isGroup == 1 && controller.sideBarData?.ismember == 0
                                ? Container(
                                    color: AppColors.grayColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: getCustomFont("You  can't send messages to this group because you are no longer  a member", 16, AppColors.colorFFFFFF, 2),
                                    ))
                                : customTextField()
                          ],
                        ),
                        Obx(
                          () => chatController.isLoderoverFullScreen.value
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ))
                              : Container(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // child: Container(),
        ),
        init: NewMessagesController(),
      ),
    );
  }

  infoMessage(data, isgroup) {
    showModalBottomSheet(
      isScrollControlled: isgroup ? true : false,
      context: context,
      useSafeArea: true,
      // height:MediaQuery.of(context).size.height,
      builder: (BuildContext bc) {
        return Container(
          child: isgroup
              ? Column(
                  children: [
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: AppColors.getFontColor(context),
                                size: 15,
                              ),
                            )),
                        Text(
                          "Message Info",
                          style: TextStyle(color: AppColors.fontColor, fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.transparent,
                          size: 15,
                        )
                      ],
                    ),
                    const Divider(
                      height: 1.0,
                    ),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: const Radius.circular(15), topLeft: const Radius.circular(15), bottomRight: Radius.circular(0), bottomLeft: Radius.circular(15)), color: AppColors.colorD4DFFF),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data.mediaType == 1
                                  ? "Image "
                                  : data.mediaType == 2
                                      ? "Video"
                                      : data.mediaType == 3
                                          ? "Audio"
                                          : data.mediaType == 4
                                              ? "Document"
                                              : data.mediaType == 5
                                                  ? "Contact"
                                                  : data.mediaType == 6
                                                      ? "Location"
                                                      : data.message ?? "",
                              style: TextStyle(color: AppColors.color1F222A, fontWeight: FontWeight.w400, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 5, 0, 5),
                              child: Text(
                                "READ BY :",
                                style: TextStyle(color: AppColors.color1F222A, fontWeight: FontWeight.w400, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        LimitedBox(
                          //   maxHeight: MediaQuery.of(context).size.height/3.5,
                          child: GetX<ChatController>(builder: (controller) {
                            return ListView.builder(
                                itemCount: chatController.GroupReadMessageinfo.length,
                                // itemCount: chatList.length,
                                shrinkWrap: true,
                                //   physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                chatController.GroupReadMessageinfo[index].receiverId!.userImage!.length > 2
                                                    ? ClipOval(
                                                        child: Container(
                                                          height: 38,
                                                          width: 38,
                                                          child: CircleAvatar(
                                                            radius: 50,
                                                            backgroundColor: Colors.white,
                                                            child: Image.network(
                                                              "$mainUrl${chatController.GroupReadMessageinfo[index].receiverId!.userImage}",
                                                              fit: BoxFit.fill,
                                                              height: 38,
                                                              width: 38,
                                                              errorBuilder: (context, error, stackTrace) {
                                                                return getEmptyImage(chatController.GroupReadMessageinfo[index].receiverId!.firstName ?? "");
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : getEmptyImage(chatController.GroupReadMessageinfo[index].receiverId!.firstName ?? ""),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 8.0),
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(10.0, 5, 0, 5),
                                                      child: Text(
                                                        chatController.GroupReadMessageinfo[index].receiverId!.firstName ?? "",
                                                        style: TextStyle(color: AppColors.color1F222A, fontWeight: FontWeight.w400, fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Text(
                                                    "Read :",
                                                    style: TextStyle(color: AppColors.color1F222A, fontWeight: FontWeight.w400, fontSize: 15),
                                                  ),
                                                ),
                                                Row(
                                                  // mainAxisAlignment: MainAxisAlignment.end ,
                                                  children: [
                                                    DateTime.parse(chatController.GroupReadMessageinfo[index].readTime!).toLocal().difference(DateTime.now()).inDays == 0
                                                        ? getCustomFont("Today , ", 15, AppColors.fontColor, 1)
                                                        : DateTime.parse(chatController.GroupReadMessageinfo[index].readTime!).toLocal().difference(DateTime.now()).inDays == 1 || DateTime.parse(chatController.GroupReadMessageinfo[index].readTime!).toLocal().difference(DateTime.now()).inDays == -1
                                                            ? getCustomFont("yesterday , ", 15, AppColors.fontColor, 1)
                                                            : getCustomFont(Moment(DateTime.parse(chatController.GroupReadMessageinfo[index].readTime!).toLocal()).format("DD-MM-YYYY , ").toString(), 15, AppColors.fontColor, 1),
                                                    getCustomFont(DateFormat().add_jmv().format(DateTime.parse(chatController.GroupReadMessageinfo[index].readTime!).toLocal()), 15, AppColors.fontColor, 1),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Text(
                                                    "Delivered :",
                                                    style: TextStyle(color: AppColors.color1F222A, fontWeight: FontWeight.w400, fontSize: 15),
                                                  ),
                                                ),
                                                Row(
                                                  // mainAxisAlignment: MainAxisAlignment.end ,
                                                  children: [
                                                    DateTime.parse(chatController.GroupReadMessageinfo[index].deliveryTime!).toLocal().difference(DateTime.now()).inDays == 0
                                                        ? getCustomFont("Today , ", 15, AppColors.fontColor, 1)
                                                        : DateTime.parse(chatController.GroupReadMessageinfo[index].deliveryTime!).toLocal().difference(DateTime.now()).inDays == 1 || DateTime.parse(chatController.GroupReadMessageinfo[index].deliveryTime!).toLocal().difference(DateTime.now()).inDays == -1
                                                            ? getCustomFont("yesterday , ", 15, AppColors.fontColor, 1)
                                                            : getCustomFont(Moment(DateTime.parse(chatController.GroupReadMessageinfo[index].deliveryTime!).toLocal()).format("DD-MM-YYYY , ").toString(), 15, AppColors.fontColor, 1),
                                                    getCustomFont(DateFormat().add_jmv().format(DateTime.parse(chatController.GroupReadMessageinfo[index].deliveryTime!).toLocal()), 15, AppColors.fontColor, 1),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        height: 1.0,
                                      ),
                                      SizedBox(height: 10)
                                    ],
                                  );
                                });
                          }),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 5, 0, 5),
                              child: Text(
                                "Delivered TO :",
                                style: TextStyle(color: AppColors.color1F222A, fontWeight: FontWeight.w400, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        LimitedBox(
                          maxHeight: chatController.GroupReadMessageinfo.length == 0 ? MediaQuery.of(context).size.height / 1.7 : MediaQuery.of(context).size.height / 3,
                          child: GetX<ChatController>(builder: (controller) {
                            return ListView.builder(
                                itemCount: chatController.GroupDeliveredMessageinfo.length,
                                shrinkWrap: true,
                                //  physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                chatController.GroupDeliveredMessageinfo[index].receiverId!.userImage!.length > 2
                                                    ? ClipOval(
                                                        child: Container(
                                                          height: 38,
                                                          width: 38,
                                                          child: CircleAvatar(
                                                            radius: 50,
                                                            backgroundColor: Colors.white,
                                                            child: Image.network(
                                                              "$mainUrl${chatController.GroupDeliveredMessageinfo[index].receiverId!.userImage}",
                                                              fit: BoxFit.fill,
                                                              height: 38,
                                                              width: 38,
                                                              errorBuilder: (context, error, stackTrace) {
                                                                return getEmptyImage(chatController.GroupDeliveredMessageinfo[index].receiverId!.firstName ?? "");
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : getEmptyImage(chatController.GroupDeliveredMessageinfo[index].receiverId!.firstName ?? ""),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 8.0),
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(10.0, 5, 0, 5),
                                                      child: Text(
                                                        chatController.GroupDeliveredMessageinfo[index].receiverId!.firstName ?? "",
                                                        style: TextStyle(color: AppColors.color1F222A, fontWeight: FontWeight.w400, fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      chatController.GroupDeliveredMessageinfo[index].updatedAt!.toLocal().difference(DateTime.now()).inDays == 0
                                                          ? getCustomFont("Today , ", 15, AppColors.fontColor, 1)
                                                          : chatController.GroupDeliveredMessageinfo[index].updatedAt!.toLocal().difference(DateTime.now()).inDays == 1 || chatController.GroupDeliveredMessageinfo[index].updatedAt!.toLocal().difference(DateTime.now()).inDays == -1
                                                              ? getCustomFont("yesterday , ", 15, AppColors.fontColor, 1)
                                                              : getCustomFont(Moment(chatController.GroupDeliveredMessageinfo[index].updatedAt!.toLocal()).format("DD-MM-YYYY , ").toString(), 15, AppColors.fontColor, 1),
                                                      getCustomFont(DateFormat().add_jmv().format(chatController.GroupDeliveredMessageinfo[index].updatedAt!.toLocal()), 15, AppColors.fontColor, 1),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        height: 1.0,
                                      ),
                                      SizedBox(height: 10)
                                    ],
                                  );
                                });
                          }),
                        )
                      ],
                    )
                  ],
                )
              : Column(
                  children: [
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: AppColors.getFontColor(context),
                                size: 15,
                              ),
                            )),
                        Text(
                          "Message Info",
                          style: TextStyle(color: AppColors.fontColor, fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.transparent,
                          size: 15,
                        )
                      ],
                    ),
                    const Divider(
                      height: 1.0,
                    ),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: const Radius.circular(15), topLeft: const Radius.circular(15), bottomRight: Radius.circular(0), bottomLeft: Radius.circular(15)), color: AppColors.colorD4DFFF),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data.mediaType == 1
                                  ? "Image"
                                  : data.mediaType == 2
                                      ? "Video"
                                      : data.mediaType == 3
                                          ? "Audio"
                                          : data.mediaType == 4
                                              ? "Document"
                                              : data.mediaType == 5
                                                  ? "Contact"
                                                  : data.mediaType == 6
                                                      ? "Location"
                                                      : data.message ?? "",
                              style: TextStyle(color: AppColors.color1F222A, fontWeight: FontWeight.w400, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        data.deliveryType == 0
                            ? Container()
                            : data.deliveryType == 1
                                ? SizedBox(height: 15, child: Image.asset("assets/images/singletick.png"))
                                : SizedBox(
                                    height: 15,
                                    child: Image.asset(
                                      "assets/images/doubletick.png",
                                      color: data.deliveryType == 3 ? AppColors.greenColor : AppColors.grayColor,
                                    )),
                        const SizedBox(width: 5),
                        Text(
                          DateFormat().add_jmv().format(data.createdAt!),
                          style: TextStyle(color: AppColors.subFontColor),
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: const Radius.circular(5), topLeft: const Radius.circular(5), bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5)), color: AppColors.colorD4DFFF),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            height: 15,
                                            child: Image.asset(
                                              "assets/images/doubletick.png",
                                              color: AppColors.greenColor,
                                            )),
                                        SizedBox(width: 10),
                                        getCustomFont("Read", 15, AppColors.fontColor, 1)
                                      ],
                                    ),
                                    data.updatedAt != null && data.deliveryType == 3
                                        ? Row(
                                            children: [
                                              data.updatedAt!.toLocal().difference(DateTime.now()).inDays == 0
                                                  ? getCustomFont("Today , ", 15, AppColors.fontColor, 1)
                                                  : data.updatedAt!.toLocal().difference(DateTime.now()).inDays == 1 || data.updatedAt!.toLocal().difference(DateTime.now()).inDays == -1
                                                      ? getCustomFont("Yesterday , ", 15, AppColors.fontColor, 1)
                                                      : getCustomFont(Moment(data.updatedAt!.toLocal()).format("DD-MM-YYYY , ").toString(), 15, AppColors.fontColor, 1),
                                              getCustomFont(DateFormat().add_jmv().format(data.updatedAt!.toLocal()), 15, AppColors.fontColor, 1),
                                            ],
                                          )
                                        : getCustomFont("-", 15, AppColors.fontColor, 1),
                                    SizedBox(height: 5),
                                    Divider(
                                      height: 1.0,
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        SizedBox(
                                            height: 15,
                                            child: Image.asset(
                                              "assets/images/doubletick.png",
                                              color: AppColors.grayColor,
                                            )),
                                        SizedBox(width: 10),
                                        getCustomFont("Delivered", 15, AppColors.fontColor, 1)
                                      ],
                                    ),
                                    data.createdAt != null && data.deliveryType == 2 || data.createdAt != null && data.deliveryType == 3
                                        ? Row(
                                            children: [
                                              data.createdAt!.toLocal().difference(DateTime.now()).inDays == 0
                                                  ? getCustomFont("Today , ", 15, AppColors.fontColor, 1)
                                                  : data.createdAt!.toLocal().difference(DateTime.now()).inDays == 1 || data.createdAt!.toLocal().difference(DateTime.now()).inDays == -1
                                                      ? getCustomFont("yesterday , ", 15, AppColors.fontColor, 1)
                                                      : getCustomFont(Moment(data.createdAt!.toLocal()).format("DD-MM-YYYY , ").toString(), 15, AppColors.fontColor, 1),
                                              getCustomFont(DateFormat().add_jmv().format(data.createdAt!), 15, AppColors.fontColor, 1),
                                            ],
                                          )
                                        : getCustomFont("-", 15, AppColors.fontColor, 1),
                                  ],
                                ))),
                      ),
                    )
                  ],
                ),
        );
      },
    );
  }

  getEmptyImage(String name) {
    return Container(height: 38, width: 38, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle), child: getCustomFont(name.length < 1 ? "" : name.substring(0, 1) ?? "", 12, AppColors.getSubFontColor(context), 1, fontWeight: FontWeight.w400));
  }

  contact_Details(data, number) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Column(
            children: [
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: themeController.isDarkMode ? AppColors.colorBlack : AppColors.getFontColor(context),
                          size: 15,
                        ),
                      )),
                  Text(
                    "Contact Details",
                    style: TextStyle(color: AppColors.fontColor, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.transparent,
                    size: 15,
                  )
                ],
              ),
              const Divider(
                height: 1.0,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.10, 20, MediaQuery.of(context).size.width * 0.10, 20),
                color: AppColors.subCardColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.10,
                      width: MediaQuery.of(context).size.width * 0.10,
                      child: CircleAvatar(radius: 50, backgroundColor: AppColors.darkPrimaryColor, child: getCustomFont(data.length < 1 ? "" : data.split(",")[0].substring(0, 1) ?? "", 12, AppColors.colorFFFFFF, 1, fontWeight: FontWeight.w400)),
                    ),
                    Column(
                      children: [
                        Text(
                          data,
                          style: TextStyle(color: AppColors.fontColor, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          number,
                          style: TextStyle(color: AppColors.fontColor, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    GestureDetector(
                        onTap: () async {
                          var newPerson = Contact();
                          newPerson.givenName = 'FreeZone';
                          newPerson.phones = [Item(label: "mobile", value: '01752591591')];
                          // await ContactsService.getContactsForPhone("01752591591");
                          //
                          await ContactsService.openContactForm().then((contact) async {
                            print("fgfg==$contact");

                            isLoading.value = true;

                            //todo : pass contact image url : 05-02-2024-9:25

                            await dashboardController.getAllContact();
                            isLoading.value = false;
                            controller.update();
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: AppColors.darkPrimaryColor),
                            child: size.Padding(
                              padding: const EdgeInsets.fromLTRB(13, 5, 13, 5),
                              child: Text(
                                "Add",
                                style: TextStyle(color: AppColors.colorFFFFFF, fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                            ))),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool checkGalleryPath(path) {
    File(path).exists().then((value) {
      return true;
    });
    return false;
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
                  "Do you really want to ${controller.sideBarData?.isGroup == 0 ? "delete these chat" : controller.sideBarData?.isAdmin == 1 || controller.sideBarData?.ismember == 0 ? "Delete group" : "leave group"} ? This process cannot be undone.",
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
                          if (controller.sideBarData?.ismember == 0 && controller.sideBarData?.isGroup == 1) {
                            chatController.DeleteConverstion(controller.sideBarData!.isGroup, controller.sideBarData!.sId);
                          } else if (controller.sideBarData?.isGroup == 1) {
                            newSocketController.leaveGroup(controller.sideBarData?.sId);
                          } else {
                            newSocketController.deleteConversation(controller.sideBarData!.isGroup, controller.sideBarData!.sId);
                            chatController.DeleteConverstion(controller.sideBarData!.isGroup, controller.sideBarData!.sId);
                          }
                          ;
                          Get.back();
                          Get.back();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.callEndColor,
                          ),
                          child: Center(
                              child: Text(
                            controller.sideBarData?.ismember == 1 || controller.sideBarData?.ismember == null && controller.sideBarData?.isGroup == 1 ? "Leave" : "Delete",
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

  blockDailog() {
    print("block1111111 ${chatController.GetIsBlock(controller.sideBarData!.sId)}");
    showDialog(
        context: context,
        barrierDismissible: false,
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
                  chatController.Isblock.value == "0" ? "You can't send message to ${controller.sideBarData!.name} if you block" : " Unblock ${controller.sideBarData!.name} to send a message.",
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
                          FocusManager.instance.primaryFocus?.unfocus();
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
                          newSocketController.sendBlock(chatController.Isblock.value == "1" ? 0 : 1, controller.sideBarData!.sId);

                          Get.back();
                          chatController.isLoderoverFullScreen.value = true;
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.primaryColor,
                          ),
                          child: Center(
                              child: Text(
                            chatController.Isblock.value == "1" ? "Unblock" : "Block",
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

  clearDailog() {
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
                  "Are you sure?",
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
                          chatController.clearChat(controller.sideBarData!.isGroup, controller.sideBarData!.sId);
                          getMessageData(i: true);

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
                            "Clear Chat",
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

  DeleteDailog(id) async {
    print(" delete message id $id");
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            // insetPadding: EdgeInsets.symmetric(horizontal: 25),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Delete",
                      style: TextStyle(color: AppColors.hintColor, fontSize: 20, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Are you sure you want to delete this message?",
                    style: TextStyle(color: AppColors.hintColor, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  isSenderr.value
                      ? Row(
                          children: [
                            Obx(
                              () => Checkbox(
                                activeColor: AppColors.primaryColor,
                                value: isdelete.value,
                                onChanged: (bool? value) {
                                  isdelete.value = value!;
                                  print("=====${isdelete.value}");
                                },
                              ),
                            ),
                            getCustomFont("Also delete for  ${controller.sideBarData?.isGroup == 1 ? "Everyone" : controller.sideBarData!.name}", 13, AppColors.hintColor, 2)
                          ],
                        )
                      : Container(),
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
                            newSocketController.deleteSingleMessage(controller.sideBarData?.isGroup == 0 || controller.sideBarData?.isGroup == null ? 0 : 1, id, controller.sideBarData?.isGroup == 1 ? null : controller.sideBarData?.sId, isdelete.value ? 2 : 1, controller.sideBarData?.isGroup == 1 ? controller.sideBarData?.sId : null);
                            isdelete.value = false;
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
                              "Delete",
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
            selectChatModel.value.message ?? "",
            style: TextStyle(color: AppColors.fontColor),
          )),
          InkWell(
              onTap: () {
                selectChatModel.value = ChatDataModel();
                isReply.value = false;
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectChatModel.value.senderId != controller.sideBarData?.sId ? "You" : (selectChatModel.value.originalName ?? ""),
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
                                  Expanded(
                                    child: Text(
                                      ((selectChatModel.value.filePath?.isNotEmpty ?? false) ? (selectChatModel.value.filePath?.split("/").last ?? "") : (selectChatModel.value.message?.split("/").last ?? "UnKnow")),
                                      style: TextStyle(fontSize: 14, color: AppColors.colorA2A6AE, fontWeight: FontWeight.w400),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  FutureBuilder(
                                    future: getFileSize((selectChatModel.value.filePath ?? ""), 1),
                                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshots) {
                                      return Text(
                                        snapshots.data ?? "",
                                        style: TextStyle(fontSize: 14, color: AppColors.primaryColor, fontWeight: FontWeight.w400),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // const Spacer(),
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
                                    selectChatModel.value = ChatDataModel();
                                    isReply.value = false;
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
            // const SizedBox(height: 9),
            // Text(
            //   "Hi, Jimmy! Any update today?",
            //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.fontColor),
            // )
          ],
        ));
  }

  Future<void> init() async {
    if (controller.sideBarData == null) {
      return;
    }
    await newSocketController.init(controller.sideBarData!.sId ?? '', controller.sideBarData!, () {
      getMessageData(i: true);
    });
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
                              selectChatModel.value.senderId != controller.sideBarData?.sId ? "You" : (selectChatModel.value.originalName ?? ""),
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
                                const SizedBox(width: 4),
                                FutureBuilder(
                                  future: getFileSize((selectChatModel.value.filePath ?? ""), 1),
                                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshots) {
                                    return Text(
                                      snapshots.data ?? "",
                                      style: TextStyle(fontSize: 14, color: AppColors.primaryColor, fontWeight: FontWeight.w400),
                                    );
                                  },
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
                                    selectChatModel.value = ChatDataModel();
                                    isReply.value = false;
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
                              selectChatModel.value.senderId != controller.sideBarData?.sId ? "You" : (selectChatModel.value.originalName ?? ""),
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
                            child: ClipRRect(borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)), child: LocalNetworkMedia().getMedia(url: getThambNelFormUrl((selectChatModel.value.message ?? "")), imageFit: BoxFit.contain)),
                          ),
                          Positioned(
                              top: 5,
                              right: 2,
                              child: InkWell(
                                  onTap: () {
                                    selectChatModel.value = ChatDataModel();
                                    isReply.value = false;
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
            // Text(
            //   "Hi, Jimmy! Any update today?",
            //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.fontColor),
            // )
          ],
        ));
  }

  videoReplyView() {
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
                              selectChatModel.value.senderId != controller.sideBarData?.sId ? "You" : (selectChatModel.value.originalName ?? ""),
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
                                  "Video",
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
                              child: LocalNetworkMedia().getMedia(url: getThambNelFormUrl("$mainUrl${selectChatModel.value.message}"), imageFit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                              top: 5,
                              right: 2,
                              child: InkWell(
                                  onTap: () {
                                    selectChatModel.value = ChatDataModel();
                                    isReply.value = false;
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
            // Text(
            //   "Hi, Jimmy! Any update today?",
            //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.fontColor),
            // )
          ],
        ));
  }

  getFileSize(String filepath, int decimals, {String? url}) async {
    if (filepath.isEmpty) {
      filepath = await ChatController().downloadImage(url: url) ?? "";
    }

    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
  }

  copyMSG(msg) async {
    print("message $msg");
    await Clipboard.setData(ClipboardData(text: msg.toString()));
    Fluttertoast.showToast(
      msg: "Text copied successfully",
    );
  }

  final _audioRecorder = Record();
  Stream<int>? timerStream;
  bool isAudioTimer = false;
  String minutesStr = '00';
  String secondsStr = '00';
  StreamSubscription<int>? timerSubscription;
  Uri? uri;
  RxBool isAudio = false.obs;
  bool _isRecording = false;
  Future<void> _stopAudio(value) async {
    print("Audio Stop $_isRecording");
    if (_isRecording) {
      // final path = await
      _audioRecorder.stop().then((path) async {
        uri = Uri.parse(path!);
        // At Recording Stop :
        isAudio.value = false;
        timerSubscription!.cancel();
        timerStream = null;
        setState(() {
          minutesStr = '00';
          secondsStr = '00';
        });
        updateAudio(false, minutesStr, secondsStr);

        setState(() => _isRecording = false);
        setState(() => isAudioTimer = false);

        // Stop the previously playing audio
        // print("currentlyPlaying $currentlyPlaying");
        // if (currentlyPlaying != null) {
        //   await currentlyPlaying!.stop();
        // }
        // print("currentlyPlaying $currentlyPlaying");

        // Play the recorded audio
        // int result = await _audioPlayer.play(path!, isLocal: true);
        //
        // if (result == 1) {
        //   currentlyPlaying =
        //       _audioPlayer; // Update the currently playing reference
        // }

        if (value) {
          if (uri!.path.isNotEmpty) {
            setState(() async {
              bool isGroup = controller.sideBarData?.isGroup == 1;
              UserDetails userDetails = await getUserData();
              var id = (Random().nextInt(900000000) + 100000000).toString();
              String? m1 = lookupMimeType(uri!.path)?.split("/")[0];
              String? m2 = lookupMimeType(uri!.path.toString())?.split("/")[1];
              chatController.insertData(id, isGroup ? 1 : 0, controller.sideBarData!.sId, controller.chatController.text, null, 0, 3, selectChatModel.value.id, null, uri!.path.toString(), null, () async {
                getMessageData(i: true);
              }, firstName: userDetails.firstName ?? "", lastName: userDetails.lastName ?? "");

              chatController.uploadMultimediaApiCall(uri!.path.toString(), uri!.path.toString(), m1, m2, (data) async {
                print("file path== ${data}==========  typesss ${lookupMimeType(data["url"])?.split("/")[0]}");

                chatController.updateData(id, isGroup ? 1 : 0, controller.sideBarData!.sId, data["url"], null, 0, 3, selectChatModel.value.id, null, uri!.path.toString(), () async {
                  getMessageData(i: true);
                }, firstName: userDetails.firstName ?? "", lastName: userDetails.lastName ?? "");
                newSocketController.send_message(id, isGroup ? 1 : 0, controller.sideBarData!.sId, data["url"], isGroup ? controller.sideBarData!.sId : null, 0, 3, selectChatModel.value.id, null, uri!.path.toString(), null, () async {
                  getMessageData(i: true);
                }, firstName: userDetails.firstName ?? "", lastName: userDetails.lastName ?? "");
              });
            });
          }
        }
      });
      // recordingFinishedCallback(path!);
    }
  }

  Future<void> _startAudio() async {
    print("Audio Start");
    try {
      if (await _audioRecorder.hasPermission()) {
        isAudio.value = true;
        await _audioRecorder.start();

        // bool isRecording =
        await _audioRecorder.isRecording().then((value) {
          print('_audioRecorder $value');

          if (value) {
            setState(() {
              _isRecording = value;
            });

            // At Recording Start:

            timerStream = stopWatchStream();
            updateAudio(true, minutesStr, secondsStr);

            timerSubscription = timerStream!.listen((int newTick) {
              setState(() {
                minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
                secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
              });
            });
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  updateAudio(value, min, sec) {
    isAudioTimer = value;
    minutesStr = min;
    secondsStr = sec;
    setState(() {});
  }

  Stream<int> stopWatchStream() {
    StreamController<int>? streamController;
    Timer? timer;
    Duration timerInterval = const Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer!.cancel();
        timer = null;
        counter = 0;
        streamController!.close();
      }
    }

    void tick(_) {
      counter++;
      streamController!.add(counter);
    }

    void startTimerAudio() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimerAudio,
      onCancel: stopTimer,
      onResume: startTimerAudio,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  RxString chatText = "".obs;
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
                              (selectChatModel.value.id?.isNotEmpty ?? false)
                                  ? selectChatModel.value.mediaType == 4
                                      ? docView()
                                      : (selectChatModel.value.mediaType == 1)
                                          ? imageReplyView()
                                          : (selectChatModel.value.mediaType == 2)
                                              ? videoReplyView()
                                              : (selectChatModel.value.mediaType == 3)
                                                  ? voiceReplyView()
                                                  : textReplyView()
                                  : const SizedBox(),
                              StreamBuilder(
                                  stream: isAudio.stream,
                                  builder: (context, snapshot) {
                                    return isAudio.value
                                        ? SizedBox(
                                            height: 60,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 20),
                                                CustomImageView(svgPath: 'mute.svg', onTap: null, height: 25, color: AppColors.callEndColor),
                                                const SizedBox(width: 10),
                                                Text(
                                                  '$minutesStr:$secondsStr',
                                                  style: TextStyle(fontSize: 15, color: AppColors.getFontColor(context)),
                                                ),
                                                const Spacer(),
                                                InkWell(
                                                  onTap: () {
                                                    _stopAudio(false);
                                                  },
                                                  child: Text(
                                                    "slide to cancel",
                                                    style: TextStyle(fontSize: 13, color: AppColors.getFontColor(context)),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                const Icon(Icons.arrow_forward_ios, size: 13),
                                                const SizedBox(width: 20),
                                                InkWell(
                                                  onTap: () {
                                                    _stopAudio(true);
                                                  },
                                                  child: Container(height: 40, width: 40, padding: const EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.primaryColor), child: CustomImageView(svgPath: 'sendicon.svg', onTap: null, height: 17)),
                                                ),
                                                // CustomImageView(
                                                //     svgPath: 'sendicon.svg',
                                                //     onTap: () {
                                                //       _stopAudio(true);
                                                //     },
                                                //     height: 25,
                                                //     color: themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor),
                                                const SizedBox(width: 12)
                                              ],
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 10,
                                            ),
                                            child: CustomTextField(
                                              showCursor: false,
                                              height: 50,
                                              controller: controller.chatController,
                                              hintText: S.of(context).typeYourMessage,
                                              hintTextColor: AppColors.hintColor,
                                              onTap: () {
                                                chatController.GetIsBlock(controller.sideBarData!.sId);
                                                if (chatController.Isblock.value == "1") {
                                                  blockDailog();
                                                }
                                                // scrollUp();
                                                //  setState(() {});
                                              },
                                              onChanged: (value) {
                                                chatController.GetIsBlock(controller.sideBarData!.sId);
                                                if (chatController.Isblock.value == "1") {
                                                  blockDailog();
                                                }
                                                chatText.value = value;
                                                newSocketController.typing(controller.sideBarData!.sId as String);
                                                // setState(() {});

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
                                              textColor: AppColors.colorBlack,
                                              suffixIcon: StreamBuilder(
                                                  stream: chatText.stream,
                                                  builder: (context, snapshot) {
                                                    return chatText.value.isEmpty
                                                        ? Padding(
                                                            padding: const EdgeInsets.all(8),
                                                            child: GestureDetector(
                                                              onTap: _startAudio,
                                                              child: CustomImageView(svgPath: 'mute.svg', onTap: _startAudio, height: 25, color: AppColors.subFontColor),
                                                            ),
                                                          )
                                                        : Padding(
                                                            padding: const EdgeInsets.all(5),
                                                            child: GestureDetector(
                                                              onTap: () async {
                                                                var id = (Random().nextInt(900000000) + 100000000).toString();
                                                                bool isGroup = controller.sideBarData?.isGroup == 1;
                                                                UserDetails userDetails = await getUserData();
                                                                if (chatController.isEdit.value) {
                                                                  newSocketController.sendEditMessage(isGroup ? 1 : 0, chatController.MessageID.value, isGroup ? controller.sideBarData?.sId ?? "" : null, controller.chatController.text, isGroup ? null : controller.sideBarData?.sId);
                                                                  getMessageData(i: true);
                                                                  chatController.isEdit.value = false;
                                                                  selectChatModel.value = ChatDataModel();
                                                                  controller.chatController.clear();
                                                                  chatText.value = "";
                                                                } else {
                                                                  if (controller.chatController.text.trim().length > 0) {
                                                                    print(" ${controller.sideBarData!.sId}   === reply message iD   ${selectChatModel.value.MSG_ID}");

                                                                    newSocketController.send_message(id, isGroup ? 1 : 0, controller.sideBarData!.sId, controller.chatController.text.trim(), isGroup ? controller.sideBarData!.sId : null, (selectChatModel.value.MSG_ID?.isEmpty ?? true) ? 0 : 1, 0, selectChatModel.value.MSG_ID == null ? selectChatModel.value.id : selectChatModel.value.MSG_ID, null, "", "", () async {
                                                                      getMessageData(i: true);
                                                                    }, firstName: userDetails.firstName ?? "", lastName: userDetails.lastName ?? "");
                                                                  }
                                                                  chatController.isEdit.value = false;
                                                                  selectChatModel.value = ChatDataModel();
                                                                  controller.chatController.clear();
                                                                  chatText.value = "";
                                                                }

                                                                isReply.value = false;
                                                                _scrollDown();
                                                              },
                                                              child: Container(
                                                                  // height: 45,
                                                                  //   width: 45,
                                                                  padding: const EdgeInsets.all(5),
                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.primaryColor),
                                                                  child: CustomImageView(svgPath: 'sendicon.svg', onTap: null, height: 17)),
                                                            ),
                                                          );
                                                  }),

                                              // prefixIcon: Padding(
                                              //   padding: const EdgeInsets.all(8),
                                              //   child: CustomImageView(svgPath: 'other_otion_image.svg', onTap: null, height: 25.h),
                                              // ),
                                              prefixIcon: DropdownButton2(
                                                underline: SizedBox(),
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
                                                  print("=========>>>${value}");
                                                  if (value?.text == MenuItems.camera.text) {
                                                    getFromCamera();
                                                  } else if (value?.text == MenuItems.document.text) {
                                                    getFromGallery();
                                                  } else if (value?.text == MenuItems.photosAndVideos.text) {
                                                    getFromVideoImage();
                                                  } else if (value?.text == MenuItems.location.text) {
                                                    _getCurrentPosition();
                                                  } else if (value?.text == MenuItems.contact.text) {
                                                    // Get.to(() => const ForwardContactScreenScreen(
                                                    //       isShare: true,
                                                    //     ));

                                                    chatController.getContactdetails.value = true;
                                                    Get.to(ShareContact(sideBarData: widget!.sideBarData));
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
                                            ).marginSymmetric(horizontal: 16),
                                          );
                                  }),
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
    // bool isGroup = controller.sideBarData?.isGroup == 1;
    // UserDetails userDetails = await getUserData();
    // var id = (Random().nextInt(900000000) + 100000000).toString();
    XFile? image = await imagePicker.ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      cameraImage = File(image.path ?? "");

      Future.delayed(const Duration(milliseconds: 100), () {
        Get.to(() => ImageTextSendScreen(
              sendFileList: [(cameraImage ?? File(""))],
            ));
      });
    }
  }

  List<File>? galleryImage;

  getFromGallery() async {
    bool isGroup = controller.sideBarData?.isGroup == 1;
    UserDetails userDetails = await getUserData();
    var id = (Random().nextInt(900000000) + 100000000).toString();
    List<XFile>? image = await imagePicker.ImagePicker().pickMultipleMedia();
    image.forEach((element) {
      String? m1 = lookupMimeType(element.path.toString())?.split("/")[0];
      String? m2 = lookupMimeType(element.path.toString())?.split("/")[1];
      chatController.insertData(id, isGroup ? 1 : 0, controller.sideBarData!.sId, controller.chatController.text, null, 0, 4, selectChatModel.value.id, null, element.path.toString(), null, () async {
        getMessageData(i: true);
      }, firstName: userDetails.firstName ?? "", lastName: userDetails.lastName ?? "");
      chatController.uploadMultimediaApiCall(element.path.toString(), element.path.toString(), m1, m2, (data) async {
        print("file path== ${data}==========  typesss ${lookupMimeType(data["originalName"])?.split("/")[0]}");
        //  if (lookupMimeType(data["originalName"])?.split("/")[0] == "image") {
        chatController.updateData(id, isGroup ? 1 : 0, controller.sideBarData!.sId, data["url"], null, 0, 4, selectChatModel.value.id, null, element.path.toString(), () async {
          getMessageData(i: true);
        }, firstName: userDetails.firstName ?? "", lastName: userDetails.lastName ?? "");
        newSocketController.send_message(id, isGroup ? 1 : 0, controller.sideBarData!.sId, data["url"], isGroup ? controller.sideBarData!.sId : null, 0, 4, selectChatModel.value.id, null, element.path.toString(), null, () async {
          getMessageData(i: true);
        }, firstName: userDetails.firstName ?? "", lastName: userDetails.lastName ?? "");
        //  }
      });
      galleryImageVideo?.add(File(element.path ?? ""));
      galleryImage?.add(File(element.path));
      selectChatModel.value = ChatDataModel();
    });
  }

  List<File>? galleryImageVideo;

  getFromVideoImage() async {
    var image = await FilePicker.platform.pickFiles(type: FileType.custom, allowMultiple: true, allowedExtensions: ["JPEG", "JPG", "gif", "jpg ", "jpeg ", "avif", "mp4", "mov", "avi", "png", "bmp", 'webp', 'svg', "PNG"]);
    // var image = await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: true);
    bool isGroup = controller.sideBarData?.isGroup == 1;
    UserDetails userDetails = await getUserData();
    var id = (Random().nextInt(900000000) + 100000000).toString();
    image?.files.forEach((element) {
      print("element == ${element} ");
      String? m1 = lookupMimeType(element.path.toString())?.split("/")[0];
      String? m2 = lookupMimeType(element.path.toString())?.split("/")[1];

      if (lookupMimeType(element.path.toString().split("/").last)?.split("/")[0] == "image") {
        chatController.insertData(id, isGroup ? 1 : 0, controller.sideBarData!.sId, controller.chatController.text, null, 0, 1, selectChatModel.value.id, null, element.path.toString(), null, () async {
          getMessageData(i: true);
        }, firstName: userDetails.firstName ?? "", lastName: userDetails.lastName ?? "");
      } else {
        chatController.insertData(id, isGroup ? 1 : 0, controller.sideBarData!.sId, controller.chatController.text, null, 0, 2, selectChatModel.value.id, null, element.path.toString(), null, () async {
          getMessageData(i: true);
        }, firstName: userDetails.firstName ?? "", lastName: userDetails.lastName ?? "");
      }
      chatController.uploadMultimediaApiCall(element.path.toString(), element.path.toString(), m1, m2, (data) async {
        if (lookupMimeType(element.path.toString().split("/").last)?.split("/")[0] == "image") {
          chatController.updateData(id, isGroup ? 1 : 0, controller.sideBarData!.sId, data["url"], null, 0, 1, selectChatModel.value.id, null, element.path.toString(), () async {
            getMessageData(i: true);
          }, firstName: userDetails.firstName ?? "", lastName: userDetails.lastName ?? "");
        } else {
          print("file path== ${data}==========  typesss ${lookupMimeType(data["originalName"])?.split("/")[0]}");
          chatController.updateData(id, isGroup ? 1 : 0, controller.sideBarData!.sId, data["url"], null, 0, 2, selectChatModel.value.id, null, element.path.toString(), () async {
            getMessageData(i: true);
          }, firstName: userDetails.firstName ?? "", lastName: userDetails.lastName ?? "");
        }
        if (lookupMimeType(data["originalName"])?.split("/")[0] == "image") {
          newSocketController.send_message(id, isGroup ? 1 : 0, controller.sideBarData!.sId, data["url"], isGroup ? controller.sideBarData!.sId : null, 0, 1, selectChatModel.value.id, null, element.path.toString(), null, () async {
            getMessageData(i: true);
          }, firstName: userDetails.firstName ?? "", lastName: userDetails.lastName ?? "");
        } else {
          newSocketController.send_message(id, isGroup ? 1 : 0, controller.sideBarData!.sId, data["url"], isGroup ? controller.sideBarData!.sId : null, 0, 2, selectChatModel.value.id, null, element.path.toString(), null, () async {
            getMessageData(i: true);
          }, firstName: userDetails.firstName ?? "", lastName: userDetails.lastName ?? "");
        }
      });
      selectChatModel.value = ChatDataModel();
      galleryImageVideo?.add(File(element.path ?? ""));
    });

    print(" video file   $galleryImageVideo");
  }

  String getThambNelFormUrl(Url) {
    //thumbnails__
    String urlList = Url.split("/").last;
    String LastString = urlList.split(".").first;
    // urlList.remove(urlList.last);
    String imageName = "thumbnails__${LastString}.png";
    return Url.replaceAll(urlList, imageName);
  }

  void scrollUp() {
    print("new message controller scroll");
    final position = controller.scrollController.position.maxScrollExtent + 40;
    controller.scrollController.jumpTo(position);
    setState(() {});
  }
}

class ChatModel {
  String? title;
  String? time;
  bool? isVoise;
  String? recodeTime;
  String? image;
  bool? isOtherUser;
  bool? isReply;

  ChatModel({this.title, this.image, this.isVoise, this.recodeTime, this.time, this.isOtherUser, this.isReply});
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
        print("----");
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
  static const List<MenuItem> firstItems = [Reply, Forward, Share, Copy, Edit, info, Delete];
  static const List<MenuItem> MultiItems = [Reply, Forward, Share, info, Delete];
  static const List<MenuItem> MultiItems_Sender = [Reply, Forward, Share, info, Delete];
  static const List<MenuItem> receiver = [Reply, Forward, Share, Copy, Delete];
  static const List<MenuItem> forwarded = [Reply, Forward, Share, Copy, info, Delete];

  static const Reply = MenuItem(text: 'Reply', icon: "replyImage.svg");
  static const Forward = MenuItem(text: 'Forward', icon: "forwordimage.svg");
  static const Share = MenuItem(text: 'Share', icon: "shareimage.svg");
  static const Copy = MenuItem(text: 'Copy message', icon: "copyimage.svg");
  static const Edit = MenuItem(text: 'Edit message', icon: "editmessageimage.svg");
  static const info = MenuItem(text: 'Info', icon: "info.svg");
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

enum Media {
  ///
  file,

  ///
  buffer,

  ///
  asset,

  ///
  stream,

  ///
  remoteExampleFile,
}

Future<void> shareFile(filepath, title) async {
  if (filepath == null) {
    Share.share(title);
  } else {
    Share.shareXFiles([XFile(filepath)]);
  }
}

class LocalNetworkMedia {
  RxBool imageRefresh = false.obs;
  File? file;

  Widget getMedia({
    double? height,
    double? width,
    borderRadius,
    title,
    colorFilter,
    BoxFit? imageFit,
    decoration,
    errorImage,
    maxHeightDiskCache,
    maxWidthDiskCache,
    color,
    reGet = 0,
    isShowProgressIndicator = false,
    String? url,
    String? id,
  }) {
    ChatController().downloadImage(url: url).then((value) {
      print(" url given $value");
      String path = (value ?? "");
      file = File(path);
      imageRefresh.value = true;
    });

    return StreamBuilder(
        stream: imageRefresh.stream,
        builder: (context, snapshot) {
          if (imageRefresh.value) {
            if (file != null) {
              print(" url given 333 $file");
              return
                  // Container(
                  // constraints: BoxConstraints(minHeight: 197, minWidth: 240),
                  //child:
                  ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  file!,
                  height: height,
                  fit: imageFit,
                  color: color,
                  errorBuilder: (context, error, stackTrace) {
                    file?.exists().then((value) {
                      // print(" url given 333 $value");

                      if (value) {
                        file?.delete().then((value) {
                          /*LocalStorageController().downloadImage(url: url, id: id, title: title).then((value) {
                              file = value;
                              imageRefresh.value = true;
                            });*/
                        });
                      }
                    });

                    return SizedBox(
                        width: width ?? double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: errorImage ?? const SizedBox(),
                        ));
                  },
                ),
              );
              //  );
            } else {
              if (reGet > 15) {
                // lstImage[url] = null;
                reGet++;
                return getMedia(url: url, id: id, height: height, width: width, borderRadius: borderRadius, colorFilter: colorFilter, imageFit: imageFit, decoration: decoration, errorImage: errorImage, color: color, reGet: reGet, isShowProgressIndicator: isShowProgressIndicator);
              }
              return SizedBox(
                  width: width ?? double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: errorImage ?? const SizedBox(),
                  ));
            }
          }
          return isShowProgressIndicator
              ? Container(
                  height: height ?? 250,
                  width: width,
                  alignment: Alignment.center,
                  child: const SizedBox(),
                )
              : Shimmer.fromColors(
                  baseColor: Colors.black38,
                  highlightColor: Colors.black12,
                  child: Container(
                    height: height ?? 100,
                    width: width,
                    decoration: decoration != null
                        ? decoration?.copyWith(color: Colors.white24)
                        : BoxDecoration(
                            color: Colors.white24,
                            borderRadius: borderRadius ?? BorderRadius.circular(0),
                            // shape: BoxShape.circle,
                          ),
                  ),
                );
        });
  }

  Future<Size> getImageHeightWidth({String? url}) async {
    String? value = "";
    value = await ChatController().downloadImage(url: url);

    file = File(value ?? "");
    imageRefresh.value = true;
    final size = await ImageSizeGetter.getSize(FileInput(file ?? File("")));
    if (size.needRotate) {
      final width = size.height;
      final height = size.width;
      print('width = $width, height = $height');
    } else {
      print('width = ${size.width}, height = ${size.height}');
    }
    return size;
  }
}

Future<Duration> getAudioDuration(file) async {
  var player = getTimeAudio.AudioPlayer();
  var duration = await player.setUrl(file);
  return duration ?? const Duration();
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;
  final bool isLast;

  const ChatBubble({
    Key? key,
    required this.text,
    this.isSender = false,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isSender) const Spacer(),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: isSender ? const Color(0xFF276bfd) : const Color(0xFF343145)),
                padding: const EdgeInsets.only(bottom: 9, top: 8, left: 14, right: 12),
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WaveBubble extends StatefulWidget {
  final bool isSender;
  final int? index;
  final String? path;
  final double? width;

  const WaveBubble({
    Key? key,
    this.width,
    this.index,
    this.isSender = false,
    this.path,
  }) : super(key: key);

  @override
  State<WaveBubble> createState() => _WaveBubbleState();
}

class _WaveBubbleState extends State<WaveBubble> {
  File? file;

  late PlayerController controller;
  late StreamSubscription<PlayerState> playerStateSubscription;

  final playerWaveStyle = PlayerWaveStyle(fixedWaveColor: AppColors.primaryColor.withOpacity(0.2), liveWaveColor: AppColors.primaryColor, spacing: 6, seekLineColor: AppColors.primaryColor, showSeekLine: false);

  @override
  void initState() {
    super.initState();

    controller = PlayerController();
    _preparePlayer();
    playerStateSubscription = controller.onPlayerStateChanged.listen((_) {
      setState(() {});
    });
  }

  void _preparePlayer() async {
    // Opening file from assets folder

    if (widget.index == null && widget.path == null && file?.path == null) {
      return;
    }
    // Prepare player with extracting waveform if index is even.
    controller.preparePlayer(
      path: widget.path ?? file!.path,
      shouldExtractWaveform: widget.index?.isEven ?? true,
    );
    // Extracting waveform separately if index is odd.
    if (widget.index?.isOdd ?? false) {
      controller
          .extractWaveformData(
            path: widget.path ?? file!.path,
            noOfSamples: playerWaveStyle.getSamplesForWidth(widget.width ?? 200),
          )
          .then((waveformData) => debugPrint(waveformData.toString()));
    }
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.path != null || file?.path != null
        ? size.Container(
            height: 50,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // if (!controller.playerState.isStopped)
                //   IconButton(
                //     onPressed: () async {
                //       controller.playerState.isPlaying
                //           ? await controller.pausePlayer()
                //           : await controller.startPlayer(
                //         finishMode: FinishMode.pause,
                //       );
                //     },
                //     icon: Icon(
                //       controller.playerState.isPlaying
                //           ? Icons.pause
                //           : Icons.play_arrow,
                //     ),
                //     color: Colors.white,
                //     splashColor: Colors.transparent,
                //     highlightColor: Colors.transparent,
                //   ),
                AudioFileWaveforms(
                  size: size.Size(MediaQuery.of(context).size.width / 4, 70),
                  playerController: controller,
                  waveformType: widget.index?.isOdd ?? false ? WaveformType.fitWidth : WaveformType.long,
                  playerWaveStyle: playerWaveStyle,
                ),
                const SizedBox(width: 4),
                controller.playerState.isPlaying
                    ? InkWell(
                        onTap: () async {
                          controller.playerState.isPlaying
                              ? await controller.pausePlayer()
                              : await controller.startPlayer(
                                  finishMode: FinishMode.pause,
                                );
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.primaryColor),
                          child: Icon(
                            Icons.pause,
                            color: AppColors.subCardColor,
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          controller.playerState.isPlaying
                              ? await controller.pausePlayer()
                              : await controller.startPlayer(
                                  finishMode: FinishMode.pause,
                                );
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.primaryColor),
                          child: Icon(
                            Icons.play_arrow,
                            color: AppColors.subCardColor,
                          ),
                        ),
                      ),
                // if (widget.isSender) const SizedBox(width: 10),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
