import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/generated/l10n.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/controller/dashboard_controller.dart';
import 'package:neoxapp/presentation/screen/dashboard/model/contact_info_model.dart';
import 'package:neoxapp/presentation/screen/message/view/create_group_screen.dart';
import 'package:neoxapp/presentation/screen/message/view/new_message_tab.dart';
import 'package:neoxapp/presentation/widgets/az_listview.dart';
import 'package:neoxapp/presentation/widgets/custom_image_view.dart';
import 'package:neoxapp/presentation/widgets/globle.dart';
import 'package:neoxapp/presentation/widgets/index_bar.dart';
import '../../../../model/restore_data_model.dart';
import '../../../controller/chat_controller.dart';
import '../../../controller/contact_controller.dart';
import '../../../controller/enterprice_user_controller.dart';

class NewChatListScreen extends StatefulWidget {
  final Function? nextOnTap;
  final Function? backOnTap;
  final Function? createGroupOnTap;
  const NewChatListScreen({Key? key, this.nextOnTap, this.backOnTap, this.createGroupOnTap}) : super(key: key);

  @override
  State<NewChatListScreen> createState() => _NewChatListScreenState();
}

class _NewChatListScreenState extends State<NewChatListScreen> {
  ContactController controller = Get.put(ContactController());
  DashboardController dashboardController = Get.put(DashboardController());
  RxBool isLoading = false.obs;
  TextEditingController searchController = TextEditingController();
  List<ContactInfo> contactsSearchLis = [];
  EnterPriceController enterPriceUserController = Get.put(EnterPriceController());
  RxList<SideBarData> contactsSearchList = <SideBarData>[].obs;
  ChatController chatController = Get.find();
  RxList<ContactInfo> selectContactList = <ContactInfo>[].obs;

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
              // floatingActionButton: InkWell(
              //   borderRadius: BorderRadius.circular(100),
              //   onTap: () {
              //     if (commonSizeForDesktop(context)) {
              //       if (widget.nextOnTap != null) {
              //         widget.nextOnTap!();
              //       }
              //     } else {
              //       // Get.to(() => AddGCreateGroupNameScreen(
              //       //       contactsSearchList: contactsSearchList,
              //       //     ));
              //     }
              //   },
              //   child: Container(
              //     height: 60,
              //     width: 60,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(100),
              //       color: AppColors.primaryColor,
              //     ),
              //     child: Center(
              //         child: Icon(
              //       Icons.arrow_forward_ios,
              //       color: AppColors.subFont1,
              //     )),
              //   ),
              // ),
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
                          S.of(context).newChat,
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
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: getTextFiled(
                                suffixIcon: 'searchImage.svg',
                                suffix: true,
                                hint: S.of(context).search,
                                context: context,
                                onChanged: (value) {
                                  contactsSearchList.value = enterPriceUserController.enterPriceUserAndSideBar.where((element) => (element.name?.toLowerCase().contains(value.toLowerCase()) ?? false)).toList();
                                },
                                fillColor: AppColors.ColorEBF0FF,
                                textEditingController: searchController,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (commonSizeForDesktop(context)) {
                                  if (widget.createGroupOnTap != null) {
                                    widget.createGroupOnTap!();
                                  }
                                } else {
                                  Get.to(() => const CreateGroupListScreen());
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: themeController.isDarkMode ? AppColors.darkPrimaryColor.withOpacity(0.5) : AppColors.primaryColor.withOpacity(0.5),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      child: CustomImageView(
                                        svgPath: "crategrop_Image.svg",
                                        color: themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    getCustomFont(
                                      S.of(context).createGroup,
                                      15,
                                      themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor,
                                      1,
                                      fontWeight: FontWeight.w600,
                                      textAlign: TextAlign.start,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            StreamBuilder(
                                stream: contactsSearchList.stream,
                                builder: (context, snapshot) {
                                  return Expanded(
                                      child: AzListView(
                                    data: contactsSearchList,
                                    itemCount: contactsSearchList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      SideBarData model = contactsSearchList[index];
                                      return _buildListItem(model, index).paddingOnly(bottom: model == contactsSearchList.last ? 170 : 8);
                                    },

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

  Widget _buildListItem(SideBarData model, int i) {
    String susTag = model.getSuspensionTag();

    print("su==${model.isShowSuspension}");
    return Column(
      children: <Widget>[
        // _buildSusWidget(susTag).marginOnly(top: i == 0 ? 0 : 16),
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag).marginOnly(top: i == 0 ? 0 : 16),
        ),
        GestureDetector(
          onTap: () {
            print(model);
            Get.back();
            chatController.isfirst.value = true;
            chatController.recieverName.value = model.name!;
            Get.to(() => NewMessageScreen(sideBarData: model));
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
                          ? Container(height: 30, width: 30, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle), child: getCustomFont(Constants.split(model.name == null || model.name!.isEmpty ? "UnKnown" : model.name ?? ""), 12, AppColors.primaryColor, 1, fontWeight: FontWeight.w400, textAlign: TextAlign.center))
                          : ClipOval(
                              child: Image.network(
                                height: 30,
                                width: 30,
                                (mainUrl + model.image!),
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
