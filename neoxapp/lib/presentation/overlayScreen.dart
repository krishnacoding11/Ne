import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/presentation/screen/caller/call_screen.dart';
import 'package:neoxapp/presentation/screen/dialpad/dial_pad.dart';
import 'package:neoxapp/presentation/widgets/custom_image_view.dart';
import '../core/widget.dart';
import 'package:neoxapp/presentation/widgets/globle.dart' as globals;
import 'controller/call_controller.dart';

class OverlayScreen {
  /// Create an Overlay on the screen
  /// Declared [overlayEntrys] as List<OverlayEntry> because we might have
  /// more than one Overlay on the screen, so we keep it on a list and remove all at once
  BuildContext _context;
  OverlayState? overlayState;
  List<OverlayEntry>? overlayEntrys;

  void closeAll() {
    for (final overlay in overlayEntrys ?? <OverlayEntry>[]) {
      overlay.remove();
    }
    overlayEntrys?.clear();
    print("adsadasdsad==${overlayEntrys?.length}");
  }

  void show(callController) {
    print("adsadasdsad111");

    overlayEntrys?.add(
      OverlayEntry(
        builder: (context) {
          return _buildOverlayWidget(context, callController);
        },
      ),
    );

    overlayState?.insert(overlayEntrys!.last);
  }

  void show1() {
    overlayEntrys?.add(
      OverlayEntry(
        builder: (context) {
          return _buildOverlayWidget1(context);
        },
      ),
    );

    overlayState?.insert(overlayEntrys!.last);
  }

  OverlayScreen._create(this._context) {
    overlayState = Overlay.of(_context);
    overlayEntrys = [];
  }

  factory OverlayScreen.of(BuildContext context) {
    return OverlayScreen._create(context);
  }

  Widget _buildOverlayWidget1(
    context,
  ) {
    var height = MediaQuery.of(context).viewPadding.top;

    // return Positioned(
    //   top: height,
    //   right: 0,
    //   left: 0,
    //   child: GestureDetector(
    //     onTap: () {},
    //     child: Container(
    //       width: double.infinity,
    //       color: AppColors.greenColor,
    //       height: 50,
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           CustomImageView(
    //             height: 20,
    //             width: 20,
    //             onTap: () {},
    //             svgPath: 'call.svg',
    //             color: Colors.white,
    //           ),
    //           SizedBox(
    //             width: 20,
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    return Container();
  }

  Widget _buildOverlayWidget(context, CallController callController) {
    var height = MediaQuery.of(context).viewPadding.top;

    return Positioned(
      top: height,
      right: 0,
      left: 0,
      child: GestureDetector(
        onTap: () {
          if (onCallContactInfo == null) {
            return;
          }

          closeAll();
          Get.to(
              CallScreen(
                contactInfo: onCallContactInfo,
                isStart: true,
                callController: callController,
                calling: (onCallContactInfo?.number?.isEmpty ?? true) ? callController.number : onCallContactInfo?.number?[0].value,
                callerName: (onCallContactInfo?.name.isEmpty ?? true) ? "Unknown" : onCallContactInfo?.name,
                callObj: globals.callglobalObj,
              ),
              arguments: {"name": (onCallContactInfo?.name.isEmpty ?? true) ? "Unknown" : onCallContactInfo?.name});
        },
        child: Container(
          width: double.infinity,
          color: AppColors.greenColor,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomImageView(
                height: 20,
                width: 20,
                onTap: () {},
                svgPath: 'call.svg',
                color: Colors.white,
              ),
              SizedBox(
                width: 20,
              ),
              StreamBuilder(
                  stream: callController.seconds.stream,
                  builder: (context, snapshot) {
                    print("c===${callController.isStartTimer}===${callController.minutes.value.toString()}");
                    return getCustomFont(
                      '${callController.name == "Unknown" || callController.name.isEmpty ? callController.number : callController.name} - ${(callController.isStartTimer ? '${callController.minutes.value.toString().padLeft(2, '0')}:'
                          '${callController.seconds.value.toString().padLeft(2, '0')}' : "")}',
                      16,
                      Colors.white,
                      1,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
