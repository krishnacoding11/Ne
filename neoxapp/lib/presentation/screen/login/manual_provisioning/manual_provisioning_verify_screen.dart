import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api/ApiServices.dart';
import '../../../../core/api_constant.dart';
import '../../../../core/constants.dart';
import '../../../../core/theme_color.dart';
import '../../../../core/widget.dart';
import '../../../../generated/l10n.dart';
import '../../../controller/login_controller.dart';
import '../../../widgets/custom_image_view.dart';
import '../../restore/restore_screen.dart';
import '../model/verify_model.dart';

class ManualProvisioningVerifyScreen extends StatefulWidget {
  final String? phoneNumber;
  final String? email;
  ManualProvisioningVerifyScreen({Key? key, this.phoneNumber, this.email}) : super(key: key);

  @override
  State<ManualProvisioningVerifyScreen> createState() => _ManualProvisioningVerifyScreenState();
}

class _ManualProvisioningVerifyScreenState extends State<ManualProvisioningVerifyScreen> {
  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.fontColor,
      ),
      decoration: BoxDecoration(color: isWorngOtp.value ? AppColors.redColor.withOpacity(0.1) : AppColors.getSubCardColor(context), borderRadius: BorderRadius.circular(10), border: Border.all(color: isWorngOtp.value ? AppColors.redColor : Colors.transparent)),
    );
    final unselectedBoxTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(color: AppColors.getSubCardColor(context)),
      decoration: BoxDecoration(color: isWorngOtp.value ? AppColors.redColor.withOpacity(0.1) : AppColors.getSubCardColor(context), borderRadius: BorderRadius.circular(10), border: Border.all(color: isWorngOtp.value ? AppColors.redColor : Colors.transparent)),
    );
    return Scaffold(
      body: Container(
        height: Get.height,
        // decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Constants.assetPath + "bg.png"), fit: BoxFit.fill)),
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Image.asset(
                      Constants.assetPath + (commonSizeForDesktop(context) ? "appbackgroud.png" : "bg.png"),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    )),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 120),
                      child: CustomImageView(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        imagePath: "${Constants.assetPath}logo_3.png",
                        height: 75,
                        alignment: Alignment.topCenter,
                      )),
                  Container(
                    width: commonSizeForDesktop(context) ? 500 : double.infinity,
                    margin: const EdgeInsets.only(bottom: 87, top: 72),
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(color: AppColors.getCardColor(context), borderRadius: BorderRadius.circular(32)),
                    child: ListView(
                      physics: commonSizeForDesktop(context) ? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
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
                        Text(" A code has been sent to \n${widget.phoneNumber} and ${widget.email}", style: TextStyle(color: AppColors.getSubFontColor(context), fontWeight: FontWeight.w400, height: 1.2), textAlign: TextAlign.center),
                        getCustomFont(
                          "Enter OTP",
                          22,
                          AppColors.getSubFontColor(context),
                          1,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                        ),
                        getVerSpace(20),
                        StreamBuilder(
                            stream: isWorngOtp.stream,
                            builder: (context, snapshot) {
                              return Pinput(
                                controller: loginController.otpController.value,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                // focusNode: FocusNode(),
                                defaultPinTheme: unselectedBoxTheme,
                                focusedPinTheme: PinTheme(
                                  width: 56,
                                  height: 56,
                                  textStyle: TextStyle(
                                    color: AppColors.fontColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: BoxDecoration(color: isWorngOtp.value ? AppColors.redColor.withOpacity(0.1) : AppColors.getSubCardColor(context), borderRadius: BorderRadius.circular(10), border: Border.all(color: isWorngOtp.value ? AppColors.redColor : AppColors.primaryColor)),
                                ),

                                submittedPinTheme: defaultPinTheme,
                                autofocus: false,
                                textInputAction: TextInputAction.done,
                                // hapticFeedbackType: HapticFeedbackType.lightImpact,
                                onCompleted: (pin) {
                                  setState(() {
                                    isWorngOtp.value = false;
                                    debugPrint('onCompleted: $pin');
                                    if (pin.length == 4) {
                                      FocusScope.of(context).unfocus();
                                    }
                                    loginController.otpController.refresh();
                                  });
                                },
                                onSubmitted: (value) {
                                  setState(() {
                                    isWorngOtp.value = false;
                                    if (value.length == 4) {
                                      FocusScope.of(context).unfocus();
                                    }
                                  });
                                },
                                onChanged: (value) {
                                  setState(() {
                                    isWorngOtp.value = false;
                                    debugPrint('onChanged: ${value.length}');
                                    if (value.length == 4) {
                                      FocusScope.of(context).unfocus();
                                    }
                                  });
                                },
                                errorPinTheme: defaultPinTheme.copyBorderWith(
                                  border: Border.all(color: Colors.redAccent),
                                ),
                              );
                            }),
                        getVerSpace(20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getCustomFont("Not received?  ", 14, AppColors.getSubFontColor(context), 1, fontWeight: FontWeight.w400),
                            getCustomFont("Resend", 14, themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor, 1, fontWeight: FontWeight.w400),
                            const SizedBox(width: 5),
                            CustomImageView(
                              svgPath: "icons.svg",
                              height: 20,
                              color: themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor,
                            )
                          ],
                        ),
                        getVerSpace(20),
                        StreamBuilder(
                            stream: loginController.otpController.stream,
                            builder: (context, snapshot) {
                              return getButton(context, (loginController.otpController.value.text.isNotEmpty && loginController.otpController.value.text.length == 4) ? AppColors.primaryColor : AppColors.primaryColor.withOpacity(0.4), S.of(context).verify, Colors.white, () {
                                if (loginController.otpController.value.text.isEmpty) {
                                  Fluttertoast.showToast(msg: "Please enter otp");
                                } else if (loginController.otpController.value.text.isNotEmpty && loginController.otpController.value.text.length != 4) {
                                  Fluttertoast.showToast(msg: "Please enter full otp");
                                } else {
                                  verifyApi();
                                }
                              }, 16, weight: FontWeight.w400);
                            }),
                        getVerSpace(40),
                      ],
                    ),
                  ).marginSymmetric(horizontal: 16),
                ],
              ).paddingOnly(bottom: 55),
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
  }

  RxBool isWorngOtp = false.obs;
  Future<void> verifyApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    isVerified.value = true;

    // print("push_token===${prefs.getString('PUSH_TOKEN').toString()}");

    String deviceId = await Constants().getId() ?? '';
    Api().call(
        url: ApiConstants.verifyUrl,
        params: {"MobileNumber": widget.phoneNumber!, "emailAddress": widget.email!, "otp": loginController.otpController.value.text, "device_id": deviceId, "device_name": "test", "osversion": 1, "push_token": prefs.getString('PUSH_TOKEN').toString()},
        error: (data) {
          setState(() {
            isWorngOtp.value = true;
          });
        },
        isProgressShow: true,
        success: (data) {
          VerifyModel model = VerifyModel.fromJson(data);
          print("sdfsdfdsfdf==${model.userDetails?.toJson()}");

          storage.write("user", jsonEncode(model.userDetails?.toJson()));
          storage.write(ApiConfig.loginToken, model.token);
          isVerified.value = false;

          registeredSip();
          if (commonSizeForDesktop(Get.context)) {
            Get.to(() => const DesktopScreen());
            print("");
          } else {
            Get.to(() => const RestoreScreen());
          }
          // Get.offAll(() => DashboardScreen(
          //       // isOk: true,
          //       // email: widget.email,
          //       // number: widget.phoneNumber,
          //     ));
        });
  }
}
