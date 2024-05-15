import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:media_kit/media_kit.dart';
import 'package:neoxapp/api/databaseHelper.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/presentation/overlayScreen.dart';
import 'package:neoxapp/presentation/controller/theme_controller.dart';
import 'package:neoxapp/presentation/screen/caller/call_screen.dart';
import 'package:neoxapp/presentation/screen/splash/splash_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:window_manager/window_manager.dart';
import 'core/pref_utils.dart';
import 'firebase/firebase_options.dart';
import 'firebase/notification_service.dart';
import 'generated/l10n.dart';
import 'model/push_notification_model.dart';
import 'package:neoxapp/core/globals.dart' as globals;
import 'package:socket_io_client/socket_io_client.dart' as IO;

const String darwinNotificationCategoryText = 'textCategory';
String? currentUuid;
bool isCallPushBackground = false;

ThemeController themeController = Get.put(ThemeController());
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
const String darwinNotificationCategoryPlain = 'plainCategory';
late final Uuid _uuid;

// class ReceivedNotification {
//   ReceivedNotification({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.payload,
//   });
//
//   final int id;
//   final String? title;
//   final String? body;
//   final String? payload;
// }
// const String navigationActionId = 'id_3';
// void showFlutterNotification(RemoteMessage message) {
//   Map<String, dynamic> result = message.data;
//
//   print('result ${result['msgType']}');
//   print('message ${result}');
//
//   // if (result['msgType'] == "1") {
//   RemoteNotification? notification = message.notification;
//   AndroidNotification? android = message.notification?.android;
//
//   print('notification $notification');
//
//   print('android $android');
//
//   // if (notification != null && android != null) {
//   if (result['msgType'] == "1") {
//     flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       result['title'], //     notification.title,
//       result['body'],
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'push_notification',
//           'push_notification_channel',
//           channelDescription: 'test',
//           // TODO add a proper drawable resource to android, for now using
//           //      one that already exists in example app.
//           icon: 'launch_background',
//           // actions: <AndroidNotificationAction>[
//           //   AndroidNotificationAction('id_1', 'Action 1'),
//           //   AndroidNotificationAction('id_2', 'Action 2'),
//           //   AndroidNotificationAction('id_3', 'Action 3'),
//           // ],
//         ),
//       ),
//     );
//   } else {
//     // FlutterRingtonePlayer.play(
//     //   fromAsset: "assets/audio/dummy.mp3", // will be the sound on Android
//     //   ios: IosSounds.glass,
//     //   asAlarm: false,
//     //   looping: true,
//     //   volume: 1.0,
//     //   // will be the sound on iOS
//     // );
//     // FlutterRingtonePlayer.playRingtone();
//     flutterLocalNotificationsPlugin.show(
//       0,
//       result['title'], //     notification.title,
//       result['body'], //  notification.body,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'push_notification',
//           'push_notification_channel',
//           channelDescription: 'test',
//           // TODO add a proper drawable resource to android, for now using
//           //      one that already exists in example app.
//           icon: 'launch_background',
//           actions: <AndroidNotificationAction>[
//             AndroidNotificationAction('id_1', 'Accept'),
//             AndroidNotificationAction('id_2', 'Decline'),
//           ],
//         ),
//       ),
//     );
//     // }
//   }
// }
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // await setupFlutterNotifications();
//   // showFlutterNotification(message);
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//
//   // await Firebase.initializeApp();
//   // LocalNotificationService.initialize();
//   // LocalNotificationService.displayNotification(message, '1');
//   print('Handling a background _firebaseMessagingBackgroundHandler ${message}');
//
//   msg = message;
//   // showFlutterNotification(message);
//   Map<String, dynamic> result = message.data;
//   // // print('result : :: ${result['msgType']}'); //  = 1
//   //
//   if (result['msgType'] == '1') {
//     _handleMessage(message);
//   } else {
//     print("Handling a background message: ${message.messageId}");
//     isCallPushBackground = true;
//     showCallkitIncoming(Uuid().v4(), message);
//   }
//   //   printLongString('result :data :: ${result['data']}');
//   //   // debugPrint('result :data :: ${result['data'].newMessage}');
//   //   Map<String, dynamic> value = jsonDecode(result['data']);
//   //
//   //   var data = value['newMessage'];
//   //   print('doc** ${data['content']}');
//   //   var data1 = value['conversation'];
//   //
//   //   NotificationController.createNewNotification(
//   //       Random().nextInt(50),
//   //       'Notifications',
//   //       data1['secondUserPhoneNumber'],
//   //       data['content'],
//   //       value,
//   //       1);
//   // } else {
//   //   Map<String, dynamic> notification = message.data;
//   //   NotificationController.createNewNotification(
//   //       Random().nextInt(50),
//   //       "call_channel",
//   //       notification['title'],
//   //       notification['body'],
//   //       notification,
//   //       2);
//   // }
// }
//
// void getMethods() async {
//   // setupInteractedMessage();
//
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   // setupInteractedMessage();
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
//   //   _handleMessage(remoteMessage);
//   //   print('message open $remoteMessage');
//   //   print(
//   //       '[FirebaseMessaging.onMessageOpenedApp] remoteMessage.notification: ${remoteMessage.notification}');
//   //   print(
//   //       '[FirebaseMessaging.onMessageOpenedApp] remoteMessage.data: ${remoteMessage.data}');
//   //   print(
//   //       '[FirebaseMessaging.onMessageOpenedApp] remoteMessage.messageId: ${remoteMessage.messageId}');
//   // });
//
//   FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
//     print(
//         '[FirebaseMessaging.onMessage] remoteMessage.notification: ${remoteMessage.senderId}');
//     print(
//         '[FirebaseMessaging.onMessage] remoteMessage.data: ${remoteMessage.data}');
//     print(
//         '[FirebaseMessaging.onMessage] remoteMessage.messageId: ${remoteMessage.messageId}');
//
//     // RemoteNotification? notification = remoteMessage.notification;
//     // AndroidNotification? android = remoteMessage.notification?.android;
//     // print('[notification.] remoteMessage.messageId: ${notification}');
//     //
//     // print('[notification.] remoteMessage.messageId: ${notification?.body}');
//     // print('[android] remoteMessage.messageId: ${android}');
//     //
//     Map<String, dynamic> result = remoteMessage.data;
//
//     print('result ${result['msgType']}');
//     msg = remoteMessage;
//     if (result['msgType'] == "1") {
//       showFlutterNotification(remoteMessage);
//     } else {
//       print(
//           'Message title: ${result['title']}, body: ${result['body']}, data: ${remoteMessage.data}');
//       currentUuid = _uuid.v4();
//       showCallkitIncoming(currentUuid!, remoteMessage);
//     }
//     //   Map<String, dynamic> value = jsonDecode(result['data']);
//     //   NotificationController.createNewNotification(Random().nextInt(50),
//     //       'Notifications', notification?.title, notification?.body, value, 1);
//     // } else {
//     //   Map<String, dynamic> notification = remoteMessage.data;
//     //   int key = Random().nextInt(50);
//     //   NotificationController.key = key;
//     //   NotificationController.createNewNotification(
//     //       // 123,
//     //       key,
//     //       "call_channel",
//     //       notification['title'],
//     //       notification['body'],
//     //       notification,
//     //       2);
//     // }
//   });
// }
//
// // RemoteMessage? localMsg;
// final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
// StreamController<ReceivedNotification>.broadcast();
// void _handleMessage(RemoteMessage message) {
//   debugPrint('_handleMessage : :: ${message.data}');
//   Map<String, dynamic> result = message.data;
//   print('result : :: ${result['msgType']}'); //  = 1
//
//   if (result['msgType'] == "1") {
//     // printLongString('result :data :: ${result['data']}');
//     // debugPrint('result :data :: ${result['data'].newMessage}');
//     Map<String, dynamic> value = jsonDecode(result['data']);
//
//     var data = value['newMessage'];
//     print('doc** ${data['content']}');
//     var data1 = value['conversation'];
//     // Doc data1 = Doc.fromJson(value['conversation']);
//
//     // ArgumentChatDetailModel model = ArgumentChatDetailModel(
//     //   // messages: chatScreenController.getChatListModel.value.messageList[index].content.toString() ?? [],
//     //   // messages: chatScreenController.getSqfliteChatListModel[index].messages ?? [],
//     //   name: AppSharedPreference.userId.toString() == data1['firstId']
//     //       ? "${data1['secondUserName']}"
//     //       : "${data1['firstUserName']}",
//     //   // "${data1['firstUserPhoneNumber']} ${data1['secondUserPhoneNumber']}", //  "${data?.firstUserName} ${data?.secondUserName}",
//     //   time: data['time'],
//     //   id: data["_id"],
//     //   shortName: "${data1['firstUserName'][0]} ${data1['secondUserName'][0]}",
//     //   secondUserPhoneNumber: data1['secondUserPhoneNumber'],
//     //   firstUserPhoneNumber: data1['firstUserPhoneNumber'],
//     //   firstId: data1['firstId'],
//     //   secondId: data1['secondId'],
//     //   tag: '1',
//     // );
//     // Get.toNamed(Routes.ca, arguments: model);
//     // Navigation.pushNamed(Routes.chatScreen, arg: model);
//   }
// }
// final StreamController<String?> selectNotificationStream =
// StreamController<String?>.broadcast();
// RemoteMessage? msg;

