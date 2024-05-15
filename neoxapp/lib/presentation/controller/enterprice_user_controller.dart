import 'dart:developer';
import 'package:get/get.dart';
import 'package:neoxapp/api/ApiServices.dart';
import 'package:neoxapp/api/databaseHelper.dart';
import 'package:neoxapp/core/api_constant.dart';
import 'package:neoxapp/model/enter_price_user_model.dart';
import 'package:neoxapp/model/restore_data_model.dart';

class EnterPriceController extends GetxController {
  Rx<EnterPriceUserModel> enterPriceUserModel = EnterPriceUserModel().obs;
  RxList<UserData> enterPriceUserList = <UserData>[].obs;
  RxList<SideBarData> enterPriceUserAndSideBar = <SideBarData>[].obs;

  getEnterPriceCall({
    Function? callBack,
  }) {
    Api().call(
        url: ApiConstants.userContactList,
        methodType: MethodType.get,
        isProgressShow: true,
        success: (data) async {
          log("dsta==$data");
          List<SideBarData> sideBarDataList = [];
          enterPriceUserModel.value = EnterPriceUserModel.fromJson(data);
          enterPriceUserList.value = [];

          enterPriceUserList.addAll(enterPriceUserModel.value.userData ?? []);
          List<Map<String, dynamic>> sideBarData = await getRestoreSideBarData();
          sideBarData.forEach((element) {
            print("sode===${SideBarData.fromJson(element).name}");

            //  print("sode===${SideBarData.fromJson(element).name}");

            sideBarDataList.add(SideBarData.fromJson(element));
          });
          // sideBarDataList.forEach((element) {
          //   enterPriceUserAndSideBar.add(element);
          // });
          // enterPriceUserList.addAll(enterPriceUserModel.value.userData??[]);
          enterPriceUserModel.value.userData?.forEach((element) {
            String name = "${element.firstName} ${element.lastName}";
            String tag = name.isEmpty ? "#" : name.toString().substring(0, 1);
            enterPriceUserAndSideBar.add(SideBarData(isGroup: 0, name: name, image: element.userImage, cid: element.sId, tagIndex: tag, sId: element.sId));
          });
          if (callBack != null) {
            callBack();
          }
        });
  }
}
