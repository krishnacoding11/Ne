import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/controller/call_controller.dart';
import 'package:neoxapp/presentation/screen/caller/call_screen.dart';
import 'package:neoxapp/presentation/screen/dashboard/model/contact_info_model.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/presentation/screen/video_calls/video_call_screen.dart';
import 'package:sip_ua/sip_ua.dart';
import 'package:tuple/tuple.dart';
import '../../../core/theme_color.dart';
import '../../../core/widget.dart';
import '../../widgets/custom_image_view.dart';
import '../dashboard/model/dialer_model.dart';
import 'package:neoxapp/presentation/widgets/globle.dart' as globals;

ContactInfo? onCallContactInfo;
List<ContactInfo> contactList=[];

class DialPad extends StatelessWidget {
  final Function(String) function;
  final Function(ContactInfo)? callFunction;
  final Function? tapRemove;
  final Function? onLongPress;
  final String? number;
  final ContactInfo? contactInfo;

  const DialPad(this.function, {super.key, this.onLongPress, this.tapRemove, this.number, this.contactInfo, this.callFunction});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - 100 - 270) / 5;
    final double itemWidth = size.width / 2;



    return GridView.builder(
      itemCount: getKeyData().length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 15, crossAxisSpacing: 25, mainAxisExtent: (itemHeight / 1.2)),
      itemBuilder: (context, index) {
        DialerModel model = getKeyData()[index];
        if (model.isCall) {
          return GestureDetector(
            onTap: () async {
              // Constants.sendToNext(
              //   Routes.callScreen,
              // );
              // await registeredSip();

              overlayScreen?.closeAll();
              try {
                if (globals.isStartedTime) {
                  if (globals.callglobalObj != null) {
                    globals.callglobalObj?.hold();
                  }
                }
                print("CallScreen==${onCallContactInfo}");


                if (onCallContactInfo!=null) {

                  print("CallScreen222==${number}");

                  if (number?.isNotEmpty ?? false) {
                    print("CallScreen333==${number}");

                    SIPUAHelper helperObj = (globals.helper ?? SIPUAHelper());

                    Map<String, dynamic> customOptions = {
                      'X-sourceNumber': '+919033586521',
                      'X-callType': 1,
                    };
                    print("CallScreen==${number?.isNotEmpty}");

                    await helperObj.call("91$number" ?? "", voiceonly: true, customOptions: customOptions, mediaStream: null);
                    if (commonSizeForDesktop(context)) {
                      if (callFunction != null) {
                        callFunction!(contactInfo ?? ContactInfo(name: "Unknown", number: []));
                      }
                    } else {
                      contactList.add(onCallContactInfo!);
                      contactList.add(contactInfo!);
                    Get.to(
                          CallScreen(
                            contactInfo: contactInfo,
                            calling: (contactInfo?.number?.isEmpty ?? true) ? number : contactInfo?.number?[0].value,
                            callerName: (contactInfo?.name.isEmpty ?? true) ? "Unknown" : contactInfo?.name,
                            callObj: globals.callglobalObj,
                            isHold: true,
                            tuple5: Tuple2(onCallContactInfo,number),
                          ),
                          arguments: {"name": (contactInfo?.name.isEmpty ?? true) ? "Unknown" : contactInfo?.name});
                    }
                  }
                } else {
                  if (number?.isNotEmpty ?? false) {
                    SIPUAHelper helperObj = (globals.helper ?? SIPUAHelper());

                    Map<String, dynamic> customOptions = {
                      'X-sourceNumber': '+919033586521',
                      'X-callType': 1,
                    };

                    await helperObj.call("91$number" ?? "", voiceonly: true, customOptions: customOptions, mediaStream: null);
                    if (commonSizeForDesktop(context)) {
                      if (callFunction != null) {
                        callFunction!(contactInfo ?? ContactInfo(name: "Unknown", number: []));
                      }
                    } else {
                      Get.to(
                          CallScreen(
                            contactInfo: contactInfo,
                            calling: (contactInfo?.number?.isEmpty ?? true) ? number : contactInfo?.number?[0].value,
                            callerName: (contactInfo?.name.isEmpty ?? true) ? "Unknown" : contactInfo?.name,
                            callObj: globals.callglobalObj,
                          ),
                          arguments: {"name": (contactInfo?.name.isEmpty ?? true) ? "Unknown" : contactInfo?.name});
                    }
                  }
                }

                print("i==${globals.isStartedTime}");
              } catch (e) {
                print("=====>>> $e");
              }
            },
            child: Container(
              //height: 500,
              // width: 60,
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.greenColor, shape: BoxShape.circle),
              child: CustomImageView(svgPath: 'call.svg', onTap: null, height: size.height * 0.03, color: Colors.white),
            ).marginAll(6),
          );
        } else if (model.text == "video") {
          return GestureDetector(
            onTap: () async {
              Get.to(() => VideoCallScreen());
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.greenColor, shape: BoxShape.circle),
              child: CustomImageView(svgPath: 'videocall_icon.svg', onTap: null, height: size.height * 0.03, color: Colors.white),
            ).marginAll(6),
          );
        } else if (model.text == "call2") {
          return GestureDetector(
            onTap: () async {
              // Constants.sendToNext(
              //   Routes.callScreen,
              // );
              // await registeredSip();

              bool callscreen = true;
              Get.to(CallScreen(), arguments: {"callscreen": callscreen == true});
              // try {
              //   SIPUAHelper helperObj = globals.helper!;
              //   await helperObj.call("91$number" ?? "", voiceonly: true, mediaStream: null);
              //   Get.to(
              //       CallScreen(
              //         contactInfo: contactInfo,
              //         calling: (contactInfo?.number?.isEmpty ?? true) ? number : contactInfo?.number?[0].value,
              //         callerName: (contactInfo?.name.isEmpty ?? true) ? "Unknown" : contactInfo?.name,
              //         callObj: globals.callglobalObj,
              //       ),
              //       arguments: {"name": (contactInfo?.name.isEmpty ?? true) ? "Unknown" : contactInfo?.name});
              // } catch (e) {
              //   print("=====>>>$e");
              // }
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.subCardColor.withOpacity(0.3), shape: BoxShape.circle),
              child: CustomImageView(svgPath: 'call2.svg', onTap: null, height: size.height * 0.03, color: Colors.white),
            ).marginAll(6),
          );
        } else {
          return index == (getKeyData().length - 1)
              ? GestureDetector(
                  onTap: () {
                    if (tapRemove != null) {
                      tapRemove!();
                    }
                  },
                  onLongPress: () {
                    if (onLongPress != null) {
                      onLongPress!();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    child: CustomImageView(svgPath: 'back.svg', onTap: null, height: 25, color: Colors.white),
                  ),
                )
              : InkWell(
                  onTap: () {
                    if (model.text.isNotEmpty) {
                      function(model.text);
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [getCustomFont(model.text, 27, Colors.white, 1, fontWeight: FontWeight.w400),
                      getCustomFont(model.subText, 10, Colors.white, 1, fontWeight: FontWeight.w400)],
                  ),
                );
        }
      },
    );
  }
}

