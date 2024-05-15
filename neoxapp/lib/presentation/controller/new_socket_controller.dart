import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:neoxapp/model/restore_data_model.dart';
import 'package:neoxapp/presentation/controller/message_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mime/mime.dart';
import 'package:neoxapp/presentation/widgets/globle.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_client/web_socket_client.dart';
import '../../api/databaseHelper.dart';
import '../../core/globals.dart';
export 'package:provider/provider.dart';
//todo : replace url of socket here
import 'package:web_socket_channel/web_socket_channel.dart';
import 'chat_controller.dart';

class NewSocketController extends GetxController {
  ChatController chatController = Get.put(ChatController());
  late WebSocketChannel channel;
  bool isLoad = true;
  TextEditingController textEditingController = TextEditingController();

  static NewSocketController get(BuildContext context) => context.read<NewSocketController>();
  Function? function;

  init(String id, SideBarData sideBarData, Function function) async {
    this.function = function;
    String uid = await getUserData().sId ?? "";

    final uri = Uri.parse('$socketUrl/?uid=$uid&cid=${id}');
    const backoff = ConstantBackoff(Duration(seconds: 1));
    final socket1 = WebSocket(uri, backoff: backoff);

    // Listen for changes in the connection state.
    socket1.connection.listen((state) => print('socket_state: "${state}"'));

    // Listen for incoming messages.
    socket1.messages.listen((message) {
      print('message====: $message');

      // Send a message to the server.
      // socket.send('ping');
    });

    await Future.delayed(Duration(seconds: 3));

    socket1.send({"isgroup": 1, "cid": "$id", "sender_id": "$uid", "receiver_id": null, "message": "updated", "group_id": "${sideBarData.sId}", "message_type": 0, "media_type": 0, "reply_message_id": "", "schedule_time": null});

    isLoad = false;
    update();
  }

  static Socket? socket;
  var uid;
  var cid;
  var group_users = [].obs;
  var sec = 0;
  RxBool connected = true.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print("====${result} socket ====== ${socket?.connected}");
      // Got a new connectivity status!
      if (result != ConnectivityResult.none) {
        connected.value = false;
      }
      ;

