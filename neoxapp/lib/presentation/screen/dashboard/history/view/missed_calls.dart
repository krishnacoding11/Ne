import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/presentation/controller/history_controller.dart';
import '../../model/history_model.dart';
import 'history_cell.dart';

class MissedCalls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HistoryController historyController = Get.find();
    // TODO: implement build
    return ListView.separated(
      itemBuilder: (context, index) {
        HistoryModel historyModel = historyController.getMissedCallData()[index];

        return HistoryCell(historyModel);
      },
      itemCount: historyController.getMissedCallData().length,
      padding: EdgeInsets.only(bottom: 100),
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }
}
