import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/generated/l10n.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/controller/dashboard_controller.dart';
import 'package:neoxapp/presentation/screen/message/view/addGroupNameScreen.dart';
import 'package:neoxapp/presentation/widgets/az_listview.dart';
import 'package:neoxapp/presentation/widgets/index_bar.dart';
import '../../../../model/enter_price_user_model.dart';
import '../../../../model/restore_data_model.dart';
import '../../../controller/chat_controller.dart';
import '../../../controller/contact_controller.dart';
import '../../../controller/enterprice_user_controller.dart';
import '../../../widgets/globle.dart';

class CreateGroupListScreen extends StatefulWidget {
  final Function? backOnTap;
  final Function? nextOnTap;
  const CreateGroupListScreen({Key? key, this.backOnTap, this.nextOnTap}) : super(key: key);

  @override
  State<CreateGroupListScreen> createState() => _CreateGroupListScreenState();
}

class _CreateGroupListScreenState extends State<CreateGroupListScreen> {
  ContactController controller = Get.put(ContactController());
  DashboardController dashboardController = Get.put(DashboardController());
  ChatController chatController = Get.find();
  RxBool isLoading = false.obs;
  TextEditingController searchController = TextEditingController();
  List<UserData> contactsSearchLis = [];

  RxList<UserData> enterPriceUserList = <UserData>[].obs;
  RxList<SideBarData> contactsSearchList = <SideBarData>[].obs;
  EnterPriceController enterPriceUserController = Get.put(EnterPriceController());

