import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/globals.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:neoxapp/generated/l10n.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/model/chat_data_model.dart';
import 'package:neoxapp/presentation/controller/contact_controller.dart';
import 'package:neoxapp/presentation/controller/dashboard_controller.dart';
import 'package:neoxapp/presentation/controller/enterprice_user_controller.dart';
import 'package:neoxapp/presentation/controller/new_socket_controller.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/presentation/screen/message/view/new_message_tab.dart';
import '../../../../model/restore_data_model.dart';
import '../../login/model/verify_model.dart';

class ForwardContactScreenScreen extends StatefulWidget {
  final bool? isShare;
  final Function? backOnTap;
  final ChatDataModel? chatDataModel;
  const ForwardContactScreenScreen({super.key, this.isShare, this.backOnTap, this.chatDataModel});

  @override
  State<ForwardContactScreenScreen> createState() => _ForwardContactScreenScreenState();
}

class _ForwardContactScreenScreenState extends State<ForwardContactScreenScreen> {
  ContactController controller = Get.put(ContactController());
  DashboardController dashboardController = Get.put(DashboardController());
  EnterPriceController enterPriceUserController = Get.put(EnterPriceController());
  RxBool isLoading = false.obs;
  TextEditingController searchController = TextEditingController();
  RxList<SideBarData> contactsSearchList = <SideBarData>[].obs;

  RxList<SideBarData> selectContactList = <SideBarData>[].obs;
  NewSocketController newSocketController = Get.put(NewSocketController());
  @override
  void initState() {
    super.initState();
    enterPriceUserController.getEnterPriceCall(callBack: () {
      contactsSearchList.value = enterPriceUserController.enterPriceUserAndSideBar;
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
                floatingActionButton: (widget.isShare ?? false)
                    ? const SizedBox()
                    : InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () async {
                          if (commonSizeForDesktop(context)) {
                            if (widget.backOnTap != null) {
                              widget.backOnTap!();
                            }
                          } else {
                            UserDetails userDetails = await getUserData();

                            await Future.sync(() {
                              selectContactList.forEach((element) {
                                var id = (Random().nextInt(900000000) + 100000000).toString();

                                if (element.isGroup == 0) {
                                  newSocketController.send_message(id, element.isGroup, element.sId, widget.chatDataModel?.message, null, 2, widget.chatDataModel?.mediaType, widget.chatDataModel?.replyMessageId, null, null, widget.chatDataModel?.message_caption, () {}, firstName: selectContactList.last.name ?? "", lastName: userDetails.lastName ?? "");
                                } else {
                                  newSocketController.send_message(id, element.isGroup, element.sId, widget.chatDataModel?.message, widget.chatDataModel?.groupId, 2, widget.chatDataModel?.mediaType, widget.chatDataModel?.replyMessageId, null, null, widget.chatDataModel?.message_caption, () {}, firstName: userDetails.firstName ?? "", lastName: userDetails.lastName ?? "");
                                }

                                print("list= 000 =${selectContactList.last.toJson()}");
                              });
                              Get.back();

                              Get.to(() => NewMessageScreen(
                                    sideBarData: selectContactList.last,
                                  ));
                            });
                          }
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height * 0.02),
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
                            (widget.isShare ?? false) ? S.of(context).contact : S.of(context).forwardTo,
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
                body: Obx(() => SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
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
                                      setState(() {
                                        contactsSearchList.value = enterPriceUserController.enterPriceUserAndSideBar.where((element) => (element.name?.toLowerCase().contains(value.toLowerCase()) ?? false)).toList();
                                        // print("===${contactsSearchLis.length}");
                                      });
                                    },
                                    fillColor: AppColors.ColorEBF0FF,
                                    textEditingController: searchController,
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                      // physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: contactsSearchList.length ?? 0,
                                      itemBuilder: (context, index) {
                                        return _buildListItem(contactsSearchList[index], index).paddingOnly(bottom: contactsSearchList[index] == contactsSearchList.last ? 170 : 2);
                                      }),
                                ),
                                // StreamBuilder(
                                //     stream: selectContactList.stream,
                                //     builder: (context, snapshot) {
                                //       return Expanded(
                                //           child: searchController.text.isEmpty
                                //               ? AzListView(
                                //                   data: dashboardController.contacts,
                                //                   itemCount: dashboardController.contacts.length,
                                //                   itemBuilder: (BuildContext context, int index) {
                                //                     ContactInfo model = dashboardController.contacts[index];
                                //                     return _buildListItem(model, index).paddingOnly(bottom: model == dashboardController.contacts.last ? 170 : 2);
                                //                   },
                                //                   physics: BouncingScrollPhysics(),
                                //                   // indexBarData: SuspensionUtil.getTagIndexList(_contacts),
                                //                   indexHintBuilder: (context, hint) {
                                //                     return Container(
                                //                       alignment: Alignment.center,
                                //                       width: 60.0,
                                //                       height: 60.0,
                                //                       decoration: BoxDecoration(
                                //                         color: Colors.grey[700]!.withAlpha(200),
                                //                         shape: BoxShape.circle,
                                //                       ),
                                //                       child: Text(hint, style: TextStyle(color: Colors.white, fontSize: 30.0)),
                                //                     );
                                //                   },
                                //                   indexBarMargin: EdgeInsets.all(0),
                                //                   indexBarAlignment: Alignment.topRight,
                                //                   indexBarOptions: IndexBarOptions(
                                //                     needRebuild: true,
                                //                     decoration: getIndexBarDecoration(Colors.white),
                                //                     downDecoration: getIndexBarDecoration(Colors.white),
                                //                   ),
                                //                 )
                                //               : ListView.builder(
                                //                   itemCount: contactsSearchLis.length,
                                //                   // shrinkWrap: true,
                                //                   itemBuilder: (context, index) {
                                //                     ContactInfo model = contactsSearchLis[index];
                                //                     return _buildListItem(model, index).paddingOnly(bottom: model == contactsSearchLis.last ? 170 : 0);
                                //                   }));
                                //     }),
                              ],
                            ),
                          )
                        ],
                      ),
                    ))),
          ],
        ),
      ),
      init: ContactController(),
    );
  }

  Decoration getIndexBarDecoration(Color color) {
    return BoxDecoration(color: color, borderRadius: BorderRadius.circular(20.0), border: Border.all(color: Colors.grey[300]!, width: .5));
  }

  Widget _buildListItem(SideBarData model, int i) {
    // String susTag = model.getSuspensionTag();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Offstage(
        //   offstage: model.isShowSuspension != true,
        //   child: _buildSusWidget(susTag).marginOnly(top: i == 0 ? 0 : 16),
        // ),
        GestureDetector(
          onTap: () {
            // Constants.sendToNext(Routes.detailScreen, arguments: model);
            // Get.back(result:model.number?.first );
            if (widget.isShare ?? false) {
              Get.back();
            } else {
              setState(() {
                if (selectContactList.contains(model)) {
                  selectContactList.remove(model);
                } else {
                  selectContactList.add(model);
                }
              });
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
                      child: (model.image?.isEmpty ?? true)
                          ? Container(height: 30, width: 30, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle), child: getCustomFont(Constants.split((model.name?.isEmpty ?? true) ? "UnKnown" : (model.name ?? "")), 12, AppColors.primaryColor, 1, fontWeight: FontWeight.w400, textAlign: TextAlign.center))
                          : ClipOval(
                              child: Image.network(
                                height: 30,
                                width: 30,
                                ("https://neoxadmin.celloip.com/" + model.image!),
                              ),
                            ),
                    ),
                    if (selectContactList.contains(model))
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
                    model.name ?? "",
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
