import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../api/databaseHelper.dart';
import '../../model/restore_data_model.dart';

class MessageController extends GetxController {
  int tabIndex = 0;
  TextEditingController textEditingController = TextEditingController();
  // SmsQuery query = new SmsQuery();
  // List<SmsThread> threads=[];
  RxList<SideBarData> chatSearchList = <SideBarData>[].obs;
  Future getAllMessages() async {
    // threads = await query.getAllThreads;

    // messages = await query.getAllSms;
    update();
  }

  MessageController() {
    getAllMessages();
  }

  onChange(int i) {
    tabIndex = i;
    update();
  }

  // MessageController() {
  //   getAllContact();
  // }
  //
  // getAllContact() async {
  //   if (await FlutterContacts.requestPermission()) {
  //     List<Contact> contacts = await FlutterContacts.getContacts();
  //
  //     _handleList(contacts);
  //
  //     update();
  //     print("conta==${contacts.length}");
  //   }
  // }
  // List<ContactInfo> contacts = [];
  //
  // void _handleList(List<Contact> list) {
  //   contacts = [];
  //   if (list.isEmpty) return;
  //   for (int i = 0, length = list.length; i < length; i++) {
  //
  //     print("sdf;lsd==${list[i]}");
  //     ContactInfo contactInfo = ContactInfo(name: list[i].displayName);
  //     String pinyin = PinyinHelper.getPinyinE(list[i].displayName);
  //     String tag = pinyin.substring(0, 1).toUpperCase();
  //     contactInfo.namePinyin = pinyin;
  //     if (RegExp("[A-Z]").hasMatch(tag)) {
  //       contactInfo.tagIndex = tag;
  //     } else {
  //       contactInfo.tagIndex = "#";
  //     }
  //     contacts.add(contactInfo);
  //   }
  //   // A-Z sort.
  //   az.SuspensionUtil.sortListBySuspensionTag(contacts);
  //
  //   // show sus tag.
  //   az.SuspensionUtil.setShowSuspensionStatus(contacts);
  //
  //   // add header.
  //
  //   print("l===${contacts.length}");
  //
  //   update();
  // }

  Rx<RestoreDataModel> restoreDataModel = RestoreDataModel().obs;

  getMessegeData() async {
    List<Map<String, dynamic>> data = await getRestoreData();
    List<Map<String, dynamic>> sideBarData = await getRestoreSideBarData();
    List<Map<String, dynamic>> userChatDataData = await getRestoreUserChatData();
    List<Map<String, dynamic>> userUserGroupChatData = await getRestoreUserGroupChatData();
    // print("userUserGroupChatData==============>>>>>${userUserGroupChatData}");
    // print("==============>>>>>${data.length}==${sideBarData.length}==${userChatDataData.length}==${userUserGroupChatData.length}");

    Map<String, dynamic> tData = {"success": data[0]["success"], "userChatDataLength": data[0]["userChatDataLength"], "UserGroupChatDataLength": data[0]["UserGroupChatDataLength"], "sideBarData": sideBarData, "userChatData": userChatDataData, "UserGroupChatData": userUserGroupChatData};
    restoreDataModel.value = RestoreDataModel.fromJson(tData);

    chatSearchList.value = restoreDataModel.value.sideBarData!;

    // print("restoreDataModel===${restoreDataModel.value.userChatData!.length}");
    // print("==============>>>>>${tData["sideBarData"]}");
    // print("==============>>>>>${tData["UserGroupChatData"]}");
  }
}
