import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:neoxapp/model/user_group_message_model.dart';

import 'chat_data_model.dart';

class RestoreDataModel {
  int? success;
  String? message;
  List<SideBarData>? sideBarData;
  List<ChatDataModel>? userChatData;
  List<UserGroupChatDataModel>? userGroupChatData;
  List<String>? broadCastList;
  int? userChatDataLength;
  int? userGroupChatDataLength;

  RestoreDataModel({this.success, this.message, this.sideBarData, this.userChatData, this.userGroupChatData, this.broadCastList, this.userChatDataLength, this.userGroupChatDataLength});

  RestoreDataModel.fromJson(Map<String, dynamic> json, {bool allData = false}) {
    success = json['success'];
    message = json['message'];
    if (json['sideBarData'] != null) {
      sideBarData = <SideBarData>[];
      json['sideBarData'].forEach((v) {
        sideBarData!.add(SideBarData.fromJson(v));
      });
    }

    if (!allData) {
      if (json['userChatData'] != null) {
        userChatData = <ChatDataModel>[];
        json['userChatData'].forEach((v) {
          userChatData!.add(ChatDataModel.fromJson(v, fromDatabase: true));
        });
      }
      if (json['UserGroupChatData'] != null) {
        userGroupChatData = <UserGroupChatDataModel>[];
        json['UserGroupChatData'].forEach((v) {
          userGroupChatData!.add(UserGroupChatDataModel.fromJson(v, fromDatabase: true));
        });
      }
      broadCastList = json['BroadCastList'] == null ? null : json['BroadCastList'].cast<String>();
      userChatDataLength = json['userChatDataLength'];
      userGroupChatDataLength = json['UserGroupChatDataLength'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (sideBarData != null) {
      data['sideBarData'] = sideBarData!.map((v) => v.toJson()).toList();
    }
    if (userChatData != null) {
      data['userChatData'] = userChatData!.map((v) => v.toJson()).toList();
    }
    if (userGroupChatData != null) {
      data['UserGroupChatData'] = userGroupChatData!.map((v) => v.toJson()).toList();
    }
    data['BroadCastList'] = broadCastList;
    data['userChatDataLength'] = userChatDataLength;
    data['UserGroupChatDataLength'] = userGroupChatDataLength;
    return data;
  }
}

class SideBarData extends ISuspensionBean {
  String? tagIndex;

  @override
  String getSuspensionTag() => tagIndex ?? "#";

  @override
  String toString() => json.encode(this);

  String? sId;
  String? lastMessage;
  int? lastMediaType;
  String? cid;
  String? createdAt;
  int? blockBy;
  String? userExtension;
  int? isGroup;
  int? isReported;
  int? isBlocked;
  int? istyping;
  int? isOnline;
  int? isblockedByReciver;
  String? lastSeen;
  int? muteType;
  int? ismute;
  String? name;
  String? description;
  String? image;
  String? lastMessageTime;
  int? unreadMsgCount;
  String? pintime;
  int? ispin;
  int? ismember = 1;
  int? isAdmin;
  SideBarData({this.sId, this.lastMessage, this.lastMediaType, this.cid, this.createdAt, this.blockBy, this.userExtension, this.isGroup, this.isReported, this.isBlocked, this.istyping, this.isOnline, this.isblockedByReciver, this.lastSeen, this.muteType, this.ismute, this.name, this.description, this.image, this.tagIndex, this.lastMessageTime, this.unreadMsgCount, this.pintime, this.ispin, this.ismember, this.isAdmin});

  SideBarData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    lastMessage = json['last_message'];
    lastMediaType = json['last_media_type'];
    cid = json['cid'];
    createdAt = json['createdAt'];
    blockBy = json['block_by'];
    userExtension = json['user_extension'];
    isGroup = json['isGroup'];
    isReported = json['isReported'];
    isBlocked = json['isBlocked'];
    istyping = json['istyping'];
    isOnline = json['is_online'];
    isblockedByReciver = json['isblocked_by_reciver'];
    lastSeen = json['last_seen'];
    muteType = json['mute_type'];
    ismute = json['ismute'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    lastMessageTime = json['last_message_time'];
    unreadMsgCount = json['unread_msg_count'];
    pintime = json['pintime'];
    ispin = json['ispin'];
    tagIndex = json['name'] == null || json["name"].isEmpty ? "#" : json["name"].toString().substring(0, 1);
    ismember = json["ismember"];
    isAdmin = json["isAdmin"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['last_message'] = lastMessage;
    data['last_media_type'] = lastMediaType;
    data['cid'] = cid;
    data['createdAt'] = createdAt;
    data['block_by'] = blockBy;
    data['user_extension'] = userExtension;
    data['isGroup'] = isGroup;
    data['isReported'] = isReported;
    data['isBlocked'] = isBlocked;
    data['istyping'] = istyping;
    data['is_online'] = isOnline;
    data['isblocked_by_reciver'] = isblockedByReciver;
    data['last_seen'] = lastSeen;
    data['mute_type'] = muteType;
    data['ismute'] = ismute;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['last_message_time'] = lastMessageTime;
    data['unread_msg_count'] = unreadMsgCount;
    data['pintime'] = pintime;
    data['ispin'] = ispin;
    data["ismember"] = ismember;
    data["isAdmin"] = isAdmin;
    return data;
  }
}

// class UserChatData {
//   String? sId;
//   String? broadcastId;
//   String? broadcastMsgId;
//   String? originalName;
//   String? message;
//   int? messageType;
//   int? mediaType;
//   int? deliveryType;
//   String? replyMessageId;
//   String? scheduleTime;
//   List<String>? blockMessageUsers;
//   List<String>? deleteMessageUsers;
//   int? isDeleted;
//   List<String>? messageReactionUsers;
//   String? messageDissapearTime;
//   String? cid;
//   String? senderId;
//   String? receiverId;
//   String? createdAt;
//   String? updatedAt;
//   int? iV;
//
//   UserChatData(
//       {this.sId,
//         this.broadcastId,
//         this.broadcastMsgId,
//         this.originalName,
//         this.message,
//         this.messageType,
//         this.mediaType,
//         this.deliveryType,
//         this.replyMessageId,
//         this.scheduleTime,
//         this.blockMessageUsers,
//         this.deleteMessageUsers,
//         this.isDeleted,
//         this.messageReactionUsers,
//         this.messageDissapearTime,
//         this.cid,
//         this.senderId,
//         this.receiverId,
//         this.createdAt,
//         this.updatedAt,
//         this.iV});
//
//   UserChatData.fromJson(Map<String, dynamic> json) {
//
//
//
//     sId = json['_id'];
//     broadcastId = json['broadcast_id'];
//     broadcastMsgId = json['broadcast_msg_id'];
//     originalName = json['originalName'];
//     message = json['message'];
//     messageType = json['message_type'];
//     mediaType = json['media_type'];
//     deliveryType = json['delivery_type'];
//     replyMessageId = json['reply_message_id'];
//     scheduleTime = json['schedule_time'];
//     blockMessageUsers = b;
//     deleteMessageUsers = json['delete_message_users'].cast<String>();
//     isDeleted = json['is_deleted'];
//     messageReactionUsers = json['message_reaction_users']==null?[]:json['message_reaction_users'].cast<String>();
//     messageDissapearTime = json['message_dissapear_time'];
//     cid = json['cid'];
//     // senderId = json['sender_id'];
//     receiverId = json['receiver_id'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     iV = json['__v'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = sId;
//     data['broadcast_id'] = broadcastId;
//     data['broadcast_msg_id'] = broadcastMsgId;
//     data['originalName'] = originalName;
//     data['message'] = message;
//     data['message_type'] = messageType;
//     data['media_type'] = mediaType;
//     data['delivery_type'] = deliveryType;
//     data['reply_message_id'] = replyMessageId;
//     data['schedule_time'] = scheduleTime;
//     data['block_message_users'] = blockMessageUsers;
//     data['delete_message_users'] = deleteMessageUsers;
//     data['is_deleted'] = isDeleted;
//     data['message_reaction_users'] = messageReactionUsers;
//     data['message_dissapear_time'] = messageDissapearTime;
//     data['cid'] = cid;
//     // data['sender_id'] = senderId;
//     data['receiver_id'] = receiverId;
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;
//     data['__v'] = iV;
//     return data;
//   }
// }

class UserGroupChatData {
  String? sId;
  String? originalName;
  String? message;
  int? messageType;
  int? mediaType;
  int? deliveryType;
  String? replyMessageId;
  int? scheduleTime;
  List<String>? blockMessageUsers;
  List<String>? deleteMessageUsers;
  int? isDeleted;
  List<String>? messageReactionUsers;
  String? messageDissapearTime;
  String? cid;
  String? groupId;
  SenderId? senderId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? isEdited;

  UserGroupChatData({this.sId, this.originalName, this.message, this.messageType, this.mediaType, this.deliveryType, this.replyMessageId, this.scheduleTime, this.blockMessageUsers, this.deleteMessageUsers, this.isDeleted, this.messageReactionUsers, this.messageDissapearTime, this.cid, this.groupId, this.senderId, this.createdAt, this.updatedAt, this.iV, this.isEdited});

  UserGroupChatData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    originalName = json['originalName'];
    message = json['message'];
    messageType = json['message_type'];
    mediaType = json['media_type'];
    deliveryType = json['delivery_type'];
    replyMessageId = json['reply_message_id'];
    scheduleTime = json['schedule_time'];
    blockMessageUsers = json['block_message_users'].cast<String>();
    deleteMessageUsers = json['delete_message_users'].cast<String>();
    isDeleted = json['is_deleted'];
    messageReactionUsers = json['message_reaction_users'].cast<String>();
    messageDissapearTime = json['message_dissapear_time'];
    cid = json['cid'];
    groupId = json['group_id'];
    // senderId = json['sender_id'] != null
    //     ? SenderId.fromJson(json['sender_id'])
    //     : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isEdited = json['is_edited'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['originalName'] = originalName;
    data['message'] = message;
    data['message_type'] = messageType;
    data['media_type'] = mediaType;
    data['delivery_type'] = deliveryType;
    data['reply_message_id'] = replyMessageId;
    data['schedule_time'] = scheduleTime;
    data['block_message_users'] = blockMessageUsers;
    data['delete_message_users'] = deleteMessageUsers;
    data['is_deleted'] = isDeleted;
    data['message_reaction_users'] = messageReactionUsers;
    data['message_dissapear_time'] = messageDissapearTime;
    data['cid'] = cid;
    data['group_id'] = groupId;
    // if (senderId != null) {
    //   data['sender_id'] = senderId!.toJson();
    // }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['is_edited'] = isEdited;
    return data;
  }
}

class SenderId {
  String? sId;
  String? firstName;
  String? lastName;

  SenderId({this.sId, this.firstName, this.lastName});

  SenderId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }
}
