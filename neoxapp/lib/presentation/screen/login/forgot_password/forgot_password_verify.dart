import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/constants.dart';
import '../../../../core/widget.dart';
import '../../../../generated/l10n.dart';
import '../../../controller/login_controller.dart';
import '../../../widgets/custom_image_view.dart';
import 'create_password_screen.dart';

class ForGotPasswordVerifyScreen extends StatefulWidget {
  final String? phoneNumber;
  final String? email;
  const ForGotPasswordVerifyScreen({Key? key, this.phoneNumber, this.email}) : super(key: key);

  @override
  State<ForGotPasswordVerifyScreen> createState() => _ForGotPasswordVerifyScreenState();
}

class _ForGotPasswordVerifyScreenState extends State<ForGotPasswordVerifyScreen> {
  LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 68,
      height: 57,
      textStyle: TextStyle(
        color: AppColors.getFontColor(context),
      ),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.primaryColor)),
    );
    final unselectedBoxTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(color: AppColors.getSubCardColor(context)),
      decoration: BoxDecoration(
        color: AppColors.getSubCardColor(context),
        borderRadius: BorderRadius.circular(10),
      ),
    );
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
                      S.of(context).verifyOtp,
                      36,
                      AppColors.getFontColor(context),
                      1,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                    getVerSpace(8),
                    Text(" A code has been sent to \n${widget.phoneNumber} via SMS", style: TextStyle(color: AppColors.getSubFontColor(context), fontWeight: FontWeight.w400, height: 1.2), textAlign: TextAlign.center),
                    getVerSpace(20),
                    Pinput(
                      controller: loginController.forgotOtpController.value,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      focusNode: FocusNode(),
                      defaultPinTheme: unselectedBoxTheme,
                      submittedPinTheme: defaultPinTheme,
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (pin) {
                        debugPrint('onCompleted: $pin');
                        loginController.forgotOtpController.refresh();
                      },
                      onChanged: (value) {
                        debugPrint('onChanged: $value');
                      },
                      errorPinTheme: defaultPinTheme.copyBorderWith(
                        border: Border.all(color: Colors.redAccent),
                      ),
                    ),
                    getVerSpace(20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getCustomFont("Not received?  ", 14, AppColors.getSubFontColor(context), 1, fontWeight: FontWeight.w400),
                        getCustomFont("Resend", 14, AppColors.primaryColor, 1, fontWeight: FontWeight.w600),
                        SizedBox(width: 5),
                        CustomImageView(
                          svgPath: "icons.svg",
                          height: 20,
                        )
                      ],
                    ),
                    getVerSpace(20),
                    StreamBuilder(
                        stream: loginController.forgotOtpController.stream,
                        builder: (context, snapshot) {
                          return getButton(context, (loginController.forgotOtpController.value.text.isNotEmpty) ? AppColors.primaryColor : AppColors.primaryColor.withOpacity(0.4), S.of(context).verify, Colors.white, () {
                            if (loginController.otpController.value.text.isNotEmpty) {
                              Get.to(() => CreatePasswordScreen());
                            }
                          }, 16, weight: FontWeight.w400);
                        }),
                    getVerSpace(40),
                  ],
                ),
              ).marginSymmetric(horizontal: 16),
            ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //
            //
            //   ],
            // ).paddingOnly(bottom: 55.h),
          ],
        ),
      ),
    );
  }
}
