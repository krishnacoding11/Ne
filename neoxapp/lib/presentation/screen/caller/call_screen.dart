import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter_audio_manager_plus/flutter_audio_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'package:get/get.dart';
import 'package:headset_connection_event/headset_event.dart';
import 'package:neoxapp/presentation/controller/conference_call_controller.dart';
import 'package:neoxapp/presentation/screen/caller/conference_call/multipal_call.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/model/call_model.dart';
import 'package:neoxapp/model/person_model.dart';
import 'package:neoxapp/presentation/controller/call_controller.dart';
import 'package:neoxapp/presentation/screen/caller/view/dial_button.dart';
import 'package:neoxapp/presentation/screen/dashboard/dashboard_page.dart';
import 'package:neoxapp/presentation/screen/dashboard/model/contact_info_model.dart';
import 'package:neoxapp/presentation/screen/dialpad/dial_pad.dart';
import 'package:neoxapp/presentation/screen/transfer_calls/transfer_contant_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_ua/sip_ua.dart';
import 'package:tuple/tuple.dart';

import '../../../core/constants.dart';
import '../../../core/theme_color.dart';
import '../../../core/widget.dart';
import '../../../generated/l10n.dart';
import 'package:neoxapp/presentation/widgets/globle.dart' as globals;
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../main.dart';
import '../../widgets/custom_image_view.dart';

//
ReceivePort? receivePort;

class CallScreen extends StatefulWidget {
  final String? calling;
  final String? callerName;
  final dynamic callObj;
  final ContactInfo? contactInfo;
  final String? tag;
  final Function? callEndTap;
  final bool? isHold;
  final bool isStart;
  final CallController? callController;
  final Tuple2? tuple5;

