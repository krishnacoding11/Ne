import 'dart:io';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/presentation/screen/caller/call_screen.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/controller/dashboard_controller.dart';
import 'package:neoxapp/presentation/controller/login_controller.dart';
import 'package:neoxapp/presentation/screen/dashboard/model/contact_info_model.dart';
import 'package:neoxapp/presentation/screen/dashboard/model/detail_model.dart';
import 'package:neoxapp/presentation/screen/dashboard/model/sub_detail_model.dart';
import 'package:neoxapp/presentation/screen/dialpad/dial_pad.dart';
import 'package:neoxapp/presentation/widgets/globle.dart';
import 'package:sip_ua/sip_ua.dart';
import 'package:neoxapp/presentation/widgets/globle.dart' as globals;
import 'package:tuple/tuple.dart';
import '../../../../core/widget.dart';
import '../../../../generated/l10n.dart';

import '../../controller/dialer_controller.dart';
import '../../widgets/custom_image_view.dart';
import 'package:flutter/cupertino.dart';

class DetailScreen extends StatefulWidget {
  final ContactInfo? contactInfo;
  final Function(ContactInfo)? callFunction;

  const DetailScreen({super.key, this.contactInfo, this.callFunction});

  @override
  State<DetailScreen> createState() => _StateDetailScreen();
}

class _StateDetailScreen extends State<DetailScreen> {
  DialerController dialerController = Get.put(DialerController());
  DashboardController dashboardController = Get.put(DashboardController());
  ContactInfo model = ContactInfo(name: '', number: [], contactImage: mainUrl + "");
  List Numbers = [];
  List numbers1 = [];

  @override
  void initState() {
    super.initState();
    model = (widget.contactInfo ?? ContactInfo(name: '', number: []));

    model.number!.forEach((element) {
      Numbers.add(element.value!.replaceAll(new RegExp(r"\s+\b|\b\s"), "").toString());
    });
    numbers1 = Numbers.toSet().toList();
    print(" numbers $numbers1");
  }

  RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - 100 - 270) / 5;
    final double itemWidth = size.width / 2;
    final getStorage = GetStorage();

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        body: GetBuilder(
          builder: (controller) => Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Constants.assetPath + (commonSizeForDesktop(context) ? "details_background.png" : "detail_bg.png")), fit: BoxFit.fill)),
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomImageView(svgPath: 'app_bar_icon.svg', height: 24, onTap: () => Get.back(), color: Colors.white),
                            InkWell(
                                onTap: () async {
                                  try {
                                    isLoading.value = true;
                                    controller.update();
                                    Contact tempContact = Contact();
                                    dashboardController.tempContacts.forEach((element) {
                                      if (element.displayName == model.name) {
                                        tempContact = element;
                                      }
                                    });

                                    Contact contact = await ContactsService.openExistingContact(tempContact);
                                    isLoading.value = false;
                                    model = ContactInfo(number: contact.phones, name: contact.displayName ?? "", img: contact.avatar, id: model.id, bgColor: model.bgColor, firstletter: contact.middleName, iconData: model.iconData, namePinyin: model.namePinyin, tagIndex: model.tagIndex);
                                    controller.update();
                                    await dashboardController.getAllContact();
                                  } catch (e) {
                                    isLoading.value = false;
                                    controller.update();
                                  }
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: AppColors.subCardColor,
                                ))
                            // CustomImageView(
                            //   svgPath: 'edit.svg',
                            //   height: 24.h,
                            //   color: Colors.white,
                            //   onTap: () async {
                            //     print("==>>${model.number}");
                            //     print("==>>${model.name}");
                            //     List<Contact> contactList = await ContactsService.getContacts();
                            //     Contact tempContact = Contact();
                            //     contactList.forEach((element) {
                            //       if (element.displayName == model.name) {
                            //         tempContact = element;
                            //       }
                            //     });
                            //     Contact contact = await ContactsService.openExistingContact(tempContact);
                            //     model = ContactInfo(number: (contact.phones?.isEmpty ?? true) ? "" : contact.phones?.first.value, name: contact.displayName ?? "", img: contact.avatar, id: model.id, bgColor: model.bgColor, firstletter: contact.middleName, iconData: model.iconData, namePinyin: model.namePinyin, tagIndex: model.tagIndex);
                            //
                            //     dashboardController.getAllContact();
                            //   },
                            // )
                          ],
                        ),
                      ).marginSymmetric(horizontal: 32),
                      model.contactImage == null
                          ? model.img == null
                              ? Container(height: 80, width: 80, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xffEBF0FF), shape: BoxShape.circle), child: getCustomFont(Constants.split(model.name), 12, AppColors.primaryColor, 1, fontWeight: FontWeight.w400))
                              : ClipOval(
                                  child: CustomImageView(
                                    height: 80,
                                    width: 80,
                                    memory: model.img,
                                    errorWidget: Container(height: 80, width: 80, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xffEBF0FF), shape: BoxShape.circle), child: getCustomFont(Constants.split(model.name), 12, AppColors.primaryColor, 1, fontWeight: FontWeight.w400)),
                                  ),
                                ).marginOnly(top: 20)
                          :

                          //todo : pass contact image url : 05-02-2024-9:25
                          ClipOval(
                              child: CustomImageView(
                                height: 80,
                                width: 80,
                                url: mainUrl + (model.contactImage!),
                                errorWidget: Container(height: 80, width: 80, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xffEBF0FF), shape: BoxShape.circle), child: getCustomFont(Constants.split(model.name), 12, AppColors.primaryColor, 1, fontWeight: FontWeight.w400)),
                              ),
                            ).marginOnly(top: 20),
                      getCustomFont(
                        model.name,
                        26,
                        Colors.white,
                        1,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      SizedBox(
                        width: commonSizeForDesktop(context) ? 700 : null,
                        child: ListView.separated(
                          itemCount: numbers1.length ?? 0,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return (numbers1.length == 1)
                                ? Container(
                                    padding: const EdgeInsets.only(left: 15, right: 10, bottom: 10),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          getCustomFont(
                                            numbers1[index] ?? "",
                                            18,
                                            Colors.white,
                                            1,
                                            fontWeight: FontWeight.w400,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              getCallButton(
                                                  icon: 'call.svg',
                                                  function: () async {
                                                    await registeredSip();
                                                    overlayScreen?.closeAll();

                                                    try {
                                                      if (globals.isStartedTime) {
                                                        if (globals.callglobalObj != null) {
                                                          globals.callglobalObj?.hold();
                                                        }
                                                      }
                                                      print("CallScreen==${onCallContactInfo}");


                                                      if (onCallContactInfo!=null) {

                                                        print("CallScreen222==${numbers1[index]}");

                                                        if (numbers1[index].isNotEmpty ?? false) {
                                                          print("CallScreen333==${numbers1[index]}");

                                                          SIPUAHelper helperObj = (globals.helper ?? SIPUAHelper());

                                                          Map<String, dynamic> customOptions = {
                                                            'X-sourceNumber': '+919033586521',
                                                            'X-callType': 1,
                                                          };
                                                          print("CallScreen==${numbers1[index]?.isNotEmpty}");

                                                          await helperObj.call("91${numbers1[index]}" ?? "", voiceonly: true, customOptions: customOptions, mediaStream: null);
                                                          if (commonSizeForDesktop(context)) {
                                                            if (widget.callFunction != null) {
                                                              widget.callFunction!(widget.contactInfo ?? ContactInfo(name: "Unknown", number: []));
                                                            }
                                                          } else {
                                                            contactList.add(onCallContactInfo!);
                                                            contactList.add(widget.contactInfo!);
                                                            Get.to(
                                                                CallScreen(
                                                                  contactInfo: widget.contactInfo,
                                                                  calling: (widget.contactInfo?.number?.isEmpty ?? true) ? numbers1[index] : widget.contactInfo?.number?[0].value,
                                                                  callerName: (widget.contactInfo?.name.isEmpty ?? true) ? "Unknown" : widget.contactInfo?.name,
                                                                  callObj: globals.callglobalObj,
                                                                  isHold: true,
                                                                  tuple5: Tuple2(onCallContactInfo,numbers1[index]),
                                                                ),
                                                                arguments: {"name": (widget.contactInfo?.name.isEmpty ?? true) ? "Unknown" : widget.contactInfo?.name});
                                                          }
                                                        }
                                                      } else {
                                                        try {
                                                          if (numbers1[index]?.isNotEmpty ?? false) {
                                                            SIPUAHelper helperObj = (globals.helper ?? SIPUAHelper());
                                                            await helperObj.call("91${numbers1[index]}" ?? "", voiceonly: true, mediaStream: null);
                                                            if (commonSizeForDesktop(context)) {
                                                              if (widget.callFunction != null) {
                                                                widget.callFunction!(widget.contactInfo ?? ContactInfo(name: "Unknown", number: []));
                                                              }
                                                            } else {
                                                              Get.to(
                                                                  CallScreen(
                                                                    contactInfo: widget.contactInfo,
                                                                    calling: (widget.contactInfo?.number?.isEmpty ?? true) ? numbers1[index] : widget.contactInfo?.number?[0].value,
                                                                    callerName: (widget.contactInfo?.name.isEmpty ?? true) ? "Unknown" : widget.contactInfo?.name,
                                                                    callObj: globals.callglobalObj,
                                                                  ),
                                                                  arguments: {"name": (widget.contactInfo?.name.isEmpty ?? true) ? "Unknown" : widget.contactInfo?.name});
                                                            }
                                                          }
                                                        } catch (e) {
                                                          print("=====>>>$e");
                                                        }
                                                      }

                                                      print("i==${globals.isStartedTime}");
                                                    } catch (e) {
                                                      print("=====>>> $e");
                                                    }

                                                    // try {
                                                    //   if (numbers1[index]?.isNotEmpty ?? false) {
                                                    //     SIPUAHelper helperObj = (globals.helper ?? SIPUAHelper());
                                                    //     await helperObj.call("91$numbers1[index]" ?? "", voiceonly: true, mediaStream: null);
                                                    //     if (commonSizeForDesktop(context)) {
                                                    //       if (widget.callFunction != null) {
                                                    //         widget.callFunction!(widget.contactInfo ?? ContactInfo(name: "Unknown", number: []));
                                                    //       }
                                                    //     } else {
                                                    //       Get.to(
                                                    //           CallScreen(
                                                    //             contactInfo: widget.contactInfo,
                                                    //             calling: (widget.contactInfo?.number?.isEmpty ?? true) ? numbers1[index] : widget.contactInfo?.number?[0].value,
                                                    //             callerName: (widget.contactInfo?.name.isEmpty ?? true) ? "Unknown" : widget.contactInfo?.name,
                                                    //             callObj: globals.callglobalObj,
                                                    //           ),
                                                    //           arguments: {"name": (widget.contactInfo?.name.isEmpty ?? true) ? "Unknown" : widget.contactInfo?.name});
                                                    //     }
                                                    //   }
                                                    // } catch (e) {
                                                    //   print("=====>>>$e");
                                                    // }
                                                  }),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              getCallButton(icon: 'chat.svg', function: () {}),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              getCallButton(icon: 'star.svg', function: () {}, color: Colors.white),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.only(left: 15, right: 10, bottom: 10),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 10),
                                          getCustomFont(
                                            numbers1?[index] ?? "",
                                            17,
                                            Colors.white,
                                            1,
                                            fontWeight: FontWeight.w400,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const Spacer(),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              getCallButton(icon: 'call.svg', function: () {

                                              }
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              getCallButton(icon: 'chat.svg', function: () {}),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              getCallButton(icon: 'star.svg', function: () {}, color: Colors.white),
                                            ],
                                          ),
                                          const SizedBox(width: 20),
                                        ],
                                      ),
                                    ),
                                  );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Divider(
                                color: AppColors.primaryColor,
                              ),
                            );
                          },
                        ),
                      ),

                      // SizedBox(
                      //   height: 32.h,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     getCallButton(icon: 'call.svg', function: () {}),
                      //     SizedBox(
                      //       width: 32.h,
                      //     ),
                      //     getCallButton(icon: 'chat.svg', function: () {}),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 32,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            clipBehavior: Clip.antiAlias,
                            padding: const EdgeInsets.only(bottom: 20),
                            decoration: ShapeDecoration(
                              color: AppColors.getCardColor(context),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(commonSizeForDesktop(context) ? 0 : 32), topLeft: Radius.circular(commonSizeForDesktop(context) ? 0 : 32)),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: SizedBox(
                                    width: commonSizeForDesktop(context) ? 700 : MediaQuery.of(context).size.width,
                                    child: Stack(
                                      children: [
                                        ListView.builder(
                                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              DetailModel detailModel = getDetails()[index];

                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  getCustomFont(
                                                    detailModel.name,
                                                    16,
                                                    AppColors.getFontColor(context),
                                                    1,
                                                    fontWeight: FontWeight.w700,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    itemBuilder: (context, index) {
                                                      SubDetailModel subDetailModel = detailModel.list[index];

                                                      return Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          Row(
                                                            children: [
                                                              CustomImageView(
                                                                height: 14,
                                                                width: 14,
                                                                svgPath: 'call_incoming.svg',
                                                                color: subDetailModel.status == 1
                                                                    ? AppColors.primaryColor
                                                                    : subDetailModel.status == 0
                                                                        ? AppColors.greenColor
                                                                        : const Color(
                                                                            0xff91ADFF,
                                                                          ),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Expanded(
                                                                child: getCustomFont(
                                                                  subDetailModel.status == 0 ? S.of(context).outgoingCall : S.of(context).incomingCall,
                                                                  14,
                                                                  AppColors.getFontColor(context),
                                                                  1,
                                                                  fontWeight: FontWeight.w600,
                                                                  textAlign: TextAlign.start,
                                                                ),
                                                              ),
                                                              getCustomFont(
                                                                subDetailModel.time,
                                                                13,
                                                                AppColors.getFontColor(context),
                                                                1,
                                                                fontWeight: FontWeight.w600,
                                                                textAlign: TextAlign.start,
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              getCustomFont(
                                                                subDetailModel.duration,
                                                                14,
                                                                AppColors.getSubFontColor(context),
                                                                1,
                                                                fontWeight: FontWeight.w400,
                                                                textAlign: TextAlign.start,
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          Container(
                                                            height: 1,
                                                            color: themeController.isDarkMode ? const Color(0xff757A84) : const Color(0xffF4F4F5),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                    // separatorBuilder: (context, index) => Container(
                                                    //   height: 1,
                                                    //   color: Color(0xffF4F4F5),
                                                    // ),
                                                    itemCount: detailModel.list.length,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                  )
                                                ],
                                              ).marginOnly(bottom: 40);
                                            },
                                            itemCount: getDetails().length),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              // getCell(S.of(context).addToFavourite, 'fav.svg', Color(0xff1B47C5), Color(0xffEBF0FF)),

                                              getCell(S.of(context).deleteContact, 'delete.svg', const Color(0xffB20000), const Color(0xffFFE0E0), onTap: () async {
                                                isLoading.value = true;
                                                controller.update();
                                                List<Contact> contactList = await ContactsService.getContacts();
                                                Contact tempContact = Contact();
                                                contactList.forEach((element) {
                                                  if (element.displayName == model.name) {
                                                    tempContact = element;
                                                  }
                                                });

                                                await ContactsService.deleteContact(tempContact);
                                                // model = ContactInfo(number: contact.phones?.map((e) => e.value ?? "").toList(), name: contact.displayName ?? "", img: contact.avatar, id: model.id, bgColor: model.bgColor, firstletter: contact.middleName, iconData: model.iconData, namePinyin: model.namePinyin, tagIndex: model.tagIndex);
                                                controller.update();
                                                await dashboardController.getAllContact();
                                                isLoading.value = false;
                                                Get.back();
                                              })
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                  isLoading.value
                      ? Container(
                          height: MediaQuery.of(context).size.height,
                          color: AppColors.statusBarColor.withOpacity(0.4),
                          child: const Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
          init: DialerController(),
        ),
      ),
    );
  }

  getCallButton({required String icon, required Function function, Color? color, Color? iconColor}) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
        height: 45,
        width: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color ?? const Color(0xff6487ED)),
        child: CustomImageView(
          svgPath: icon,
          color: iconColor,
          height: 22,
        ),
      ),
    );
  }

  getCell(String title, String icon, Color iconColor, Color bgColor, {Function()? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(100)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              CustomImageView(
                svgPath: icon,
              ),
              const SizedBox(
                width: 10,
              ),
              getCustomFont(
                title,
                14,
                iconColor,
                1,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
            ],
          )),
    );
  }
}

List<DetailModel> getDetails() {
  return [
    DetailModel(name: 'Call logs', list: [
      SubDetailModel(duration: '2:32 min', time: '6:37 pm', status: 0),
    ]),
    DetailModel(name: 'Yesterday', list: [
      SubDetailModel(duration: '2:32 min', time: '6:37 pm', status: 1),
      SubDetailModel(duration: '2:32 min', time: '6:37 pm', status: 0),
    ]),
    DetailModel(name: '01 December 2023', list: [
      SubDetailModel(duration: '2:32 min', time: '6:37 pm', status: 1),
      SubDetailModel(duration: '2:32 min', time: '6:37 pm', status: 1),
    ]),
  ];
}
