import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/presentation/controller/enterprice_user_controller.dart';
import 'package:neoxapp/presentation/screen/dashboard/contact/view/enter_price_contact_screen.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/controller/dashboard_controller.dart';
import 'package:neoxapp/presentation/screen/dashboard/contact/view/all_contacts.dart';
import 'package:neoxapp/presentation/screen/dashboard/contact/view/fav_contact.dart';
// import 'package:azlistview/azlistview.dart' as az;
import 'package:neoxapp/presentation/screen/dashboard/model/contact_info_model.dart';
import '../../../../core/widget.dart';
import '../../../../generated/l10n.dart';
import '../../../controller/contact_controller.dart';

class ContactScreen extends StatefulWidget {
  final Function(ContactInfo)? contactInfoFunction;
  const ContactScreen({super.key, this.contactInfoFunction});

  @override
  State<ContactScreen> createState() => _StateContactScreen();
}

class _StateContactScreen extends State<ContactScreen> {
  ContactController controller = Get.put(ContactController());
  EnterPriceController enterPriceController = Get.put(EnterPriceController());
  DashboardController dashboardController = Get.put(DashboardController());
  RxBool isLoading = false.obs;
  @override
  void initState() {
    super.initState();
    enterPriceController.getEnterPriceCall();
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    print("call==${size.height}");

    return GetBuilder(
      builder: (controller) => Container(
        decoration: commonSizeForDesktop(context) ? BoxDecoration(color: AppColors.subCardColor) : BoxDecoration(image: DecorationImage(image: AssetImage(themeController.isDarkMode ? "${Constants.assetPath}dark_dashboard.png" : "${Constants.assetPath}history_bg.png"), fit: BoxFit.fill)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: controller.tabIndex == 0
              ? FloatingActionButton(
                  onPressed: () async {
                    // isLoading.value = true;
                    controller.update();
                    // Contact contact =

                    try {
                      await ContactsService.openContactForm().then((contact) async {
                        print("fgfg==$contact");

                        isLoading.value = true;

                        dashboardController.contacts.add(ContactInfo(
                          number: contact.phones,
                          name: contact.displayName ?? "",
                          img: contact.avatar,
                          firstletter: contact.middleName,
                          contactImage: "",
                        ));
                        //todo : pass contact image url : 05-02-2024-9:25

                        await dashboardController.getAllContact();
                        isLoading.value = false;
                        controller.update();
                      });
                    } on FormOperationException catch (e) {
                      switch (e.errorCode) {
                        case FormOperationErrorCode.FORM_OPERATION_CANCELED:
                        case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
                        case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
                        default:
                          print(e.errorCode);
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  backgroundColor: AppColors.primaryColor,
                  child: Icon(Icons.add, color: AppColors.subCardColor, size: 30),
                ).paddingOnly(bottom: commonSizeForDesktop(context) ? 0 : MediaQuery.of(context).size.height * 0.1)
              : SizedBox(),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: getCustomFont(
                    S.of(context).contact,
                    24,
                    AppColors.getFontColor(context),
                    1,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                  ).marginOnly(left: 40, bottom: 35, top: 30),
                ),
                Center(
                  child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          commonSizeForDesktop(context) ? SizedBox() : getCell(S.of(context).all, 0),
                          getCell(S.of(context).enterprise, 1),
                          getCell(S.of(context).favourite, 2),
                        ],
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
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
                    child: Center(
                      child: Container(
                        child: controller.tabIndex == 0
                            ? Stack(
                                children: [
                                  const AllContacts(),
                                  isLoading.value
                                      ? Container(
                                          height: MediaQuery.of(context).size.height,
                                          color: AppColors.statusBarColor.withOpacity(0.4),
                                          child: const Center(child: CircularProgressIndicator()),
                                        )
                                      : const SizedBox()
                                ],
                              )
                            : controller.tabIndex == 1
                                ? EnterPriceContacts(
                                    enterPriceList: enterPriceController.enterPriceUserModel.value.userData,
                                  )
                                : FavContact(contactInfoFunction: (contact) {
                                    if (widget.contactInfoFunction != null) {
                                      widget.contactInfoFunction!(contact);
                                    }
                                  }),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      init: ContactController(),
    );
  }

  getCell(String title, int i) {
    return InkWell(
      onTap: () {
        controller.onChange(i);
      },
      child: Container(
          decoration: BoxDecoration(color: controller.tabIndex == i ? const Color(0xffEBF0FF) : Colors.transparent, borderRadius: BorderRadius.circular(100)),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          child: getCustomFont(
            title,
            14,
            controller.tabIndex == i ? AppColors.primaryColor : AppColors.hintColor,
            1,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          )),
    );
  }
}
