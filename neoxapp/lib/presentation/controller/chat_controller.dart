import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:neoxapp/api/databaseHelper.dart';
import 'package:neoxapp/core/globals.dart';
import 'package:neoxapp/model/restore_data_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path_provider/path_provider.dart';
import '../../api/ApiServices.dart';
// import 'package:http/http.dart' show consolidateHttpClientResponseBytes;
import '../../core/api_constant.dart';
import '../../model/group_message_info.dart';
import '../screen/login/model/verify_model.dart';
import 'message_controller.dart';
import 'new_socket_controller.dart';

class ChatController extends GetxController {
  RxBool isTyping = false.obs;
  RxBool isEdit = false.obs;
  RxBool isMute = false.obs;
  RxBool isLoderoverFullScreen = false.obs;
  RxString updateUnreadCount = "".obs;
  RxInt isOnline = 0.obs;
  RxString lastseen = "".obs;
  RxString Isblock = "".obs;
  RxString MessageID = "".obs;
  RxBool isfirst = false.obs;
  RxBool isAdmin = false.obs;
  RxString recieverName = "".obs;
  Rx<RestoreDataModel> restoreDataModel = RestoreDataModel().obs;
  MessageController messageController = Get.put(MessageController());

  var GroupReadMessageinfo = <DDatum>[].obs;
  var GroupDeliveredMessageinfo = <DDatum>[].obs;

  RxBool getContactdetails = false.obs;

  RxString contactFristName = "".obs;

  RxString contactNumber = "".obs;

  RxBool isAvailble = true.obs;
  RxString uid = "".obs;
  RxString cid = "".obs;
  RxString useremail = "".obs;
  @override
  void onInit() {
    // TODO: implement onInit
    getdata();

    super.onInit();
  }

  void getdata() async {
    uid.value = getUserData().sId ?? "";
    cid.value = getUserData().eid ?? "";
    useremail.value = getUserData().emailAddress ?? "";
    print("uid ===   ${uid.value}");
  }

  restoreApiCall({String id = "65a65b135e602f3df469c24e", Function? callBack, Function(String)? count}) {
    UserDetails userDetails = getUserData();
    Api().call(
        url: "${ApiConstants.restoreUrl}/${userDetails.sId}",
        methodType: MethodType.get,
        success: (data) async {
          restoreDataModel.value = RestoreDataModel.fromJson(data, allData: true);

          Map<String, dynamic> tempMap = {"success": data["success"], "userChatDataLength": data["userChatDataLength"], "UserGroupChatDataLength": data["UserGroupChatDataLength"]};
          print("data==${data["userChatData"].length}");
          if (count != null && data["userChatData"] != null && data["UserGroupChatData"] != null) {
            count(((data["userChatData"].length) + (data["UserGroupChatData"]?.length)).toString());
          }
          await insertRestoreData(tempMap);

          print("sideBarData==${data["sideBarData"]}");
          await insertSideBarRestoreData(List<Map<String, dynamic>>.from(data["sideBarData"]));

          await insertUserChatDataRestoreData(List<Map<String, dynamic>>.from(data["userChatData"]));
          await insertRestoreUserGroupChatData(List<Map<String, dynamic>>.from(data["UserGroupChatData"]));

          var k = await getRestoreSideBarData();
          update();

          if (callBack != null) {
            callBack();
          }
        });

    getdata();
  }

  uploadMultimediaApiCall(
    filepath,
    file,
    mediatype1,
    mediatype2,
    Function success,
  ) async {
    UserDetails userDetails = getUserData();

    dio.MultipartFile imagedile = await dio.MultipartFile.fromFile(filepath, filename: filepath, contentType: MediaType(mediatype1, mediatype2));
    print("user==${"${ApiConstants.restoreUrl}/${userDetails.sId}"}");
    Api().call(
        url: ApiConstants.uploadMultiMediaUrl,
        params: dio.FormData.fromMap({"file": imagedile}),
        success: (data) async {
          print("data==${data}");

          success(data);
        });
  }

  GroupInfoApiCall(id) async {
    Api().call(
        url: "${ApiConstants.groupInfoUrl}${id}",
        methodType: MethodType.get,
        success: (data) async {
          print("data==${data}");
          GroupReadMessageinfo.clear();
          GroupDeliveredMessageinfo.clear();
          GroupDeliveredMessageinfo.value = [];
          GroupReadMessageinfo.value = GroupMessageInfo.fromJson(data).readData!;
          GroupDeliveredMessageinfo.value = GroupMessageInfo.fromJson(data).deliverdData!;
        });
  }

  getContactDetails(
    Function success,
  ) async {
    await contactFristName.value != "";
    success({contactFristName.value, contactNumber.value});
  }

