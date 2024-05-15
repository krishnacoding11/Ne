import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:azlistview/azlistview.dart' as az;
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/presentation/screen/detail/detail_screen.dart';
import '../../../../../core/constants.dart';
import '../../../../../core/theme_color.dart';
import '../../../../../core/widget.dart';
import '../../../../../main.dart';
import '../../../../widgets/az_listview.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../../widgets/index_bar.dart';
import '../../model/contact_info_model.dart';

class FavContact extends StatefulWidget {
  final Function(ContactInfo)? contactInfoFunction;
  const FavContact({Key? key, this.contactInfoFunction}) : super(key: key);

  @override
  State<FavContact> createState() => _FavContactState();
}

class _FavContactState extends State<FavContact> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  RxList<ContactInfo> _contacts = <ContactInfo>[].obs;
  double susItemHeight = 40;

  void loadData() async {
    rootBundle.loadString('assets/data/fav_contacts.json').then((value) {
      setState(() {
        List list = json.decode(value);
        list.forEach((v) {
          _contacts.add(ContactInfo.fromJson(v));
        });
        _handleList(_contacts);
      });
    });
  }

  void _handleList(List<ContactInfo> list) {
    if (list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    // A-Z sort.
    az.SuspensionUtil.sortListBySuspensionTag(_contacts);

    // show sus tag.
    az.SuspensionUtil.setShowSuspensionStatus(_contacts);

    // add header.

    setState(() {});
  }

  Widget _buildSusWidget(String susTag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: susItemHeight,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          getCustomFont('$susTag', 16, themeController.isDarkMode ? AppColors.subFontColor : AppColors.getFontColor(context), 1, fontWeight: FontWeight.w700),
          // Text(
          //   '$susTag',
          //   textScaleFactor: 1.2,
          // ),
          // Expanded(
          //     child: Divider(
          //       height: .0,
          //       indent: 10.0,
          //     ))
        ],
      ),
    );
  }

  Widget _buildListItem(ContactInfo model, int i, {Function(ContactInfo)? contactInfoFunction}) {
    String susTag = model.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag).marginOnly(top: i == 0 ? 0 : 16),
        ),

        InkWell(
          onTap: () {
            // Constants.sendToNext(Routes.detailScreen, arguments: model);
            model.number = [Item(label: "sdf", value: "101023564564"), Item(label: "sdf", value: "456792648")];
            if (commonSizeForDesktop(context)) {
              if (contactInfoFunction != null) {
                contactInfoFunction(model);
              }
            } else {
              Get.to(() => DetailScreen(contactInfo: model), arguments: model);
            }
          },
          child: Container(
            decoration: BoxDecoration(color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white, borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.only(left: 16, right: 16, top: 12),
            child: Row(
              children: [
                model.img == null || model.img!.isEmpty
                    ? Container(height: 26, width: 26, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xffEBF0FF), shape: BoxShape.circle), child: getCustomFont(Constants.split(model.name), 12, AppColors.primaryColor, 1, fontWeight: FontWeight.w400, textAlign: TextAlign.center))
                    : ClipOval(
                        child: CustomImageView(
                          height: 26,
                          width: 26,
                          imagePath: '${Constants.assetPath}${model.img}',
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

  Decoration getIndexBarDecoration(Color color) {
    return BoxDecoration(color: color, borderRadius: BorderRadius.circular(20.0), border: Border.all(color: Colors.grey[300]!, width: .5));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder(
            stream: _contacts.stream,
            builder: (context, snapshot) {
              return AzListView(
                data: _contacts,
                itemCount: _contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  ContactInfo model = _contacts[index];
                  return _buildListItem(model, index, contactInfoFunction: (contact) {
                    if (widget.contactInfoFunction != null) {
                      widget.contactInfoFunction!(contact);
                    }
                  });
                },
                physics: const BouncingScrollPhysics(),
                // indexBarData: SuspensionUtil.getTagIndexList(_contacts),
                indexHintBuilder: (context, hint) {
                  return Container(
                    alignment: Alignment.center,
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.blue[700]!.withAlpha(200),
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
              );
            }),

        //   Align(alignment: Alignment.bottomRight,
        //     child: Container(
        //       height: 48,
        //       margin: EdgeInsets.only(right: 10),
        //       width: 48,
        //       decoration: BoxDecoration(
        //           color: AppColors.primaryColor,
        //           shape: BoxShape.circle
        //       ),
        //       alignment: Alignment.center,
        //       child: CustomImageView(
        //         svgPath: 'add.svg',
        //         color: Colors.white,
        //         height: 19,
        //       ),
        //     ),
        //   )
      ],
    );
  }
}
