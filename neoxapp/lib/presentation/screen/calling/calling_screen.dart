import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:neoxapp/presentation/widgets/globle.dart' as globals;
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/controller/dialer_controller.dart';
import 'package:neoxapp/presentation/widgets/custom_image_view.dart';
import 'package:sip_ua/sip_ua.dart';

BuildContext? globalContext;

class CallingScreen extends StatefulWidget {
  final Call? gcall;
  const CallingScreen({Key? key, this.gcall}) : super(key: key);

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> implements SipUaHelperListener {
  DialerController dialerController = Get.put(DialerController());
  late BuildContext myContext;
  @override
  void initState() {
    super.initState();
    myContext = context;
    globalContext = context;

    print("incoming call....ringing");
    FlutterRingtonePlayer().play(
      fromAsset: "assets/audio/dummy.mp3", // will be the sound on Android
      ios: IosSounds.glass,
      asAlarm: false,
      looping: true,
      volume: 1.0,
      // will be the sound on iOS
    );
    FlutterRingtonePlayer().playRingtone();
    globals.helper!.addSipUaHelperListener(this);
    print('------------> initializing incoming call 1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        builder: (controller) => Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage(themeController.isDarkMode ? Constants.assetPath + "dark_dashboard.png" : Constants.assetPath + "light_dashboard.png"), fit: BoxFit.fill)),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      padding: EdgeInsets.only(bottom: 40),
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(-0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [Colors.transparent, Color(0xFF1B47C5)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios_rounded,
                              color: AppColors.subCardColor,
                              size: 20,
                            ),
                            Text(
                              "Incoming call",
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                      ),
                      ClipOval(
                        child: CustomImageView(
                          height: 100,
                          width: 100,
                          imagePath: '${Constants.assetPath}user_1.png',
                          // imagePath: '${Constants.assetPath}${historyModel.image}',
                        ),
                      ).marginOnly(top: 20, bottom: 16),
                      getCustomFont(
                        widget.gcall!.remote_identity.toString(),
                        // historyModel.name,
                        26,
                        AppColors.getFontColor(context),
                        1,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getCustomFont(
                            globals.globalCallerNumber,
                            18,
                            AppColors.getFontColor(context),
                            1,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          // getCustomFont(
                          //   ' / 02:37 min',
                          //   16.sp,
                          //   AppColors.getFontColor(context),
                          //   1,
                          //   fontWeight: FontWeight.w400,
                          //   textAlign: TextAlign.center,
                          // ),
                        ],
                      ),
                      Spacer(),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                widget.gcall?.answer(globals.helper!.buildCallOptions(true));
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 78,
                                width: 78,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.greenColor, boxShadow: [
                                  BoxShadow(
                                    color: AppColors.statusBarColor.withOpacity(0.2),
                                    spreadRadius: 5,
                                    blurRadius: 10,
                                    offset: Offset(0, 8),
                                  )
                                ]),
                                child: Icon(
                                  Icons.call,
                                  color: AppColors.subCardColor,
                                  size: 35,
                                ),
                              ),
                            ),
                            SizedBox(width: 30),
                            Container(
                              height: 78,
                              width: 78,
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.subCardColor.withOpacity(0.5), boxShadow: [
                                BoxShadow(
                                  color: AppColors.statusBarColor.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: Offset(0, 8),
                                )
                              ]),
                              child: CustomImageView(svgPath: 'message.svg', onTap: null, height: 25, color: Colors.white),
                            ),
                            SizedBox(width: 30),
                            InkWell(
                              onTap: () {
                                widget.gcall?.peerConnection?.close();
                                FlutterRingtonePlayer().stop();
                                Get.back();
                              },
                              child: Container(
                                height: 78,
                                width: 78,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.callEndColor, boxShadow: [
                                  BoxShadow(
                                    color: AppColors.statusBarColor.withOpacity(0.2),
                                    spreadRadius: 5,
                                    blurRadius: 10,
                                    offset: Offset(0, 8),
                                  )
                                ]),
                                child: Icon(
                                  Icons.call_end,
                                  color: AppColors.subCardColor,
                                  size: 35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: (MediaQuery.of(context).size.height * .1) + 50,
                      )
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

  @override
  void callStateChanged(Call call, CallState state) {
    print('Callv state callStateChanged New : ${state.state.name}');
    print('my context: $myContext');
    print('state context: ${state.state}');

    switch (state.state) {
      case CallStateEnum.ENDED:
        // if (globalContext != null) {
        Get.back();
        // }
        // Navigator.of(myContext).pop();
        break;
      case CallStateEnum.FAILED:
        if (globalContext != null) {
          Get.back(closeOverlays: true);
        }
        // Navigator.of(myContext).pop();
        break;
      case CallStateEnum.NONE:
        // TODO: Handle this case.
        break;
      case CallStateEnum.STREAM:
        print('stream called');
        FlutterRingtonePlayer().stop();

//        IncomingCall().killScreen();
        // TODO: Handle this case.
        break;
      case CallStateEnum.UNMUTED:
        // TODO: Handle this case.
        break;
      case CallStateEnum.MUTED:
        // TODO: Handle this case.
        break;
      case CallStateEnum.CONNECTING:
        // TODO: Handle this case.
        break;
      case CallStateEnum.PROGRESS:
        // TODO: Handle this case.
        break;
      case CallStateEnum.ACCEPTED:
        // TODO: Handle this case.
        break;
      case CallStateEnum.CONFIRMED:
        // TODO: Handle this case.
        break;
      case CallStateEnum.REFER:
        // TODO: Handle this case.
        break;
      case CallStateEnum.HOLD:
        // TODO: Handle this case.
        break;
      case CallStateEnum.UNHOLD:
        // TODO: Handle this case.
        break;
      case CallStateEnum.CALL_INITIATION:
        // TODO: Handle this case.
        break;
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
}
