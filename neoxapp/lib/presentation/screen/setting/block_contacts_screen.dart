import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/controller/dashboard_controller.dart';
import 'package:neoxapp/presentation/screen/dashboard/model/contact_info_model.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/presentation/widgets/custom_image_view.dart';
import '../../controller/contact_controller.dart';

class BlockContactScreen extends StatefulWidget {
  const BlockContactScreen({Key? key}) : super(key: key);

  @override
  State<BlockContactScreen> createState() => _BlockContactScreenState();
}

class _BlockContactScreenState extends State<BlockContactScreen> {
  ContactController controller = Get.put(ContactController());
  DashboardController dashboardController = Get.put(DashboardController());
  RxBool isLoading = false.obs;
  TextEditingController searchController = TextEditingController();
  List<ContactInfo> contactsSearchLis = [];

  RxList<ContactInfo> selectContactList = <ContactInfo>[].obs;

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
                          "Blocked Contacts",
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
                        width: commonSizeForMidDesktop(context) ? 800 : double.infinity,
                        height: MediaQuery.of(context).size.height,
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white,
                          boxShadow: [BoxShadow(color: themeController.isDarkMode ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08), spreadRadius: 2, blurRadius: 4)],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder(
                                stream: selectContactList.stream,
                                builder: (context, snapshot) {
                                  return Expanded(
                                      child: ListView.builder(
                                          itemCount: 3,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                // Constants.sendToNext(Routes.detailScreen, arguments: model);
                                                // Get.back(result:model.number?.first );
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(left: 16, right: 16, top: 12),
                                                child: Row(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        Padding(padding: const EdgeInsets.only(top: 6, right: 6), child: Container(height: 30, width: 30, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle), child: getCustomFont(Constants.split("Anthony Harding"), 12, AppColors.primaryColor, 1, fontWeight: FontWeight.w400, textAlign: TextAlign.center))),
                                                        Positioned(
                                                          right: 1,
                                                          child: CustomImageView(svgPath: "bloclImage.svg", height: 20),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                    Expanded(
                                                      child: getCustomFont(
                                                        "Anthony Harding",
                                                        15,
                                                        AppColors.getFontColor(context),
                                                        1,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Unblock",
                                                      style: TextStyle(color: themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }));
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

  Widget _buildListItem(ContactInfo model, int i) {
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
            // Get.back(result:model.number?.first );
            // if (selectContactList.contains(model)) {
            //   selectContactList.remove(model);
            // } else {
            //   selectContactList.add(model);
            // }
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
                      child: (model.img?.isEmpty ?? true)
                          ? Container(height: 30, width: 30, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle), child: getCustomFont(Constants.split(model.name.isEmpty ? "UnKnown" : model.name), 12, AppColors.primaryColor, 1, fontWeight: FontWeight.w400, textAlign: TextAlign.center))
                          : ClipOval(
                              child: CustomImageView(
                                height: 30,
                                width: 30,
                                memory: (model.img!),
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
                    model.name,
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
