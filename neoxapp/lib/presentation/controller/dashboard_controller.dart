import 'dart:io';
import 'package:contacts_service/contacts_service.dart' as cs;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:neoxapp/presentation/screen/dashboard/dialer/dialer_screen.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as request;
import 'package:azlistview/azlistview.dart' as az;
import 'package:neoxapp/presentation/screen/message/view/message_tab.dart';
import 'package:neoxapp/presentation/screen/setting/setting_screen.dart';
import '../../api/ApiServices.dart';
import '../../core/api_constant.dart';
import '../../model/group_detail_model.dart';
import '../screen/dashboard/contact/contact_screen.dart';
import '../screen/dashboard/history/history_screen.dart';
import '../screen/dashboard/model/contact_info_model.dart';
import 'new_socket_controller.dart';

class DashboardController extends GetxController {
  NewSocketController newSocketController = Get.put(NewSocketController());
  int selectedIndex = 2;

  onChange(int i) {
    selectedIndex = i;
    update();
  }

  getGroupDetailsApi({
    id,
    Function(GroupDetailModel)? callBack,
  }) {
    Api().call(
        url: ApiConstants.groupDetails + id,
        methodType: MethodType.get,
        isProgressShow: true,
        success: (data) async {
          print("data==$data");
          if (data["success"] == 1) {
            if (callBack != null) {
              callBack(GroupDetailModel.fromJson(data));
            }
          }
        });

    // Api().call(
    //     url: ApiConstants.groupDetails+id,
    //     methodType: MethodType.get,
    //     isProgressShow: true,
    //     success: (data) async {
    //       print("dsta==$data");
    //
    //
    //
    //       if(callBack != null){
    //         callBack();
    //       }
    //     });
  }

  List<Widget> widgetList = [
    const HistoryScreen(),
    const ContactScreen(),
    const DialerScreen(),
    const MessageScreen(),
    const SettingScreen()
    // RestoreScreen()
    // Container(
    //   color: Colors.white,
    //   child: Center(child: getCustomFont('Setting', 20.sp, AppColors.primaryColor, 1)),
    // ),
  ];

  DashboardController() {
    // getAllContact();
  }

  List<ContactInfo> contacts = [];
  List<cs.Contact> tempContacts = [];

  getAllContact() async {
    if (!Platform.isWindows) {
      if (await request.FlutterContacts.requestPermission()) {
        List<cs.Contact> contactList = await cs.ContactsService.getContacts();
        tempContacts = contactList;
        // final List<Contact> contacts = await FastContacts.getAllContacts();

        // List<Contact> contacts = await FlutterContacts.getContacts();

        await _handleList(contactList);
        if (Platform.isWindows) {
          for (int i = 0; i < 6; i++) {
            contacts.add(ContactInfo(displayName: "test user", name: "test user", number: [cs.Item(value: "142545425", label: "adfd")]));
          }
        }

        update();
      }
    }
  }

  Future<void> _handleList(List<cs.Contact> list) async {
    try {
      contacts = [];
      if (list.isEmpty) return;
      for (int i = 0, length = list.length; i < length; i++) {
        // Contact? contact = await FastContacts.getContact(list[i].id);
        // cs.Contact? contact = await cs.ContactsService.getContactsForPhone((list[i].phones?.isEmpty ?? true) ? "" : (list[i].phones[0].value ?? ""));

        // Uint8List? thumbnail = await FastContacts.getContactImage(contact!.id);

        print("sdf;lsd==${list[i]}");

        ContactInfo contactInfo = ContactInfo(
          name: list[i].displayName ?? "",
          number: list[i].phones,
          img: list[i].avatar,
          suffix: list[i].suffix,
          displayName: list[i].displayName,
          company: list[i].company,
          jobTitle: list[i].jobTitle,
          prefix: list[i].prefix,
          middleName: list[i].middleName,
          givenName: list[i].givenName,
          familyName: list[i].familyName,
          emails: list[i].emails,
          androidAccountType: list[i].androidAccountType,
          birthday: list[i].birthday,
          postalAddresses: list[i].postalAddresses,
        );
        String pinyin = PinyinHelper.getPinyinE((list[i].displayName?.isEmpty ?? true) ? "Guest" : (list[i].displayName ?? ""));
        String tag = pinyin.substring(0, 1).toUpperCase();
        contactInfo.namePinyin = pinyin;
        if (RegExp("[A-Z]").hasMatch(tag)) {
          contactInfo.tagIndex = tag;
        } else {
          contactInfo.tagIndex = "#";
        }
        contacts.add(contactInfo);
      }
      // A-Z sort.
      az.SuspensionUtil.sortListBySuspensionTag(contacts);

      // show sus tag.
      az.SuspensionUtil.setShowSuspensionStatus(contacts);

      // add header.

      print("l===${contacts.length}");

      update();
    } catch (e) {
      print("=====${e}");
    }
  }
}