firebaseSetup() async {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

//   NotificationSettings settings =
//       await FirebaseMessaging.instance.requestPermission(
//     alert: true,
//     badge: true,
//     provisional: false,
//     sound: true,
//   );
//
//   var initializationSettingsAndroid = new AndroidInitializationSettings(
//       '@mipmap/ic_launcher'); // <- default icon name is @mipmap/ic_launcher
//
//
//   final InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     // iOS: initializationSettingsDarwin,
//     // macOS: initializationSettingsDarwin,
//     // linux: initializationSettingsLinux,
//   );
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onDidReceiveNotificationResponse:
//           (NotificationResponse notificationResponse) {
//     print(
//         'onDidReceiveNotificationResponse ** ${notificationResponse.notificationResponseType}');
//     // print(
//     //     'onDidReceiveNotificationResponse ** ${notificationResponse.payload}');
//   });
//
//   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     print('User granted permission');
//     firebaseNotificationMethod();
//   } else {
//     print('User declined or has not accepted permission');
//   }
}
void getFcmToken() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('FCM TOKEN::::: $fcmToken');

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("PUSH_TOKEN", fcmToken.toString());
}

firebaseNotificationMethod() async {
  getFcmToken();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  // socketConnect();

  // For handling the received notifications
//  chatController.insertDbSingleObj(data1, false);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("notification call ${message.notification?.body}");

    // showFlutterNotification(message);

    // showSimpleNotification(Text(notification!.title!));
  });
  // For handling notification when the app is in background
  // but not terminated
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //  print("notification testing ${ message.notification?.title}");

    PushNotificationModel notification = PushNotificationModel(
      title: message.notification?.title,
      body: message.notification?.body,
    );

    print("notification testing title ${message.notification?.title}");
  });
}

