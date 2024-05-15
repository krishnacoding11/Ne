import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:neoxapp/presentation/controller/login_controller.dart';
import 'package:neoxapp/presentation/controller/splash_controller.dart';
import 'package:neoxapp/presentation/screen/caller/call_screen.dart';
import 'package:neoxapp/presentation/screen/calling/calling_screen.dart';
import 'package:sip_ua/sip_ua.dart';
import 'package:neoxapp/presentation/widgets/globle.dart' as globals;
import 'package:fluttertoast/fluttertoast.dart';
import '../../../firebase/notification_service.dart';

late Map<String, Call> calls111;
late Call callglobalObjMain;
bool isCallPushBackground = false;
bool isSMSPushBackground = false;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _StateSplashScreen();
}

class _StateSplashScreen extends State<SplashScreen> with WidgetsBindingObserver implements SipUaHelperListener {
  SplashController splashController = Get.put(SplashController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    globals.helper = SIPUAHelper();
    registeredSip();
    if (Platform.isAndroid || Platform.isIOS) {
      notificationServices.requestNotificationPermission();
      notificationServices.forgroundMessage();
      notificationServices.firebaseInit(context);
      notificationServices.setupInteractMessage(context);
      notificationServices.isTokenRefresh();

      notificationServices.getDeviceToken().then((value) {
        if (kDebugMode) {
          print('device token');
          print(value);
        }
      });
    }
    WidgetsBinding.instance.addObserver(this);
    globals.helper!.addSipUaHelperListener(this);
    splashController.start();
  }

  NotificationServices notificationServices = NotificationServices();
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
    //     statusBarBrightness:!PrefUtils.getIsDarkMode()  ?Brightness.dark: Brightness.light,
    //     statusBarIconBrightness:!PrefUtils.getIsDarkMode()  ?Brightness.dark: Brightness.light
    // ));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light),
      child: WillPopScope(
        onWillPop: () => exit(0),
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Constants.assetPath + (commonSizeForDesktop(context) ? "desktop_splash.png" : "splash.png")), fit: BoxFit.fill)),
              ),
              Center(
                child: Container(
                  height: commonSizeForDesktop(context) ? 150 : 100,
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("${Constants.assetPath}logo_3.png"), fit: BoxFit.fitHeight)),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // return WillPopScope(child: Scaffold(
    //
    //
    //   appBar: CommonWidget.noneAppBar(),
    //
    //   body: Container(
    //     decoration: BoxDecoration(
    //       image: DecorationImage(
    //         image: AssetImage(Constants.assetPath+"splash.png"),
    //         fit: BoxFit.fill
    //       )
    //     ),
    //   ),
    // ), onWillPop: () => exit(0),);
  }

  @override
  Future<void> callStateChanged(Call call, CallState state) async {
    print('call state main********');
    if (call.state == CallStateEnum.CALL_INITIATION) {
      globals.callglobalObj = call;
      callglobalObjMain = call;

      calls111 = <String, Call>{};
      // calls111[call.id.toString()] =
      //     Call(call.id, call.session, CallStateEnum.CALL_INITIATION);

      Map<String, Call> tempMap = {
        call.id.toString(): Call(call.id, call.session, CallStateEnum.CALL_INITIATION),
      };

      calls111 = tempMap;
      // calls111 = {globals.callglobalObj!.id.toString(): globals.callglobalObj!};

      // calls111.addAll(tempMap);

      print('value length ${calls111.values.length}');
      print('call **** len ${calls111.length}');

      for (var entry in calls111.entries) {
        print('key ${entry.key}');
        print('value ${entry.value}');
      }

      // print('find call ${globals.helper!.findCall(call.id.toString())!.id}');
      // print(
      //     'find call ${globals.helper!.findCall(call.id.toString())!.session.id}');
      // print('--------myContext-----------$myContext');
      // print('--------callglobalObjMain-----------$callglobalObjMain');

      if (call.direction == "INCOMING") {
        print("isCallPushBackground:::====${isCallPushBackground}");
        if (isCallPushBackground = true) {
          print("isCallPushBackground:::${isCallPushBackground}");

          isCallPushBackground = false;
          print("isCallPushBackground====>>>${isCallPushBackground}");

          // call.answer(globals.helper!.buildCallOptions(true));
          // print("isCallPushBackground.....${isCallPushBackground}");
        }
      }
      if (call.direction == "INCOMING") {
        if (call.state != CallStateEnum.ACCEPTED || call.state != CallStateEnum.ENDED) {
          Get.to(() => CallingScreen(gcall: call));
        }
      }
    } else if (call.state == CallStateEnum.CONNECTING) {
      Get.to(
        () => CallScreen(calling: call.remote_identity.toString(), callObj: call, callerName: call.remote_identity.toString()),
        arguments: {"name": call.remote_identity.toString()},
      );

      // print(" PhNumber.value::${contactsController.PhNumber.value}");
      // print("callobject.value::${call.}");
      print("call.remote_identity::${call.remote_identity.toString()}");
      print("call.remote.displayname::${call.remote_display_name.toString()}");
      print("call.local_identity::${call.local_identity.toString()}");
      print("call.session.local_identity::${call.session.local_identity.toString()}");
      print("call.session.remote_identity::${call.session.remote_identity.toString()}");
      // print("X-FS-Support::${}");
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
    if (state.state == RegistrationStateEnum.UNREGISTERED) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: getCustomFont(
      //     "sip is not registere",
      //     17.sp,
      //     AppColors.getFontColor(context),
      //     1,
      //     fontWeight: FontWeight.w500,
      //     textAlign: TextAlign.center,
      //   ),
      // ));

      Fluttertoast.showToast(msg: "sip is not registere", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.white, textColor: Colors.black, fontSize: 16.0);
    } else if (state.state == RegistrationStateEnum.REGISTERED) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: getCustomFont(
      //     "sip is registere",
      //     17.sp,
      //     AppColors.getFontColor(context),
      //     1,
      //     fontWeight: FontWeight.w500,
      //     textAlign: TextAlign.center,
      //   ),
      // ));

      Fluttertoast.showToast(msg: "sip is registere", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.white, textColor: Colors.black, fontSize: 16.0);
    } else if (state.state == RegistrationStateEnum.REGISTRATION_FAILED) {
      Fluttertoast.showToast(msg: "sip is not registere", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.white, textColor: Colors.black, fontSize: 16.0);

      //
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: getCustomFont(
      //     "sip is not registere",
      //     17.sp,
      //     AppColors.getFontColor(context),
      //     1,
      //     fontWeight: FontWeight.w500,
      //     textAlign: TextAlign.center,
      //   ),
      // ));
    }
  }

  @override
  void transportStateChanged(TransportState state) {
    // TODO: implement transportStateChanged
  }
}
