import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neoxapp/presentation/screen/dashboard/model/history_model.dart';
import '../../../../../core/constants.dart';
import '../../../../../core/route/app_routes.dart';
import '../../../../../core/theme_color.dart';
import '../../../../../core/widget.dart';
import '../../../../../main.dart';
import '../../../../widgets/custom_image_view.dart';

class HistoryCell extends StatelessWidget {
  final HistoryModel historyModel;
  HistoryCell(this.historyModel);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        // Constants.sendToNext(Routes.detailScreen,arguments: historyModel);
      },
      child: Container(
        decoration: BoxDecoration(color: themeController.isDarkMode ? Color(0xff272A2F) : Colors.white, borderRadius: BorderRadius.circular(16)),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            historyModel.image == null || historyModel.image!.isEmpty
                ? Container(height: 38, width: 38, alignment: Alignment.center, decoration: BoxDecoration(color: Color(0xffEBF0FF), shape: BoxShape.circle), child: getCustomFont(historyModel.name.contains("+") ? "#" : Constants.split(historyModel.name), 12, AppColors.primaryColor, 1, fontWeight: FontWeight.w400))
                : ClipOval(
                    child: CustomImageView(
                      height: 38,
                      width: 38,
                      imagePath: '${Constants.assetPath}${historyModel.image}',
                    ),
                  ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getCustomFont(
                  historyModel.name,
                  16,
                  historyModel.status == 0 ? AppColors.redColor : AppColors.getFontColor(context),
                  1,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  height: 3,
                ),
                Row(
                  children: [
                    CustomImageView(
                      height: 14,
                      width: 14,
                      svgPath: 'call_incoming.svg',
                      color: historyModel.status == 1
                          ? AppColors.greenColor
                          : historyModel.status == 0
                              ? AppColors.redColor
                              : Color(
                                  0xff91ADFF,
                                ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    historyModel.status == 0
                        ? Expanded(
                            child: getCustomFont(historyModel.time, 13, AppColors.getSubFontColor(context), 1, fontWeight: FontWeight.w400),
                          )
                        : Expanded(
                            child: Row(
                            children: [
                              getCustomFont(historyModel.time, 13, AppColors.getSubFontColor(context), 1, fontWeight: FontWeight.w400),
                              SizedBox(
                                width: 5,
                              ),
                              CustomImageView(
                                height: 5,
                                width: 5,
                                svgPath: 'dot.svg',
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              getCustomFont("2m:22s", 13, AppColors.getSubFontColor(context), 1, fontWeight: FontWeight.w400),
                            ],
                          )),
                  ],
                ),
              ],
            )),
            CustomImageView(
              height: 22,
              width: 22,
              onTap: () {
                Constants.sendToNext(
                  Routes.callScreen,
                );
              },
              svgPath: 'call.svg',
              color: Color(
                0xff91ADFF,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
