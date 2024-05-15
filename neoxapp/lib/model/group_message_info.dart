// To parse this JSON data, do
//
//     final groupMessageInfo = groupMessageInfoFromJson(jsonString);

import 'dart:convert';

GroupMessageInfo groupMessageInfoFromJson(String str) => GroupMessageInfo.fromJson(json.decode(str));

String groupMessageInfoToJson(GroupMessageInfo data) => json.encode(data.toJson());

class GroupMessageInfo {
  int? success;
  String? message;
  MessageDetail? messageDetail;
  List<DDatum>? readData;
  List<DDatum>? deliverdData;

  GroupMessageInfo({
    this.success,
    this.message,
    this.messageDetail,
    this.readData,
    this.deliverdData,
  });

  factory GroupMessageInfo.fromJson(Map<String, dynamic> json) => GroupMessageInfo(
        success: json["success"],
        message: json["message"],
        messageDetail: json["MessageDetail"] == null ? null : MessageDetail.fromJson(json["MessageDetail"]),
        readData: json["ReadData"] == null ? [] : List<DDatum>.from(json["ReadData"]!.map((x) => DDatum.fromJson(x))),
        deliverdData: json["DeliverdData"] == null ? [] : List<DDatum>.from(json["DeliverdData"]!.map((x) => DDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "MessageDetail": messageDetail?.toJson(),
        "ReadData": readData == null ? [] : List<dynamic>.from(readData!.map((x) => x.toJson())),
        "DeliverdData": deliverdData == null ? [] : List<dynamic>.from(deliverdData!.map((x) => x.toJson())),
      };
}

class DDatum {
  String? id;
  dynamic deliveryTime;
  dynamic readTime;
  int? deliveryType;
  String? cid;
  String? groupId;
  String? messageId;
  ReceiverId? receiverId;
  String? senderId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  DDatum({
    this.id,
    this.deliveryTime,
    this.readTime,
    this.deliveryType,
    this.cid,
    this.groupId,
    this.messageId,
    this.receiverId,
    this.senderId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory DDatum.fromJson(Map<String, dynamic> json) => DDatum(
        id: json["_id"],
        deliveryTime: json["delivery_time"],
        readTime: json["read_time"],
        deliveryType: json["delivery_type"],
        cid: json["cid"],
        groupId: json["group_id"],
        messageId: json["message_id"],
        receiverId: json["receiver_id"] == null ? null : ReceiverId.fromJson(json["receiver_id"]),
        senderId: json["sender_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "delivery_time": deliveryTime,
        "read_time": readTime,
        "delivery_type": deliveryType,
        "cid": cid,
        "group_id": groupId,
        "message_id": messageId,
        "receiver_id": receiverId?.toJson(),
        "sender_id": senderId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class ReceiverId {
  String? id;
  String? userImage;
  String? firstName;
  String? lastName;

  ReceiverId({
    this.id,
    this.userImage,
    this.firstName,
    this.lastName,
  });

  factory ReceiverId.fromJson(Map<String, dynamic> json) => ReceiverId(
        id: json["_id"],
        userImage: json["user_image"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_image": userImage,
        "first_name": firstName,
        "last_name": lastName,
      };
}

class MessageDetail {
  String? id;
  String? originalName;
  String? message;
  String? messageCaption;
  int? messageType;
  int? mediaType;
  int? deliveryType;
  String? replyMessageId;
  dynamic scheduleTime;
  List<dynamic>? blockMessageUsers;
  List<dynamic>? deleteMessageUsers;
  int? isDeleted;
  List<dynamic>? messageReactionUsers;
  dynamic messageDissapearTime;
  int? isEdited;
  String? cid;
  String? groupId;
  String? senderId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  MessageDetail({
    this.id,
    this.originalName,
    this.message,
    this.messageCaption,
    this.messageType,
    this.mediaType,
    this.deliveryType,
    this.replyMessageId,
    this.scheduleTime,
    this.blockMessageUsers,
    this.deleteMessageUsers,
    this.isDeleted,
    this.messageReactionUsers,
    this.messageDissapearTime,
    this.isEdited,
    this.cid,
    this.groupId,
    this.senderId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory MessageDetail.fromJson(Map<String, dynamic> json) => MessageDetail(
        id: json["_id"],
        originalName: json["originalName"],
        message: json["message"],
        messageCaption: json["message_caption"],
        messageType: json["message_type"],
        mediaType: json["media_type"],
        deliveryType: json["delivery_type"],
        replyMessageId: json["reply_message_id"],
        scheduleTime: json["schedule_time"],
        blockMessageUsers: json["block_message_users"] == null ? [] : List<dynamic>.from(json["block_message_users"]!.map((x) => x)),
        deleteMessageUsers: json["delete_message_users"] == null ? [] : List<dynamic>.from(json["delete_message_users"]!.map((x) => x)),
        isDeleted: json["is_deleted"],
        messageReactionUsers: json["message_reaction_users"] == null ? [] : List<dynamic>.from(json["message_reaction_users"]!.map((x) => x)),
        messageDissapearTime: json["message_dissapear_time"],
        isEdited: json["is_edited"],
        cid: json["cid"],
        groupId: json["group_id"],
        senderId: json["sender_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "originalName": originalName,
        "message": message,
        "message_caption": messageCaption,
        "message_type": messageType,
        "media_type": mediaType,
        "delivery_type": deliveryType,
        "reply_message_id": replyMessageId,
        "schedule_time": scheduleTime,
        "block_message_users": blockMessageUsers == null ? [] : List<dynamic>.from(blockMessageUsers!.map((x) => x)),
        "delete_message_users": deleteMessageUsers == null ? [] : List<dynamic>.from(deleteMessageUsers!.map((x) => x)),
        "is_deleted": isDeleted,
        "message_reaction_users": messageReactionUsers == null ? [] : List<dynamic>.from(messageReactionUsers!.map((x) => x)),
        "message_dissapear_time": messageDissapearTime,
        "is_edited": isEdited,
        "cid": cid,
        "group_id": groupId,
        "sender_id": senderId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
