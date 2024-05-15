import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import '../../../../core/constants.dart';
import '../../../../core/theme_color.dart';
import '../../../../core/widget.dart';
import '../../../../generated/l10n.dart';
import '../../../controller/login_controller.dart';
import '../../../widgets/custom_image_view.dart';

class MobileEmailScreen extends StatefulWidget {
  const MobileEmailScreen({Key? key}) : super(key: key);

  @override
  State<MobileEmailScreen> createState() => _MobileEmailScreenState();
}

class _MobileEmailScreenState extends State<MobileEmailScreen> {
  LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (BuildContext, bool isKeyboardVisible) {
        return Scaffold(
          body: Container(
            height: Get.height,
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Constants.assetPath + (commonSizeForDesktop(context) ? "appbackgroud.png" : "bg.png")), fit: BoxFit.fill)),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 100),
                          child: CustomImageView(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            imagePath: "${Constants.assetPath}logo_3.png",
                            height: 75,
                            alignment: Alignment.topCenter,
                          )),
                      Container(
                        height: MediaQuery.of(context).size.height - 6 * kBottomNavigationBarHeight,
                        width: commonSizeForDesktop(context) ? 500 : double.infinity,
                        margin: EdgeInsets.only(/*bottom: 87.h,*/ top: 50),
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(color: AppColors.getCardColor(context), borderRadius: BorderRadius.circular(32)),
                        child: SingleChildScrollView(
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getVerSpace(40),
                              getCustomFont(
                                S.of(context).welcome,
                                36,
                                AppColors.getFontColor(context),
                                1,
                                fontWeight: FontWeight.w700,
                                textAlign: TextAlign.center,
                              ),
                              getVerSpace(8),
                              getCustomFont(
                                S.of(context).signInToGetStarted,
                                22,
                                AppColors.getSubFontColor(context),
                                1,
                                fontWeight: FontWeight.w400,
                                textAlign: TextAlign.center,
                              ),
                              getVerSpace(20),
                              getTextFiled(
                                  textEditingController: loginController.mobileUserNameController.value,
                                  prefix: true,
                                  prefixIcon: 'mail.svg',
                                  hint: S.of(context).userName,
                                  context: context,
                                  onChanged: (value) {
                                    loginController.emailController.refresh();
                                  }),
                              getVerSpace(20),
                              getTextFiled(
                                  textEditingController: loginController.mobilePasswordController.value,
                                  prefix: true,
                                  prefixIcon: 'mobile.svg',
                                  hint: S.of(context).password,
                                  context: context,
                                  onChanged: (value) {
                                    loginController.emailController.refresh();
                                  }),
                              getVerSpace(20),
                              getTextFiled(
                                  textEditingController: loginController.mobileRegisterServerController.value,
                                  prefix: true,
                                  prefixIcon: 'mobile.svg',
                                  hint: S.of(context).registrarServer,
                                  context: context,
                                  onChanged: (value) {
                                    loginController.emailController.refresh();
                                  }),
                              getVerSpace(20),
                              DropdownButtonFormField2(
                                hint: Text('Via Transport'),
                                value: loginController.selectedViaTransport.value,
                                onChanged: (newValue) {
                                  setState(() {
                                    loginController.selectedViaTransport.value = newValue ?? "";
                                  });
                                },
                                decoration: InputDecoration(
                                    counterText: "",
                                    contentPadding: getHeightPadding(),
                                    isDense: true,
                                    prefixIconConstraints: BoxConstraints(minWidth: 45, maxWidth: 45),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(left: 16, right: 10),
                                      child: CustomImageView(
                                        svgPath: "mobile.svg",
                                      ),
                                    ),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.transparent, width: 0)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.transparent, width: 0)),
                                    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.transparent, width: 0)),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.transparent, width: 0)),
                                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: AppColors.redColor, width: 1)),
                                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: AppColors.redColor, width: 1)),
                                    fillColor: AppColors.getSubCardColor(context),
                                    filled: true,
                                    errorStyle: TextStyle(color: AppColors.redColor, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: Constants.fontLato),
                                    label: null,
                                    hintStyle: TextStyle(color: AppColors.hintColor, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: Constants.fontLato)),
                                items: ["abc", "abc1", "abc2"].map((value) {
                                  return DropdownMenuItem(
                                    child: Text(value, style: TextStyle(color: AppColors.fontColor, fontSize: 14)),
                                    value: value,
                                  );
                                }).toList(),
                              ),
                              // getVerSpace(20.h),
                              // getTextFiled(textEditingController: loginController.emailController.value, prefix: true, prefixIcon: 'mobile.svg', hint: S.of(context).viaTransport, context: context,onChanged: (value){
                              //   loginController.emailController.refresh();
                              // }),
                              getVerSpace(20),
                              getTextFiled(
                                  textEditingController: loginController.mobileWebRTCController.value,
                                  prefix: true,
                                  prefixIcon: 'mobile.svg',
                                  hint: S.of(context).webRTCSocketURI,
                                  context: context,
                                  onChanged: (value) {
                                    loginController.emailController.refresh();
                                  }),
                              getVerSpace(20),
                              getTextFiled(
                                  textEditingController: loginController.mobileDisplayNameController.value,
                                  prefix: true,
                                  prefixIcon: 'mobile.svg',
                                  hint: S.of(context).displayName,
                                  context: context,
                                  onChanged: (value) {
                                    loginController.emailController.refresh();
                                  }),
                              getVerSpace(40),
                              getButton(context, (loginController.mobileUserNameController.value.text.isNotEmpty && loginController.mobilePasswordController.value.text.isNotEmpty && loginController.mobileRegisterServerController.value.text.isNotEmpty && loginController.mobileWebRTCController.value.text.isNotEmpty && loginController.mobileDisplayNameController.value.text.isNotEmpty && loginController.selectedViaTransport.value.isNotEmpty) ? AppColors.primaryColor : AppColors.primaryColor.withOpacity(0.4), S.of(context).register, Colors.white, () {
                                if (loginController.mobileUserNameController.value.text.isNotEmpty && loginController.mobilePasswordController.value.text.isNotEmpty && loginController.mobileRegisterServerController.value.text.isNotEmpty && loginController.mobileWebRTCController.value.text.isNotEmpty && loginController.mobileDisplayNameController.value.text.isNotEmpty && loginController.selectedViaTransport.value.isNotEmpty) {
                                  loginController.checkMobileEmail();
                                }
                              }, 16, weight: FontWeight.w400),
                              SizedBox(height: isKeyboardVisible ? 170 : 0),
                              getVerSpace(40),
                            ],
                          ),
                        ),
                      ).marginSymmetric(horizontal: 16),
                    ],
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 16,
                  child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const SizedBox(
                        width: 100,
                        height: 25,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                            SizedBox(width: 10),
                            Text("Back"),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
