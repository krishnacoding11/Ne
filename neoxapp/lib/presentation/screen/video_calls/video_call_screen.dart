import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/widgets/custom_image_view.dart';

import '../../../generated/l10n.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Constants.assetPath + "video_backGround.png"),
          fit: BoxFit.fill,
        ),
        gradient: LinearGradient(
          colors: [AppColors.color1F222A, AppColors.color1B47C5],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: InkWell(
              onTap: () {
                Get.back();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 10),
                  Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20,
                    color: AppColors.subCardColor,
                  ),
                  SizedBox(width: 10),
                  getCustomFont(
                    S.of(context).back,
                    15,
                    AppColors.subCardColor,
                    1,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            actions: [
              CustomImageView(
                svgPath: "add_call_icon.svg",
                // height: 28.h,
              ),
              SizedBox(width: 25),
            ],
          ),
          bottomNavigationBar: Container(
            height: 100,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // height: 45,
                  // width: 45,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.subFont1.withOpacity(0.2),
                  ),
                  child: CustomImageView(svgPath: 'camera_image.svg', onTap: null, height: 30, color: Colors.white),
                ),
                SizedBox(width: 10),
                Container(
                  // height: 45,
                  // width: 45,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.subFont1.withOpacity(0.2),
                  ),
                  child: CustomImageView(svgPath: 'video_icon_imae.svg', onTap: null, height: 30, color: Colors.white),
                ),
                SizedBox(width: 10),
                Container(
                  // height: 45,
                  // width: 45,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.subFont1.withOpacity(0.2),
                  ),
                  child: CustomImageView(svgPath: 'mute.svg', onTap: null, height: 30, color: Colors.white),
                ),
                SizedBox(width: 10),
                Container(
                  // height: 45,
                  // width: 45,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.callEndColor,
                  ),
                  child: CustomImageView(svgPath: 'cut.svg', onTap: null, height: 30, color: Colors.white),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  GridView.builder(
                      itemCount: 6,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8, mainAxisSpacing: 16),
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  "https://media.istockphoto.com/id/471674230/photo/portrait-of-an-american-real-man.jpg?s=612x612&w=0&k=20&c=Z5PvQP3jfjeuDRau_SOApsmexDveMblcYyrdVd-BgQE=",
                                  fit: BoxFit.fill,
                                )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Center(child: Text("Christine Kennedy")),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            )
                          ],
                        );
                      }),
                ],
              ),
            ),
          )),
    );
  }
}
