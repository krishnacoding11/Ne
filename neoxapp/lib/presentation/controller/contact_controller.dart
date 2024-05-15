import 'package:get/get.dart';
import '../../model/enter_price_user_model.dart';

class ContactController extends GetxController {
  int tabIndex = 0;
  RxList<UserData> selectContactList = <UserData>[].obs;
  RxList groupuserIS = [].obs;
  onChange(int i) {
    tabIndex = i;
    update();
  }

  // ContactController() {
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
}