  const CallScreen({Key? key,this.isHold, this.tuple5, this.callController, this.isStart = false, this.calling, this.callerName, this.callObj, this.tag, this.contactInfo, this.callEndTap}) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> implements SipUaHelperListener {



  onBack() {
    CallController callController = Get.find();

    if (callController.isDialPad) {
      callController.onChange(false);
    } else {
      if (commonSizeForDesktop(Get.context)) {
        if (widget.callEndTap != null) {
          widget.callEndTap!();
        }
      } else {
        Get.offAll(() => const DashboardScreen());
      }
    }
  }

  List<String> speakerList = ["Bluetooth", "Speaker", "Mic"];
  RxString selectSpeaker = "".obs;
  CallController? callController;
  late BuildContext myContext;
  bool _speakerOn = false;
  bool _hold = false;
  bool callScreen = false;
  Timer? mytimer;
  String timerValue = "";
  CallState? _myCallState;
  String cName = "";
  String selectedAudioOutput = "";
  dynamic argumentData = Get.arguments;
  dynamic argumentData1 = Get.arguments;

  final _headsetPlugin = HeadsetEvent();
  HeadsetState? _headsetState;

  @override
  void initState() {
    super.initState();

    if (widget.isStart) {
      callController = widget.callController!;
    } else {
      callController = Get.put(CallController());
    }
    setState(() {});

    print("isStartedTime -- ${globals.isStartedTime}");

    _headsetPlugin.requestPermission();
    _headsetPlugin.getCurrentState.then((val) {
      print("value bluettoth -- $val");

      setState(() {
        _headsetState = val;
      });
      if (val == HeadsetState.CONNECT) {
        selectSpeaker.value = "Bluetooth";
      } else if (val == HeadsetState.DISCONNECT) {
        selectSpeaker.value = "Earpiece";
      } else {
        selectSpeaker.value = "Speaker";
      }
    });

    /// Detect the moment headset is plugged or unplugged
    _headsetPlugin.setListener((val) {
      setState(() {
        _headsetState = val;
      });
    });

    if (globals.globalCallerName == "") {
      globals.globalCallerName = widget.callerName ?? "";
      globals.globalCallerNumber = widget.calling ?? "";

      if (argumentData != null) {
        // print(argumentData["name"]);
        if (argumentData["name"] != null) {
          cName = argumentData["name"];
          setState(() {});
        }
      }

      if (argumentData1 != null) {
        // print(argumentData["name"]);
        if (argumentData1["callscreen"] != null) {
          callScreen = argumentData1["callscreen"];
          print("callscreen====${argumentData1["callscreen"]}");
          setState(() {});
        }
      }

      if (widget.callObj == 'null' && widget.tag == "2") {
        // print('call obj $serviceObj');
        Future list = getCallId();
        // print('list id ${list}');

        if (globals.callglobalObj != null) {
          globals.callglobalObj!.answer(globals.helper!.buildCallOptions(true));
        }
      }

      globals.helper?.addSipUaHelperListener(this);

      updateCallValue();
      // log('${globals.helper!.listeners}');
      // openScreen();
      callController!.mishalCall.value = false;
      // foregroundService();
    } else {
      if (globals.isStartedTime) {
        callController!.isStartTimer = true;
        callController!.update();
      }
    }
    myContext = context;
  }

  @override
  Widget build(BuildContext context) {


    onCallContactInfo = widget.contactInfo;

    // final overlayScreen = OverlayScreen.of(context);
    // HistoryModel historyModel = Get.arguments;

    if (callController == null) {
      return Container();
    }
    var height = MediaQuery.of(context).size.height;

    callController!.number = widget.calling ?? "";

    callController!.name = (widget.callerName == null || widget.callerName!.isEmpty) ? callController!.number : widget.callerName ?? "";

    overlayScreen?.closeAll();

    return WillPopScope(
        child: Scaffold(
          body: Container(
            decoration: commonSizeForDesktop(context) ? null : BoxDecoration(image: DecorationImage(image: AssetImage(themeController.isDarkMode ? Constants.assetPath + "dark_dashboard.png" : Constants.assetPath + "history_bg.png"), fit: BoxFit.fill)),
            child: SafeArea(
              child: GetBuilder(
                builder: (controller) {
                  return Stack(
                    children: [
                      if (commonSizeForDesktop(context))
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: Image.asset(
                                "assets/images/backgorundimage.png",
                                height: 350,
                              )),
                            ],
                          ),
                        ),
                      Column(
                        children: [
                          SizedBox(
                            height: height * 0.009,
                          ),
                          (widget.isHold??false)
                          // (callScreen == true)
                              ? multipalCall(ConferenceCallController(),contactInfo: widget.contactInfo,hangup: (p0) {
                                _handleHangup();
                              },holdCall: (p0) {

                            if (globals.callglobalObj != null) {
                              globals.callglobalObj?.hold();
                              _hold = true;
                            }

                          },).paddingSymmetric(horizontal: 24, vertical: 30)
                              // ? multipalCall(ConferenceCallController()).paddingSymmetric(horizontal: 24, vertical: 30)
                              : Column(
                                  children: [
                                    (widget.contactInfo?.img?.isEmpty ?? true)
                                        ? Container(
                                            // height: height * 0.30,

                                            child: Container(height: height * 0.09, width: 80, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xffEBF0FF), shape: BoxShape.circle), child: getCustomFont(Constants.split((widget.contactInfo?.name.isEmpty ?? true) ? widget.calling ?? '' : (widget.contactInfo?.name ?? "")), 20, AppColors.primaryColor, 1, fontWeight: FontWeight.w400, textAlign: TextAlign.center)).marginOnly(top: height * 0.009, bottom: height * 0.009))
                                        : ClipOval(
                                            child: CustomImageView(
                                              height: 80,
                                              width: 80,
                                              memory: (widget.contactInfo?.img),
                                            ),
                                          ).marginOnly(top: 20, bottom: 16),
                                    getCustomFont(
                                      (cName == ""
                                              ? widget.callerName == ""
                                                  ? globals.globalCallerName
                                                  : widget.callerName
                                              : cName) ??
                                          widget.calling ??
                                          '',
                                      // historyModel.name,
                                      26,
                                      AppColors.getFontColor(context),
                                      1,
                                      fontWeight: FontWeight.w600,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 0,
                                    ),
                                    StreamBuilder(
                                        stream: callController!.seconds.stream,
                                        builder: (context, snapshot) {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              getCustomFont(
                                                "Ringing",
                                                // "Ringing ${widget.calling == "" ? globals.globalCallerNumber : widget.calling}",
                                                // '${Get.arguments}',
                                                18,
                                                AppColors.getFontColor(context),
                                                1,
                                                fontWeight: FontWeight.w400,
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                            ],
                                          );
                                        }),
                                    StreamBuilder(
                                        stream: isOpenKeyBord.stream,
                                        builder: (context, snapshot) {
                                          return isOpenKeyBord.value
                                              ? getDialerTextFiled(
                                                  fontSize: 25,
                                                  textEditingController: controller.textEditingController,
                                                  onChange: (value) {},
                                                  context: context,
                                                  hint: '',
                                                )
                                              : const SizedBox();
                                        }),
                                    StreamBuilder(
                                        stream: callController!.seconds.stream,
                                        builder: (context, snapshot) {
                                          return getCustomFont(
                                            callController!.isStartTimer ? '${callController!.minutes.value.toString().padLeft(2, '0')}:${callController!.seconds.value.toString().padLeft(2, '0')}' : "",
                                            16,
                                            AppColors.getFontColor(context),
                                            1,
                                            fontWeight: FontWeight.w400,
                                            textAlign: TextAlign.center,
                                          );
                                        }),
                                    StreamBuilder(
                                        stream: isOpenKeyBord.stream,
                                        builder: (context, snapshot) {
                                          return SizedBox(
                                            height: isOpenKeyBord.value ? 0 : 35,
                                          );
                                        }),
                                  ],
                                ),
                          // ClipOval(
                          //   child: CustomImageView(
                          //     height: 80.h,
                          //     width: 80.h,
                          //     imagePath: '${Constants.assetPath}user_1.png',
                          //     // imagePath: '${Constants.assetPath}${historyModel.image}',
                          //   ),
                          // ).marginOnly(top: 20.h, bottom: 16.h),

                          // historyModel.image == null || historyModel.image!.isEmpty
                          //     ? Container(height: 80.h, width: 80.h, alignment: Alignment.center, decoration: BoxDecoration(color: Color(0xffEBF0FF), shape: BoxShape.circle), child: getCustomFont(Constants.split(historyModel.name), 12.sp, AppColors.primaryColor, 1, fontWeight: FontWeight.w400))
                          //     :

                          ///////

                          StreamBuilder(
                              stream: isOpenKeyBord.stream,
                              builder: (context, snapshot) {
                                if (isOpenKeyBord.value) {
                                  return Expanded(
                                    flex: 1,
                                    child: Container(
                                      clipBehavior: Clip.antiAlias,
                                      padding: const EdgeInsets.only(bottom: 40),
                                      decoration: commonSizeForDesktop(context)
                                          ? BoxDecoration()
                                          : const ShapeDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment(-0.00, -1.00),
                                                end: Alignment(0, 1),
                                                colors: [Color(0xFF648CFF), Color(0xFF1B47C5)],
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(32),
                                                  topLeft: Radius.circular(32),
                                                ),
                                              ),
                                            ),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          Expanded(
                                            child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              child: DialPadCall(
                                                callEnd: () {
                                                  _handleHangup();
                                                },
                                                (p0) {
                                                  controller.textEditingController.text = controller.textEditingController.text + p0;
                                                  if (controller.textEditingController.text.isNotEmpty) {
                                                    globals.callglobalObj?.sendDTMF(p0);
                                                  }
                                                },
                                                keyBordCall: () {
                                                  isOpenKeyBord.value = false;
                                                },
                                                number: controller.textEditingController.text,
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
                                                  controller.update();
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Expanded(
                                    flex: 1,
                                    child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        alignment: Alignment.center,
                                        decoration: commonSizeForDesktop(context)
                                            ? BoxDecoration()
                                            : const ShapeDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment(-0.00, -1.00),
                                                  end: Alignment(0, 1),
                                                  colors: [Color(0xFF638BFF), Color(0xFF1B47C5)],
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32)),
                                                ),
                                              ),
                                        child: controller.isDialPad
                                            ? SizedBox(
                                                width: MediaQuery.of(context).size.width > 450 ? 390 : MediaQuery.of(context).size.width,
                                                child: Row(
                                                  children: [
                                                    Center(
                                                      child: SizedBox(
                                                        width: MediaQuery.of(context).size.width > 450 ? 390 :
                                                        MediaQuery.of(context).size.width,
                                                        child: DialPad(
                                                          (p0) {},
                                                        ).marginSymmetric(vertical: 0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox(
                                                width: MediaQuery.of(context).size.width > 450 ? 390 : MediaQuery.of(context).size.width,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        // Expanded(
                                                        //     child: DialButton(
                                                        //   S.of(context).addCall,
                                                        //   'add.svg',
                                                        // )),
                                                        StreamBuilder(
                                                            stream: _audioMuted.stream,
                                                            builder: (context, snapshot) {
                                                              return Expanded(
                                                                  child: DialButton(
                                                                color: _audioMuted.value ? Colors.white : null,
                                                                iconColor: _audioMuted.value ? AppColors.primaryColor : Colors.white,
                                                                S.of(context).mute,
                                                                !_audioMuted.value ? 'mute.svg' : "unmute.svg",
                                                                function: () {
                                                                  _muteAudio();
                                                                },
                                                              ));
                                                            }),
                                                        _headsetState == null || _headsetState == HeadsetState.DISCONNECT
                                                            ? Expanded(
                                                                child: StreamBuilder(
                                                                    stream: selectSpeaker.stream,
                                                                    builder: (context, snapshot) {
                                                                      return DialButton(function: () {
                                                                        _toggleSpeaker();

                                                                        // showModalBottomSheet(
                                                                        //   context: context,
                                                                        //   shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                                                                        //   builder: (BuildContext context) {
                                                                        //     return Container(
                                                                        //       height: 300,
                                                                        //       padding: const EdgeInsets.all(25),
                                                                        //       decoration: BoxDecoration(color: themeController.isDarkMode ? Colors.black : Colors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                                                                        //       child: Center(
                                                                        //           child: StreamBuilder(
                                                                        //               stream: selectSpeaker.stream,
                                                                        //               builder: (context, snapshot) {
                                                                        //                 return Column(
                                                                        //                   children: [
                                                                        //                     ListView.builder(
                                                                        //                         shrinkWrap: true,
                                                                        //                         itemCount: speakerList.length,
                                                                        //                         itemBuilder: (context, index) {
                                                                        //                           return InkWell(
                                                                        //                             onTap: () {
                                                                        //                               selectSpeaker.value = speakerList[index];
                                                                        //                               Get.back();
                                                                        //                             },
                                                                        //                             child: Container(
                                                                        //                               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                                        //                               margin: EdgeInsets.only(bottom: selectSpeaker.value == speakerList[index] ? 15 : 10),
                                                                        //                               width: double.infinity,
                                                                        //                               decoration: BoxDecoration(
                                                                        //                                 color: selectSpeaker.value == speakerList[index] ? (themeController.isDarkMode ? const Color(0xff272A2F) : AppColors.ColorF4F4F5) : Colors.transparent,
                                                                        //                                 borderRadius: BorderRadius.circular(10),
                                                                        //                               ),
                                                                        //                               child: Row(
                                                                        //                                 children: [
                                                                        //                                   index == 0
                                                                        //                                       ? CustomImageView(
                                                                        //                                           svgPath: "bluetooth_image.svg",
                                                                        //                                           height: 28,
                                                                        //                                         )
                                                                        //                                       : index == 1
                                                                        //                                           ? CustomImageView(
                                                                        //                                               svgPath: "speker.svg",
                                                                        //                                               height: 28,
                                                                        //                                               color: AppColors.grayColor,
                                                                        //                                             )
                                                                        //                                           : CustomImageView(
                                                                        //                                               svgPath: "mute.svg",
                                                                        //                                               height: 28,
                                                                        //                                               color: AppColors.grayColor,
                                                                        //                                             ),
                                                                        //                                   const SizedBox(width: 10),
                                                                        //                                   Text(
                                                                        //                                     speakerList[index],
                                                                        //                                     style: TextStyle(
                                                                        //                                       fontSize: 14,
                                                                        //                                       color: themeController.isDarkMode ? Colors.white : Colors.black,
                                                                        //                                     ),
                                                                        //                                   )
                                                                        //                                 ],
                                                                        //                               ),
                                                                        //                             ),
                                                                        //                           );
                                                                        //                         }),
                                                                        //                     const SizedBox(
                                                                        //                       height: 30,
                                                                        //                     ),
                                                                        //                     InkWell(
                                                                        //                       onTap: () {
                                                                        //                         Get.back();
                                                                        //                       },
                                                                        //                       child: Text(
                                                                        //                         "Cancel",
                                                                        //                         style: TextStyle(color: themeController.isDarkMode ? Colors.white : Colors.black, fontSize: 16),
                                                                        //                       ),
                                                                        //                     ),
                                                                        //                   ],
                                                                        //                 );
                                                                        //               })),
                                                                        //     );
                                                                        //   },
                                                                        // );
                                                                      },
                                                                          S.of(context).speaker,
                                                                          color: _speakerOn ? Colors.white : null,
                                                                          iconColor: _speakerOn ? AppColors.primaryColor : Colors.white,
                                                                          // 'speker.svg',
                                                                          selectSpeaker.value == "Bluetooth"
                                                                              ? "bluetooth_image.svg"
                                                                              : selectSpeaker.value == "Speaker"
                                                                                  ? 'speker.svg'
                                                                                  : selectSpeaker.value == "Mic"
                                                                                      ? "mute.svg"
                                                                                      : 'speker.svg');
                                                                    }))
                                                            : Expanded(
                                                                child: StreamBuilder(
                                                                    stream: selectSpeaker.stream,
                                                                    builder: (context, snapshot) {
                                                                      return DialButton(function: () {
                                                                        showModalBottomSheet(
                                                                          context: context,
                                                                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                                                                          builder: (BuildContext context) {
                                                                            return Container(
                                                                              height: 300,
                                                                              padding: const EdgeInsets.all(25),
                                                                              decoration: BoxDecoration(color: themeController.isDarkMode ? Colors.black : Colors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                                                                              child: Center(
                                                                                  child: StreamBuilder(
                                                                                      stream: selectSpeaker.stream,
                                                                                      builder: (context, snapshot) {
                                                                                        return Column(
                                                                                          children: [
                                                                                            ListView.builder(
                                                                                                shrinkWrap: true,
                                                                                                itemCount: speakerList.length,
                                                                                                itemBuilder: (context, index) {
                                                                                                  return InkWell(
                                                                                                    onTap: () {
                                                                                                      selectSpeaker.value = speakerList[index];
                                                                                                      if (kDebugMode) {
                                                                                                        print("selectSpeaker ${selectSpeaker.value}");
                                                                                                      }
                                                                                                      handleAudioOutputSelection();
                                                                                                      Get.back();
                                                                                                    },
                                                                                                    child: Container(
                                                                                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                                                                      margin: EdgeInsets.only(bottom: selectSpeaker.value == speakerList[index] ? 15 : 10),
                                                                                                      width: double.infinity,
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: selectSpeaker.value == speakerList[index] ? (themeController.isDarkMode ? const Color(0xff272A2F) : AppColors.ColorF4F4F5) : Colors.transparent,
                                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                                      ),
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          index == 0
                                                                                                              ? CustomImageView(
                                                                                                                  svgPath: "bluetooth_image.svg",
                                                                                                                  height: 28,
                                                                                                                )
                                                                                                              : index == 1
                                                                                                                  ? CustomImageView(
                                                                                                                      svgPath: "speker.svg",
                                                                                                                      height: 28,
                                                                                                                      color: AppColors.grayColor,
                                                                                                                    )
                                                                                                                  : CustomImageView(
                                                                                                                      svgPath: "mute.svg",
                                                                                                                      height: 28,
                                                                                                                      color: AppColors.grayColor,
                                                                                                                    ),
                                                                                                          const SizedBox(width: 10),
                                                                                                          Text(
                                                                                                            speakerList[index],
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 14,
                                                                                                              color: themeController.isDarkMode ? Colors.white : Colors.black,
                                                                                                            ),
                                                                                                          )
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  );
                                                                                                }),
                                                                                            const SizedBox(
                                                                                              height: 30,
                                                                                            ),
                                                                                            InkWell(
                                                                                              onTap: () {
                                                                                                Get.back();
                                                                                              },
                                                                                              child: Text(
                                                                                                "Cancel",
                                                                                                style: TextStyle(color:
                                                                                                themeController.isDarkMode ? Colors.white : Colors.black, fontSize: 16),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        );
                                                                                      })),
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                          S.of(context).speaker,
                                                                          color: _speakerOn ? Colors.white : null,
                                                                          iconColor: _speakerOn ? AppColors.primaryColor : Colors.white,
                                                                          // 'speker.svg',
                                                                          selectSpeaker.value == "Bluetooth"
                                                                              ? "bluetooth_image.svg"
                                                                              : selectSpeaker.value == "Speaker"
                                                                                  ? 'speker.svg'
                                                                                  : selectSpeaker.value == "Mic"
                                                                                      ? "mute.svg"
                                                                                      : 'speker.svg');
                                                                    })),

                                                        Expanded(
                                                            child: DialButton(
                                                          S.of(context).transfer,
                                                          'transfer.svg',
                                                          function: () {
                                                            Get.to(() => TransferContactScreen(
                                                                  callEnd: () {
                                                                    _handleHangup();
                                                                  },
                                                                ));
                                                          },
                                                        )),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 24,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: DialButton(
                                                          S.of(context).add,
                                                          'add.svg',
                                                          function: () {
                                                            overlayScreen?.show(callController);
                                                            Get.offAll(() => const DashboardScreen());
                                                          },
                                                        )),
                                                        Expanded(
                                                            child: DialButton(
                                                          S.of(context).hold,
                                                          color: _hold ? Colors.white : null,
                                                          iconColor: _hold ? AppColors.primaryColor : Colors.white,
                                                          _hold ? "unHold.svg" : 'hold.svg',
                                                          function: () {
                                                            setState(() {
                                                              if (_hold == false) {
                                                                if (globals.callglobalObj != null) {
                                                                  globals.callglobalObj?.hold();
                                                                  _hold = true;
                                                                }
                                                              } else {
                                                                if (globals.callglobalObj != null) {
                                                                  globals.callglobalObj?.unhold();
                                                                  _hold = false;
                                                                }
                                                              }
                                                            });
                                                          },
                                                        )),
                                                        Expanded(
                                                            child: DialButton(
                                                          S.of(context).message,
                                                          'chat.svg',
                                                        )),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 24,
                                                    ),
                                                    Row(
                                                      children: [
                                                        // Expanded(child: Container()),
                                                        Expanded(
                                                          child: Container(),
                                                          //     child: DialButton(
                                                          //   S.of(context).conference,
                                                          //   'keybord_icon.svg',
                                                          //   size: 55,
                                                          //   function: () {
                                                          //     Get.to(() => ConferenceScreen());
                                                          //   },
                                                          // )
                                                          //
                                                        ),
                                                        Expanded(
                                                            child: DialButton(
                                                          '',
                                                          'cut.svg',
                                                          color: AppColors.redColor,
                                                          size: 45,
                                                          function: () {
                                                            _handleHangup();
                                                          },
                                                        )),
                                                        Expanded(
                                                            child: DialButton(
                                                          S.of(context).keypad,
                                                          'keybord_icon.svg',
                                                          size: 55,
                                                          function: () {
                                                            isOpenKeyBord.value = true;
                                                          },
                                                        )),
                                                        // Expanded(child: Container()),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ).marginSymmetric(vertical: 40, horizontal: 24)),
                                  );
                                }
                              })
                        ],
                      ),
                    ],
                  );
                },
                init: CallController(),
              ),
            ),
          ),
        ),
        onWillPop: () async {
          print("fgdfg");

          overlayScreen?.show(callController);

          onBack();
          return false;
        });
  }

  updateCallValue() async {
    await Future.delayed(const Duration(milliseconds: 2));
    callController!.isCallRunning.value = true;
    callController!.isCallRunning.refresh();
    // await Future.delayed(Duration(milliseconds: 1));
  }

  getCallId() async {
    debugPrint('dataa:: ${await FlutterCallkitIncoming.activeCalls()}');
    // List<String> activeId = await FlutterCallkitIncoming.activeCalls();
    // print('activeId id ${activeId.length}');
    // print('fetch id ${activeId[0]}');

    return await FlutterCallkitIncoming.activeCalls();
  }

  @override
  void callStateChanged(Call call, CallState state) {
    print('Callv  out going call changed *************');

    myMethod(call, state);
  }

  void myMethod(Call call, CallState callState) {
    // _call = globals.callglobalObj;
    print('Callv state callStateChanged New : ${callState.state}');
    // _call = call;
    // _call = call;
    // widget.call = call;
    if (callState.state == CallStateEnum.HOLD || callState.state == CallStateEnum.UNHOLD) {
      _hold = callState.state == CallStateEnum.HOLD;


      return;
    }

    print('callstatus===: ${callState.state}===${call.session.contact}');
    // if (callState.state == CallStateEnum.MUTED) {
    //   if (callState.audio!) _audioMuted = true;
    //   // if (callState.video!) _videoMuted = true;
    //   // setState(() {_audioMuted = myTemp;});
    //
    //   print('Callv &&&&& audio: : $_audioMuted');
    //   return;
    // }
    //
    // if (callState.state == CallStateEnum.UNMUTED) {
    //   if (callState.audio!) _audioMuted = false;
    //   // if (callState.video!) _videoMuted = false;
    //   // setState(() {_audioMuted = _audioMuted;});
    //
    //   return;
    // }

    if (callState.state != CallStateEnum.STREAM) {
      // _state = callState.state;
    }

    print('Callv CALLED STATE**********@@@@@@@' + callState.state.toString());
    globals.mycallstate = callState;
    switch (callState.state) {
      case CallStateEnum.STREAM:
        // Future.delayed(Duration(seconds: 20), () {
        _handelStreams(callState);
        // });
        break;
      case CallStateEnum.ENDED:
        print("callstateended. Get.back called");

        clearData();
        try {
          // if (myContext != null) {
          if (commonSizeForDesktop(Get.context)) {
            if (widget.callEndTap != null) {
              widget.callEndTap!();
            }
          } else {
            Get.offAll(() => const DashboardScreen());
          }
          // }
        } catch (e) {
          if (commonSizeForDesktop(Get.context)) {
            if (widget.callEndTap != null) {
              widget.callEndTap!();
            }
          } else {
            Get.offAll(() => const DashboardScreen());
          }
        }
        // Navigator.of(myContext).pop();
        //Get.back();
        // Get.pop(closeOverlays: true);
        break;
      case CallStateEnum.FAILED:
        try {
          // if (myContext != null) {
          ScaffoldMessenger.of(myContext).showSnackBar(const SnackBar(
            content: Text("Unable to connect call. Please try again."),
          ));
          Navigator.of(myContext, rootNavigator: false).pop();
          // }
        } catch (e) {
          if (commonSizeForDesktop(Get.context)) {
            if (widget.callEndTap != null) {
              widget.callEndTap!();
            }
          } else {
            Get.offAll(() => const DashboardScreen());
          }
        }
        break;
      case CallStateEnum.UNMUTED:
        print('UNMUTED $callState');
        break;
      case CallStateEnum.MUTED:
        print('MUTED $callState');
        break;
      case CallStateEnum.CONNECTING:
      case CallStateEnum.PROGRESS:
        break;
      case CallStateEnum.ACCEPTED:
        print('finally accepted******');
        break;
      case CallStateEnum.CONFIRMED:
        // isConfirmed = true;
        callController!.isStartTimer = true;
        callController!.update();
        globals.isStartedTime = true;
        _startTimer();
        break;
      case CallStateEnum.HOLD:


      case CallStateEnum.UNHOLD:
      case CallStateEnum.NONE:
      case CallStateEnum.CALL_INITIATION:
        print('call CALL_INITIATION');
        break;
      case CallStateEnum.REFER:
        break;
    }
  }

  _startTimer() {
    mytimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (callController!.seconds.value == 59) {
        callController!.seconds.value = 00;
        callController!.minutes.value = callController!.minutes.value + 1;
      } else {
        callController!.seconds.value = callController!.seconds.value + 1;
      }

      print('Callv callController');

      callController!.update();
    });
  }

  void _handelStreams(CallState event) {
    print('Callv connected stream&&&&&&&&&&************** ... $event');
    MediaStream? stream = event.stream;
    print('Callv connected stream&&&&&&&&&&************** ... ${event.stream}');

    globals.mycallstate = event;
    _myCallState = event;

    print('Callv State _myCallState... $_myCallState');
    print('Callv originator  ${event.originator}');

    if (event.originator == 'local') {
      globals.localStream = stream;

      print('Callv local stream... ${globals.localStream.toString()}');
    }

    // if (_localRenderer != null) {
    //   _localRenderer!.srcObject = stream;
    // }
    if (!WebRTC.platformIsDesktop) {
      // event.stream?.getAudioTracks().indexOf(MediaStreamTrack)
      event.stream?.getAudioTracks().first.enableSpeakerphone(false);
      // event.stream?.getAudioTracks().first.applyConstraints(mapdata);
    }

    if (event.originator == 'remote') {
      // if (_remoteRenderer != null) {
      //   _remoteRenderer!.srcObject = stream;
      // }
      globals.remoteStream = stream;
    }
    setState(() {
      // updateStream(stream);
    });
// updateStream(stream);
// setState(() {
// // _resizeLocalVideo();
// });
  }

  void _toggleSpeaker() {
    // print('local $_localStream');
    // print('_remoteStream $_remoteStream');

    if (globals.localStream == null && globals.remoteStream == null) {
      var tempSpeaker = !_speakerOn;

      /*  if (tempSpeaker)
        FlutterAudioManager.changeToSpeaker();
      else
        FlutterAudioManager.changeToHeadphones();*/

      if (globals.mycallstate?.originator == "local") {
        globals.localStream = globals.mycallstate?.stream;

        globals.localStream?.getAudioTracks()[0].enableSpeakerphone(tempSpeaker);
      }

      if (globals.mycallstate?.originator == "remote") {
        globals.remoteStream = globals.mycallstate?.stream;
        globals.remoteStream?.getAudioTracks()[0].enableSpeakerphone(tempSpeaker);
      }

      setState(() {
        _speakerOn = tempSpeaker;
      });
    } else {
      /*print('Callv local stream $_localStream');
      print('Callv global ${globals.mycallstate}');
      print('Callv _remoteStream $_remoteStream');
      print('Callv local stream $_localRenderer');
      print('Callv state stream $_myCallState');
      print('Callv _speakerOn stream $_speakerOn');*/

      if (globals.localStream != null) {
        // print('Callv check stream');
        var tempSpeaker = !_speakerOn;
        globals.localStream!.getAudioTracks()[0].enableSpeakerphone(tempSpeaker);
        setState(() {
          _speakerOn = tempSpeaker;
        });
      } else if (globals.remoteStream != null) {
        var tempSpeaker = !_speakerOn;
        // _speakerOn = !_speakerOn;
        // if (!kIsWeb) {
        globals.remoteStream?.getAudioTracks()[0].enableSpeakerphone(tempSpeaker);
        // }
        setState(() {
          _speakerOn = tempSpeaker;
        });
      }
    }
  }

  void handleAudioOutputSelection() async {
    // selectedAudioOutput = audioOutput;

    if (selectSpeaker.value == "Bluetooth") {
      await ChangeToBluetooth();
    } else if (selectSpeaker.value == "Mic") {
      await _toggleEarpiece(true);
    } else if (selectSpeaker.value == "Speaker") {
      _toggleSpeaker();
    }
  }

  Future<void> ChangeToBluetooth() async {
    try {
      await FlutterAudioManagerPlus.getCurrentOutput().then((value) {
        print("FlutterAudioManagerPlus test ${value.toString()}");
      });
      await FlutterAudioManagerPlus.getAvailableInputs().then((value) {
        print("FlutterAudioManagerPlus value ${value.toString()}");
      });
      await FlutterAudioManagerPlus.changeToBluetooth();
      setState(() {
        // onBluetooth = true;
        // speakerOn = false;
      });
    } catch (e) {
      print("Error in ChangeToBluetooth: $e");
    }
  }

  Future<void> _toggleEarpiece(bool useEarpiece) async {
    try {
      print("EarpieceOn $useEarpiece");
      // await FlutterAudioManagerPlus.getCurrentOutput().then((value) {
      //   print("FlutterAudioManagerPlus test ${value.toString()}");
      // });
      // await FlutterAudioManagerPlus.getAvailableInputs().then((value) {
      //   print("FlutterAudioManagerPlus value0000000 ${value}");
      // });
      globals.remoteStream?.getAudioTracks()[0].enableSpeakerphone(true);
      await FlutterAudioManagerPlus.changeToReceiver().then((value) => {
            print("FlutterAudioManagerPlus value ${value.toString()}"),
          });
      await FlutterAudioManagerPlus.getCurrentOutput().then((value) {
        print("FlutterAudioManagerPlus test ${value.toString()}");
      });
    } catch (e) {
      print("Error in _toggleEarpiece: $e");
    }
  }

  RxBool isOpenKeyBord = false.obs;

  clearData() {
    globals.helper?.removeSipUaHelperListener(this);

    callController!.isCallRunning.value = false;
    callController!.seconds.value = 0;
    callController!.minutes.value = 0;
    callController!.update();
    globals.globalCallerName = "";
    globals.globalCallerNumber = "";

    // globals.seconds = 0;
    // globals.minutes = 0;
    globals.localStream = null;
    globals.remoteStream = null;
    if (globals.isStartedTime) {
      callController!.isStartTimer = false;
      globals.isStartedTime = false;
      // myTimer.cancel();
    }
    stopService();
  }

  stopService() async {
    if (await FlutterForegroundTask.isRunningService) {
      // stopForegroundTask();
    }
  }

  void _handleHangup() {

    onCallContactInfo=null;
    if (mytimer != null) {
      mytimer!.cancel();
    }

    // globals.mycallstate.state.
    try {
      clearData();

      if (globals.callglobalObj != null) {
        globals.callglobalObj?.hangup();
      }
      globals.callglobalObj = null;

      if (commonSizeForDesktop(Get.context)) {
        if (widget.callEndTap != null) {
          widget.callEndTap!();
        }
      } else {
        overlayScreen?.closeAll();

        Get.offAll(() => const DashboardScreen());
      }
      // print('Callv timer : $_timer');
      // _timer?.cancel();
    } catch (e) {
      if (commonSizeForDesktop(Get.context)) {
        if (widget.callEndTap != null) {
          widget.callEndTap!();
        }
      } else {
        overlayScreen?.closeAll();

        Get.offAll(() => const DashboardScreen());
      }
    }
  }

  @override
  void onNewMessage(SIPMessageRequest msg) {
    // TODO: implement onNewMessage
  }

  @override
  void onNewNotify(Notify ntf) {
    // TODO: implement onNewNotify
  }

  @override
  void registrationStateChanged(RegistrationState state) {
    // TODO: implement registrationStateChanged
  }

  @override
  void transportStateChanged(TransportState state) {
    // TODO: implement transportStateChanged
  }

  final RxBool _audioMuted = false.obs;

  _muteAudio() {
    var tempMute = _audioMuted.value;

    if (globals.callglobalObj != null) {
      if (tempMute) {
        tempMute = false;

        globals.callglobalObj?.unmute(true, false);
      } else {
        tempMute = true;
        globals.callglobalObj?.mute(true, false);
      }
      print("tempMute$tempMute");
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => setState(() {
          _audioMuted.value = tempMute;
        }),
      );
    }
  }

  Future<bool> startForegroundTask() async {
    // You can save data using the saveData function.

    print('call #### startForegroundTask ${globals.callglobalObj}');
    // serviceObj = globals.callglobalObj!;
    print('call #### globals ${globals.callglobalObj?.id}');
    // calls111[globals.callglobalObj!.id.toString()] = globals.callglobalObj!;

    // var callsNew = <String, Call>{};
    //
    // MyTaskHandler().callTask = <String, Call>{};
    //
    // MyTaskHandler().callTask[globals.callglobalObj!.id.toString()] = Call(
    //     globals.callglobalObj!.id,
    //     globals.callglobalObj!.session,
    //     CallStateEnum.CALL_INITIATION);

    // Map<String, dynamic> user = {'Username': 'tom', 'Password': 'pass@123'};

    // Map<String, dynamic> tempMap = {
    //   'callId': globals.callglobalObj!.id.toString(),
    //   'modelCallObj': Call(globals.callglobalObj!.id,
    //       globals.callglobalObj!.session, CallStateEnum.CALL_INITIATION)
    // };
    Caller c1 = Caller(
      // callId: globals.callglobalObj!.id.toString(),
      callObj: Call(globals.callglobalObj?.id, globals.callglobalObj!.session, CallStateEnum.CALL_INITIATION),
      name: 'test name',
      age: 20,
    );

    // print('call list ${globals.helper!.calls}');
    print(' listener ${globals.helper.toString()}');

    print('session ID**** ${globals.callglobalObj?.session.id.toString()}');

    PersonModel pm = PersonModel(
      // callerObj: Call(globals.callglobalObj!.id,
      //     globals.callglobalObj!.session, CallStateEnum.CALL_INITIATION),
      name: (cName == ""
              ? widget.callerName == ""
                  ? globals.globalCallerName
                  : widget.callerName
              : cName) ??
          "",
      helper: globals.helper ?? SIPUAHelper(),
    );
    final prefs = await SharedPreferences.getInstance();
    const key = 'custom';
    final value = jsonEncode(pm.toJson());

    // json.encode(PersonModel(
    //     callerObj: Call(globals.callglobalObj!.id,
    //         globals.callglobalObj!.session, CallStateEnum.CALL_INITIATION),
    //     name: 'person model'));
    prefs.setString(key, value);

    // final call = Call(id: 1, name: 'John');
    // final json = jsonEncode(call);
    //
    // final callFromJson =
    //     jsonDecode(jsonString, fromJson: const CallConverter());

    // print('c1  ${c1.toJson()}');
    // SharedPreferences shared_User = await SharedPreferences.getInstance();
    // bool result = await shared_User.setString('caller', jsonEncode(tempMap));
    // print('cresult1  ${result}');

    // var map = json.encode({
    //   "callId": globals.callglobalObj!.id.toString(),
    //   "modelCallObj": Call(globals.callglobalObj!.id,
    //       globals.callglobalObj!.session, CallStateEnum.CALL_INITIATION)
    // });
    //
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    print('get obj  ${prefs.getString("custom")}');
    // setState(() {});
    await FlutterForegroundTask.saveData(
        key: 'callerName',
        value: (cName == ""
                ? widget.callerName == ""
                    ? globals.globalCallerName
                    : widget.callerName
                : cName) ??
            "");

    // Call(serviceObj!.id,  serviceObj!.session, serviceObj!.state);
    // await FlutterForegroundTask.saveData(
    //     key: 'callObj', value: globals.callglobalObj != null ? 1 : 0);

    await FlutterForegroundTask.saveData(key: 'callId', value: globals.callglobalObj?.id.toString() ?? "");

    await FlutterForegroundTask.saveData(key: 'sessionId', value: globals.callglobalObj?.session.id.toString() ?? "");

    await FlutterForegroundTask.saveData(key: 'callObj', value: Call(globals.callglobalObj?.id, globals.callglobalObj!.session, CallStateEnum.CALL_INITIATION).toString());

    // Register the receivePort before starting the service.
    // final ReceivePort?
    receivePort = FlutterForegroundTask.receivePort;
    final bool isRegistered = registerReceivePort(receivePort);

    print('isRegistered $isRegistered');
    if (!isRegistered) {
      print('Failed to register receivePort!');
      return false;
    }

    if (await FlutterForegroundTask.isRunningService) {
      print('************ sdfs');
      return FlutterForegroundTask.restartService();
    } else {
      print('sdfsdf sdfs');

      return FlutterForegroundTask.startService(
        notificationTitle: (widget.callerName == "" ? globals.globalCallerName : widget.callerName) ?? "", //'Foreground Service is running',
        notificationText: 'Ongoing voice call', // 'Tap to return to the app',
        callback: startCallback,
      );
    }
  }

  bool registerReceivePort(ReceivePort? newReceivePort) {
    print('CALLING ******** $registerReceivePort');
    print('newReceivePort ******** $newReceivePort');
    if (newReceivePort == null) {
      return false;
    }

    // closeReceivePort();

    receivePort = newReceivePort;
    receivePort?.listen((data) {
      print('data &&&&&&  $data');
      // if (data is Call) {
      //   serviceObj = globals.callglobalObj!;
      // } else
      if (data is int) {
        print('eventCount: $data');
      } else if (data is String) {
        if (data == 'onNotificationPressed') {
          Get.to(
              () => const CallScreen(
                    calling: "",
                    callObj: "",
                    callerName: "",
                  ),
              arguments: {"name": ""});
        }
      } else if (data is DateTime) {
        print('timestamp: ${data.toString()}');
      }
    });

    return receivePort != null;
  }

  void foregroundService() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestPermissionForAndroid();
      _initForegroundTask();

      // You can get the previous ReceivePort without restarting the service.
      if (await FlutterForegroundTask.isRunningService) {
        print('is rnning task *******');
        final newReceivePort = FlutterForegroundTask.receivePort;
        registerReceivePort(newReceivePort);
      }
    });
  }

  Future<void> _requestPermissionForAndroid() async {
    if (!Platform.isAndroid) {
      return;
    }

    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // onNotificationPressed function to be called.
    //
    // When the notification is pressed while permission is denied,
    // the onNotificationPressed function is not called and the app opens.
    //
    // If you do not use the onNotificationPressed or launchApp function,
    // you do not need to write this code.
    if (!await FlutterForegroundTask.canDrawOverlays) {
      await FlutterForegroundTask.openSystemAlertWindowSettings();
    }

    // Android 12 or higher, there are restrictions on starting a foreground service.
    //
    // To restart the service on device reboot or unexpected problem, you need to allow below permission.
    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    // Android 13 and higher, you need to allow notification permission to expose foreground service notification.
    final NotificationPermission notificationPermissionStatus = await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermissionStatus != NotificationPermission.granted) {
      // This function requires `android.permission.POST_NOTIFICATIONS` permission.
      await FlutterForegroundTask.requestNotificationPermission();
    }
  }

  void _initForegroundTask() {
    print('call forgreound');
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription: 'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
        buttons: [
          const NotificationButton(id: 'hangButton', text: 'Hang up'),
          // const NotificationButton(id: 'testButton', text: 'Test'),
        ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );

    // startForegroundTask();
  }
}

class MyTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  int _eventCount = 0;
  Call? callObj;
  String callerName = "";
  late SharedPreferences prefs;
  late SIPUAHelper helper;

  // MyTaskHandler(this.helper);

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;

    try {
      // print('global helper: ${globals.helper}');

      prefs = await SharedPreferences.getInstance();

      // SIPUAHelper? helper = SIPUAHelper();

      //
      print('get obj######## c2');

      var data = prefs.getString("custom");
      print('get obj######## data  $data');
      Map<String, dynamic> c2 = json.decode(data!);
      print('get obj######## main  $c2');
      // print('get obj######## main ${(c2['helper'] as SIPUAHelper).connected}');
      // print('get obj######## main ${(c2['helper'] as SIPUAHelper).calls}');

      // helper = SIPUAHelper.fromJson(
      //     c2); //c2['helper'] as SIPUAHelper; //callerObj.helper;
      // // print(' get obj ## call ${helper.calls}');
      // print('get obj######## main ${helper}');

      // helper = const SIPUAHelperConverter().fromJson(c2['helper']);
      // print(' get obj ## call ${c2['helper'].calls}');
      // PersonModel callerObj = PersonModel.fromJson(c2);
      // print(' get obj ## main ### $helper');
      // print(' get obj ## main ### ${helper.calls}');

      // if (callObj != null) {
      // print('get obj######## c2 ${callerObj.callObj}');

      // Call callAbc = callerObj.callObj as Call;
      // print('get obj######## ccallAbc2 ${callAbc.id}');

      //   serviceObj = callObj!;
      // }
      // You can use the getData function to get the stored data.

      final customData = await FlutterForegroundTask.getData<String>(key: 'callerName');
      // print('get obj########  ${prefs.getString("custom")}');

      // int? objValue = await FlutterForegroundTask.getData<int>(key: 'callObj');
      // print('objValue: $objValue');
      // print('objValue: ${(objValue == 1)}');
      // print('customData: $customData');
      // print('service : ${serviceObj}');
      // print('cal : ${globals.callglobalObj}');

      // callerName = pmObj.name; // customData!;
      // if (objValue == 1) {
      // callObj = globals.callglobalObj as Call;

      var callId = await FlutterForegroundTask.getData<String>(key: 'callId');
      print('callId: $callId');

      // print('GET OBJ ${helper.findCall(callId.toString())}');

      var sessionId = await FlutterForegroundTask.getData<String>(key: 'sessionId');
      print('sessionId: $sessionId');

      var callObj = (await FlutterForegroundTask.getData<String>(key: 'callObj'));
      print('callObj: $callObj');



      // callObj = await FlutterForegroundTask.getData<Call>(key: 'callObj');
      // print('callObj: $callObj');

      // callObj = Call(callId, callglobalObj., CallStateEnum.CALL_INITIATION);

      // Future.delayed(Duration(seconds: 3)).then((value) {
      //   print('call**len ${calls111.length}');
      //   callObj = findCall(callId.toString());
      //   print('call #### callObj ${callObj!.id}');
      // });
      // }
    } catch (e) {
      print('exception *** $e');
    }

    //   print('serviceObj: $serviceObj');
    //   print('serviceObj: $callObj');
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    print('update ************** $_eventCount');
    print('update ************** $callerName');
    // print('update ************** ${serviceObj!.id}');

    FlutterForegroundTask.updateService(
      notificationTitle: callerName,
      // globals.globalCallerName, //'Foreground Service is running',
      notificationText: 'Ongoing voice call ',

      // notificationTitle: 'MyTaskHandler',
      // notificationText: 'eventCount: $_eventCount',
    );

    // print('sdfasd ${callglobalObjMain == null ? "null" : callglobalObjMain}');
    // sendPort?.send('callObj');
    // Send data to the main isolate.
    sendPort?.send(_eventCount);
    //
    _eventCount++;
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    // Called when the notification button on the Android platform is pressed.
    print('onButtonPressed >> $id');
    if (id == "hangButton") {
      // print('global ${globals.callglobalObj ?? "null obj"}');
      // print('callObj: $callObj');
      // print('get obj  ${prefs.getString("custom")}');
      callObj!.hangup();
      // globals.callglobalObj!.hangup();
      stopForegroundTask();
    }
  }

  Future<bool> stopForegroundTask() {
    return FlutterForegroundTask.stopService();
  }

  @override
  void onNotificationPressed() {
    // Called when the notification itself on the Android platform is pressed.
    //
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // this function to be called.

    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp("/resume-route");
    _sendPort?.send('onNotificationPressed');
  }

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) {

    print("repeat ===$sendPort");
    // TODO: implement onRepeatEvent
  }
}
