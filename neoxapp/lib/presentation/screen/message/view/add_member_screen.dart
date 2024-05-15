import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/controller/dashboard_controller.dart';
import 'package:neoxapp/presentation/controller/new_socket_controller.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/presentation/widgets/az_listview.dart';
import 'package:neoxapp/presentation/widgets/index_bar.dart';
import '../../../../model/enter_price_user_model.dart';
import '../../../controller/contact_controller.dart';
import '../../../controller/enterprice_user_controller.dart';
import '../../../widgets/globle.dart';

class AddMemberScreen extends StatefulWidget {
  final Function? backOnTap;
  final String? groupId;
  final List<String>? memberIdList;

  const AddMemberScreen({Key? key, this.backOnTap, this.groupId, this.memberIdList}) : super(key: key);

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  ContactController controller = Get.put(ContactController());
  DashboardController dashboardController = Get.put(DashboardController());
  RxBool isLoading = false.obs;
  TextEditingController searchController = TextEditingController();
  // List<ContactInfo> contactsSearchLis = [];

  // RxList<ContactInfo> selectContactList = <ContactInfo>[].obs;
  RxList<UserData> enterPriceUserList = <UserData>[].obs;
  EnterPriceController enterPriceUserController = Get.put(EnterPriceController());

  RxList<String> selectContactList = <String>[].obs;

  @override
  void initState() {
    super.initState();

    setState(() {});
    enterPriceUserController.getEnterPriceCall(callBack: () {
      if (widget.memberIdList != null) {
        final List<UserData> memberIdList = enterPriceUserController.enterPriceUserList.where((city) => !widget.memberIdList!.contains(city.sId)).toList();

        enterPriceUserList.value = memberIdList;
      } else {
        enterPriceUserList.value = enterPriceUserController.enterPriceUserList;
      }

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
                onTap: () async {
                  if (widget.groupId != null) {
                    if (selectContactList.isEmpty) {}
                    print("i===true");
                    NewSocketController newSocketController = Get.find();

                    // final List<String> memberIdList = selectContactList.map((city) => city.sId??'').toList();
                    newSocketController.addGroupMembers(widget.groupId, selectContactList);
                    Navigator.of(context).pop(true);
                  } else {
                    if (commonSizeForDesktop(context)) {
                      if (widget.backOnTap != null) {
                        widget.backOnTap!();
                      }
                    } else {
                      Get.back();
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
                preferredSize: Size.fromHeight(80),
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
                        SizedBox(width: 10),
                        Icon(Icons.arrow_back_ios_rounded, size: 20, color: AppColors.getFontColor(context)),
                        SizedBox(width: 10),
                        getCustomFont(
                          "Add members",
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
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: commonSizeForLargDesktop(context) ? 900 : double.infinity,
                        height: MediaQuery.of(context).size.height,
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode ? Color(0xff272A2F) : Colors.white,
                          boxShadow: [BoxShadow(color: themeController.isDarkMode ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.108), spreadRadius: 2, blurRadius: 10)],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // StreamBuilder(
                            //     stream: selectContactList.stream,
                            //     builder: (context, snapshot) {
                            //       return Expanded(
                            //           child: AzListView(
                            //         data: dashboardController.contacts,
                            //         itemCount: dashboardController.contacts.length,
                            //         itemBuilder: (BuildContext context, int index) {
                            //           ContactInfo model = dashboardController.contacts[index];
                            //           return _buildListItem(model, index).paddingOnly(bottom: model == dashboardController.contacts.last ? 170 : 8);
                            //         },
                            //         physics: BouncingScrollPhysics(),
                            //         // indexBarData: SuspensionUtil.getTagIndexList(_contacts),
                            //         indexHintBuilder: (context, hint) {
                            //           return Container(
                            //             alignment: Alignment.center,
                            //             width: 60.0,
                            //             height: 60.0,
                            //             decoration: BoxDecoration(
                            //               color: Colors.grey[700]!.withAlpha(200),
                            //               shape: BoxShape.circle,
                            //             ),
                            //             child: Text(hint, style: TextStyle(color: Colors.white, fontSize: 30.0)),
                            //           );
                            //         },
                            //         indexBarMargin: EdgeInsets.all(0),
                            //         indexBarAlignment: Alignment.topRight,
                            //         indexBarOptions: IndexBarOptions(
                            //           needRebuild: true,
                            //           decoration: getIndexBarDecoration(Colors.white),
                            //           downDecoration: getIndexBarDecoration(Colors.white),
                            //         ),
                            //       ));
                            //     }),

                            StreamBuilder(
                                stream: selectContactList.stream,
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
              ),
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
  //           decoration: BoxDecoration(color: themeController.isDarkMode ? Color(0xff272A2F) : Colors.white, borderRadius: BorderRadius.circular(16)),
  //           margin: EdgeInsets.only(left: 16, right: 16, top: 12),
  //           child: Row(
  //             children: [
  //               Stack(
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 6, right: 6),
  //                     child:
  //                     (model.img?.isEmpty ?? true)
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
  //                     Positioned(
  //                         right: 1,
  //                         child: Icon(
  //                           Icons.check_circle,
  //                           color: Colors.green,
  //                           size: 18,
  //                         ))
  //                 ],
  //               ),
  //               SizedBox(
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

            if (selectContactList.contains(model.sId)) {
              selectContactList.remove(model.sId);
            } else {
              selectContactList.add(model.sId ?? '');
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
                    if (selectContactList.contains(model.sId))
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
      padding: EdgeInsets.symmetric(horizontal: 16),
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
