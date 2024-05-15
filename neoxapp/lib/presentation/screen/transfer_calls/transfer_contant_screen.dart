import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:neoxapp/generated/l10n.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/controller/dashboard_controller.dart';
import 'package:neoxapp/presentation/screen/caller/call_screen.dart';
import 'package:neoxapp/presentation/screen/dashboard/model/contact_info_model.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/presentation/widgets/az_listview.dart';
import 'package:neoxapp/presentation/widgets/custom_image_view.dart';
import 'package:neoxapp/presentation/widgets/index_bar.dart';
import 'package:sip_ua/sip_ua.dart';

import '../../controller/contact_controller.dart';
import 'package:neoxapp/presentation/widgets/globle.dart' as globals;

class TransferContactScreen extends StatefulWidget {
  final Function? callEnd;
  const TransferContactScreen({Key? key, this.callEnd}) : super(key: key);

  @override
  State<TransferContactScreen> createState() => _TransferContactScreenState();
}

class _TransferContactScreenState extends State<TransferContactScreen> {
  ContactController controller = Get.put(ContactController());
  DashboardController dashboardController = Get.put(DashboardController());
  RxBool isLoading = false.obs;
  TextEditingController searchController = TextEditingController();
  List<ContactInfo> contactsSearchLis = [];
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
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  title: GestureDetector(
                    onTap: () {
                      Get.back();
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
                          S.of(context).transfer,
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
                        width: commonSizeForDesktop(context) ? 800 : MediaQuery.of(context).size.height,
                        height: MediaQuery.of(context).size.height,
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white,
                          boxShadow: [BoxShadow(color: themeController.isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1), spreadRadius: 4, blurRadius: 15)],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: getTextFiled(
                                suffixIcon: 'searchImage.svg',
                                suffix: true,
                                keyboardType: TextInputType.number,
                                hint: S.of(context).searchNumber,
                                context: context,
                                fillColor: AppColors.primaryColor.withOpacity(0.1),
                                onChanged: (value) {
                                  setState(() {
                                    contactsSearchLis = dashboardController.contacts.where((element) => element.name.contains(value)).toList();
                                  });
                                },
                                textEditingController: searchController,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                widget.callEnd!();
                                SIPUAHelper helperObj = (globals.helper ?? SIPUAHelper());
                                await helperObj.call("91${searchController.text}" ?? "", voiceonly: true, mediaStream: null);
                                Get.to(
                                    CallScreen(
                                      contactInfo: ContactInfo(name: '', number: [Item(value: searchController.text)]),
                                      calling: searchController.text,
                                      callerName: "Unknown",
                                      callObj: globals.callglobalObj,
                                    ),
                                    arguments: {"name": "Unknown"});
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Transfer to : ",
                                    style: TextStyle(color: AppColors.colorBlack),
                                  ),
                                  Text(
                                    searchController.text,
                                    style: TextStyle(color: AppColors.primaryColor),
                                  ),
                                  Icon(
                                    Icons.call,
                                    color: AppColors.primaryColor,
                                  ),
                                ],
                              ).paddingOnly(left: 10),
                            ),
                            Expanded(
                                child: searchController.text.isEmpty
                                    ? AzListView(
                                        data: dashboardController.contacts,
                                        itemCount: dashboardController.contacts.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          ContactInfo model = dashboardController.contacts[index];
                                          return _buildListItem(model, index).paddingOnly(bottom: model == dashboardController.contacts.last ? 170 : 0);
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
                                        indexBarOptions: IndexBarOptions(
                                          needRebuild: true,
                                          decoration: getIndexBarDecoration(Colors.white),
                                          downDecoration: getIndexBarDecoration(Colors.white),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: contactsSearchLis.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          ContactInfo model = contactsSearchLis[index];
                                          return _buildListItem(model, index).paddingOnly(bottom: model == contactsSearchLis.last ? 170 : 0);
                                        })),
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

  Widget _buildListItem(ContactInfo model, int i) {
    String susTag = model.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag).marginOnly(top: i == 0 ? 0 : 16),
        ),

        GestureDetector(
          onTap: () async {
            // Constants.sendToNext(Routes.detailScreen, arguments: model);
            widget.callEnd!();
            SIPUAHelper helperObj = (globals.helper ?? SIPUAHelper());
            await helperObj.call("91${model.number?[0].value}" ?? "", voiceonly: true, mediaStream: null);
            Get.to(
                CallScreen(
                  contactInfo: model,
                  calling: (model.number?.isEmpty ?? true) ? "" : model.number?[0].value,
                  callerName: (model.name.isEmpty ?? true) ? "Unknown" : model.name,
                  callObj: globals.callglobalObj,
                ),
                arguments: {"name": (model.name.isEmpty ?? true) ? "Unknown" : model.name});
            // Get.back(result: model.number?.first);
          },
          child: Container(
            decoration: BoxDecoration(color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white, borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.only(left: 16, right: 16, top: 12),
            child: Row(
              children: [
                (model.img?.isEmpty ?? true)
                    ? Container(height: 26, width: 26, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle), child: getCustomFont(Constants.split(model.name.isEmpty ? "UnKnown" : model.name), 12, AppColors.primaryColor, 1, fontWeight: FontWeight.w400, textAlign: TextAlign.center))
                    : ClipOval(
                        child: CustomImageView(
                          height: 26,
                          width: 26,
                          memory: (model.img!),
                        ),
                      ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: getCustomFont(
                    model.name,
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