@pragma('vm:entry-point')
Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase.initializeApp();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print("Handling a background notification message:11: ${message.notification}");
  if (message.notification != null) {
    NotificationServices notificationServices = NotificationServices();
    // notificationServices.showNotification(message, 1);
    // notificationServices.showNotificationWithButton(message);
  } else {
    // RingtonePlayer.stop();
  }
  return;
}

OverlayScreen? overlayScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid || Platform.isIOS) {
    await Firebase.initializeApp();
    firebaseSetup();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    getFcmToken();
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await PrefUtils().init();
  // FirebaseNotificationService.initializeService();
//   // getMethods();print("object===${WidgetsBinding.instance?.window.platformBrightness}");
//   // SIPUAHelper helper = SIPUAHelper();
//   if (globals.helper == null) {
//     globals.helper = SIPUAHelper();
//   }
//   // initSocket();
//   registeredSip();
//
//   _isAndroidPermissionGranted();
//   _requestPermissions();
//
//   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//     statusBarColor: Colors.transparent,
//     systemNavigationBarColor: Colors.transparent,
//   ));
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//   // checkNotificationPermission();
//   // NotificationController.initializeLocalNotifications();
//   const AndroidInitializationSettings initializationSettingsAndroid =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//   const initializationSettingsIOs = DarwinInitializationSettings();
//   // InitializationSettings initializationSettings = const InitializationSettings(
//   //     android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
//
//   // await flutterLocalNotificationsPlugin.initialize(
//   //   initializationSettings,
//   //   onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
//   //   onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
//   // );
//
//   final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
//       Platform.isLinux
//       ? null
//       : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
//
//   if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
//
//
//   }
//
//   final List<DarwinNotificationCategory> darwinNotificationCategories =
//   <DarwinNotificationCategory>[
//     DarwinNotificationCategory(
//       darwinNotificationCategoryText,
//       actions: <DarwinNotificationAction>[
//         DarwinNotificationAction.text(
//           'text_1',
//           'Action 1',
//           buttonTitle: 'Send',
//           placeholder: 'Placeholder',
//         ),
//       ],
//     ),
//     DarwinNotificationCategory(
//       darwinNotificationCategoryPlain,
//       actions: <DarwinNotificationAction>[
//         DarwinNotificationAction.plain('id_1', 'Action 1'),
//         DarwinNotificationAction.plain(
//           'id_2',
//           'Action 2 (destructive)',
//           options: <DarwinNotificationActionOption>{
//             DarwinNotificationActionOption.destructive,
//           },
//         ),
//         DarwinNotificationAction.plain(
//           navigationActionId,
//           'Action 3 (foreground)',
//           options: <DarwinNotificationActionOption>{
//             DarwinNotificationActionOption.foreground,
//           },
//         ),
//         DarwinNotificationAction.plain(
//           'id_4',
//           'Action 4 (auth required)',
//           options: <DarwinNotificationActionOption>{
//             DarwinNotificationActionOption.authenticationRequired,
//           },
//         ),
//       ],
//       options: <DarwinNotificationCategoryOption>{
//         DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
//       },
//     )
//   ];
//
//   /// Note: permissions aren't requested here just to demonstrate that can be
//   /// done later
//   final DarwinInitializationSettings initializationSettingsDarwin =
//   DarwinInitializationSettings(
//     requestAlertPermission: false,
//     requestBadgePermission: false,
//     requestSoundPermission: false,
//     onDidReceiveLocalNotification:
//         (int id, String? title, String? body, String? payload) async {
//       print('onDidReceiveLocalNotification $title');
//       print('body $body');
//       print('payload $payload');
//       didReceiveLocalNotificationStream.add(
//         ReceivedNotification(
//           id: id,
//           title: title,
//           body: body,
//           payload: payload,
//         ),
//       );
//     },
//     notificationCategories: darwinNotificationCategories,
//   );
//   final LinuxInitializationSettings initializationSettingsLinux =
//   LinuxInitializationSettings(
//     defaultActionName: 'Open notification',
//     defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
//   );
//   final InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsDarwin,
//     macOS: initializationSettingsDarwin,
//     linux: initializationSettingsLinux,
//   );
//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse:
//         (NotificationResponse notificationResponse) {
//           FlutterRingtonePlayer.stop();
//       print(
//           'onDidReceiveNotificationResponse ** ${notificationResponse.notificationResponseType}');
//       print(
//           'onDidReceiveNotificationResponse ** ${notificationResponse.payload}');
//
//       _handleMessage(msg!);
//       // switch (notificationResponse.notificationResponseType) {
//       //   case NotificationResponseType.selectedNotification:
//       //     selectNotificationStream.add(notificationResponse.payload);
//       //     break;
//       //   case NotificationResponseType.selectedNotificationAction:
//       //     print('notificationResponse ${notificationResponse.actionId}');
//       //     print('navigationActionId ${navigationActionId}');
//       //     if (notificationResponse.actionId == navigationActionId) {
//       //       selectNotificationStream.add(notificationResponse.payload);
//       //     }
//       //     break;
//       // }
//     },
//     onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
//   );
//
//
//   FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
//     if (event != null) {
//       print("CALLED   EVENT ${event.event}");
//       if (event.event == Event.actionCallAccept) {
//         print('accept call received');
//         print('accept call received ${msg?.data}');
//
//         Map<String, dynamic>? result = msg?.data;
//         print('result ${result!['body']}');
//
//         String callData = result!['body'];
//
//         callglobalObj?.answer(globals.helper!.buildCallOptions(true));
//         String callingNumber = callData.split("(")[1].toString();
//         print('callingNumber    $callingNumber');
//         Get.to(
//                 () => CallScreen(
//                 calling: callingNumber.replaceAll(")", ""),
//                 callerName: result!['callername'].toString(),
//                 callObj: "null"
//                 ),
//             arguments: {"name": result!['callername'].toString()});
//       } else if (event.event == Event.actionCallDecline) {
//         print('decline call received');
//
//         await FlutterCallkitIncoming.endCall(currentUuid!);
//
//         Future.delayed(const Duration(seconds: 2)).then((value) {
//           callglobalObj?.hangup();
//         });
//
//         // callglobalObjMain?.hangup();
//       } else if (event.event == Event.actionCallCallback) {
//         Map<String, dynamic>? result = msg?.data;
//         print('result ${result!['body']}');
//
//         String callData = result!['body'];
//
//         String callingNumber = callData.split("(")[1].toString();
//         // print(
//         //     'callingNumber    ${(callData.split("(")[1].toString().length - 1).toString()}');
//         SIPUAHelper helperObj = globals.helper!;
//         // number
//         // String number =
//         //     data.destinationNumber ?? "";
//         // // helperObj.call(number);
//         helperObj.call(callingNumber.replaceAll(")", ""),
//             voiceonly: true, mediaStream: null);
//
//         Get.to(
//             CallScreen(
//                 calling: callingNumber.replaceAll(")", ""),
//                 // (callData.split("(")[1].toString().length - 1).toString(),
//                 callerName: result!['callername'].toString(),
//                 callObj: globals.callglobalObj,
//                 tag: "2"),
//             arguments: {"name": result!['callername'].toString()})!;
//       } else {
//         print('call event -- ${event.event.toString()} ');
//       }
//     }
//     // switch (event?.event) {
//     //   case Event.actionCallIncoming:
//     //     // TODO: received an incoming call
// // todo: calling screen for the receive screen
// //     Get.to(
// //         caller(
// //             calling: callingNumber.replaceAll(")", ""),
// //             // (callData.split("(")[1].toString().length - 1).toString(),
// //             callerName: result!['callername'].toString(),
// //             callObj: globals.callglobalObj,
// //             tag: "2"),
// //         arguments: {"name": result!['callername'].toString()})!;
//     // todo : call receive listener
//     //     break;
//     //   case Event.actionCallStart:
//     //     // TODO: started an outgoing call
//     //     // TODO: show screen calling in Flutter
//     //     break;
//     //   case Event.actionCallAccept:
//     //     // TODO: accepted an incoming call
//     //     // TODO: show screen calling in Flutter
//     //     break;
//     //   case Event.actionCallDecline:
//     //     // TODO: declined an incoming call
//     //     break;
//     //   case Event.actionCallEnded:
//     //     // TODO: ended an incoming/outgoing call
//     //     break;
//     //   case Event.actionCallTimeout:
//     //     // TODO: missed an incoming call
//     //     break;
//     //   case Event.actionCallCallback:
//     //     // TODO: only Android - click action `Call back` from missed call notification
//     //     break;
//     //   case Event.actionCallToggleHold:
//     //     // TODO: only iOS
//     //     break;
//     //   case Event.actionCallToggleMute:
//     //     // TODO: only iOS
//     //     break;
//     //   case Event.actionCallToggleDmtf:
//     //     // TODO: only iOS
//     //     break;
//     //   case Event.actionCallToggleGroup:
//     //     // TODO: only iOS
//     //     break;
//     //   case Event.actionCallToggleAudioSession:
//     //     // TODO: only iOS
//     //     break;
//     //   case Event.actionDidUpdateDevicePushTokenVoip:
//     //     // TODO: only iOS
//     //     break;
//     //   case Event.actionCallCustom:
//     //     // TODO: for custom action
//     //     break;
//     // }
//   });
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      // size: Size(800, 600),
      minimumSize: Size(1000, 800),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  MediaKit.ensureInitialized();
  GetStorage.init();
  if (Platform.isAndroid) {

  }

  runApp(const MyApp());

}

