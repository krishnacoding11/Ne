import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../model/group_detail_model.dart';
import 'chat_controller.dart';
import 'dashboard_controller.dart';
import 'package:mime/mime.dart';
import 'new_socket_controller.dart';

class GroupInfoController extends GetxController {
  GroupDetailModel? groupDetailModel;
  RxBool isMessageAdmin = false.obs;
  RxBool isEdit = false.obs;
  String isAdminId = '';
  TextEditingController textFiledController = TextEditingController();
  NewSocketController newSocketController = Get.find();

  String path = '';

  ChatController chatController = Get.find();

  getImageFromGlarey() async {
    var image = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    print("l===${image}");

    if (image == null) {
      return;
    }

    if (image.files.isEmpty) {
      return;
    }

    path = image.files[0].path.toString();

    update();
  }

  sendData({image, admin, isImage = false}) async {
    if (isImage && path.isNotEmpty) {
      String? m1 = lookupMimeType(path.toString())?.split("/")[0];
      String? m2 = lookupMimeType(path.toString())?.split("/")[1];

      await chatController.uploadMultimediaApiCall(path.toString(), path.toString(), m1, m2, (data) async {
        print(" dataurl===${data["url"]}");

        newSocketController.updateGroupData(groupDetailModel!.groupDetai.id, textFiledController.text, data["url"], admin ?? groupDetailModel!.groupDetai.isAdminSendMessage);
      });
    } else {
      print(" dataurl===${groupDetailModel!.groupDetai.groupImage}");

      newSocketController.updateGroupData(groupDetailModel!.groupDetai.id, textFiledController.text, groupDetailModel!.groupDetai.groupImage, admin ?? groupDetailModel!.groupDetai.isAdminSendMessage);
    }

    updateData();
  }

  setData(GroupDetailModel? model) {
    groupDetailModel = null;
    groupDetailModel = model;

    print("dsta1212==${groupDetailModel!.groupDetai.groupUsers.length}");

    isMessageAdmin.value = groupDetailModel!.groupDetai.isAdminSendMessage == 1;

    textFiledController.text = groupDetailModel!.groupDetai.groupName;

    isEdit.value = false;
    path = "";
    update();
  }

  DashboardController dashboardController = Get.find();

  updateData() {
    Future.delayed(const Duration(milliseconds: 500), () {
      dashboardController.getGroupDetailsApi(
        id: groupDetailModel!.groupDetai.id,
        callBack: (p0) {
          setData(p0);
        },
      );
    });
  }
}
