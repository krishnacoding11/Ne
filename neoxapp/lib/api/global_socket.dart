import 'package:neoxapp/core/globals.dart';
import 'package:neoxapp/presentation/widgets/globle.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GlobalSocket {
  static Socket? socket;
  GlobalSocket._();

  /// the one and only instance of this singleton
  static final instance = GlobalSocket._();
  bool isDelete = false;
  static bool isSend = false;
  bool isAdd = false;
  late String selectedUserId = "";
  late String broadcastId = "";
  late int isSelectedGroup = 0;
  var userId = "";
  var uid;

  Socket getSocketObj() {
    if (socket == null) {
      getSocket();
    }
    return socket!;
  }

  Future<Socket> getSocket() async {
    var cid = getUserData().eid ?? "";
    uid = await getUserData().sId ?? "";
    print("new get Socket===$cid=====>$uid");
    print("null--$socket");
    if (socket == null) {
      try {
        socket = io(
            '$baseSocketUrl' + uid + "&cid=" + cid,

            // 'wss://$baseServer/?cid=' + cid + "&uid=" + uid,
            OptionBuilder()
                .setTransports(['websocket', 'polling']) // for Flutter or Dart VM
                .disableAutoConnect()
                .build());
        socket!.connect();
        socket!.onConnect((msg) {
          print('socket on connect   $msg');
          listenAllSocket();
        });
        socket!.on("connect", (data) {
          print('socket connection   $data');
        });
        socket!.on("error_connection", (data) {
          print('socket error_connection   $data');
        });
        socket!.onConnecting((data) => print('connecting... $data'));
        socket!.onDisconnect((data) {
          print("socket on disconnect");
        });
        socket!.onConnectError((err) => print("o connection error==$err"));
        socket!.onError((err) => print("on Error==$err"));
      } catch (e) {
        print("exception===$e");
      }
    }
    return socket!;
  }

  listenAllSocket() async {
    print("listen socket new global");
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    socket!.on("receive_message", (messages) {
      print("new receive message socket");
    });
  }
}
