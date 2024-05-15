// To parse this JSON data, do
//
//     final userGroupChatDataModel = userGroupChatDataModelFromJson(jsonString);

import 'dart:convert';

UserGroupChatDataModel userGroupChatDataModelFromJson(String str) => UserGroupChatDataModel.fromJson(json.decode(str));

String userGroupChatDataModelToJson(UserGroupChatDataModel data) => json.encode(data.toJson());

class UserGroupChatDataModel {
  String id;
  String? MSG_ID;
  String originalName;
  String filePath;
  String message;
  String? message_caption;
  String groupId;
  int messageType;
  int mediaType;
  int deliveryType;
  String replyMessageId;
  int scheduleTime;
  List<dynamic> blockMessageUsers;
  List<String> deleteMessageUsers;
  int isDeleted;
  List<dynamic> messageReactionUsers;
  String messageDissapearTime;
  String cid;
  SenderId senderId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  int? isEdited;

  UserGroupChatDataModel({
    required this.id,
    this.MSG_ID,
    required this.originalName,
    required this.message,
    this.message_caption,
    required this.messageType,
    required this.mediaType,
    required this.deliveryType,
    required this.replyMessageId,
    required this.filePath,
    required this.scheduleTime,
    required this.blockMessageUsers,
    required this.deleteMessageUsers,
    required this.isDeleted,
    required this.messageReactionUsers,
    required this.messageDissapearTime,
    required this.cid,
    required this.groupId,
    required this.senderId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.isEdited,
  });

  factory UserGroupChatDataModel.fromJson(Map<String, dynamic> json, {bool fromDatabase = false}) {
    // String string="{\"last_name\"=\"celloip\", \"_id\"=\"65a65b135e602f3df469c24e\", \"first_name\"=\"pradip\"}".replaceAll("=", ":");

    // Map valueMap = jsonDecode(json["sender_id"].toString().replaceAll("=", ":"));
    // Map valueMap = jsonDecode(json["sender_id"].toString().replaceAll("=", ":"));
    // print("date==${jsonDecode("\"${json["sender_id"].toString().replaceAll("=", ":")}\"")}");
    if (fromDatabase) {
      return UserGroupChatDataModel(
          id: json["_id"],
          MSG_ID: json["MSG_ID"],
          originalName: json["originalName"],
          message: json["message"],
          message_caption: json["message_caption"],
          messageType: json["message_type"],
          filePath: json["filePath"] ?? "",
          mediaType: json["media_type"],
          deliveryType: json["delivery_type"],
          replyMessageId: json["reply_message_id"],
          scheduleTime: json["schedule_time"] ?? 0,
          blockMessageUsers: json["block_message_users"].toString().replaceAll("[]", "").isEmpty ? [] : jsonDecode(json["block_message_users"]).cast<String>().toList(),
          // List<dynamic>.from(json["block_message_users"].map((x) => x)),
          deleteMessageUsers: json["delete_message_users"].toString().replaceAll("[]", "").isEmpty ? [] : jsonDecode(json["delete_message_users"]).cast<String>().toList(),
          // deleteMessageUsers:json["delete_message_users"].toString().replaceAll("[]", "").isEmpty?[]: List<String>.from(json["delete_message_users"]),
          messageReactionUsers: json["message_reaction_users"].toString().replaceAll("[]", "").isEmpty
              ? []
              :
              // List<dynamic>.from(json["message_reaction_users"].map((x) => x)),
              jsonDecode(json["message_reaction_users"]).cast<String>().toList(),
          isDeleted: json["is_deleted"],
          messageDissapearTime: json["message_dissapear_time"] ?? '',
          cid: json["cid"],
          groupId: json["group_id"],
          senderId: SenderId.fromJson(jsonDecode(json["sender_id"])),
          // senderId: SenderId.fromJson(jsonDecode(json["sender_id"].replaceAll("=", ":")).cast<Map<String, dynamic>>() ),
          // senderId: SenderId.fromJson(("\"${json["sender_id"].toString().replaceAll("=", ":")}\"") as Map<String, dynamic> ),
          createdAt: DateTime.parse(json["createdAt"]),
          updatedAt: DateTime.parse(json["updatedAt"]),
          v: json["__v"],
          isEdited: json["is_edited"]);
    }
    return UserGroupChatDataModel(id: json["_id"], MSG_ID: json["MSG_ID"], originalName: json["originalName"], message: json["message"], message_caption: json["message_caption"], messageType: json["message_type"], mediaType: json["media_type"], filePath: json["filePath"] ?? "", deliveryType: json["delivery_type"], replyMessageId: json["reply_message_id"], scheduleTime: json["schedule_time"] ?? 0, blockMessageUsers: List<dynamic>.from(json["block_message_users"].map((x) => x)), deleteMessageUsers: List<String>.from(json["delete_message_users"].map((x) => x)), isDeleted: json["is_deleted"], messageReactionUsers: List<dynamic>.from(json["message_reaction_users"].map((x) => x)), messageDissapearTime: json["message_dissapear_time"] ?? '', cid: json["cid"], groupId: json["group_id"], senderId: SenderId.fromJson(json["sender_id"]), createdAt: DateTime.parse(json["createdAt"]), updatedAt: DateTime.parse(json["updatedAt"]), v: json["__v"], isEdited: json["is_edited"]);
  }

  Map<String, dynamic> toJson() {
    return {"_id": id, "MSG_ID": MSG_ID, "originalName": originalName, "message": message, "message_caption": message_caption, "message_type": messageType, "media_type": mediaType, "filePath": filePath, "delivery_type": deliveryType, "reply_message_id": replyMessageId, "schedule_time": scheduleTime, "block_message_users": jsonEncode(blockMessageUsers), "delete_message_users": jsonEncode(deleteMessageUsers), "is_deleted": isDeleted, "message_reaction_users": jsonEncode(messageReactionUsers), "message_dissapear_time": messageDissapearTime, "cid": cid, "group_id": groupId, "sender_id": jsonEncode(senderId.toJson()), "createdAt": createdAt.toLocal().toString(), "updatedAt": updatedAt.toLocal().toString(), "__v": v, "is_edited": isEdited};
  }
}

class SenderId {
  String id;
  String firstName;
  String lastName;

  SenderId({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory SenderId.fromJson(Map<String, dynamic> json) => SenderId(
        id: json["_id"].toString(),
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "first_name": firstName,
        "last_name": lastName,
      };
}