  getOnlineStatus(id) async {
    final db = await initDatabase;
    List<Map<String, dynamic>> allData = [];
    allData = await db!.rawQuery("Select is_online, last_seen FROM RestoreSideBarData WHERE _id LIKE '%$id%'");
    //isOnline.value;
    if (allData.isNotEmpty) {
      isOnline.value = allData[0]["is_online"] == null || allData.isEmpty ? 0 : allData[0]["is_online"];
      lastseen.value = allData[0]["last_seen"] == "null" || allData[0]["last_seen"] == null ? "" : allData[0]["last_seen"].toString();
    }
  }

  DeleteSinglechat(id, group) async {
    final db = await initDatabase;
    if (group == 0) {
      await db?.delete("RestoreUserChatData", where: "MSG_ID=?", whereArgs: [id]);
    } else {
      await db?.delete("RestoreUserGroupChatData", where: "MSG_ID=?", whereArgs: [id]);
    }
    MessageController messageController = Get.find();
    await messageController.getMessegeData();
    messageController.update();
  }

  checkchatisInserted(id) async {
    print("======$id");
    final db = await initDatabase;
    List<Map<String, dynamic>>? allData = [];
    allData = await db?.query("RestoreSideBarData", where: "_id=?", whereArgs: [id]);

    return allData?.length;
  }

  String basePath = "";
  Future<String> getStoragePath() async {
    if (basePath.isNotEmpty) {
      return basePath;
    }

    String dir = "";
    // if (await Permission.storage.request().isGranted) {
    if (Platform.isAndroid) {
      dir = "/storage/emulated/0/Download";
    } else {
      dir = (await getApplicationDocumentsDirectory()).path;
    }
    // }

    basePath = dir;
    return basePath;
  }

