// To parse this JSON data, do
//
//     final groupDetailModel = groupDetailModelFromJson(jsonString);

import 'dart:convert';

GroupDetailModel groupDetailModelFromJson(String str) => GroupDetailModel.fromJson(json.decode(str));

String groupDetailModelToJson(GroupDetailModel data) => json.encode(data.toJson());

class GroupDetailModel {
  int success;
  String message;
  GroupDetai groupDetai;

  GroupDetailModel({
    required this.success,
    required this.message,
    required this.groupDetai,
  });

  factory GroupDetailModel.fromJson(Map<String, dynamic> json) => GroupDetailModel(
        success: json["success"],
        message: json["message"],
        groupDetai: GroupDetai.fromJson(json["Group_detai"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "Group_detai": groupDetai.toJson(),
      };
}

class GroupDetai {
  String id;
  String description;
  List<GroupUser> groupUsers;
  String groupImage;
  String lastMessageSenderId;
  int lastMessageType;
  String lastMessage;
  dynamic lastMessageTime;
  int lastMediaType;
  int isDeleted;
  int isAdminSendMessage;
  String publicLink;
  dynamic publicLinkExpireTime;
  List<dynamic> groupLeaveMembers;
  String cid;
  String createdBy;
  String groupName;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  int groupUserCount;

  GroupDetai({
    required this.id,
    required this.description,
    required this.groupUsers,
    required this.groupImage,
    required this.lastMessageSenderId,
    required this.lastMessageType,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMediaType,
    required this.isDeleted,
    required this.isAdminSendMessage,
    required this.publicLink,
    required this.publicLinkExpireTime,
    required this.groupLeaveMembers,
    required this.cid,
    required this.createdBy,
    required this.groupName,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.groupUserCount,
  });

  factory GroupDetai.fromJson(Map<String, dynamic> json) => GroupDetai(
        id: json["_id"],
        description: json["description"],
        groupUsers: List<GroupUser>.from(json["group_users"].map((x) => GroupUser.fromJson(x))),
        groupImage: json["group_image"],
        lastMessageSenderId: json["last_message_sender_id"],
        lastMessageType: json["last_message_type"],
        lastMessage: json["last_message"],
        lastMessageTime: json["last_message_time"],
        lastMediaType: json["last_media_type"],
        isDeleted: json["is_deleted"],
        isAdminSendMessage: json["is_admin_send_message"],
        publicLink: json["public_link"],
        publicLinkExpireTime: json["public_link_expire_time"],
        groupLeaveMembers: List<dynamic>.from(json["group_leave_members"].map((x) => x)),
        cid: json["cid"],
        createdBy: json["created_by"],
        groupName: json["group_name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        groupUserCount: json["group_user_count"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "description": description,
        "group_users": List<dynamic>.from(groupUsers.map((x) => x.toJson())),
        "group_image": groupImage,
        "last_message_sender_id": lastMessageSenderId,
        "last_message_type": lastMessageType,
        "last_message": lastMessage,
        "last_message_time": lastMessageTime,
        "last_media_type": lastMediaType,
        "is_deleted": isDeleted,
        "is_admin_send_message": isAdminSendMessage,
        "public_link": publicLink,
        "public_link_expire_time": publicLinkExpireTime,
        "group_leave_members": List<dynamic>.from(groupLeaveMembers.map((x) => x)),
        "cid": cid,
        "created_by": createdBy,
        "group_name": groupName,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "group_user_count": groupUserCount,
      };
}

class GroupUser {
  String id;
  String cid;
  String groupId;
  MemberId memberId;
  int isAdmin;
  int v;
  DateTime createdAt;
  DateTime updatedAt;

  GroupUser({
    required this.id,
    required this.cid,
    required this.groupId,
    required this.memberId,
    required this.isAdmin,
    required this.v,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GroupUser.fromJson(Map<String, dynamic> json) => GroupUser(
        id: json["_id"],
        cid: json["cid"],
        groupId: json["group_id"],
        memberId: MemberId.fromJson(json["member_id"]),
        isAdmin: json["is_admin"],
        v: json["__v"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "cid": cid,
        "group_id": groupId,
        "member_id": memberId.toJson(),
        "is_admin": isAdmin,
        "__v": v,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class MemberId {
  String id;
  String userImage;
  String firstName;
  String lastName;

  MemberId({
    required this.id,
    required this.userImage,
    required this.firstName,
    required this.lastName,
  });

  factory MemberId.fromJson(Map<String, dynamic> json) => MemberId(
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
