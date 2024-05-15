import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants.dart';
import '../../../../core/theme_color.dart';
import '../../../../core/widget.dart';
import '../../../../generated/l10n.dart';
import '../../../../main.dart';
import '../../../controller/login_controller.dart';
import '../../../widgets/custom_image_view.dart';
import 'forgot_password_verify.dart';

class ForGotScreen extends StatefulWidget {
  const ForGotScreen({Key? key}) : super(key: key);

  @override
  State<ForGotScreen> createState() => _ForGotScreenState();
}

class _ForGotScreenState extends State<ForGotScreen> {
  LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: Get.height,
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Constants.assetPath + "bg.png"), fit: BoxFit.fill)),
      child: CustomScrollView(
        // mainAxisAlignment: MainAxisAlignment.center,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
                margin: EdgeInsets.only(top: 100),
                child: CustomImageView(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  imagePath: "${Constants.assetPath}logo_3.png",
                  height: 75,
                  alignment: Alignment.topCenter,
                )),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 87, top: 72),
              padding: EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(color: AppColors.getCardColor(context), borderRadius: BorderRadius.circular(32)),
              child: Column(
                children: [
                  getVerSpace(40),
                  getCustomFont(
                    S.of(context).resetPassword,
                    36,
                    AppColors.getFontColor(context),
                    1,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                  getVerSpace(8),
                  getCustomFont(
                    S.of(context).resetPasswordDescription,
                    16,
                    AppColors.getSubFontColor(context),
                    1,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                  getVerSpace(20),
                  getTextFiled(
                      textEditingController: loginController.resetEmailController.value,
                      prefix: true,
                      prefixIcon: 'mail.svg',
                      hint: S.of(context).email,
                      context: context,
                      onChanged: (value) {
                        loginController.resetEmailController.refresh();
                      }),
                  getVerSpace(30),
                  StreamBuilder(
                      stream: loginController.resetEmailController.stream,
                      builder: (context, snapshot) {
                        return getButton(context, (loginController.resetEmailController.value.text.isNotEmpty) ? AppColors.primaryColor : AppColors.primaryColor.withOpacity(0.4), S.of(context).resetPassword, AppColors.subCardColor, () {
                          Get.to(() => ForGotPasswordVerifyScreen(
                                email: loginController.resetEmailController.value.text,
                              ));
                        }, 16);
                      }),
                  getVerSpace(50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getMultilineCustomFont(S.of(context).rememberPassword, 14, AppColors.getSubFontColor(context), fontWeight: FontWeight.w400, textAlign: TextAlign.center, fontFamily: Constants.fontLato),
                      getHorSpace(5),
                      getMultilineCustomFont(S.of(context).login, 16, themeController.isDarkMode ? Color(0xff91ADFF) : AppColors.primaryColor, fontWeight: FontWeight.w600, textAlign: TextAlign.center, fontFamily: Constants.fontLato),
                      getHorSpace(5),
                      CustomImageView(
                        svgPath: "icons.svg",
                        height: 20,
                      ),
                    ],
                  ),
                  getVerSpace(30),
                ],
              ),
            ).marginSymmetric(horizontal: 16),
          ),
        ],
      ).paddingOnly(bottom: 55),
    )
        /* Container(height: Get.height,
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Constants.assetPath + "bg.png"), fit: BoxFit.fill)),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              child: CustomImageView(
                onTap: () {
                  Navigator.pop(context);
                },
                imagePath: "${Constants.assetPath}neox.png",
                height: 35.h,
                alignment: Alignment.bottomCenter,
              ),
            ).paddingOnly(top: 150.h),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 87.h, top: 72.h),
              padding: EdgeInsets.symmetric(horizontal: 25.h),
              decoration: BoxDecoration(color: AppColors.getCardColor(context), borderRadius: BorderRadius.circular(32.r)),
              child: Column(
                children: [
                  getVerSpace(40.h),
                  getCustomFont(
                    S.of(context).resetPassword,
                    36.sp,
                    AppColors.getFontColor(context),
                    1,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                  getVerSpace(8.h),
                  getCustomFont(
                    S.of(context).resetPasswordDescription,
                    16.sp,
                    AppColors.getSubFontColor(context),
                    1,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                  getVerSpace(20.h),
                  getTextFiled(
                      textEditingController: loginController.resetPasswordController.value,
                      prefix: true,
                      prefixIcon: 'mail.svg',
                      hint: S.of(context).email,
                      context: context,
                      onChanged: (value) {
                        loginController.resetPasswordController.refresh();
                      }),
                  getVerSpace(30.h),
                  getButton(context, AppColors.primaryColor,S.of(context).resetPassword, AppColors.subCardColor, (){}, 16),
                  getVerSpace(50.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getMultilineCustomFont(S.of(context).dontHaveAnAccount, 14.sp, AppColors.getSubFontColor(context), fontWeight: FontWeight.w400, textAlign: TextAlign.center, fontFamily: Constants.fontLato),
                      getHorSpace(5.w),
                      getMultilineCustomFont(S.of(context).createNow, 16.sp, themeController.isDarkMode ? Color(0xff91ADFF) : AppColors.primaryColor, fontWeight: FontWeight.w400, textAlign: TextAlign.center, fontFamily: Constants.fontLato),
                      getHorSpace(5.w),
                      CustomImageView(
                        svgPath: "icons.svg",
                        height: 20.h,
                      ),
                    ],
                  ),
                  getVerSpace(30.h),
                ],
              ),
            ).marginSymmetric(horizontal: 16.h),
          ],
        ),
      ),
    ),*/
        );
  }
}
