import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme_color.dart';
import '../../../../../core/widget.dart';
import '../../../../../main.dart';

class MessageCell extends StatelessWidget {
// final SmsThread smsMessage;
//   MessageCell
//       (this.smsMessage);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(color: themeController.isDarkMode ? const Color(0xff272A2F) : Colors.white, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          // smsMessage.image == null || smsMessage.image!.isEmpty
          //     ?
          Container(height: 38, width: 38, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xffEFEFF1), shape: BoxShape.circle), child: getCustomFont('KL', 12, AppColors.getSubFontColor(context), 1, fontWeight: FontWeight.w400))
          //     :
          //
          // ClipOval(
          //   child: CustomImageView(
          //     height: 38.h,
          //     width: 38.h,
          //     imagePath: '${Constants.assetPath}${smsMessage.image}',
          //   ),
          // ),
          ,
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCustomFont(
                'Anthony Harding',
                16,
                AppColors.getFontColor(context),
                1,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  // CustomImageView(
                  //   height: 14.h,
                  //   width: 14.h,
                  //   svgPath: 'call_incoming.svg',
                  //   color: smsMessage.status == 1
                  //       ? AppColors.greenColor
                  //       : smsMessage.status == 0
                  //       ? AppColors.redColor
                  //       : Color(
                  //     0xff91ADFF,
                  //   ),
                  // ),

                  Expanded(child: getCustomFont('Who was that photographer...', 13, AppColors.getSubFontColor(context), 1, fontWeight: FontWeight.w400)),
                ],
              ),
            ],
          )),
          getCustomFont('12:30am', 13, AppColors.getSubFontColor(context), 1, fontWeight: FontWeight.w400),
          // CustomImageView(
          //   height: 22.h,
          //   width: 22.h,onTap: () {
          //   Constants.sendToNext(Routes.callScreen,);
          //
          // },
          //   svgPath: 'call.svg',
          //   color: Color(
          //     0xff91ADFF,
          //   ),
          // ),0xff91ADFF
        ],
      ),
    );
  }
}