class DialPadCall extends StatelessWidget {
  final Function(String) function;
  final Function? tapRemove;
  final Function? onLongPress;
  final Function? callEnd;
  final Function? keyBordCall;
  final String? number;
  final ContactInfo? contactInfo;

  const DialPadCall(this.function, {super.key, this.onLongPress, this.tapRemove, this.keyBordCall, this.number, this.contactInfo, this.callEnd});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - 100 - 270) / 5;

    return GridView.builder(
      itemCount: getKeyDataCall().length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 25, mainAxisExtent: (itemHeight / 1.2)),
      itemBuilder: (context, index) {
        DialerModel model = getKeyDataCall()[index];
        if (model.text == "endCall") {
          return GestureDetector(
            onTap: () async {
              if (callEnd != null) {
                callEnd!();
              }
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.redColor, shape: BoxShape.circle),
              child: CustomImageView(svgPath: 'cut.svg', onTap: null, height: 35, color: Colors.white),
            ).marginAll(10),
          );
        } else if (model.text == "keypad") {
          return GestureDetector(
            onTap: () async {
              if (keyBordCall != null) {
                keyBordCall!();
              }
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle),
              child: CustomImageView(svgPath: 'keybord_icon.svg', onTap: null, height: 40, color: Colors.white),
            ).marginAll(10),
          );
        } else {
          return index == (getKeyData().length - 1)
              ? GestureDetector(
                  onTap: () {
                    if (tapRemove != null) {
                      tapRemove!();
                    }
                  },
                  onLongPress: () {
                    if (onLongPress != null) {
                      onLongPress!();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    child: CustomImageView(svgPath: 'back.svg', onTap: null, height: 25, color: Colors.white),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    if (model.text.isNotEmpty) {
                      function(model.text);
                    }
                  },
                  child: Container(
                    decoration: commonSizeForDesktop(context) ? BoxDecoration(borderRadius: BorderRadius.circular(100), color: model.text.isEmpty ? Colors.transparent : AppColors.primaryColor) : BoxDecoration(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [getCustomFont(model.text, 27, Colors.white, 1, fontWeight: FontWeight.w400), getCustomFont(model.subText, 10, Colors.white, 1, fontWeight: FontWeight.w400)],
                    ),
                  ),
                );
        }
      },
    );
  }
}