@pragma('vm:entry-point')
void startCallback() {
  // print('startCallback ${globals.helper}');
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  // print('** ${{
  //   notificationResponse.notificationResponseType
  // }} notification(${notificationResponse.id}) action tapped: '
  //     '${notificationResponse.actionId} with'
  //     ' payload: ${notificationResponse.payload}');
  //
  // Map<String, dynamic>? result;
  // String callNumber = "";
  // if (msg != null) {
  //   result = msg!.data;
  //   callNumber = result['body'].toString().split('(')[1];
  // }

  // print('obj call ${callglobalObjMain}');
  // // SIPUAHelper helperObj = globals.helper!;
  // if (notificationResponse.actionId == 'id_1') {
  //   Future.delayed(Duration(milliseconds: 2)).then((value) {
  //     print('obj new ${callglobalObjMain}');
  //     if (callglobalObjMain != null) {
  //       callglobalObjMain?.answer(globals.helper!.buildCallOptions());
  //     }
  //   });

  // Navigator.pop(context);
  // String number = callNumber; //result != null ? (callNumber) : "";
  // // helperObj.call(number);
  // helperObj.call(number, voiceonly: true, mediaStream: null);
  // Get.to(
  //     () => CallScreen(
  //           calling: number,
  //           callObj: globals.callglobalObj,
  //           callerName: result != null ? result['app'] : number,
  //         ),
  //     arguments: {"name": result != null ? result['app'] : number});
  // } else {
  //   if (globals.callglobalObj != null) {
  //     globals.callglobalObj?.hangup();
  //   }
  // }

  // if (notificationResponse.input?.isNotEmpty ?? false) {
  //   // ignore: avoid_print
  //   print(
  //       'notification action tapped with input: ${notificationResponse.input}');
  // }
}

