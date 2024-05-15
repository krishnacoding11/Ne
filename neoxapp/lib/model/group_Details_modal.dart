// // To parse this JSON data, do
// //
// //     final groupDetailsModal = groupDetailsModalFromJson(jsonString);
//
// import 'dart:convert';
//
// GroupDetailsModal groupDetailsModalFromJson(String str) => GroupDetailsModal.fromJson(json.decode(str));
//
// String groupDetailsModalToJson(GroupDetailsModal data) => json.encode(data.toJson());
//
// class GroupDetailsModal {
//   int success;
//   String message;
//   GroupDetail groupDetail;
//
//   GroupDetailsModal({
//     required this.success,
//     required this.message,
//     required this.groupDetail,
//   });
//
//   factory GroupDetailsModal.fromJson(Map<String, dynamic> json) => GroupDetailsModal(
//     success: json["success"],
//     message: json["message"],
//     groupDetail: GroupDetail.fromJson(json["Group_detail"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "message": message,
//     "Group_detail": groupDetail.toJson(),
//   };
// }
//
// class GroupDetail {
//   String id;
//   int isDeleted;
//   String name;
//   int profileType;
//   int neoxConfigCreate;
//   int neoxConfigUpdate;
//   int neoxConfigDelete;
//   int neoxConfigView;
//   int neoxConfigDownload;
//   int enterpriseCreate;
//   int enterpriseUpdate;
//   int enterpriseDelete;
//   int enterpriseView;
//   int subscriberCreate;
//   int subscriberUpdate;
//   int subscriberDelete;
//   int subscriberView;
//   int emailUpdate;
//   int emailDelete;
//   int emailView;
//   int smsUpdate;
//   int smsDelete;
//   int smsView;
//   int enterpriseDownload;
//   int subscriberDownload;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int v;
//
//   GroupDetail({
//     required this.id,
//     required this.isDeleted,
//     required this.name,
//     required this.profileType,
//     required this.neoxConfigCreate,
//     required this.neoxConfigUpdate,
//     required this.neoxConfigDelete,
//     required this.neoxConfigView,
//     required this.neoxConfigDownload,
//     required this.enterpriseCreate,
//     required this.enterpriseUpdate,
//     required this.enterpriseDelete,
//     required this.enterpriseView,
//     required this.subscriberCreate,
//     required this.subscriberUpdate,
//     required this.subscriberDelete,
//     required this.subscriberView,
//     required this.emailUpdate,
//     required this.emailDelete,
//     required this.emailView,
//     required this.smsUpdate,
//     required this.smsDelete,
//     required this.smsView,
//     required this.enterpriseDownload,
//     required this.subscriberDownload,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//   });
//
//   factory GroupDetail.fromJson(Map<String, dynamic> json) => GroupDetail(
//     id: json["_id"],
//     isDeleted: json["is_deleted"],
//     name: json["name"],
//     profileType: json["profile_type"],
//     neoxConfigCreate: json["neox_config_create"],
//     neoxConfigUpdate: json["neox_config_update"],
//     neoxConfigDelete: json["neox_config_delete"],
//     neoxConfigView: json["neox_config_view"],
//     neoxConfigDownload: json["neox_config_download"],
//     enterpriseCreate: json["enterprise_create"],
//     enterpriseUpdate: json["enterprise_update"],
//     enterpriseDelete: json["enterprise_delete"],
//     enterpriseView: json["enterprise_view"],
//     subscriberCreate: json["subscriber_create"],
//     subscriberUpdate: json["subscriber_update"],
//     subscriberDelete: json["subscriber_delete"],
//     subscriberView: json["subscriber_view"],
//     emailUpdate: json["email_update"],
//     emailDelete: json["email_delete"],
//     emailView: json["email_view"],
//     smsUpdate: json["sms_update"],
//     smsDelete: json["sms_delete"],
//     smsView: json["sms_view"],
//     enterpriseDownload: json["enterprise_download"],
//     subscriberDownload: json["subscriber_download"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     v: json["__v"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "is_deleted": isDeleted,
//     "name": name,
//     "profile_type": profileType,
//     "neox_config_create": neoxConfigCreate,
//     "neox_config_update": neoxConfigUpdate,
//     "neox_config_delete": neoxConfigDelete,
//     "neox_config_view": neoxConfigView,
//     "neox_config_download": neoxConfigDownload,
//     "enterprise_create": enterpriseCreate,
//     "enterprise_update": enterpriseUpdate,
//     "enterprise_delete": enterpriseDelete,
//     "enterprise_view": enterpriseView,
//     "subscriber_create": subscriberCreate,
//     "subscriber_update": subscriberUpdate,
//     "subscriber_delete": subscriberDelete,
//     "subscriber_view": subscriberView,
//     "email_update": emailUpdate,
//     "email_delete": emailDelete,
//     "email_view": emailView,
//     "sms_update": smsUpdate,
//     "sms_delete": smsDelete,
//     "sms_view": smsView,
//     "enterprise_download": enterpriseDownload,
//     "subscriber_download": subscriberDownload,
//     "createdAt": createdAt.toIso8601String(),
//     "updatedAt": updatedAt.toIso8601String(),
//     "__v": v,
//   };
// }
