import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:neoxapp/api/ApiServices.dart';
import 'package:neoxapp/core/api_constant.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:neoxapp/presentation/screen/dashboard/dashboard_page.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/presentation/screen/login/model/verify_model.dart';
import '../../../../core/constants.dart';
import '../../../../core/theme_color.dart';
import '../../../../generated/l10n.dart';
import '../../../controller/login_controller.dart';
import '../../../widgets/custom_image_view.dart';

class LoginScreenAutoProvisioning extends StatefulWidget {
  const LoginScreenAutoProvisioning({Key? key}) : super(key: key);

  @override
  State<LoginScreenAutoProvisioning> createState() => _LoginScreenAutoProvisioningState();
}

class _LoginScreenAutoProvisioningState extends State<LoginScreenAutoProvisioning> {
  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (BuildContext, bool isKeyboardVisible) {
        return Scaffold(
          // extendBodyBehindAppBar: true,
          // appBar: AppBar(
          //   backgroundColor: Colors.transparent,
          // ),
          body: Container(
            height: Get.height,
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Constants.assetPath + (commonSizeForDesktop(context) ? "appbackgroud.png" : "bg.png")), fit: BoxFit.fill)),
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 100),
                          child: CustomImageView(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            imagePath: "${Constants.assetPath}logo_3.png",
                            height: 75,
                            alignment: Alignment.topCenter,
                          )),
                      Container(
                        height: 350,
                        width: commonSizeForDesktop(context) ? 500 : null,
                        margin: const EdgeInsets.only(bottom: 87, top: 72),
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(color: AppColors.getCardColor(context), borderRadius: BorderRadius.circular(32)),
                        child: SingleChildScrollView(
                          physics: commonSizeForDesktop(context) ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
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
                                textEditingController: loginController.autoProvisioningUrlController.value,
                                prefix: true,
                                prefixIcon: 'mail.svg',
                                hint: S.of(context).emailProvisioning,
                                context: context,
                                onChanged: (value) {
                                  loginController.autoProvisioningUrlController.refresh();
                                },
                              ),
                              getVerSpace(20),
                              StreamBuilder(
                                  stream: loginController.autoProvisioningUrlController.stream,
                                  builder: (context, snapshot) {
                                    return getButton(context, (loginController.autoProvisioningUrlController.value.text.isNotEmpty) ? AppColors.primaryColor : AppColors.primaryColor.withOpacity(0.4), S.of(context).signIn, Colors.white, () {
                                      if (loginController.autoProvisioningUrlController.value.text.isNotEmpty) {
                                        loginLinkApi(link: loginController.autoProvisioningUrlController.value.text);
                                        // loginController.checkAutoProvisioningUrl();
                                      }
                                    }, 16, weight: FontWeight.w400);
                                  }),
                              getVerSpace(20),
                              SizedBox(height: isKeyboardVisible ? 80 : 0),
                              getVerSpace(40),
                            ],
                          ),
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
      },
    );
  }

  Future<void> loginLinkApi({
    String? link,
  }) async {
    String deviceId = await Constants().getId() ?? '';
    Api().call(
        url: ApiConstants.linkUrlLogin,
        params: {"fqdntoken": link, "device_id": deviceId, "device_name": "test", "osversion": "android"},
        success: (data) {
          VerifyModel model = VerifyModel.fromJson(data);
          if (commonSizeForDesktop(Get.context)) {
            Get.to(() => const DesktopScreen());
          } else {
            Get.to(() => const DashboardScreen());
          }
        });
  }
}
