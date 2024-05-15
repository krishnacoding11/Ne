import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/main.dart';
import 'package:mime/mime.dart';
import '../../../../core/globals.dart';
import '../../../../model/enter_price_user_model.dart';
import '../../../controller/chat_controller.dart';
import '../../../controller/contact_controller.dart';
import '../../../controller/new_socket_controller.dart';
import '../../../widgets/globle.dart';
import '../../login/model/verify_model.dart';

class AddGCreateGroupNameScreen extends StatefulWidget {
  final RxList<UserData> contactsSearchList;
  final Function? backOnTap;
  final Function? nextOnTap;

  const AddGCreateGroupNameScreen({super.key, required this.contactsSearchList, this.backOnTap, this.nextOnTap});

  @override
  State<AddGCreateGroupNameScreen> createState() => _AddGCreateGroupNameScreenState();
}

class _AddGCreateGroupNameScreenState extends State<AddGCreateGroupNameScreen> {
  ChatController chatController = Get.find();
  NewSocketController newSocketController = Get.find();
  ContactController controller = Get.find();
  RxString groupName = "".obs;
  RxString filepath = "".obs;
  RxString url = "".obs;
  RxBool loading = false.obs;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  getImageFromGlarey() async {
    var image = await FilePicker.platform.pickFiles(type: FileType.custom, allowMultiple: true, allowedExtensions: ["jpg ", "jpeg ", "png"]);
    // var image = await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: true);
    loading.value = true;
    filepath.value = image!.files[0].path.toString();
    UserDetails userDetails = await getUserData();
    var id = (Random().nextInt(900000000) + 100000000).toString();
  }

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
            floatingActionButton: GestureDetector(
              // borderRadius: BorderRadius.circular(100),
              onTap: () {
                // if (commonSizeForDesktop(context)) {
                //   if (widget.nextOnTap != null) {
                //     widget.nextOnTap!();
                //   }
                // } else {
                if (filepath.value != "" && groupName.value != "") {
                  String? m1 = lookupMimeType(filepath.value)?.split("/")[0];
                  String? m2 = lookupMimeType(filepath.value)?.split("/")[1];
                  chatController.uploadMultimediaApiCall(filepath.value, filepath.value, m1, m2, (data) async {
                    print("file path== ${data}==========  typesss ${data["url"]}");
                    url.value = data["url"];
                    loading.value = false;
                    newSocketController.sendCreateGroup(groupName.value, null, data["url"], controller.groupuserIS.value);
                    Get.back();
                    Get.back();
                    Get.back();
                  });
                } else if (groupName.value != "") {
                  newSocketController.sendCreateGroup(groupName.value, null, null, controller.groupuserIS.value);
                  Get.back();
                  Get.back();
                  Get.back();
                } else {
                  Fluttertoast.showToast(
                    msg: "Please give group name ",
                  );
//}
                  // widget.backOnTap;
                  // Get.to(() => const MainGroupInfoScreen());
                }
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: AppColors.primaryColor,
                ),
                child: Center(
                    child: Icon(
                  Icons.check,
                  color: AppColors.subFont1,
                )),
              ),
            ),
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
                        "Create group",
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
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: commonSizeForLargDesktop(context) ? 900 : double.infinity,
                      height: MediaQuery.of(context).size.height,
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white,
                        boxShadow: [BoxShadow(color: themeController.isDarkMode ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.1), spreadRadius: 2, blurRadius: 10)],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 80,
                            decoration: BoxDecoration(color: themeController.isDarkMode ? Colors.black : AppColors.subCardColor, borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.all(10),
                            width: double.infinity,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    getImageFromGlarey();
                                  },
                                  child: ClipOval(
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      color: Colors.white,
                                      child: Obx(() => filepath.value == ""
                                          ? const Icon(Icons.image_outlined)
                                          : CircleAvatar(
                                              radius: 50,

                                              // Set the radius of the circle
                                              // Set the background color of the circle
                                              backgroundColor: Colors.white,
                                              child: Image.file(
                                                File(filepath.value),
                                                height: 40,
                                                width: 40,
                                                fit: BoxFit.fill,
                                              ),
                                            )),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: TextFormField(
                                  onChanged: (val) {
                                    groupName.value = val;
                                  },
                                  style: TextStyle(fontSize: 15, color: AppColors.getFontColor(context)),
                                  decoration: InputDecoration(hintText: "Group name", hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.getFontColor(context)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor))),
                                ))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height / 3,
                            child: ListView.builder(
                                itemCount: widget.contactsSearchList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  UserData model = widget.contactsSearchList[index];
                                  return _buildListItem(model, index).paddingOnly(bottom: model == widget.contactsSearchList.last ? 170 : 10);
                                }),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(UserData model, int i) {
    String susTag = model.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag).marginOnly(top: i == 0 ? 0 : 16),
        ),

        GestureDetector(
          onTap: () {
            // Constants.sendToNext(Routes.detailScreen, arguments: model);
            // Get.back(result: model.number?.first);
          },
          child: Container(
            decoration: BoxDecoration(color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white, borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.only(left: 16, right: 16, top: 12),
            child: Row(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6, right: 6),
                      child: (model.userImage?.isEmpty ?? true)
                          ? Container(height: 30, width: 30, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle), child: getCustomFont(Constants.split(model.firstName == null || model.firstName!.isEmpty ? "UnKnown" : model.firstName ?? ""), 12, AppColors.fontColor, 1, fontWeight: FontWeight.w400, textAlign: TextAlign.center))
                          : ClipOval(
                              child: Image.network(
                              height: 30,
                              width: 30,
                              mainUrl + (model.userImage!),
                            )),
                    ),
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
                    "${model.firstName}   ${model.lastName}" ?? "",
                    16,
                    AppColors.getFontColor(context),
                    1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        // ListTile(
        //   leading: CircleAvatar(
        //     backgroundColor: Colors.blue[700],
        //     child: Text(
        //       model.name[0],
        //       style: TextStyle(color: Colors.white),
        //     ),
        //   ),
        //   title: Text(model.name),
        //   onTap: () {
        //     print("OnItemClick: $model");
        //     Navigator.pop(context, model);
        //   },
        // )
      ],
    );
  }

  double susItemHeight = 40;

  Widget _buildSusWidget(String susTag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: susItemHeight,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          getCustomFont('$susTag', 16, themeController.isDarkMode ? AppColors.subFontColor : AppColors.getFontColor(context), 1, fontWeight: FontWeight.w700),
        ],
      ),
    );
  }
}
