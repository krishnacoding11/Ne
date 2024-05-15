import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants.dart';
import '../../../../core/globals.dart';
import '../../../../core/theme_color.dart';
import '../../../../core/widget.dart';
import '../../../../generated/l10n.dart';
import '../../../../main.dart';
import '../../../../model/restore_data_model.dart';
import '../../../controller/contact_controller.dart';
import '../../../controller/dashboard_controller.dart';
import '../../../controller/message_controller.dart';
import '../../../controller/new_socket_controller.dart';
import '../../../widgets/az_listview.dart';
import '../../../widgets/custom_image_view.dart';
import '../../dashboard/model/contact_info_model.dart';
import '../../login/model/verify_model.dart';

class ShareContact extends StatefulWidget {
  final SideBarData? sideBarData;
  const ShareContact({super.key, this.sideBarData});

  @override
  State<ShareContact> createState() => _ShareContactState();
}

class _ShareContactState extends State<ShareContact> {
  ContactController controller = Get.put(ContactController());
  NewSocketController newSocketController = Get.find();
  RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget _buildListItem(ContactInfo model, int i) {
      String susTag = model.getSuspensionTag();
      return Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              var id = (Random().nextInt(900000000) + 100000000).toString();
              UserDetails userDetails = await getUserData();
              newSocketController.send_message(id, widget.sideBarData!.isGroup == 1 ? 1 : 0, widget.sideBarData!.sId, "${model.name},${model.number![0].value!}", widget.sideBarData!.isGroup == 1 ? widget.sideBarData!.sId : null, 0, 5, null, null, null, null, () async {
                ();
              }, firstName: userDetails.firstName ?? "", lastName: userDetails.lastName ?? "");
              Get.back();
              MessageController messageController = Get.find();
              await messageController.getMessegeData();
              messageController.update();
              messageController.refresh();
            },
            child: Container(
              decoration: BoxDecoration(color: themeController.isDarkMode ? Color(0xff272A2F) : Colors.white, borderRadius: BorderRadius.circular(16)),
              margin: EdgeInsets.only(left: 16, right: 16, top: 12),
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
                  SizedBox(
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

    return GetBuilder(
      builder: (controller) {
        return (Scaffold(
          body: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: AppColors.getFontColor(context),
                        size: 15,
                      )).marginOnly(left: 40, bottom: 35, top: 30),
                  const SizedBox(
                    width: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: getCustomFont(
                      S.of(context).contact,
                      24,
                      AppColors.getFontColor(context),
                      1,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                    ).marginOnly(bottom: 35, top: 30),
                  ),
                ],
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
                    child: Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: Stack(
                        children: [
                          AzListView(
                              data: controller.contacts,
                              itemCount: controller.contacts.length,
                              itemBuilder: (BuildContext context, int index) {
                                ContactInfo model = controller.contacts[index];
                                return _buildListItem(model, index).paddingOnly(bottom: model == controller.contacts.last ? 80 : 10);
                              }),
                          isLoading.value
                              ? Container(
                                  height: MediaQuery.of(context).size.height,
                                  color: AppColors.statusBarColor.withOpacity(0.4),
                                  child: const Center(child: CircularProgressIndicator()),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
      },
      init: DashboardController(),
    );
  }
}
