// import 'dart:convert';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_callkit_incoming/entities/entities.dart';
// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:neoxapp/core/pref_utils.dart';
// import 'package:neoxapp/presentation/controller/login_controller.dart';
// import 'package:uuid/uuid.dart';
//
// // import 'package:intercom_flutter/intercom_flutter.dart';
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
// class FirebaseNotificationService {
//   static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//
//   static int item = 1;
//
//   static initializeService() async {
//     NotificationSettings settings = await firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//
//     item = 1;
//     try {
//       firebaseMessaging.requestPermission(sound: true, badge: true, alert: true, provisional: true);
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//
//     if (kDebugMode) {
//       print(PrefUtils.getFcmToken().toString());
//     }
//
// /*    if (isSwipeCartApp) {
//       try {
//         await Intercom.instance.initialize('appIdHere', iosApiKey: 'iosKeyHere', androidApiKey: 'androidKeyHere');
//         final intercomToken = Platform.isIOS ? await firebaseMessaging.getAPNSToken() : await firebaseMessaging.getToken();
//         Intercom.instance.sendTokenToIntercom(intercomToken ?? "");
//       } catch (e) {
//         if (kDebugMode) {
//           print(e);
//         }
//       }
//     }*/
//
//     firebaseMessaging.getToken().then((String? token) async {
//       assert(token != null);
//       if (kDebugMode) {
//         print("FCM-TOKEN $token");
//       }
//       PrefUtils.setFcmToken(token ?? "");
//     });
//   }
//
//   static getNotification() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//       if (kDebugMode) {
//         print(message);
//         print("--------------------------${message.data}");
//       }
//       // registeredSip();
//       showNotification(message);
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       if (kDebugMode) {
//         print(message.data);
//       }
//       // NotificationController.to.notificationReadCall(
//       //     params: {'"userid"': '"${getUserDetails().userId}"', '"notification_id"': '"${message.data["notification_id"]}"'}, callBack: () {});
//       // showNotification(message);
//       // notificationShow(
//       //   message.data["redirect_screen"],
//       //   data: message.data.containsKey("data") ? message.data["data"] : "",
//       //   title: message.data.containsKey("title") ? message.data["title"] : "",
//       // );
//       registeredSip();
//     });
//
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//   }
//
//   static notificationShow(pageId, {data, title}) {
//     // switch (pageId.toString()) {
//     //   case "1":
//     //     Get.to(() => const LoginScreen());
//     //     break;
//     //   case "2":
//     //     Get.to(() => const HomeScreen());
//     //     break;
//     //   case "3":
//     //     Get.to(() => const OffersProductScanningScreen());
//     //     break;
//     //   case "4":
//     //     Get.to(() => const ScreenDetailsScreen());
//     //     break;
//     //   case "5":
//     //     Get.to(() => const ReferalDetailsScreen());
//     //     break;
//     //   case "6":
//     //     Get.to(() => const BankManagementScreen());
//     //     break;
//     //   case "7":
//     //     Get.to(() => const AddBankScreen());
//     //     break;
//     //   case "8":
//     //     Get.to(() => const TransactionHistoryScreen());
//     //     break;
//     //   case "9":
//     //     Get.to(() => const ReferralListScreen());
//     //     break;
//     //   case "10":
//     //     Get.to(() => const WithdrawalRequestScreen());
//     //     break;
//     //   case "11":
//     //     Get.to(() => const WithdrawalHistoryListScreen());
//     //     break;
//     //   case "12":
//     //     Get.to(() => const QrScannerScreen());
//     //     break;
//     // }
//   }
//
//   static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     if (kDebugMode) {
//       print(message.data);
//     }
//     // NotificationController.to.notificationReadCall(
//     //     params: {'"userid"': '"${getUserDetails().userId}"', '"notification_id"': '"${message.data["notification_id"]}"'}, callBack: () {});
//     // showNotification(message);
//     // registeredSip();
//     showCallkitIncoming(Uuid().v4(),message);
//   }
//
//   static showNotification(RemoteMessage message) async {
//     FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     var androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iOSSettings = const DarwinInitializationSettings();
//     var initSettings = InitializationSettings(android: androidSettings, iOS: iOSSettings);
//
//     var android = const AndroidNotificationDetails('channel id', 'channel NAME', priority: Priority.high, importance: Importance.max);
//     var iOS = const DarwinNotificationDetails();
//     var platform = NotificationDetails(android: android, iOS: iOS);
//     var jsonData = jsonEncode(message.data);
//
//     flutterLocalNotificationsPlugin.initialize(initSettings, onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
//       if (kDebugMode) {
//         print(notificationResponse.payload);
//         registeredSip();
//
//       }
//     });
//
//     await flutterLocalNotificationsPlugin.show(item++, message.notification!.title ?? "", message.notification!.body ?? "", platform, payload: jsonData);
//   }
// }
// Future<void> showCallkitIncoming(String uuid, RemoteMessage remoteMessage) async {
//   print('string uuid ${uuid}');
//   Map<String, dynamic> result = remoteMessage.data;
//   String number = "8160062673" ?? result['body'];
//   // String call_id = result['callId'];
//   print('string  Call kit number ${number}');
//   // print('string  SIP call_id ${call_id}');
//   final params = CallKitParams(
//
//     id: uuid,
//     nameCaller: "text" ??  result['title'],
//     appName: 'SpotiFone',
//     // avatar: 'https://i.pravatar.cc/100',
//     handle: "8160062673"  ??result['body'],
//     type: 0,
//     // duration: 1000,
//     duration: 20000,
//     textAccept: 'Accept',
//     textDecline: 'Decline',
//     missedCallNotification: NotificationParams(
//       showNotification: false,
//       isShowCallback: false,
//       subtitle: 'Missed call',
//       callbackText: '',
//     ),
//     extra: <String, dynamic>{'userId': '1a2b3c4d23'},
//     headers: <String, dynamic>{'apiKey': 'Abc@1234!', 'platform': 'flutter'},
//     android: AndroidParams(isCustomNotification: true, isShowLogo: false, ringtonePath: "assets/audio/dummy.mp3", backgroundColor: '#000000', actionColor: '#4CAF50', incomingCallNotificationChannelName: "Incoming Call Spotifone", missedCallNotificationChannelName: "Missed Call Spotifone"),
//     ios: IOSParams(
//       iconName: 'CallKitLogo',
//       handleType: '',
//       supportsVideo: true,
//       maximumCallGroups: 2,
//       maximumCallsPerCallGroup: 1,
//       audioSessionMode: 'default',
//       audioSessionActive: true,
//       audioSessionPreferredSampleRate: 44100.0,
//       audioSessionPreferredIOBufferDuration: 0.005,
//       supportsDTMF: true,
//       supportsHolding: true,
//       supportsGrouping: false,
//       supportsUngrouping: false,
//       ringtonePath: 'system_ringtone_default',
//     ),
//   );
//
//   await FlutterCallkitIncoming.showCallkitIncoming(params);
//   //.then((value) => {
//   // print("CallKit BAck Value ${value}"),
//   //  print('call even register or notouter -- ${globals.helper?.registered} '),
//   // Future.delayed(Duration(seconds: 3)).then((value) async {
//   //   print('call even register or not t -- ${globals.helper
//   //       ?.registered} ');
//   //   print('call even register connected   or not t -- ${globals.helper?.connected} ');
//   //   print('call even register connected   or not t -- ${globals.helper?.registerState.toString()} ');
//   //   print('call even register connected   or not t findCallOne  -- ${globals.helper?.findCallOne()} ');
//   //
//   // }),
//   // });
//
//   await FlutterCallkitIncoming.onEvent.listen((event) async {
//     print("event=== ${event}");
//
//     // print("call event length :: ${event.toString()}");
//     // print("call event call_id :: ${call_id}");
//     // print("call event number :: ${number}");
//     // print("navigatorKey.currentContext :${NavigationService.navigatorKey.currentContext}");
//     // print(" navigatorKey.currentState ${NavigationService.navigatorKey.currentState}");
//     // if(globals.helper != null) {
//     //   if (globals.helper!.connected) {
//     //     print("call find call Number :: ${ globals.helper?.findCallNumber(number)}");
//     //   }
//     // }
//   });
// }
