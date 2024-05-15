import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/controller/login_controller.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import '../../../../api/ApiServices.dart';
import '../../../../core/api_constant.dart';
import '../../../../core/widget.dart';
import '../../../../generated/l10n.dart';
import '../../../widgets/custom_image_view.dart';
import '../login_option.dart';
import 'manual_provisioning_verify_screen.dart';

class ManualProvisioningScreen extends StatefulWidget {
  final bool? isOk;
  final String? number;
  final String? email;
  const ManualProvisioningScreen({super.key, this.isOk = false, this.email, this.number});

  @override
  State<ManualProvisioningScreen> createState() => _ManualProvisioningScreenState();
}

class _ManualProvisioningScreenState extends State<ManualProvisioningScreen> {
  LoginController loginController = Get.put(LoginController());
  ScrollController scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isOk ?? false) {
      loginController.manualProvisioningEmailController.value.text = widget.email ?? "";
      loginController.manualProvisioningPasswordController.value.text = widget.number ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return KeyboardVisibilityBuilder(
      builder: (BuildContext, bool isKeyboardVisible) {
        return Scaffold(
          body: Container(
            height: Get.height,
            // decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Constants.assetPath + (commonSizeForDesktop(context) ? "appbackgroud.png" : "bg.png")), fit: BoxFit.fill)),
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
                    children: [
                      // GestureDetector(onTap: (){
                      //   Get.off(()=>LoginOptionScreen());
                      // },
                      //     child: Container(
                      //       width: 100,
                      //       height: 25,
                      //       child:Row(
                      //         crossAxisAlignment:CrossAxisAlignment.start ,
                      //         children: [
                      //           Icon(Icons.arrow_back_ios_rounded,color: Colors.white),
                      //           SizedBox(width: 10),
                      //           Text("Back"),
                      //         ],
                      //       ),
                      //     )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1 + MediaQuery.of(context).size.height * 0.05),
                              child: CustomImageView(
                                onTap: () {},
                                imagePath: "${Constants.assetPath}logo_3.png",
                                height: MediaQuery.of(context).size.height * 0.09,
                                alignment: Alignment.topCenter,
                              )),
                          Container(
                            width: commonSizeForDesktop(context) ? 500 : double.infinity,
                            height: height * 0.6 - height * 0.02,
                            margin: EdgeInsets.only(bottom: height * 0.09, top: height * 0.09),
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            decoration: BoxDecoration(color: AppColors.getCardColor(context), borderRadius: BorderRadius.circular(32)),
                            child: ListView(
                              physics: commonSizeForDesktop(context) ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              children: [
                                getVerSpace(height * 0.02),
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
                                SingleChildScrollView(
                                    controller: scrollController,
                                    child: Column(
                                      children: [
                                        getTextFiled(
                                            textEditingController: loginController.manualProvisioningEmailController.value,
                                            prefix: true,
                                            prefixIcon: 'mail.svg',
                                            hint: S.of(context).emailID,
                                            keyboardType: TextInputType.emailAddress,
                                            context: context,
                                            onChanged: (value) {
                                              loginController.manualProvisioningEmailController.refresh();
                                            }),
                                        getVerSpace(20),
                                        getTextFiled(
                                            textEditingController: loginController.manualProvisioningPasswordController.value,
                                            prefix: true,
                                            scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20 * 4),
                                            prefixIcon: 'mobile.svg',
                                            keyboardType: TextInputType.phone,
                                            hint: S.of(context).mobileNumber,
                                            context: context,
                                            onChanged: (value) {
                                              loginController.manualProvisioningPasswordController.refresh();
                                            }),
                                      ],
                                    )),
                                getVerSpace(15),
                                (loginController.otpController.value.text.isNotEmpty ?? false)
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [CustomImageView(svgPath: 'success.svg'), const SizedBox(width: 10), getCustomFont("Verify Successfully", 14, AppColors.greenColor, 1)],
                                      )
                                    : const SizedBox.shrink(),
                                getVerSpace(20),
                                StreamBuilder(
                                    stream: loginController.manualProvisioningPasswordController.stream,
                                    builder: (context, snapshot) {
                                      return getButton(context, (loginController.manualProvisioningEmailController.value.text.isNotEmpty /*&&loginController.manualProvisioningPasswordController.value.text.isNotEmpty*/ && (loginController.manualProvisioningPasswordController.value.text.length == 10)) ? AppColors.primaryColor : AppColors.primaryColor.withOpacity(0.4), S.of(context).signIn, Colors.white, () {
                                        // if (widget.isOk ?? false) {
                                        //   if (loginController.manualProvisioningPasswordController.value.text.length == 10) {
                                        //     // Get.to(() => ManualProvisioningVerifyScreen(
                                        //     //       phoneNumber: loginController.manualProvisioningPasswordController.value.text,
                                        //     //       email: loginController.manualProvisioningEmailController.value.text,
                                        //     //     ));
                                        //     if (commonSizeForDesktop(Get.context)) {
                                        //       Get.to(() => const DesktopScreen());
                                        //     } else {
                                        //       Get.to(() => const DashboardScreen());
                                        //     }
                                        //     // loginApi(email: loginController.manualProvisioningEmailController.value.text, mobile: loginController.manualProvisioningPasswordController.value.text);
                                        //   }
                                        // } else {
                                        // Get.to(() => const DashboardScreen());
                                        if ((loginController.manualProvisioningEmailController.value.text.isNotEmpty /*&&loginController.manualProvisioningPasswordController.value.text.isNotEmpty*/ && (loginController.manualProvisioningPasswordController.value.text.length == 10))) {
                                          loginApi(email: loginController.manualProvisioningEmailController.value.text, mobile: loginController.manualProvisioningPasswordController.value.text);
                                        }

                                        // loginController.checkManualProvisioning(email: loginController.manualProvisioningEmailController.value.text, mobile: loginController.manualProvisioningPasswordController.value.text, otp: loginController.otpController.value.text);
                                      }, 16, weight: FontWeight.w400);
                                    }),
                                SizedBox(height: height * 0.03),
                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      getCustomFont(
                                        S.of(context).orLoginUsing,
                                        14,
                                        AppColors.getSubFontColor(context),
                                        1,
                                        fontWeight: FontWeight.w400,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(width: 5),
                                      InkWell(
                                        onTap: () {
                                          Get.to(() => const LoginOptionScreen());
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            getCustomFont(
                                              S.of(context).autoProvisioning,
                                              14,
                                              themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor,
                                              1,
                                              fontWeight: FontWeight.w400,
                                              textAlign: TextAlign.center,
                                            ),
                                            Icon(
                                              Icons.arrow_forward,
                                              color: themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: isKeyboardVisible ? 170 : 0),
                                // getVerSpace(40),
                              ],
                            ),
                          ).marginSymmetric(horizontal: 16),
                        ],
                      ).paddingOnly(bottom: 55),
                    ],
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 16,
                  child: InkWell(
                      onTap: () {
                        Get.offAll(() => LoginOptionScreen());
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

  Future<void> loginApi({
    String? email,
    String? mobile,
  }) async {
    Api().call(
        url: ApiConstants.loginUrl,
        isProgressShow: true,
        params: {"emailAddress": email, "MobileNumber": mobile},
        success: (data) {
          print("dsta==$data");
          // LoginModel model = LoginModel.fromJson(data);

          Get.to(() => ManualProvisioningVerifyScreen(
                phoneNumber: mobile ?? '',
                email: email ?? '',
              ));
        });
  }
}