  @override
  void initState() {
    super.initState();
    // enterPriceUserList.value=[];
    enterPriceUserController.getEnterPriceCall(callBack: () {
      enterPriceUserList.value = enterPriceUserController.enterPriceUserList;
      //  enterPriceUserController.enterPriceUserList.forEach((element) {
      //   if(element.sId!=chatController.uid) {
      //     enterPriceUserList.value.add(element);
      //   }
      //  });
      contactsSearchList.value = enterPriceUserController.enterPriceUserAndSideBar;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    print("call==${size.height}");

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
              floatingActionButton: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  if (commonSizeForDesktop(context)) {
                    if (widget.nextOnTap != null) {
                      widget.nextOnTap!();
                    }
                  } else {
                    controller.selectContactList.forEach((element) {
                      controller.groupuserIS.add(element.sId);
                    });
                    if (controller.selectContactList.length > 0) {
                      Get.to(() => AddGCreateGroupNameScreen(
                            contactsSearchList: controller.selectContactList,
                          ));
                    } else {
                      Fluttertoast.showToast(
                        msg: "Please select at least one member ",
                      );
                    }
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
                    Icons.arrow_forward_ios,
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
                      children: [
                        const SizedBox(width: 10),
                        Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 20,
                          color: AppColors.getFontColor(context),
                        ),
                        const SizedBox(width: 10),
                        getCustomFont(
                          S.of(context).createGroup,
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
              body: StreamBuilder(
                  stream: enterPriceUserList.stream,
                  builder: (context, snapshot) {
                    return SingleChildScrollView(
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
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: getTextFiled(
                                      suffixIcon: 'searchImage.svg',
                                      suffix: true,
                                      hint: S.of(context).search,
                                      context: context,
                                      onChanged: (value) {
                                        enterPriceUserList.value = enterPriceUserController.enterPriceUserList.where((element) => ("${element.firstName} ${element.lastName}".toLowerCase().contains(value.toLowerCase()) ?? false)).toList();
                                      },
                                      fillColor: AppColors.ColorEBF0FF,
                                      textEditingController: searchController,
                                    ),
                                  ),
                                  StreamBuilder(
                                      stream: controller.selectContactList.stream,
                                      builder: (context, snapshot) {
                                        return Expanded(
                                            child: AzListView(
                                          data: enterPriceUserList,
                                          itemCount: enterPriceUserList.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            UserData model = enterPriceUserList[index];
                                            return _buildListItem(model, index).paddingOnly(bottom: model == enterPriceUserList.last ? 170 : 8);
                                          },

                                          // susItemBuilder: (context, index) {
                                          //
                                          //   SideBarData model = contactsSearchList[index];
                                          //
                                          //   String tag = model.getSuspensionTag();
                                          //   print("object===$tag");
                                          //
                                          //
                                          //   return   _buildSusWidget(tag).marginOnly(top:  16);
                                          // },
                                          physics: const BouncingScrollPhysics(),
                                          // indexBarData: SuspensionUtil.getTagIndexList(_contacts),
                                          indexHintBuilder: (context, hint) {
                                            return Container(
                                              alignment: Alignment.center,
                                              width: 60.0,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[700]!.withAlpha(200),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(hint, style: const TextStyle(color: Colors.white, fontSize: 30.0)),
                                            );
                                          },
                                          indexBarMargin: const EdgeInsets.all(0),
                                          indexBarAlignment: Alignment.topRight,
                                          indexBarOptions: IndexBarOptions(
                                            needRebuild: true,
                                            decoration: getIndexBarDecoration(Colors.white),
                                            downDecoration: getIndexBarDecoration(Colors.white),
                                          ),
                                        ));
                                        //     child: AzListView(
                                        //   data: dashboardController.contacts,
                                        //   itemCount: dashboardController.contacts.length,
                                        //   itemBuilder: (BuildContext context, int index) {
                                        //     ContactInfo model = dashboardController.contacts[index];
                                        //     return _buildListItem(model, index).paddingOnly(bottom: model == dashboardController.contacts.last ? 170 : 8);
                                        //   },
                                        //   physics: const BouncingScrollPhysics(),
                                        //   // indexBarData: SuspensionUtil.getTagIndexList(_contacts),
                                        //   indexHintBuilder: (context, hint) {
                                        //     return Container(
                                        //       alignment: Alignment.center,
                                        //       width: 60.0,
                                        //       height: 60.0,
                                        //       decoration: BoxDecoration(
                                        //         color: Colors.grey[700]!.withAlpha(200),
                                        //         shape: BoxShape.circle,
                                        //       ),
                                        //       child: Text(hint, style: const TextStyle(color: Colors.white, fontSize: 30.0)),
                                        //     );
                                        //   },
                                        //   indexBarMargin: const EdgeInsets.all(0),
                                        //   indexBarAlignment: Alignment.topRight,
                                        //   indexBarOptions: IndexBarOptions(
                                        //     needRebuild: true,
                                        //     decoration: getIndexBarDecoration(Colors.white),
                                        //     downDecoration: getIndexBarDecoration(Colors.white),
                                        //   ),
                                        // ));
                                      }),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      init: ContactController(),
    );
  }

  Decoration getIndexBarDecoration(Color color) {
    return BoxDecoration(color: color, borderRadius: BorderRadius.circular(20.0), border: Border.all(color: Colors.grey[300]!, width: .5));
  }

  // Widget _buildListItem(ContactInfo model, int i) {
  //   String susTag = model.getSuspensionTag();
  //   return Column(
  //     children: <Widget>[
  //       Offstage(
  //         offstage: model.isShowSuspension != true,
  //         child: _buildSusWidget(susTag).marginOnly(top: i == 0 ? 0 : 16),
  //       ),
  //       GestureDetector(
  //         onTap: () {
  //           // Constants.sendToNext(Routes.detailScreen, arguments: model);
  //           // Get.back(result:model.number?.first );
  //           if (selectContactList.contains(model)) {
  //             selectContactList.remove(model);
  //           } else {
  //             selectContactList.add(model);
  //           }
  //         },
  //         child: Container(
  //           decoration: BoxDecoration(color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white, borderRadius: BorderRadius.circular(16)),
  //           margin: const EdgeInsets.only(left: 16, right: 16, top: 12),
  //           child: Row(
  //             children: [
  //               Stack(
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 6, right: 6),
  //                     child: (model.img?.isEmpty ?? true)
  //                         ? Container(height: 30, width: 30, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle), child: getCustomFont(Constants.split(model.name.isEmpty ? "UnKnown" : model.name), 12, AppColors.primaryColor, 1, fontWeight: FontWeight.w400, textAlign: TextAlign.center))
  //                         : ClipOval(
  //                             child: CustomImageView(
  //                               height: 30,
  //                               width: 30,
  //                               memory: (model.img!),
  //                             ),
  //                           ),
  //                   ),
  //                   if (selectContactList.contains(model))
  //                     const Positioned(
  //                         right: 1,
  //                         child: Icon(
  //                           Icons.check_circle,
  //                           color: Colors.green,
  //                           size: 18,
  //                         ))
  //                 ],
  //               ),
  //               const SizedBox(
  //                 width: 15,
  //               ),
  //               Expanded(
  //                 child: getCustomFont(
  //                   model.name,
  //                   15,
  //                   AppColors.getFontColor(context),
  //                   1,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildListItem(UserData model, int i) {
    String susTag = model.getSuspensionTag();

    return Column(
      children: <Widget>[
        // _buildSusWidget(susTag).marginOnly(top: i == 0 ? 0 : 16),
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag).marginOnly(top: i == 0 ? 0 : 16),
        ),
        GestureDetector(
          onTap: () {
            // Constants.sendToNext(Routes.detailScreen, arguments: model);
            // Get.back(result:model.number?.first );
            // if (selectContactList.contains(model)) {
            //   selectContactList.remove(model);
            // } else {
            //   selectContactList.add(model);
            // }
            if (controller.selectContactList.contains(model)) {
              controller.selectContactList.remove(model);
            } else {
              controller.selectContactList.add(model);
            }
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
                        child: Container(
                            height: 30,
                            width: 30,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle),
                            child:

                                // getCustomFont(Constants.split(model.firstName==null || model.firstName!.isEmpty ? "UnKnown" : model.firstName??""), 12, AppColors.primaryColor, 1, fontWeight: FontWeight.w400, textAlign: TextAlign.center))

                                (model.userImage?.isEmpty ?? true)
                                    ? Container(height: 30, width: 30, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle), child: getCustomFont(Constants.split(model.firstName == null || model.firstName!.isEmpty ? "UnKnown" : model.firstName ?? ""), 12, AppColors.fontColor, 1, fontWeight: FontWeight.w400, textAlign: TextAlign.center))
                                    : ClipOval(
                                        child: Image.network(
                                        height: 30,
                                        width: 30,
                                        mainUrl + (model.userImage!),
                                      )))),
                    if (controller.selectContactList.contains(model))
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
                    "${model.firstName} ${model.lastName}",
                    15,
                    AppColors.getFontColor(context),
                    1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
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
