import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../model/restore_data_model.dart';

class NewMessagesController extends GetxController {
  SideBarData? sideBarData;
  bool isGroup = false;

  ScrollController scrollController = ScrollController();

  bool isRecording = false;

  TextEditingController chatController = TextEditingController();

  setSideBarData(SideBarData sideBarData) {
    this.sideBarData = sideBarData;
    isGroup = sideBarData.isGroup == 1;

    update();
  }
}
