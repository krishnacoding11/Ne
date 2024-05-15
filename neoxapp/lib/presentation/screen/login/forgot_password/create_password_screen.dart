import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants.dart';
import '../../../../core/route/app_routes.dart';
import '../../../../core/theme_color.dart';
import '../../../../core/widget.dart';
import '../../../../generated/l10n.dart';
import '../../../../main.dart';
import '../../../controller/login_controller.dart';
import '../../../widgets/custom_image_view.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({Key? key}) : super(key: key);

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Constants.assetPath + "bg.png"), fit: BoxFit.fill)),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(top: 120),
                child: CustomImageView(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  imagePath: "${Constants.assetPath}logo_3.png",
                  height: 75,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height - 7.2 * kBottomNavigationBarHeight,
                width: double.infinity,
                margin: EdgeInsets.only(top: 50),
                padding: EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: AppColors.getCardColor(context),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  children: [
                    getVerSpace(40),
                    getCustomFont(
                      S.of(context).createPassword,
                      36,
                      AppColors.getFontColor(context),
                      1,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                    getVerSpace(8),
                    getCustomFont(
                      S.of(context).enterPassword,
                      22,
                      AppColors.getSubFontColor(context),
                      1,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                    ),

                    getVerSpace(20),
                    ObxValue(
                      (p0) => getTextFiled(
                          textEditingController: loginController.createPasswordController.value,
                          prefix: true,
                          prefixIcon: 'lock.svg',
                          hint: S.of(context).password,
                          context: context,
                          suffixIcon: 'eye.svg',
                          suffix: true,
                          obscureText: loginController.isShowPassword.value,
                          function: () {
                            loginController.isShowPassword.value = !loginController.isShowPassword.value;
                          },
                          onChanged: (value) {
                            loginController.createPasswordController.refresh();
                          }),
                      loginController.isShowPassword,
                    ),
                    getVerSpace(20),
                    ObxValue(
                      (p0) => getTextFiled(
                          textEditingController: loginController.createNewPasswordController.value,
                          prefix: true,
                          prefixIcon: 'lock.svg',
                          hint: S.of(context).password,
                          context: context,
                          suffixIcon: 'eye.svg',
                          suffix: true,
                          obscureText: loginController.isShowPassword.value,
                          function: () {
                            loginController.isShowPassword.value = !loginController.isShowPassword.value;
                          },
                          onChanged: (value) {
                            loginController.createNewPasswordController.refresh();
                          }),
                      loginController.isShowPassword,
                    ),
                    getVerSpace(20),
                    getButton(context, (loginController.createNewPasswordController.value.text.isNotEmpty && loginController.createPasswordController.value.text.isNotEmpty) ? AppColors.primaryColor : AppColors.primaryColor.withOpacity(0.4), 'Reset', AppColors.subCardColor, () {
                      Constants.sendToNext(Routes.dashboardScreen);
                    }, 16, weight: FontWeight.w400),
                    getVerSpace(30),
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
                    // StreamBuilder(
                    //     stream: loginController.otpController.stream,
                    //     builder: (context, snapshot) {
                    //       return getButton(context,(loginController.otpController.value.text.isNotEmpty ) ? AppColors.primaryColor  : AppColors.primaryColor.withOpacity(0.4), S.of(context).verify, Colors.white, () {
                    //         isVerified.value = true;
                    //         loginController.manualProvisioningPasswordController.refresh();
                    //         Get.off(()=>ManualProvisioningScreen(isOk: true));
                    //       }, 16.sp, weight: FontWeight.w400);
                    //     }
                    // ),
                  ],
                ),
              ).marginSymmetric(horizontal: 16),
            ),
          ],
        ) /*:ListView(
        children: [
          Container(
              margin: EdgeInsets.only(top: 120.h),
              child: CustomImageView(
                onTap: () {
                  Navigator.pop(context);
                },
                imagePath: "${Constants.assetPath}logo_3.png",
                height: 75.h,
                alignment: Alignment.topCenter,
              )),
          Container(
            height:  MediaQuery.of(context).size.height-7.2*kBottomNavigationBarHeight,
            width: double.infinity,
            margin: EdgeInsets.only( top: 50.h),
            padding: EdgeInsets.symmetric(horizontal: 25.h),
            decoration: BoxDecoration(color: AppColors.getCardColor(context), borderRadius: BorderRadius.circular(32.r)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  getVerSpace(40.h),
                  getCustomFont(
                    S.of(context).createPassword,
                    36.sp,
                    AppColors.getFontColor(context),
                    1,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                  getVerSpace(8.h),
                  getCustomFont(
                    S.of(context).enterPassword,
                    22.sp,
                    AppColors.getSubFontColor(context),
                    1,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),

                  getVerSpace(20.h),
                  ObxValue(
                        (p0) => getTextFiled(
                        textEditingController: loginController.createPasswordController.value,
                        prefix: true,
                        prefixIcon: 'lock.svg',
                        hint: S.of(context).password,
                        context: context,
                        suffixIcon: 'eye.svg',
                        suffix: true,
                        obscureText: loginController.isShowPassword.value,
                        function: () {
                          loginController.isShowPassword.value = !loginController.isShowPassword.value;
                        },
                        onChanged: (value) {
                          loginController.createPasswordController.refresh();
                        }),
                    loginController.isShowPassword,
                  ),
                  getVerSpace(20.h),
                  ObxValue(
                        (p0) => getTextFiled(
                        textEditingController: loginController.createNewPasswordController.value,
                        prefix: true,
                        prefixIcon: 'lock.svg',
                        hint: S.of(context).password,
                        context: context,
                        suffixIcon: 'eye.svg',
                        suffix: true,
                        obscureText: loginController.isShowPassword.value,
                        function: () {
                          loginController.isShowPassword.value = !loginController.isShowPassword.value;
                        },
                        onChanged: (value) {
                          loginController.createNewPasswordController.refresh();
                        }),
                    loginController.isShowPassword,
                  ),
                  getVerSpace(20.h),
                  getButton(context, AppColors.primaryColor, 'Reset', AppColors.subCardColor, () {}, 16.sp, weight: FontWeight.w400),
                  getVerSpace(30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getMultilineCustomFont(S.of(context).rememberPassword, 14.sp, AppColors.getSubFontColor(context), fontWeight: FontWeight.w400, textAlign: TextAlign.center, fontFamily: Constants.fontLato),
                      getHorSpace(5.w),
                      getMultilineCustomFont(S.of(context).login, 16.sp, themeController.isDarkMode ? Color(0xff91ADFF) : AppColors.primaryColor, fontWeight: FontWeight.w600, textAlign: TextAlign.center, fontFamily: Constants.fontLato),
                      getHorSpace(5.w),
                      CustomImageView(
                        svgPath: "icons.svg",
                        height: 20.h,
                      ),
                    ],
                  ),
                  getVerSpace(30.h),
                  // StreamBuilder(
                  //     stream: loginController.otpController.stream,
                  //     builder: (context, snapshot) {
                  //       return getButton(context,(loginController.otpController.value.text.isNotEmpty ) ? AppColors.primaryColor  : AppColors.primaryColor.withOpacity(0.4), S.of(context).verify, Colors.white, () {
                  //         isVerified.value = true;
                  //         loginController.manualProvisioningPasswordController.refresh();
                  //         Get.off(()=>ManualProvisioningScreen(isOk: true));
                  //       }, 16.sp, weight: FontWeight.w400);
                  //     }
                  // ),


                ],
              ),
            ),
          ).marginSymmetric(horizontal: 16.h),
        ],
      ).paddingOnly(bottom: 55.h)*/
        ,
      ),
    );
  }
}
