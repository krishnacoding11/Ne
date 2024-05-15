import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/presentation/controller/history_controller.dart';
import 'package:neoxapp/presentation/screen/dashboard/history/view/history_cell.dart';
import '../../model/history_model.dart';

class AllCalls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HistoryController historyController = Get.find();
    // TODO: implement build
    return ListView.separated(
      itemBuilder: (context, index) {
        HistoryModel historyModel = historyController.getHistoryData()[index];

        return HistoryCell(historyModel);
      },
      itemCount: historyController.getHistoryData().length,
      padding: EdgeInsets.only(bottom: 100),
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }
}