List<DialerModel> getKeyData() {
  return [
    DialerModel(text: '1', isCall: false, subText: ''),
    DialerModel(text: '2', isCall: false, subText: 'ABC'),
    DialerModel(text: '3', isCall: false, subText: 'DEF'),
    DialerModel(text: '4', isCall: false, subText: 'GHI'),
    DialerModel(text: '5', isCall: false, subText: 'JKL'),
    DialerModel(text: '6', isCall: false, subText: 'MNO'),
    DialerModel(text: '7', isCall: false, subText: 'PQR'),
    DialerModel(text: '8', isCall: false, subText: 'STU'),
    DialerModel(text: '9', isCall: false, subText: 'VWXZ'),
    DialerModel(text: '*', isCall: false, subText: ''),
    DialerModel(text: '0', isCall: false, subText: '+'),
    DialerModel(text: '#', isCall: false, subText: ''),
    DialerModel(text: 'video', isCall: false, subText: ''),
    DialerModel(text: 'call2', isCall: false, subText: ''),
    DialerModel(text: '', isCall: true, subText: ''),
  ];
}

List<DialerModel> getKeyDataCall() {
  return [
    DialerModel(text: '1', isCall: false, subText: ''),
    DialerModel(text: '2', isCall: false, subText: 'ABC'),
    DialerModel(text: '3', isCall: false, subText: 'DEF'),
    DialerModel(text: '4', isCall: false, subText: 'GHI'),
    DialerModel(text: '5', isCall: false, subText: 'JKL'),
    DialerModel(text: '6', isCall: false, subText: 'MNO'),
    DialerModel(text: '7', isCall: false, subText: 'PQR'),
    DialerModel(text: '8', isCall: false, subText: 'STU'),
    DialerModel(text: '9', isCall: false, subText: 'VWXZ'),
    DialerModel(text: '*', isCall: false, subText: ''),
    DialerModel(text: '0', isCall: false, subText: '+'),
    DialerModel(text: '#', isCall: false, subText: ''),
    DialerModel(text: '', isCall: false, subText: ''),
    DialerModel(text: 'endCall', isCall: false, subText: ''),
    DialerModel(text: 'keypad', isCall: true, subText: ''),
  ];
}