  Future<String?> downloadImage({String? url, Function? callBack}) async {
    try {
      String dirPath = await getStoragePath();
      String title = url?.split("/").last ?? "";
      File file = File("");
      file = File('$dirPath/$title');
      if (await file.exists()) {
        print("===exists=>>>${file.path}");
        return file.path;
      }
      var httpClient = HttpClient();
      var request = await httpClient.getUrl(Uri.parse(url ?? ""));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);

      await file.create(recursive: true);

      await file.writeAsBytes(bytes);
      print("====>>>${file.path}");
      return file.path;
    } catch (e) {
      if (kDebugMode) {
        print("eeror =====> $e");
      }
      return null;
    }
  }

  updateLastmessage(Map<String, dynamic> tempmsg) async {
    final db = await initDatabase;
    try {
      var row = {
        'last_message': tempmsg['last_media_type'] == 0
            ? tempmsg['last_message']
            : tempmsg['last_media_type'] == 1
                ? "Image"
                : tempmsg['last_media_type'] == 2
                    ? "Video"
                    : tempmsg['last_media_type'] == 3
                        ? "Audio"
                        : tempmsg['last_media_type'] == 4
                            ? "Document"
                            : tempmsg['last_media_type'] == 5
                                ? "Contact"
                                : tempmsg['last_media_type'] == 6
                                    ? "Location"
                                    : "Info",
        'last_message_time': DateTime.now().toString(),
        'createdAt': DateTime.now().toString(),
        'last_media_type': tempmsg['last_media_type'],
      };
      print("==update==${tempmsg}");
      if (tempmsg['receiver_id'] == uid.value) {
        print("==update==1 ${uid.value}");
        await db?.update('RestoreSideBarData', row, where: '_id = ?', whereArgs: [tempmsg['senderId']]);
      } else {
        await db?.update('RestoreSideBarData', row, where: '_id = ?', whereArgs: [tempmsg['receiver_id']]);
        print("==update==2");
      }

      MessageController messageController = Get.find();
      await messageController.getMessegeData();
      messageController.update();
      messageController.refresh();
      NewSocketController socket = Get.find();
      if (socket.function != null) {
        socket.function!();
      }
    } catch (e, st) {
      if (kDebugMode) {
        print("ReadData--->${e.toString()}----$st");
      }
    } finally {}
  }

  updateDeliveryStatus(id, group, deliveryType, mID) async {
    final db = await initDatabase;
    // print("ooooo $mID == $deliveryType  == $group");
    var row = {'delivery_type': deliveryType, "MSG_ID": mID};
    var row1 = {'delivery_type': deliveryType};
    print("hello$id");
    if (deliveryType == 2 || deliveryType == 3) {
      if (group == 0) {
        print("delivery status  00000000");
        await db?.update("RestoreUserChatData", row1, where: "MSG_ID=?", whereArgs: [mID]);
      } else {
        await db?.update("RestoreUserGroupChatData", row1, where: "MSG_ID=?", whereArgs: [mID]);
      }
      await messageController.getMessegeData();
      messageController.update();

      NewSocketController socket = Get.find();
      if (socket.function != null) {
        socket.function!();
      }
    } else {
      if (group == 0) {
        await db?.update("RestoreUserChatData", row, where: "_id=?", whereArgs: [id]);
      } else {
        await db?.update("RestoreUserGroupChatData", row, where: "_id=?", whereArgs: [id]);
      }
    }

    await messageController.getMessegeData();
    messageController.update();
    NewSocketController socket = Get.find();

    if (socket.function != null) {
      socket.function!();
    }
  }

  updateBlockStatus(isBlocked, id, ByID) async {
    final db = await initDatabase;
    print("block id ${id} $isBlocked");
    var row = {
      'isBlocked': isBlocked,
    };

    await db?.update("RestoreSideBarData", row, where: "_id=?", whereArgs: [id]);
    getRestoreSideBarData();
    MessageController messageController = Get.find();
    await messageController.getMessegeData();
    messageController.update();

    isLoderoverFullScreen.value = false;
    GetIsBlock(id);
  }

  updateInfoOneToOne(updatedAt, MID) async {
    final db = await initDatabase;

    var row = {"updatedAt": updatedAt};

    await db?.update("RestoreUserChatData", row, where: "MSG_ID=?", whereArgs: [MID]);

    MessageController messageController = Get.find();
    await messageController.getMessegeData();
    messageController.update();
  }

  GetIsBlock(id) async {
    final db = await initDatabase;

    var all = await db!.rawQuery("Select isBlocked FROM RestoreSideBarData WHERE _id LIKE '%$id%'");

    if (all.isNotEmpty) {
      Isblock.value = all.first["isBlocked"].toString();
    }
  }

  insertData(tem_message_id, isgroup, receiverId, message, groupId, messageType, mediaType, replyMessageId, scheduleTime, file, message_caption, function, {String firstName = "", String lastName = ""}) async {
    List<Map<String, dynamic>> insert = [
      {
        "_id": tem_message_id,
        "MSG_ID": "",
        "broadcast_id": "",
        "broadcast_msg_id": "",
        "originalName": "",
        "message": message,
        "message_caption": message_caption,
        "message_type": messageType,
        "media_type": mediaType,
        "filePath": mediaType == 0 ? "" : file,
        "delivery_type": 0,
        "reply_message_id": replyMessageId.toString(),
        "schedule_time": scheduleTime,
        "block_message_users": [],
        "delete_message_users": [],
        "is_deleted": 0,
        "message_dissapear_time": "",
        "cid": cid.value,
        "receiver_id": isgroup == 1 ? "null" : receiverId,
        "createdAt": DateTime.now().toString(),
        "updatedAt": DateTime.now().toString(),
        "__v": 0,
        "is_edited": 0,
      }
    ];

    if (isgroup == 0) {
      print("===== insert one to one $receiverId");

      insert[0]["sender_id"] = uid.value;
      insert[0]["message_reaction_users"] = "";

      await insertUserChatDataRestoreData(List<Map<String, dynamic>>.from(insert));
      await getRestoreUserChatData();
      function();

      update();
    } else if (isgroup == 1) {
      print("===== insert 1111 ${receiverId}");
      insert[0]["sender_id"] = {"_id": uid, "first_name": firstName, "last_name": lastName};
      insert[0]["message_reaction_users"] = [];
      insert[0]["group_id"] = receiverId;

      await insertRestoreUserGroupChatData(List<Map<String, dynamic>>.from(insert));
      print("===== insert 2222 ${DateTime.now()}");

      await messageController.getMessegeData();
      messageController.update();
      messageController.refresh();
      if (function != null) {
        function!();
      }
    }

    Map<String, dynamic> row = {
      "receiver_id": isgroup == 1 ? groupId : receiverId,
      'last_message': message,
      'last_message_time': DateTime.now().toString(),
      'createdAt': DateTime.now().toString(),
      'last_media_type': mediaType,
    };
    updateLastmessage(row);
  }

  updateData(tem_message_id, isgroup, receiverId, message, groupId, messageType, mediaType, replyMessageId, scheduleTime, file, function, {String firstName = "", String lastName = ""}) async {
    Map<String, dynamic> insert = {
      "_id": tem_message_id,
      "message": message,
    };

    if (isgroup == 0) {
      await updateUserChatDataFullRestoreData(insert["message"], insert["_id"]);
      print("path 5 ${DateTime.now()}");
    } else if (isgroup == 1) {
      // insert["sender_id"] = {"_id": uid, "first_name": firstName, "last_name": lastName};
      insert["message_reaction_users"] = [];
      insert["group_id"] = receiverId;
      print("insert12===${insert}");
      await updateUserDataGroupChatDataRestoreData(insert, insert["_id"]);
    }

    MessageController messageController = Get.find();
    await messageController.getMessegeData();
    messageController.update();
    print("path 6 ${DateTime.now()}");
  }

  insertSidebar(data) async {
    await insertSideBarRestoreData(data);

    await messageController.getMessegeData();
    messageController.update();
    NewSocketController socket = Get.find();
    if (socket.function != null) {
      socket.function!();
    }
    update();
  }

  clearChat(group, receiverId) async {
    print("clear chat ${receiverId}   group  ${uid.value}");
    final db = await initDatabase;
    if (group == 0 || group == null) {
      await db?.delete("RestoreUserChatData", where: "receiver_id=? ", whereArgs: [receiverId]);
      await db?.delete("RestoreUserChatData", where: "sender_id=?", whereArgs: [receiverId]);
    } else {
      await db?.delete("RestoreUserGroupChatData", where: "group_id=?", whereArgs: [receiverId]);
    }
    Map<String, dynamic> row = {
      "receiver_id": receiverId,
      'last_message': "",
      'last_message_time': "",
      'createdAt': "",
      'last_media_type': 0,
    };
    updateLastmessage(row);

    messageController.update();
    NewSocketController socket = Get.find();
    if (socket.function != null) {
      socket.function!();
    }
    Fluttertoast.showToast(
      msg: "Chat cleared successfully",
    );
  }

  DeleteConverstion(group, id) async {
    print("Delete chat");
    final db = await initDatabase;
    await db?.delete("RestoreSideBarData", where: "_id=?", whereArgs: [id]);
    if (group == 0) {
      await db?.delete("RestoreUserChatData");
    } else {
      await db?.delete("RestoreUserGroupChatData");
    }

    MessageController messageController = Get.find();
    await messageController.getMessegeData();
    messageController.update();
  }

  updateleavegroupStatus(id) async {
    print(" update group memeber $id");
    final db = await initDatabase;
    var row = {'ismember': 0};
    await db?.update('RestoreSideBarData', row, where: '_id = ?', whereArgs: [id]);
    MessageController messageController = Get.find();
    await messageController.getMessegeData();
    messageController.update();
  }

  updateEditedMessage(group, message, mID) async {
    final db = await initDatabase;
    print("ooooo $mID ==   == $group");
    var row = {'message': message, 'is_edited': 1};
    if (group == 0) {
      await db?.update("RestoreUserChatData", row, where: "MSG_ID=?", whereArgs: [mID]);
      getRestoreUserChatData();
    } else {
      await db?.update("RestoreUserGroupChatData", row, where: "MSG_ID=?", whereArgs: [mID]);
    }

    await messageController.getMessegeData();
    messageController.update();
    NewSocketController socket = Get.find();
    if (socket.function != null) {
      socket.function!();
    }
  }

  updateUnreadMessageCount(id, read) async {
    print("update unread count $id ");
    final db = await initDatabase;
    if (!read) {
      List<Map<String, dynamic>> allData = [];
      allData = await db!.rawQuery("Select unread_msg_count FROM RestoreSideBarData WHERE _id LIKE '%$id%'");

      if (allData.isNotEmpty) {
        var row = {
          'unread_msg_count': allData[0]["unread_msg_count"] + 1,
        };
        await db?.update("RestoreSideBarData", row, where: "_id=?", whereArgs: [id]);
      } else {
        var row = {
          'unread_msg_count': 1,
        };
        await db?.update("RestoreSideBarData", row, where: "_id=?", whereArgs: [id]);
      }
    } else {
      var row = {
        'unread_msg_count': 0,
      };
      await db?.update("RestoreSideBarData", row, where: "_id=?", whereArgs: [id]);
    }

    MessageController messageController = Get.find();
    await messageController.getMessegeData();
    messageController.update();
    messageController.refresh();
    NewSocketController socket = Get.find();
    if (socket.function != null) {
      socket.function!();
    }
  }

  updateMuteNotification(id, mute) async {
    getMute(id);
    final db = await initDatabase;
    var row = {'ismute': mute};
    await db?.update("RestoreSideBarData", row, where: "_id=?", whereArgs: [id]);
    await messageController.getMessegeData();
    messageController.update();
    messageController.refresh();
    NewSocketController socket = Get.find();
    if (socket.function != null) {
      socket.function!();
    }
  }

  getMute(id) async {
    final db = await initDatabase;
    List<Map<String, dynamic>> allData = [];
    allData = await db!.rawQuery("Select ismute FROM RestoreSideBarData WHERE _id LIKE '%$id%'");
    if (allData[0]["ismute"] == 1) {
      isMute.value = true;
    } else {
      isMute.value = false;
    }
  }
}
