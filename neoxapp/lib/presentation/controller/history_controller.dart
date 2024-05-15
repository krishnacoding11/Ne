import 'package:get/get.dart';
import 'package:neoxapp/presentation/screen/dashboard/model/history_model.dart';

class HistoryController extends GetxController {
  int tabIndex = 0;

  onChange(int i) {
    tabIndex = i;
    update();
  }

  List<HistoryModel> getHistoryData() {
    return [
      HistoryModel(name: 'Melissa Jackson', image: 'user_1.png', status: 1, time: '2 min ago'),
      HistoryModel(name: 'Eugene Smith', status: 2, time: '4:38 pm'),
      HistoryModel(
        name: 'Leslie Pearson',
        status: 1,
        time: '10:06 pm',
        image: 'user_1.png',
      ),
      HistoryModel(
        name: '+91 740 530 50 60',
        status: 0,
        time: 'Yesterday',
      ),
      HistoryModel(
        name: 'Lorie Reynoso',
        status: 2,
        time: 'Yesterday',
      ),
      HistoryModel(name: 'Tracy Streeter (3)', status: 0, time: 'Yesterday', image: 'user_3.png'),
      HistoryModel(name: 'Jillian Sherry', status: 1, time: 'Wednesday', image: 'user_4.png'),
    ];
  }

  List<HistoryModel> getMissedCallData() {
    return [
      HistoryModel(name: 'Eugene Smith', status: 0, time: '4:38 pm'),
      HistoryModel(
        name: 'Leslie Pearson',
        status: 0,
        time: '10:06 pm',
        image: 'user_1.png',
      ),
      HistoryModel(
        name: 'Lorie Reynoso',
        status: 0,
        time: 'Yesterday',
      ),
      HistoryModel(name: 'Tracy Streeter (3)', status: 0, time: 'Yesterday', image: 'user_3.png'),
      HistoryModel(name: 'Jillian Sherry', status: 0, time: 'Wednesday', image: 'user_4.png'),
    ];
  }
}
