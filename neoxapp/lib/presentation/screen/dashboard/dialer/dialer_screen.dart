import 'dart:io';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/presentation/screen/desktop/dailer_destopscreen.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/controller/dashboard_controller.dart';
import 'package:neoxapp/presentation/screen/dashboard/model/contact_info_model.dart';
import 'package:neoxapp/presentation/screen/dialpad/dial_pad.dart';
import '../../../../core/widget.dart';
import '../../../../generated/l10n.dart';
import '../../../controller/dialer_controller.dart';
import '../../../widgets/custom_image_view.dart';

class DialerScreen extends StatefulWidget {
  final Function(ContactInfo)? callFunction;
  const DialerScreen({super.key, this.callFunction});

  @override
  State<DialerScreen> createState() => _StateDialerScreen();
}

class _StateDialerScreen extends State<DialerScreen> {
  DialerController dialerController = Get.put(DialerController());
  DashboardController dashboardController = Get.put(DashboardController());
  Rx<ContactInfo> selectNumberDetails = ContactInfo(name: Platform.isWindows ? 'asdasd' : "", number: []).obs;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: themeController.isDarkMode ? Colors.black : Colors.white, statusBarBrightness: themeController.isDarkMode ? Brightness.light : Brightness.dark, statusBarIconBrightness: themeController.isDarkMode ? Brightness.light : Brightness.dark));
    return SafeArea(
      child: GetBuilder(
        builder: (controller) => Container(
          decoration: (MediaQuery.of(context).size.width < 450) ? BoxDecoration(image: DecorationImage(image: AssetImage(themeController.isDarkMode ? Constants.assetPath + "dark_dashboard.png" : Constants.assetPath + "history_bg.png"), fit: BoxFit.fill)) : null,
          child: Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StreamBuilder(
                      stream: selectNumberDetails.stream,
                      builder: (context, snapshot) {
                        return getCustomFont(
                          selectNumberDetails.value.name ?? "",
                          16,
                          AppColors.getFontColor(context),
                          1,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                        ).paddingOnly(top: 20);
                      }),
                  Center(
                    child: SizedBox(
                      child: getDialerTextFiled(
                        textEditingController: controller.textEditingController,
                        context: context,
                        hint: '',
                        suffixIcon: controller.textEditingController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  if (controller.textEditingController.text.isNotEmpty) {
                                    controller.textEditingController.text = controller.textEditingController.text.substring(0, controller.textEditingController.text.length - 1);
                                  }
                                  bool isSelect = false;
                                  if (controller.textEditingController.text.length <= 11) {
                                    for (var element in dashboardController.contacts) {
                                      for (var number in element.number?.map((e) => e.value).toList() ?? []) {
                                        if (number.contains(controller.textEditingController.text)) {
                                          selectNumberDetails.value.name = element.name;
                                          selectNumberDetails.value.namePinyin = element.namePinyin;
                                          selectNumberDetails.value.number = [Item(value: number)];
                                          selectNumberDetails.value.tagIndex = element.tagIndex;
                                          selectNumberDetails.value.img = element.img;
                                          selectNumberDetails.value.bgColor = element.bgColor;
                                          selectNumberDetails.refresh();
                                          isSelect = true;
                                          break;
                                        } else {
                                          if (!isSelect || controller.textEditingController.text.isEmpty) {
                                            selectNumberDetails.value = ContactInfo(name: '', number: []);
                                          }
                                        }
                                      }
                                    }
                                  } else {
                                    if (controller.textEditingController.text.isEmpty) {
                                      selectNumberDetails.value = ContactInfo(name: '', number: []);
                                    }
                                  }
                                  if (controller.textEditingController.text.isEmpty) {
                                    selectNumberDetails.value = ContactInfo(name: '', number: []);
                                  }
                                  controller.update();
                                },
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  color: Colors.transparent,
                                  width: 25.5,
                                  margin: const EdgeInsets.only(right: 50, top: 10),
                                  child: CustomImageView(
                                    svgPath: 'back.svg',
                                    onTap: null,
                                    height: 25,
                                    color: AppColors.getFontColor(context),
                                    width: 25,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ).paddingOnly(top: 0),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    children: [
                      if (!Platform.isWindows)
                        Expanded(
                          child: getCell(S.of(context).addNumber, 'add.svg', () async {
                            Contact contact = await ContactsService.openContactForm();
                            dashboardController.contacts.add(ContactInfo(
                              number: contact.phones,
                              name: contact.displayName ?? "",
                              img: contact.avatar,
                              firstletter: contact.middleName,
                            ));
                          }),
                        ),
                      Expanded(child: getCell(S.of(context).sendMessage, 'send.svg', () {})),
                    ],
                  ).paddingOnly(bottom: Platform.isWindows ? 50 : 35),
                ],
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  clipBehavior: Clip.antiAlias,
                  padding: const EdgeInsets.only(bottom: 40),
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(-0.00, -1.00),
                      end: Alignment(0, 1),
                      colors: [Color(0xFF648CFF), Color(0xFF1B47C5)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(MediaQuery.of(context).size.width > 450 ? 0 : 32), topLeft: Radius.circular(MediaQuery.of(context).size.width > 450 ? 0 : 32)),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          // width:  MediaQuery.of(context).size.width > 500 ? 500 : MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(right: MediaQuery.of(context).size.width > 450 ? 50 : 0, top: MediaQuery.of(context).size.width > 450 ? 50 : 0),
                          width: MediaQuery.of(context).size.width > 450 ? 390 : MediaQuery.of(context).size.width,
                          child: Center(
                            child: DialPad(
                              (p0) {
                                setState(() {
                                  bool isSelect = false;
                                  controller.textEditingController.text = controller.textEditingController.text + p0;
                                  desktopNumber = controller.textEditingController.text;
                                  if (controller.textEditingController.text.length <= 11) {
                                    for (var element in dashboardController.contacts) {
                                      for (var number in element.number?.map((e) => e.value).toList() ?? []) {
                                        if (number.contains(controller.textEditingController.text)) {
                                          selectNumberDetails.value.name = element.name;
                                          selectNumberDetails.value.namePinyin = element.namePinyin;
                                          selectNumberDetails.value.number = [number];
                                          selectNumberDetails.value.img = element.img;
                                          selectNumberDetails.value.tagIndex = element.tagIndex;
                                          selectNumberDetails.value.bgColor = element.bgColor;
                                          selectNumberDetails.refresh();
                                          isSelect = true;
                                          break;
                                        } else {
                                          if (!isSelect) {
                                            selectNumberDetails.value = ContactInfo(name: '', number: []);
                                          }
                                        }
                                      }
                                    }
                                  } else {
                                    if (!isSelect) {
                                      selectNumberDetails.value = ContactInfo(name: '', number: []);
                                    }
                                  }
                                  controller.update();
                                });
                              },
                              contactInfo: selectNumberDetails.value,
                              number: controller.textEditingController.text,
                              callFunction: (callValue) {
                                if (widget.callFunction != null) {
                                  widget.callFunction!(callValue);
                                }
                              },
                              onLongPress: () {
                                if (controller.textEditingController.text.isNotEmpty) {
                                  controller.textEditingController.text = '';
                                  controller.update();
                                }
                              },
                              tapRemove: () {
                                if (controller.textEditingController.text.isNotEmpty) {
                                  controller.textEditingController.text = controller.textEditingController.text.substring(0, controller.textEditingController.text.length - 1);
                                }
                                bool isSelect = false;
                                if (controller.textEditingController.text.length <= 11) {
                                  for (var element in dashboardController.contacts) {
                                    for (var number in element.number ?? []) {
                                      if (number.contains(controller.textEditingController.text)) {
                                        selectNumberDetails.value.name = element.name;
                                        selectNumberDetails.value.namePinyin = element.namePinyin;
                                        selectNumberDetails.value.number = [number];
                                        selectNumberDetails.value.tagIndex = element.tagIndex;
                                        selectNumberDetails.value.img = element.img;
                                        selectNumberDetails.value.bgColor = element.bgColor;
                                        selectNumberDetails.refresh();
                                        isSelect = true;
                                        break;
                                      } else {
                                        if (!isSelect || controller.textEditingController.text.isEmpty) {
                                          selectNumberDetails.value = ContactInfo(name: '', number: []);
                                        }
                                      }
                                    }
                                  }
                                } else {
                                  if (controller.textEditingController.text.isEmpty) {
                                    selectNumberDetails.value = ContactInfo(name: '', number: []);
                                  }
                                }
                                if (controller.textEditingController.text.isEmpty) {
                                  selectNumberDetails.value = ContactInfo(name: '', number: []);
                                }
                                controller.update();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        init: DialerController(),
      ),
    );
  }

  Widget getCell(String title, String image, Function function) {
    Color color = themeController.isDarkMode ? Colors.white : AppColors.primaryColor;
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomImageView(
            svgPath: image,
            height: 16,
            color: color,
          ),
          getHorSpace(5),
          getCustomFont(
            title,
            14,
            color,
            1,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget dailTextFiledView(controller) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 450 ? 450 : MediaQuery.of(context).size.width,
      child: Expanded(
        child: getDialerTextFiled(
          textEditingController: controller.textEditingController,
          context: context,
          hint: '',
          suffixIcon: controller.textEditingController.text.isNotEmpty
              ? InkWell(
                  onTap: () {
                    if (controller.textEditingController.text.isNotEmpty) {
                      controller.textEditingController.text = controller.textEditingController.text.substring(0, controller.textEditingController.text.length - 1);
                    }
                    bool isSelect = false;
                    if (controller.textEditingController.text.length <= 11) {
                      for (var element in dashboardController.contacts) {
                        for (var number in element.number ?? []) {
                          if (number.contains(controller.textEditingController.text)) {
                            selectNumberDetails.value.name = element.name;
                            selectNumberDetails.value.namePinyin = element.namePinyin;
                            selectNumberDetails.value.number = [number];
                            selectNumberDetails.value.tagIndex = element.tagIndex;
                            selectNumberDetails.value.img = element.img;
                            selectNumberDetails.value.bgColor = element.bgColor;
                            selectNumberDetails.refresh();
                            isSelect = true;
                            break;
                          } else {
                            if (!isSelect || controller.textEditingController.text.isEmpty) {
                              selectNumberDetails.value = ContactInfo(name: '', number: []);
                            }
                          }
                        }
                      }
                    } else {
                      if (controller.textEditingController.text.isEmpty) {
                        selectNumberDetails.value = ContactInfo(name: '', number: []);
                      }
                    }
                    if (controller.textEditingController.text.isEmpty) {
                      selectNumberDetails.value = ContactInfo(name: '', number: []);
                    }
                    controller.update();
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.transparent,
                    width: 25.5,
                    margin: const EdgeInsets.only(right: 50, top: 10),
                    child: CustomImageView(
                      svgPath: 'back.svg',
                      onTap: null,
                      height: 25,
                      color: AppColors.getFontColor(context),
                      width: 25,
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
