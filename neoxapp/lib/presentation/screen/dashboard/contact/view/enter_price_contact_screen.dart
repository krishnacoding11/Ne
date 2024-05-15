import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neoxapp/model/enter_price_user_model.dart';
import 'package:neoxapp/presentation/controller/contact_controller.dart';
import 'package:neoxapp/presentation/controller/dashboard_controller.dart';
import 'package:neoxapp/presentation/screen/detail/detail_screen.dart';
import 'package:neoxapp/presentation/widgets/az_listview.dart';
import 'package:neoxapp/presentation/widgets/globle.dart';
import 'package:neoxapp/presentation/widgets/index_bar.dart';
import '../../../../../core/constants.dart';
import '../../../../../core/theme_color.dart';
import '../../../../../core/widget.dart';
import '../../../../../main.dart';
import '../../model/contact_info_model.dart';

class EnterPriceContacts extends StatefulWidget {
  final List<UserData>? enterPriceList;
  const EnterPriceContacts({Key? key, this.enterPriceList}) : super(key: key);

  @override
  State<EnterPriceContacts> createState() => _EnterPriceContactsState();
}

class _EnterPriceContactsState extends State<EnterPriceContacts> {
  ContactController controller = Get.find();
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

  Widget _buildListItem(UserData model, int i) {
    String susTag = model.getSuspensionTag();
    final getStorage = GetStorage();
    getStorage.write('finalCount', mainUrl + model.userImage!);

    return Column(
      children: <Widget>[
        // Offstage(
        //   offstage: model.isShowSuspension != true,
        //   child: _buildSusWidget(susTag).marginOnly(top: i == 0 ? 0 : 16),
        // ),

        GestureDetector(
          onTap: () {
            // Constants.sendToNext(Routes.detailScreen, arguments: model);
            ContactInfo contactInfo = ContactInfo(name: "${model.firstName} ${model.lastName}", number: [Item(value: model.mobileNumber, label: "")], displayName: "${model.firstName} ${model.lastName}", contactImage: model.userImage ?? "");
            Get.to(() => DetailScreen(
                  contactInfo: contactInfo,
                ));
          },
          child: Container(
            decoration: BoxDecoration(color: themeController.isDarkMode ? Color(0xff272A2F) : Colors.white, borderRadius: BorderRadius.circular(16)),
            margin: EdgeInsets.only(left: 16, right: 16, top: 12),
            child: Row(
              children: [
                (model.userImage?.isEmpty ?? true)
                    ? Container(height: 26, width: 26, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle), child: getCustomFont(Constants.split("${model.firstName} ${model.lastName}"), 12, AppColors.primaryColor, 1, fontWeight: FontWeight.w400, textAlign: TextAlign.center))
                    : ClipOval(
                        child: Image.network(
                          height: 26,
                          width: 26,
                          mainUrl + model.userImage! ?? "",
                        ),
                      ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: getCustomFont(
                    "${model.firstName} ${model.lastName}",
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
              data: (widget.enterPriceList ?? []),
              itemCount: (widget.enterPriceList?.length ?? 0),
              itemBuilder: (BuildContext context, int index) {
                UserData model = (widget.enterPriceList?[index] ?? UserData());
                return _buildListItem(model, index).paddingOnly(bottom: model == widget.enterPriceList?.last ? 90 : 10);
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
