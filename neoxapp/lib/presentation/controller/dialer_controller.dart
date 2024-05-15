import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:neoxapp/presentation/screen/dashboard/model/dialer_model.dart';

class DialerController extends GetxController {
  TextEditingController textEditingController = TextEditingController(text: '');

  List<DialerModel> getKeyData() {
    return [
      DialerModel(text: '1', isCall: false, subText: ''),
      DialerModel(text: '2', isCall: false, subText: 'ABC'),
      DialerModel(text: '3', isCall: false, subText: 'DEF'),
      DialerModel(text: '4', isCall: false, subText: 'GHI'),
      DialerModel(text: '5', isCall: false, subText: 'JKL'),
      DialerModel(text: '6', isCall: false, subText: 'MNO'),
      DialerModel(text: '7', isCall: false, subText: 'PQR'),
      DialerModel(text: '8', isCall: false, subText: 'STU'),
      DialerModel(text: '9', isCall: false, subText: 'VWXZ'),
      DialerModel(text: '*', isCall: false, subText: ''),
      DialerModel(text: '0', isCall: false, subText: '+'),
      DialerModel(text: '#', isCall: false, subText: ''),
      DialerModel(text: '', isCall: false, subText: ''),
      DialerModel(text: '', isCall: true, subText: ''),
      DialerModel(text: '', isCall: false, subText: ''),
    ];
  }
}
