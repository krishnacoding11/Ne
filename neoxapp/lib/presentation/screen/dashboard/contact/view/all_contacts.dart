import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/presentation/controller/contact_controller.dart';
import 'package:neoxapp/presentation/controller/dashboard_controller.dart';
import 'package:neoxapp/presentation/screen/detail/detail_screen.dart';
import 'package:neoxapp/presentation/widgets/az_listview.dart';
import 'package:neoxapp/presentation/widgets/index_bar.dart';
import '../../../../../core/constants.dart';
import '../../../../../core/theme_color.dart';
import '../../../../../core/widget.dart';
import '../../../../../main.dart';
import '../../../../controller/chat_controller.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../model/contact_info_model.dart';

class AllContacts extends StatefulWidget {
  const AllContacts({Key? key}) : super(key: key);

  @override
  State<AllContacts> createState() => _AllContactsState();
}

class _AllContactsState extends State<AllContacts> {
  ContactController controller = Get.put(ContactController());
  ChatController chatController = Get.find();
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
            if (!chatController.getContactdetails.value) {
              print("------- 3");
              // Constants.sendToNext(Routes.detailScreen, arguments: model);
              Get.to(() => DetailScreen(
                    contactInfo: model,
                  ));
            } else {
              chatController.contactNumber.value = model.number![0].value!;
              chatController.contactFristName.value = model.name;
              chatController.getContactdetails.value = false;
              Get.back();
            }
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

  Decoration getIndexBarDecoration(Color color) {
    return BoxDecoration(color: color, borderRadius: BorderRadius.circular(20.0), border: Border.all(color: Colors.grey[300]!, width: .5));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (controller) {
        return Stack(
          children: [
            AzListView(
              data: controller.contacts,
              itemCount: controller.contacts.length,
              itemBuilder: (BuildContext context, int index) {
                ContactInfo model = controller.contacts[index];
                return _buildListItem(model, index).paddingOnly(bottom: model == controller.contacts.last ? 80 : 10);
              },
              physics: BouncingScrollPhysics(),
              // indexBarData: SuspensionUtil.getTagIndexList(_contacts),
              indexHintBuilder: (context, hint) {
                return Container(
                  alignment: Alignment.center,
                  width: 60.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[700]!.withAlpha(200),
                    shape: BoxShape.circle,
                  ),
                  child: Text(hint, style: TextStyle(color: Colors.white, fontSize: 30.0)),
                );
              },
              indexBarMargin: EdgeInsets.all(0),
              indexBarOptions: IndexBarOptions(
                needRebuild: true,
                decoration: getIndexBarDecoration(Colors.white),
                downDecoration: getIndexBarDecoration(Colors.white),
              ),
            ),
            // Align(
            //   alignment: Alignment.bottomRight,
            //   child: Container(
            //     height: 48,
            //     margin: EdgeInsets.only(right: 10),
            //     width: 48,
            //     decoration: BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle),
            //     alignment: Alignment.center,
            //     child: CustomImageView(
            //       svgPath: 'add.svg',
            //       color: Colors.white,
            //       height: 19,
            //     ),
            //   ),
            // )
          ],
        );
      },
      init: DashboardController(),
    );
  }
}