Future<void> initSocket() async {
  String? deviceId = await Constants().getId();
  String? deviceName = await Constants().getDeviceName();
  // String? deviceName1 = await Constants().getDeviceName();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setString("DeviceId", deviceId.toString());
  prefs.setString("DeviceName", deviceName.toString());
  print("deviceid---" + deviceId.toString());
  print("name---" + deviceName.toString());
  print("lastSmsId---" + prefs.getString("LastSMSId").toString());
  globals.socket = IO.io(Constants.socket_url, <String, dynamic>{
    'autoConnect': true,
    'transports': ['websocket'],
    "deviceUDID": deviceId,
    "lastSmsId": prefs.getString("LastSMSId")
  });

  globals.socket.connect();
  globals.socket.onConnect((_) {
    print('SOKET Connection established');
  });
  globals.socket.onDisconnect((_) => print('SOKET Connection Disconnection'));
  globals.socket.onConnectError((err) => print("SOKET connection error" + err));
  globals.socket.onError((err) => print("SOKET error" + err));

  globals.socket.on("outboundACK", (data) => print("SOKET outboundACK"));

  globals.socket.on("inboundSMS", (data) => print("SOKET inboundSMS"));

  globals.socket.on("accountCall", (data) => print("SOKET accountCall"));

  globals.socket.onAny((event, data) => print("SOKET $event"));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyApp();
  }
  // This widget is the root of your application.
}

