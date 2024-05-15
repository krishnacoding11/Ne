import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CallController extends GetxController {
  RxBool isCallRunning = false.obs;
  RxInt seconds = 0.obs;
  RxInt minutes = 0.obs;
  RxBool mishalCall = false.obs;
  RxBool zunaiarzCall = false.obs;
  TextEditingController textEditingController = TextEditingController(text: '');

  bool isStartTimer = false;
  String number = "";
  String name = "";

  bool isDialPad = false;
  onChange(bool i) {
    isDialPad = i;
    update();
  }
}
