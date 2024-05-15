import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/screen/dashboard/history/view/all_calls.dart';
import 'package:neoxapp/presentation/screen/dashboard/history/view/missed_calls.dart';
import '../../../../../core/widget.dart';
import '../../../../../generated/l10n.dart';
import '../../../controller/history_controller.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _StateHistoryScreen();
}

class _StateHistoryScreen extends State<HistoryScreen> {
  HistoryController historyController = Get.put(HistoryController());
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    print("call==${size.height}");

    return GetBuilder(
      builder: (controller) => Container(
        decoration: commonSizeForDesktop(context) ? null : BoxDecoration(image: DecorationImage(image: AssetImage(themeController.isDarkMode ? Constants.assetPath + "dark_dashboard.png" : Constants.assetPath + (commonSizeForDesktop(context) ? "backgorundimage.png" : "history_bg.png")), fit: BoxFit.fill)),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 40,
                  ),
                  Expanded(
                      child: getCustomFont(
                    S.of(context).callHistory,
                    24,
                    AppColors.getFontColor(context),
                    1,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                  )),
                  // CustomImageView(
                  //   svgPath: 'search.svg',
                  //   height: 24,
                  // ),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ).marginOnly(bottom: 35, top: 30),
              Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      getCell(S.of(context).allCalls, 0),
                      getCell(S.of(context).missedCalls, 1),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: commonSizeForDesktop(context) ? 1000 : null,
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white,
                    boxShadow: [BoxShadow(color: themeController.isDarkMode ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.1), spreadRadius: 2, blurRadius: 30)],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: getTextFiled(
                          suffixIcon: 'searchImage.svg',
                          suffix: true,
                          hint: S.of(context).search,
                          context: context,
                          onChanged: (value) {},
                          fillColor: AppColors.ColorEBF0FF,
                          textEditingController: searchController,
                        ),
                      ),
                      Expanded(child: historyController.tabIndex == 0 ? AllCalls() : MissedCalls()),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      init: HistoryController(),
    );
  }

  getCell(String title, int i) {
    return InkWell(
      onTap: () {
        historyController.onChange(i);
      },
      child: Container(
          decoration: BoxDecoration(color: historyController.tabIndex == i ? const Color(0xffEBF0FF) : Colors.transparent, borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          child: getCustomFont(
            title,
            14,
            historyController.tabIndex == i ? AppColors.primaryColor : AppColors.hintColor,
            1,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          )),
    );
  }
}
