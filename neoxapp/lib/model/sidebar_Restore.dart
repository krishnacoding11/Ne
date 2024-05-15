// To parse this JSON data, do
//
//     final sidebarRestore = sidebarRestoreFromJson(jsonString);

import 'dart:convert';

SidebarRestore sidebarRestoreFromJson(String str) => SidebarRestore.fromJson(json.decode(str));

String sidebarRestoreToJson(SidebarRestore data) => json.encode(data.toJson());

class SidebarRestore {
  List<SideBarDatum>? sideBarData;

  SidebarRestore({
    this.sideBarData,
  });

  factory SidebarRestore.fromJson(Map<String, dynamic> json) => SidebarRestore(
        sideBarData: json["sideBarData"] == null ? [] : List<SideBarDatum>.from(json["sideBarData"]!.map((x) => SideBarDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sideBarData": sideBarData == null ? [] : List<dynamic>.from(sideBarData!.map((x) => x.toJson())),
      };
}

class SideBarDatum {
  String? id;
  String? lastMessage;
  int? lastMediaType;
  DateTime? createdAt;
  int? blockBy;
  String? userExtension;
  int? isGroup;
  int? isReported;
  int? isBlocked;
  int? istyping;
  int? isOnline;
  int? isblockedByReciver;
  dynamic lastSeen;
  int? muteType;
  int? ismute;
  String? name;
  String? cid;
  String? description;
  String? image;
  DateTime? lastMessageTime;
  int? unreadMsgCount;
  dynamic pintime;
  int? ispin;
  int? isAdmin;

  SideBarDatum({
    this.id,
    this.lastMessage,
    this.lastMediaType,
    this.createdAt,
    this.blockBy,
    this.userExtension,
    this.isGroup,
    this.isReported,
    this.isBlocked,
    this.istyping,
    this.isOnline,
    this.isblockedByReciver,
    this.lastSeen,
    this.muteType,
    this.ismute,
    this.name,
    this.cid,
    this.description,
    this.image,
    this.lastMessageTime,
    this.unreadMsgCount,
    this.pintime,
    this.ispin,
    this.isAdmin,
  });

  factory SideBarDatum.fromJson(Map<String, dynamic> json) => SideBarDatum(
        id: json["_id"],
        lastMessage: json["last_message"],
        lastMediaType: json["last_media_type"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]).toLocal(),
        blockBy: json["block_by"],
        userExtension: json["user_extension"],
        isGroup: json["isGroup"],
        isReported: json["isReported"],
        isBlocked: json["isBlocked"],
        istyping: json["istyping"],
        isOnline: json["is_online"],
        isblockedByReciver: json["isblocked_by_reciver"],
        lastSeen: json["last_seen"],
        muteType: json["mute_type"],
        ismute: json["ismute"],
        name: json["name"],
        cid: json["cid"],
        description: json["description"],
        image: json["image"],
        lastMessageTime: json["last_message_time"] == null ? null : DateTime.parse(json["last_message_time"]).toLocal(),
        unreadMsgCount: json["unread_msg_count"],
        pintime: json["pintime"],
        ispin: json["ispin"],
        isAdmin: json["isAdmin"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "last_message": lastMessage,
        "last_media_type": lastMediaType,
        "createdAt": createdAt?.toLocal().toString(),
        "block_by": blockBy,
        "user_extension": userExtension,
        "isGroup": isGroup,
        "isReported": isReported,
        "isBlocked": isBlocked,
        "istyping": istyping,
        "is_online": isOnline,
        "isblocked_by_reciver": isblockedByReciver,
        "last_seen": lastSeen,
        "mute_type": muteType,
        "ismute": ismute,
        "name": name,
        "cid": cid,
        "description": description,
        "image": image,
        "last_message_time": lastMessageTime?.toLocal().toString(),
        "unread_msg_count": unreadMsgCount,
        "pintime": pintime,
        "ispin": ispin,
        "isAdmin": isAdmin,
      };
}