class _MyApp extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    //
    WidgetsBinding.instance.addObserver(this);
    //  FlutterNativeSplash.remove();
  }

  // This callback is invoked every time the platform brightness changes.
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    // Get the brightness.
    var brightness = View.of(context).platformDispatcher.platformBrightness;

    themeController.changeTheme(isDark: brightness == Brightness.dark);

    print("light===$brightness");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: themeController.isDarkMode ? appDarkTheme(context) : appLightTheme(context),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: GetBuilder(
          builder: (controller) {
            return Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) {
                    overlayScreen = OverlayScreen.of(context);

                    return child!;
                  },
                )
              ],
            );
          },
          init: ThemeController(),
        ),
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      onInit: () {
        //   FlutterNativeSplash.remove();
        initDatabase;
        initDB();
        // FirebaseNotificationService.initializeService();ZZ
      },
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, S.delegate],
      // initialRoute: Routes.dashboardScreen,
      // routes: AppPages.routes,
      //home: (MediaQuery.of(context).size.width < 450) ? const DashboardScreen() : const DesktopScreen(),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Create an instance of OverlayScreen
//     final overlayScreen = OverlayScreen.of(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextButton(
//               onPressed: () {
//                 // display the overlay
//                 overlayScreen.show1();
//               },
//               child: const Text('Display Overlay'),
//             ),
//             const SizedBox(height: 30),
//             TextButton(
//               onPressed: () {
//                 // Call your next screen here
//               },
//               child: const Text('Go to next page'),
//             ),
//             const SizedBox(height: 30),
//             TextButton(
//               onPressed: () {
//                 // removed all overlays on the screen
//                 overlayScreen.closeAll();
//               },
//               child: const Text('Close Overlay'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// todo :
