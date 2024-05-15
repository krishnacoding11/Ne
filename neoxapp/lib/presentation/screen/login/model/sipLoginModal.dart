// To parse this JSON data, do
//
//     final sipLoginModal = sipLoginModalFromJson(jsonString);

import 'dart:convert';

SipLoginModal sipLoginModalFromJson(String str) => SipLoginModal.fromJson(json.decode(str));

String sipLoginModalToJson(SipLoginModal data) => json.encode(data.toJson());

class SipLoginModal {
  String? message;
  Data? data;

  SipLoginModal({
    this.message,
    this.data,
  });

  factory SipLoginModal.fromJson(Map<String, dynamic> json) => SipLoginModal(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Access? access;
  Refresh? refresh;

  Data({
    this.access,
    this.refresh,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        access: json["access"] == null ? null : Access.fromJson(json["access"]),
        refresh: json["refresh"] == null ? null : Refresh.fromJson(json["refresh"]),
      );

  Map<String, dynamic> toJson() => {
        "access": access?.toJson(),
        "refresh": refresh?.toJson(),
      };
}

class Access {
  String? token;
  DateTime? expires;
  String? userId;

  Access({
    this.token,
    this.expires,
    this.userId,
  });

  factory Access.fromJson(Map<String, dynamic> json) => Access(
        token: json["token"],
        expires: json["expires"] == null ? null : DateTime.parse(json["expires"]),
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "expires": expires?.toIso8601String(),
        "user_id": userId,
      };
}

class Refresh {
  String? token;
  DateTime? expires;

  Refresh({
    this.token,
    this.expires,
  });

  factory Refresh.fromJson(Map<String, dynamic> json) => Refresh(
        token: json["token"],
        expires: json["expires"] == null ? null : DateTime.parse(json["expires"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "expires": expires?.toIso8601String(),
      };
}
