import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/controller/login_controller.dart';
import 'package:sip_ua/sip_ua.dart';
import '../../../core/widget.dart';
import '../../../generated/l10n.dart';
import '../../widgets/custom_image_view.dart';

class _StateLoginScreen extends State<LoginScreen> implements SipUaHelperListener {
  LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SIPUAHelper helper = SIPUAHelper();
    if (helper.registered) {
      registeredSip();
    }

    helper.addSipUaHelperListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Constants.assetPath + "bg.png"), fit: BoxFit.fill)),
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: CustomImageView(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    imagePath: "${Constants.assetPath}neox.png",
                    height: 35,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 87, top: 72),
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(color: AppColors.getCardColor(context), borderRadius: BorderRadius.circular(32)),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
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
                          textEditingController: loginController.emailController.value,
                          prefix: true,
                          prefixIcon: 'mail.svg',
                          hint: S.of(context).emailOrUsername,
                          context: context,
                          onChanged: (value) {
                            loginController.emailController.refresh();
                          }),
                      getVerSpace(15),
                      ObxValue(
                        (p0) => getTextFiled(
                            textEditingController: loginController.passwordController.value,
                            prefix: true,
                            prefixIcon: 'lock.svg',
                            hint: S.of(context).password,
                            context: context,
                            suffixIcon: 'eye.svg',
                            suffix: true,
                            obscureText: loginController.isShow.value,
                            function: () {
                              loginController.isShow.value = !loginController.isShow.value;
                            },
                            onChanged: (value) {
                              loginController.emailController.refresh();
                            }),
                        loginController.isShow,
                      ),
                      getVerSpace(16),
                      getMultilineCustomFont(S.of(context).forgotPassword, 14, themeController.isDarkMode ? Color(0xff91ADFF) : AppColors.primaryColor, fontWeight: FontWeight.w600, textAlign: TextAlign.start, fontFamily: Constants.fontLato).marginOnly(left: 16),
                      getVerSpace(30),
                      StreamBuilder(
                          stream: loginController.emailController.stream,
                          builder: (context, snapshot) {
                            return Stack(
                              children: [
                                getButton(context, AppColors.subCardColor, '', Colors.white, () {}, 16, weight: FontWeight.w400),
                                getButton(context, (loginController.emailController.value.text.isNotEmpty && loginController.passwordController.value.text.isNotEmpty) ? AppColors.primaryColor : AppColors.primaryColor.withOpacity(0.4), S.of(context).signIn, Colors.white, () {
                                  // loginController.registeredSip();
                                  if ((loginController.emailController.value.text.isNotEmpty && loginController.passwordController.value.text.isNotEmpty)) {
                                    loginController.checkEmailOrPassword();
                                  }

                                  // Constants.sendToNext(Routes.dashboardScreen);
                                }, 16, weight: FontWeight.w400),
                              ],
                            );
                          }),
                      getVerSpace(30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          getMultilineCustomFont(S.of(context).dontHaveAnAccount, 14, AppColors.getSubFontColor(context), fontWeight: FontWeight.w400, textAlign: TextAlign.center, fontFamily: Constants.fontLato),
                          getHorSpace(5),
                          getMultilineCustomFont(S.of(context).createNow, 16, themeController.isDarkMode ? Color(0xff91ADFF) : AppColors.primaryColor, fontWeight: FontWeight.w400, textAlign: TextAlign.center, fontFamily: Constants.fontLato),
                          getHorSpace(5),
                          CustomImageView(
                            svgPath: "icons.svg",
                            height: 20,
                          ),
                        ],
                      )
                    ],
                  ),
                ).marginSymmetric(horizontal: 16),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () => exit(0),
    );
  }

  bool emailValid(email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  @override
  void callStateChanged(Call call, CallState state) {
    // TODO: implement callStateChanged
  }

  @override
  void onNewMessage(SIPMessageRequest msg) {
    print("regisrerd===msg");
    // TODO: implement onNewMessage
  }

  @override
  void onNewNotify(Notify ntf) {
    // TODO: implement onNewNotify

    print("regisrerd===ntf");
  }

  @override
  void registrationStateChanged(RegistrationState state) {
    // TODO: implement registrationStateChanged

    print("regisrerd===true");
  }

  @override
  void transportStateChanged(TransportState state) {
    print("regisrerd===state");
    // TODO: implement transportStateChanged
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _StateLoginScreen();
}
