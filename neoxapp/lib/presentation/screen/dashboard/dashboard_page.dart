import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/main.dart';
import '../../../generated/l10n.dart';
import '../../controller/dashboard_controller.dart';
import '../../controller/message_controller.dart';
import '../../controller/new_socket_controller.dart';
import '../../widgets/curved_bottom_bar.dart';
import '../../widgets/custom_image_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _StateDashboardScreen();
}

class _StateDashboardScreen extends State<DashboardScreen> with WidgetsBindingObserver {
  DashboardController dashboardController = Get.put(DashboardController());
  MessageController controller = Get.put(MessageController());
  NewSocketController newSocketController = Get.put(NewSocketController());

  MessageController messageController = Get.put(MessageController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dashboardController.getAllContact();
    messageController.getMessegeData();
    newSocketController.getSocketObj();
    WidgetsBinding.instance.addObserver(this);
  }

  var appLifeState;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('didChangeAppLifecycleState ${state}');
    appLifeState = state;
    if (state == AppLifecycleState.paused) {
      newSocketController.socketDisconnect();
    } else if (state == AppLifecycleState.resumed) {
      newSocketController.socketconnect();
    }
  }

  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent, // status bar color
    //
    //     statusBarIconBrightness: PrefUtils.getIsDarkMode() ? Brightness.light : Brightness.dark // status bar color
    //     ));

    var size = MediaQuery.of(context).size;

    final double itemHeight = size.height;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: themeController.isDarkMode ? Colors.black : Colors.white, statusBarBrightness: themeController.isDarkMode ? Brightness.light : Brightness.dark, statusBarIconBrightness: themeController.isDarkMode ? Brightness.light : Brightness.dark));

    return WillPopScope(
      child: SafeArea(
        child: GetBuilder(
          builder: (controller) => Container(
            // decoration: controller.selectedIndex == 2
            //     ? ShapeDecoration(
            //           gradient: LinearGradient(
            //             begin: Alignment(-0.00, -1.00),
            //             end: Alignment(0, 1),
            //             colors: [Color(0xFF648CFF), Color(0xf315BD6)],
            //           ),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.only(topRight: Radius.circular(32.r), topLeft: Radius.circular(32.r)),
            //         ),
            //       )
            //     : null,
            child: Scaffold(
              body: Stack(
                children: [
                  Container(
                    decoration: controller.selectedIndex == 2 ? null : BoxDecoration(image: DecorationImage(image: AssetImage(themeController.isDarkMode ? Constants.assetPath + "dark_dashboard.png" : Constants.assetPath + "light_dashboard.png"), fit: BoxFit.fill)),
                    child: controller.widgetList[controller.selectedIndex],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Builder(builder: (context) {
                      print("theme===true");

                      return CurvedNavigationBar(
                        selectedIndex: controller.selectedIndex,
                        items: <String>[
                          'tab_call.svg',
                          'contact.svg',
                          '',
                          'chat.svg',
                          'setting.svg',
                        ],
                        selectedItems: <String>[
                          S.of(context).history,
                          S.of(context).contact,
                          '',
                          S.of(context).message,
                          S.of(context).setting,
                        ],
                        onTap: (index) {
                          dashboardController.update();
                          controller.onChange(index);
                          //Handle button tap
                        },
                        index: 2,
                        height: itemHeight >= 720 ? 85 : 75,
                      );
                    }),
                  )
                ],
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  controller.onChange(2);
                },
                backgroundColor: controller.selectedIndex == 2 ? AppColors.primaryColor : Colors.white,
                splashColor: AppColors.primaryColor.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: CustomImageView(
                    imagePath: '${Constants.assetPath}dialer.png',
                    height: 30,
                    color: controller.selectedIndex == 2
                        ? Colors.white
                        : Color(
                            0xff91ADFF,
                          )),
              ).marginOnly(bottom: itemHeight >= 720 ? 85 / 1.5 : 75 / 1.5),
              // bottomNavigationBar: CurvedNavigationBar(
              //
              //
              //   selectedIndex: controller.selectedIndex,
              //   items: <String>[
              //     'tab_call.svg',
              //     'contact.svg',
              //     '',
              //     'chat.svg',
              //     'setting.svg',
              //   ],
              //   selectedItems: <String>[
              //     S.of(context).history,
              //     S.of(context).contact,
              //     '',
              //     S.of(context).message,
              //     S.of(context).setting,
              //   ],
              //   onTap: (index) {
              //     controller.onChange(index);
              //     //Handle button tap
              //   },
              //   index: 2,
              //   height: 75.h,
              // ),
            ),
          ),
          init: DashboardController(),
        ),
      ),
      onWillPop: () => exit(0),
    );
  }
}
