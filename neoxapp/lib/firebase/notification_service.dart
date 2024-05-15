import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationServices {
  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSetting, onDidReceiveNotificationResponse: (payload) {
      // handle interaction when app is active for android
      // print('didC Global $appLifeState');

      handleMessage(context, message, 0);
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      // if (kDebugMode) {
      print("notifications title:${notification!.title}");
      print("notifications body:${notification.body}");
      print('count:${android!.count}');
      print('data:${message.data.toString()}');
      print('data:${message.notification!.android}');
      print('data:${message.notification!.android!.channelId}');
      // }

      final prefs = await SharedPreferences.getInstance();

      int id = (prefs.getInt("notificationId") ?? 1) + 1;

      const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('your channel id', 'your channel name', channelDescription: 'your channel description', importance: Importance.max, priority: Priority.high, ticker: 'ticker');

      const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(id, notification.title, notification.body, notificationDetails, payload: 'item x');

      prefs.setInt("notificationId", id);

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        getCurrentId(message, context);
      }
    });
  }

  void getCurrentId(RemoteMessage message, context) async {
    // await getCurrentUserid().then((value) {
    //   print('curent id : $value');
    //   // print('message id : ${message.data}');
    //   // print('message id : ${message.notification!.body}');
    //
    //   NotificationCallModal data1 = NotificationCallModal.fromJson(message.data);
    //
    //   // print('data1 id : ${data1.id}');
    //
    //   var temp = data1.id.toString().split(",");
    //   print('data2 id : ${temp[0]}');
    //
    //   if (value != temp[0]) {
    //     // initLocalNotifications(context, message);
    showNotification(message, 2);
    //   }
    // });
  }

  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled() ?? false;

      // setState(() {
      //   _notificationsEnabled = granted;
      // });
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted = await androidImplementation?.requestNotificationsPermission();
      // setState(() {
      //   _notificationsEnabled = granted ?? false;
      // });
    }
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
    _isAndroidPermissionGranted();
    _requestPermissions();
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message, int tag) async {
    // NotificationCallModal data1 = NotificationCallModal.fromJson(message.data);
    // // print("Handling a showNotification: ${data1.type}");
    // // print("Handling a showNotification: ${tag}");
    // // print("Handling a showNotification: ${message.notification!.android!.channelId}");
    //
    // var intValue = Random().nextInt(100);
    // AndroidNotificationChannel channel = AndroidNotificationChannel(
    //   // message.notification!.android!.channelId.toString(),
    //   data1.type == "3" || data1.type == "4" || data1.type == "5" || data1.type == "6" ? '11' : intValue.toString(),
    //   data1.type == "3" || data1.type == "4" || data1.type == "5" || data1.type == "6" ? '11' : intValue.toString(),
    //   importance: Importance.max,
    //   showBadge: false,
    //   playSound: true,
    //   // sound: const RawResourceAndroidNotificationSound('default_ringtone'),
    // );
    //
    // print("Channel id--" + channel.toString());
    // print("Channel id--" + channel.id.toString());
    //
    // var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    //
    // AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    //   // data1.type == "3" || data1.type == "4" || data1.type == "5" || data1.type == "6" ? '11' : '0',
    //     channel.id.toString(),
    //     channel.name.toString(),
    //     channelDescription: 'your channel description',
    //     importance: Importance.high,
    //     priority: Priority.high,
    //     playSound: true,
    //     ticker: 'ticker',
    //     setAsGroupSummary: true,
    //     sound: channel.sound,
    //     // sound: const RawResourceAndroidNotificationSound('default_ringtone'),
    //
    //     actions:
    //     // data1.type == "3" || data1.type == "4" || data1.type == "5" || data1.type == "6"
    //     //     ? <AndroidNotificationAction>[
    //     //         const AndroidNotificationAction('id_1', 'End Call'),
    //     //         const AndroidNotificationAction('id_2', 'Accept'),
    //     //       ]:
    //     [],
    //     //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
    //     icon:'@mipmap/ic_launcher'
    // );
    //
    // DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: false, presentSound: true);
    //
    // NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails, iOS: darwinNotificationDetails);
    //
    // bool isShown = true;
    // if (tag == 2) {
    //   isShown = data1.type == "3" || data1.type == "4" || data1.type == "5" || data1.type == "6" ? false : true;
    // }
    //
    // if (isShown) {
    //   Future.delayed(Duration.zero, () {
    //     flutterLocalNotificationsPlugin.show(
    //       data1.type == "3" || data1.type == "4" || data1.type == "5" || data1.type == "6" ? 11 : intValue,
    //       // channel.id != null ? int.parse(channel.id) : 0,
    //       message.notification!.title.toString(),
    //       message.notification!.body.toString(),
    //       notificationDetails,
    //     );
    //   });
    //
    //   Future.delayed(Duration(seconds: 1), () {
    //     if (data1.type == "3" || data1.type == "4" || data1.type == "5" || data1.type == "6") {
    //       flutterLocalNotificationsPlugin.cancel(11);
    //     } else {
    //       // if(tag==1)
    //       // flutterLocalNotificationsPlugin.cancel(intValue);
    //     }
    //   });
    // }
    // // }
    // // else {
    // //   Future.delayed(Duration.zero, () {
    // //     flutterLocalNotificationsPlugin.show(
    // //       data1.type == "3" || data1.type == "4" || data1.type == "5" || data1.type == "6" ? 11 : 0,
    // //       message.notification!.title.toString(),
    // //       message.notification!.body.toString(),
    // //       notificationDetails,
    // //     );
    // //   });
    // // }
    // if (tag == 1 && (data1.type == "3" || data1.type == "4" || data1.type == "5" || data1.type == "6")) {
    //   // RingtonePlayer.ringtone();
    //   RingtonePlayer.play(
    //       alarmMeta: AlarmMeta(
    //         'com.vitel.global.MainActivity',
    //         'ic_alarm_notification',
    //       ),
    //       volume: 0.4,
    //       android: Android.ringtone,
    //       ios: Ios.alarm,
    //       loop: true);
    //
    //   Future.delayed(Duration(seconds: 17), () {
    //     RingtonePlayer.stop();
    //   });
    //   // FlutterRingtonePlayer.play(fromAsset: "assets/images/default.mp3", volume: 0.4);
    // }
  }

  //function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    print("notification message app killed");

    // when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    print("notification message  184 ${initialMessage} ");
    if (initialMessage != null) {
      handleMessage(context, initialMessage, 1);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("notification message ");
      handleMessage(context, event, 12);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message, tag) {
    print("notification message 197  ${message.data} ");
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