      if (result != "ConnectivityResult.none" && socket?.connected == false) {
        getSocketObj();
      } else if (socket?.connected == false) {
        getSocketObj();
      }
    });
    getSocketObj();
    uid = getUserData().sId ?? "";
    cid = getUserData().eid ?? "";
    getvalue();
    super.onInit();
  }

  getvalue() {
    uid = getUserData().sId ?? "";
    cid = getUserData().eid ?? "";
    print("uid ===   ${getUserData().sId}");
  }

  Socket getSocketObj() {
    if (socket == null) {
      getSocket();
    }
    return socket!;
  }

  Future<Socket> getSocket() async {
    uid = getUserData().sId ?? "";
    cid = getUserData().eid ?? "";
    print("new get Socket===${uid}=====>${cid}");
    print("null--$socket");
    if (socket == null) {
      try {
        socket = io(
            '$baseSocketUrl' + uid + "&cid=" + cid,
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

  socketDisconnect() {
    if (socket != null) {
      print(" Disconnect ====00000000000 ");
      socket!.close();
      socket!.disconnect();
      socket!.dispose();
      // socket=null;
    }
  }

  socketconnect() {
    if (socket != null) {
      print(" connect  ====00000000000 ");
      socket!.connect();

      // socket=null;
    } else {
      getSocket();
    }
  }

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  disposeChannel() {
    channel.sink.close();
  }

  ///=============  All Emitter function is defined here =====================///
  checkchatisInserted(id) async {
    print("======$id");
    final db = await initDatabase;
    List<Map<String, dynamic>>? allData = [];
    allData = await db?.query("RestoreSideBarData", where: "_id=?", whereArgs: [id]);

    return allData?.length;
  }

  void send_message(tem_message_id, isgroup, receiverId, message, groupId, messageType, mediaType, replyMessageId, scheduleTime, file, message_caption, function, {String firstName = "", String lastName = ""}) async {
    print("==== temp id ${{"tmp_message_id": tem_message_id, "isgroup": isgroup, "cid": cid, "sender_id": uid, "receiver_id": isgroup == 1 ? null : receiverId, "message": message, "group_id": groupId, "message_type": messageType, "media_type": mediaType, "reply_message_id": replyMessageId, "schedule_time": scheduleTime}}");

    print("l111===${await checkchatisInserted(receiverId) == 0}");

    if (isgroup == 0 && await checkchatisInserted(receiverId) == 0) {
      List<Map<String, dynamic>> insertSidebar = [
        {'_id': receiverId, 'last_message': message, 'last_media_type': 0, 'cid': cid, 'createdAt': DateTime.now().toString(), 'block_by': 0, 'user_extension': "", 'isGroup': isgroup, 'isReported': 0, 'isBlocked': 0, 'istyping': 0, 'is_online': 0, 'isblocked_by_reciver': 0, 'last_seen': DateTime.now().toString(), 'mute_type': 0, 'ismute': 0, 'name': chatController.isfirst.value ? chatController.recieverName.value : firstName, 'description': "", 'image': "", 'last_message_time': DateTime.now().toString(), 'unread_msg_count': 0, 'pintime': DateTime.now().toString(), 'ispin': 0}
      ];
      await insertSideBarRestoreData(insertSidebar);
    }

    chatController.isfirst.value = false;

    if (mediaType == 0 || mediaType == 6 || mediaType == 1 || mediaType == 2 || mediaType == 4 || mediaType == 5) {
      chatController.insertData(tem_message_id, isgroup, receiverId, message, groupId, messageType, mediaType, replyMessageId, scheduleTime, file, message_caption, function);
    }
    socket?.emit("send_message", {"tmp_message_id": tem_message_id, "isgroup": isgroup, "cid": chatController.cid.value, "sender_id": chatController.uid.value, "receiver_id": isgroup == 1 ? null : receiverId, "message": message, "group_id": groupId, "message_type": messageType, "media_type": mediaType, "reply_message_id": replyMessageId, "schedule_time": scheduleTime, "message_caption": message_caption});
  }

  void sendDeliveryStatus(isgroup, groupId, messageId, deliveryType) {
    print("delivery status $deliveryType ,");
    socket!.emit("send_delivery_status", {"cid": cid, "isgroup": isgroup, "message_id": messageId, "group_id": isgroup == 1 ? groupId : null, "receiver_id": uid, "delivery_type": deliveryType});
  }

  void sendCreateGroup(groupName, description, groupImage, groupusers) {
    print("====$groupusers");
    socket?.emit("send_create_group", {"uid": uid, "cid": cid, "group_name": groupName, "description": description, "group_image": groupImage, "group_users": groupusers});
  }

  void removeGroupMembers(groupId, memberId) {
    socket?.emit("remove_group_members", {"uid": uid, "cid": cid, "group_id": groupId, "member_id": memberId});
  }

  void updateGroupData(groupId, groupName, groupImage, isAdminSendMessage) {
    socket?.emit("send_edit_group", {"group_id": groupId, "group_name": groupName, "description": "", "group_image": groupImage, "cid": cid, "is_admin_send_message": isAdminSendMessage});
  }

  void sendGroupAdmin(groupId, memberId) {
    socket?.emit("send_group_admin", {"uid": uid, "group_id": groupId, "member_id": memberId, "status": 1});
  }

  void addGroupMembers(groupId, memberId) {
    socket?.emit("add_group_members", {"uid": uid, "cid": cid, "group_id": groupId, "member_ids": memberId});
  }

  void sendEditMessage(isgroup, messageId, groupId, message, receiverId) {
    socket?.emit("send_edit_message", {"isgroup": isgroup, "message_id": messageId, "group_id": groupId, "uid": uid, "cid": cid, "message": message});
    chatController.updateEditedMessage(isgroup, message, messageId);
    Map<String, dynamic> row = {
      "receiver_id": isgroup == 1 ? groupId : receiverId,
      'last_message': message,
      'last_message_time': DateTime.now().toString(),
      'createdAt': DateTime.now().toString(),
      'last_media_type': 0,
    };
    chatController.updateLastmessage(row);
  }

  void sendBlock(isBlocked, blockId) {
    socket?.emit("send_block", {"cid": cid, "block_by": uid, "block_id": blockId, "isBlocked": isBlocked});
  }

  void leaveGroup(group_id) {
    print(" rec id --------  $group_id");
    socket?.emit("leave_goup", {"cid": cid, "uid": uid, "group_id": group_id});
  }

  void deleteConversation(isgroup, receiverId) {
    socket?.emit("delete_conversation", {"cid": cid, "uid": uid, "receiver_id": receiverId, "isgroup": isgroup});
  }

  void deleteSingleMessage(isgroup, MessageId, receiverId, isDeleteForMe, groupid) async {
    print("delete == $MessageId , $isgroup");
    chatController.DeleteSinglechat(MessageId, isgroup);
    socket?.emit("delete_message", {
      "cid": cid,
      "sender_id": uid,
      "receiver_id": receiverId,
      "isgroup": isgroup,
      "isDeleteForMe": isDeleteForMe,
      "message_ids": [MessageId],
      "group_id": groupid,
    });

    ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
      content: Text('Message deleted successfully '),
    ));

    if (function != null) {
      function!();
    }
    //  socket?.emit("delete_conversation", {"cid": cid, "uid": uid, "receiver_id": MessageId, "isgroup": isgroup});
  }

  void typing(String receiverId) {
    socket?.emit("typing", {"cid": cid, "sender_id": uid, "reciver_id": receiverId});
  }

  void checkuserOnelineStatus(String receiverId) {
    print(" oneline status ${{"cid": cid, "uid": uid, "reciver_id": receiverId}} ");
    socket?.emit("user_online_status", {"cid": cid, "uid": uid, "receiver_id": receiverId});
  }

  retrysend() async {
    List<Map<String, dynamic>> data = await getRestoreUserChatData();
    print("All data $data");
    data.forEach((element) async {
      if (element["delivery_type"] == 0) {
        if (element["media_type"] == 1 || element["media_type"] == 2 || element["media_type"] == 3 || element["media_type"] == 4 || element["media_type"] == 5) {
          print("All data ${element["filePath"]}");
          String? m1 = lookupMimeType(element["filePath"])?.split("/")[0];
          String? m2 = lookupMimeType(element["filePath"].toString())?.split("/")[1];

          chatController.uploadMultimediaApiCall(element["filePath"].toString(), element["filePath"].toString(), m1, m2, (data) async {
            print("file path== ${element["group_id"]}==========  typesss ${element["receiver_id"]}");

            socket?.emit("send_message", {"tmp_message_id": element["_i}d"], "isgroup": element["group_id"] != "" ? 1 : 0, "cid": cid, "sender_id": uid, "receiver_id": element["group_id"] != "" ? null : element["receiver_id"], "message": element["message"], "group_id": element["group_id"] != "" ? element["group_id"] : null, "message_type": element["message_type"], "media_type": element["media_type"], "reply_message_id": element["reply_message_id"], "schedule_time": data["url"]});

            final db = await initDatabase;
            Map<String, dynamic> insert = {"_id": element["_id"], "message": data["url"], "delivery_type": 1};
            await db?.update("RestoreUserChatData", insert, where: "_id=?", whereArgs: [element["_id"]]);
            MessageController messageController = Get.find();
            await messageController.getMessegeData();
            messageController.update();
            //  messageController.refresh();
            if (function != null) {
              function!();
            }
          });
        }
      }
    });
  }

  ///===================  All Listener function is here =================///

  listenAllSocket() async {
    socket!.on("receive_message", (messages) async {
      print("new receive_message ${messages} ");
      print("group inserted ${messages["message_detail"]["receiver_id"]}");
      if (messages["message_detail"]["receiver_id"] != null ? await chatController.checkchatisInserted(messages["message_detail"]["sender_id"]) == 0 : await chatController.checkchatisInserted(messages["message_detail"]["group_id"]) == 0) {
        print("new receive_message ${messages["isgroup"]} ");
        List<Map<String, dynamic>> insertSidebar = [
          {'_id': messages["message_detail"]["receiver_id"] != null ? messages["message_detail"]["sender_id"] : messages["message_detail"]["group_id"], 'last_message': messages["message_detail"]["message"], 'last_media_type': 0, 'cid': cid, 'createdAt': DateTime.now().toString(), 'block_by': 0, 'user_extension': "", 'isGroup': messages["isgroup"], 'isReported': 0, 'isBlocked': 0, 'istyping': 0, 'is_online': 0, 'isblocked_by_reciver': 0, 'last_seen': DateTime.now().toString(), 'mute_type': 0, 'ismute': 0, 'name': messages["message_detail"]["originalName"], 'description': "", 'image': "", 'last_message_time': DateTime.now().toString(), 'unread_msg_count': 0, 'pintime': DateTime.now().toString(), 'ispin': 0}
        ];
        await insertSideBarRestoreData(insertSidebar);
        getRestoreSideBarData();
        update();
      }

      if (messages["message_detail"]["receiver_id"] != null) {
        DateTime createdAt = DateTime.parse(messages["message_detail"]["createdAt"]).toLocal();
        messages["message_detail"]["createdAt"] = createdAt.toString();
        messages["message_detail"]["MSG_ID"] = messages["message_detail"]["_id"];

        // messages["message_detail"]["reply_message_id"] = messages["message_detail"]["reply_message_id"]!=null? messages["message_detail"]["reply_message_id"]["_id"]:"";

        await insertUserChatDataRestoreData(List<Map<String, dynamic>>.from([messages["message_detail"]]));
        sendDeliveryStatus(0, null, messages["message_detail"]["_id"], 2);
        await getRestoreUserChatData();
      } else if (messages["message_detail"]["group_id"] != null) {
        print("group inserted message ");
        DateTime updateTime = DateTime.parse(messages["message_detail"]["updatedAt"]).toLocal();
        messages["message_detail"]["updatedAt"] = updateTime.toString();
        messages["message_detail"]["sender_id"] = {"_id": messages["message_detail"]["sender_id"]["_id"], "first_name": messages["message_detail"]["sender_id"]["first_name"], "last_name": messages["message_detail"]["sender_id"]["first_name"]};
        messages["message_detail"]["MSG_ID"] = messages["message_detail"]["_id"];
        messages["message_detail"]["createdAt"] = updateTime.toString();

        await insertRestoreUserGroupChatData(List<Map<String, dynamic>>.from([messages["message_detail"]]));
        sendDeliveryStatus(1, messages["message_detail"]["group_id"], messages["message_detail"]["_id"], 2);
      }

      Map<String, dynamic> row = {"receiver_id": messages["message_detail"]["receiver_id"] != null ? messages["message_detail"]["receiver_id"] : messages["message_detail"]["group_id"], 'last_message': messages["message_detail"]["message"], 'last_message_time': DateTime.now().toString(), 'createdAt': DateTime.now().toString(), 'last_media_type': messages["message_detail"]["media_type"], 'senderId': messages["message_detail"]["sender_id"]};
      chatController.updateLastmessage(row);

      if (chatController.updateUnreadCount.value != messages["message_detail"]["sender_id"] && messages["isgroup"] == 0) {
        chatController.updateUnreadMessageCount(messages["message_detail"]["sender_id"], false);
      } else if (chatController.updateUnreadCount.value != messages["message_detail"]["group_id"]) {
        chatController.updateUnreadMessageCount(messages["message_detail"]["group_id"], false);
      }
      {}
    });

    socket!.on("ack_send_message", (messages) async {
      print("ack_send_message${messages}");

      if (messages["message_detail"] != null) {
        await chatController.updateDeliveryStatus(messages["message_detail"]["tmp_message_id"], messages["isgroup"], messages["message_detail"]["delivery_type"], messages["message_detail"]["_id"]);
      }
      MessageController messageController = Get.find();
      await messageController.getMessegeData();
      messageController.update();
      messageController.refresh();
      if (function != null) {
        function!();
      }
    });
    socket!.on("receive_group_member_detail", (messages) async {
      print("receive_group_member_detail${messages}");
    });
    socket!.on("receive_group_admin", (messages) async {
      print("receive_group_admin${messages}");
    });

    socket!.on("receive_edit_group", (messages) async {
      print("receive_edit_group${messages}");
      print("receive_edit_group12${messages["group_image"]}");

      await updateSideBarGroupData(messages["_id"], messages["group_name"], messages["group_image"]);

      MessageController messageController = Get.find();

      await messageController.getMessegeData();
      messageController.update();
    });

    socket!.on("receive_group_member_detail", (messages) async {
      print("receive_group_member_detail${messages}");
    });

    socket!.on("ack_remove_group_members", (messages) async {
      print("ack_remove_group_members${messages}");
    });

    socket!.on("ack_send_delivery_status", (messages) async {
      print("ack_send_delivery_status, $messages");
      await chatController.updateDeliveryStatus('', messages["isgroup"], messages["post"]["delivery_type"], messages["post"]["_id"]);
      chatController.updateInfoOneToOne(messages["post"]["updatedAt"], messages["post"]["_id"]);
      MessageController messageController = Get.find();
      await messageController.getMessegeData();
      messageController.update();

      if (function != null) {
        function!();
      }
    });

    socket!.on("receive_delivery_status", (messages) async {
      print("receive_delivery_status $messages");
      await chatController.updateDeliveryStatus('', messages["isgroup"], messages["post"]["delivery_type"], messages["post"]["_id"]);
      if (function != null) {
        function!();
      }
    });

    socket!.on("ack_send_create_group", (messages) {
      log("ack_send_create_group ${messages}");
      List<Map<String, dynamic>> a = [
        {"_id": messages["post"]["_id"], "last_message": messages["post"]["last_message"], "cid": messages["post"]["cid"], "last_media_type": messages["post"]["last_media_type"], "createdAt": DateTime.now().toString(), "block_by": messages["post"]["block_message_users"], "user_extension": "", "isGroup": 1, "isReported": 0, "isBlocked": 0, "istyping": 0, "is_online": 0, "isblocked_by_reciver": 0, "last_seen": "", "mute_type": 0, "ismute": 0, "name": messages["post"]["group_name"], "description": "", "image": messages["post"]["group_image"], "last_message_time": DateTime.now().toString(), "unread_msg_count": 0, "pintime": "", "ispin": 0}
      ];
      chatController.insertSidebar(a);
    });

    socket!.on("receive_create_group", (messages) {
      print("receive_create_group ${messages}");
      List<Map<String, dynamic>> a = [
        {"_id": messages["post"]["_id"], "last_message": messages["post"]["last_message"], "cid": messages["post"]["cid"], "last_media_type": messages["post"]["last_media_type"], "createdAt": DateTime.now().toString(), "block_by": messages["post"]["block_message_users"], "user_extension": "", "isGroup": 1, "isReported": 0, "isBlocked": 0, "istyping": 0, "is_online": 0, "isblocked_by_reciver": 0, "last_seen": "", "mute_type": 0, "ismute": 0, "name": messages["post"]["group_name"], "description": "", "image": messages["post"]["group_image"], "last_message_time": DateTime.now().toString(), "unread_msg_count": 0, "pintime": "", "ispin": 0}
      ];
      chatController.insertSidebar(a);
    });
    socket!.on("ack_send_edit_message", (message) {
      print("ack_send_edit_message $message");
    });
    socket!.on("receive_edit_message", (message) async {
      print("receive_edit_message $message");
      chatController.updateEditedMessage(message["isgroup"], message["message_detail"]["message"], message["message_detail"]["_id"]);
      Map<String, dynamic> row = {
        "receiver_id": message["isgroup"] == 1 ? message["group_id"] : message["message_detail"]["receiver_id"],
        'last_message': message["message_detail"]["message"],
        'last_message_time': DateTime.now().toString(),
        'createdAt': DateTime.now().toString(),
        'last_media_type': message["message_detail"]["message_type"],
      };
      chatController.updateLastmessage(row);
      MessageController messageController = Get.find();
      await messageController.getMessegeData();
      messageController.update();
      messageController.refresh();
      if (function != null) {
        function!();
      }
    });
    socket!.on("ack_send_block", (message) {
      print("ack_send_block $message");
      chatController.updateBlockStatus(message["isBlocked"], message["block_id"], uid);
    });
    socket!.on("ack_delete_conversation", (message) {
      print("ack_delete_conversation $message");
      Fluttertoast.showToast(
          msg: "Chat deleted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          // timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
    socket!.on("ack_delete_message", (message) {
      print("ack_delete_message $message");
    });
    socket!.on("receive_delete_message", (message) async {
      print("receive_delete_message ${message}");
      chatController.DeleteSinglechat(message["Deleted_messages"][0]["_id"], message["isgroup"]);
      if (function != null) {
        function!();
      }
    });
    socket!.on("ack_typing", (data) {
      chatController.isTyping.value = true;
      sec = sec + 5;
      print("ack_typing $data");
      Future.delayed(Duration(seconds: sec), () {
        chatController.isTyping.value = false;

        sec = 0;
      });
    });

    socket!.on("send_online_status", (message) {
      print("send_online_status, $message");
      updateSideBarRestoreData(message["_id"], message["is_online"], message["last_seen"]);
      chatController.getOnlineStatus(message["_id"]);
    });
    socket!.on("ack_user_online_status", (message) async {
      print("ack_user_online_status${message}");

      updateSideBarRestoreData(message["receiver_id"], message["user_status"], message["user_status"] == 1 ? null : message["user_lastseen_time"]);
      chatController.getOnlineStatus(message["receiver_id"]);
    });
    socket!.on("ack_leave_goup", (message) {
      print("ack_leave_goup ${message["message_detail"]["group_id"]}");
      chatController.updateleavegroupStatus(message["message_detail"]["group_id"]);
    });
    socket!.on("receive_leave_goup", (message) {
      print("receive_leave_goup $message");
    });
    if (function != null) {
      function!();
    }
  }
}
