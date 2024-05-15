// To parse this JSON data, do
//
//     final chatDataModel = chatDataModelFromJson(jsonString);

import 'dart:convert';

ChatDataModel chatDataModelFromJson(String str) => ChatDataModel.fromJson(json.decode(str));

String chatDataModelToJson(ChatDataModel data) => json.encode(data.toJson());

class ChatDataModel {
  String? id;
  String? MSG_ID;
  dynamic broadcastId;
  dynamic broadcastMsgId;
  String? originalName;
  String? message;
  String? message_caption;
  int? messageType;
  int? mediaType;
  int? deliveryType;
  String? replyMessageId;
  dynamic scheduleTime;
  List<dynamic>? blockMessageUsers;
  List<String>? deleteMessageUsers;
  int? isDeleted;
  List<dynamic>? messageReactionUsers;
  dynamic messageDissapearTime;
  String? cid;
  String? senderId;
  String? senderFirstName;
  String? senderLastName;
  String? groupId;
  String? filePath;
  String? receiverId;
  ChatDataModel? replyMessage;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  int? isEdited;

  ChatDataModel({
    this.id,
    this.MSG_ID,
    this.broadcastId,
    this.broadcastMsgId,
    this.originalName,
    this.filePath,
    this.message,
    this.message_caption,
    this.messageType,
    this.mediaType,
    this.deliveryType,
    this.replyMessageId,
    this.scheduleTime,
    this.blockMessageUsers,
    this.replyMessage,
    this.deleteMessageUsers,
    this.isDeleted,
    this.messageReactionUsers,
    this.messageDissapearTime,
    this.cid,
    this.groupId,
    this.senderId,
    this.receiverId,
    this.senderFirstName,
    this.senderLastName,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isEdited,
  });

  factory ChatDataModel.fromJson(Map<String, dynamic> json, {bool fromDatabase = false}) {
    if (fromDatabase) {
      // print("object==${json["block_message_users"]}");

      return ChatDataModel(
        id: json["_id"],
        MSG_ID: json["MSG_ID"],
        broadcastId: json["broadcast_id"],
        broadcastMsgId: json["broadcast_msg_id"],
        originalName: json["originalName"],
        message: json["message"],
        message_caption: json["message_caption"],
        messageType: json["message_type"],
        filePath: json["filePath"] ?? "",
        mediaType: json["media_type"],
        deliveryType: json["delivery_type"],
        replyMessageId: json["reply_message_id"],
        scheduleTime: json["schedule_time"],
        blockMessageUsers: (json["block_message_users"] == null || json["block_message_users"] == "null") ? [] : (json["block_message_users"].toString().replaceAll("[]", "").isEmpty ? [] : List<dynamic>.from(jsonDecode(json["block_message_users"]).map((x) => x))),
        deleteMessageUsers: json["delete_message_users"].toString().replaceAll("[]", "").isEmpty ? [] : [],
        //  List<String>.from(jsonDecode(json["delete_message_users"]).map((x) => x)),
        isDeleted: json["is_deleted"],
        messageReactionUsers: json["message_reaction_users"].toString().replaceAll("[]", "").isEmpty ? [] : List<dynamic>.from(json["message_reaction_users"].map((x) => x)),
        messageDissapearTime: json["message_dissapear_time"],
        cid: json["cid"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        isEdited: json["is_edited"],
        senderFirstName: json["senderFirstName"] ?? "",
        senderLastName: json["senderLastName"] ?? "",
        groupId: json["group_id"] ?? "",
      );
    }
    return ChatDataModel(
      id: json["_id"],
      MSG_ID: json["MSG_ID"],
      broadcastId: json["broadcast_id"],
      broadcastMsgId: json["broadcast_msg_id"],
      originalName: json["originalName"],
      message: json["message"],
      message_caption: json["message_caption"],
      messageType: json["message_type"],
      senderFirstName: json["senderFirstName"] ?? "",
      senderLastName: json["senderLastName"] ?? "",
      mediaType: json["media_type"],
      filePath: json["filePath"] ?? "",
      deliveryType: json["delivery_type"],
      replyMessageId: json["reply_message_id"],
      scheduleTime: json["schedule_time"],
      blockMessageUsers: List<dynamic>.from(json["block_message_users"].map((x) => x)),
      deleteMessageUsers: List<String>.from(json["delete_message_users"].map((x) => x)),
      isDeleted: json["is_deleted"],
      groupId: json["group_id"] ?? "",
      messageReactionUsers: json["message_reaction_users"] == null || json["message_reaction_users"].isEmpty ? [] : List<dynamic>.from(json["message_reaction_users"].map((x) => x)),
      messageDissapearTime: json["message_dissapear_time"],
      cid: json["cid"],
      senderId: json["sender_id"],
      receiverId: json["receiver_id"] ?? "",
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      v: json["__v"],
      isEdited: json["is_edited"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "MSG_ID": MSG_ID,
        "broadcast_id": broadcastId,
        "broadcast_msg_id": broadcastMsgId,
        "originalName": originalName,
        "message": message,
        "message_caption": message_caption,
        "message_type": messageType,
        "media_type": mediaType,
        "filePath": filePath ?? "",
        "delivery_type": deliveryType,
        "reply_message_id": replyMessageId,
        "schedule_time": scheduleTime,
        "block_message_users": jsonEncode(blockMessageUsers),
        "delete_message_users": jsonEncode(deleteMessageUsers),
        "is_deleted": isDeleted,
        "message_reaction_users": jsonEncode(messageReactionUsers),
        "message_dissapear_time": messageDissapearTime,
        "cid": cid,
        "sender_id": senderId,
        "senderLastName": senderLastName ?? "",
        "senderFirstName": senderFirstName ?? "",
        "receiver_id": receiverId,
        "group_id": groupId ?? "",
        "createdAt": createdAt?.toLocal().toString(),
        "updatedAt": updatedAt?.toLocal().toString(),
        "__v": v,
        "is_edited": isEdited,
      };
}
