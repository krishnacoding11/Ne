import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:azlistview/azlistview.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ContactInfo extends ISuspensionBean {
  String name;
  String? tagIndex;
  String? namePinyin;
  List<Item>? number;
  List<Item>? emails;
  String? displayName;
  String? givenName;
  String? middleName;
  String? prefix;
  String? suffix;
  String? familyName;
  String? company;
  String? jobTitle;
  String? androidAccountTypeRaw, androidAccountName;
  AndroidAccountType? androidAccountType;
  List<PostalAddress>? postalAddresses = [];
  DateTime? birthday;
  String? contactImage;

  Color? bgColor;
  IconData? iconData;

  Uint8List? img;
  String? id;
  String? firstletter;

  ContactInfo({
    required this.name,
    required this.number,
    this.tagIndex,
    this.namePinyin,
    this.bgColor,
    this.iconData,
    this.img,
    this.displayName,
    this.givenName,
    this.middleName,
    this.androidAccountType,
    this.birthday,
    this.postalAddresses,
    this.prefix,
    this.suffix,
    this.familyName,
    this.company,
    this.emails,
    this.jobTitle,
    this.id,
    this.firstletter,
    this.contactImage,
  });

  ContactInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        img = json['img'],
        displayName = json["displayName"],
        givenName = json["givenName"],
        middleName = json["middleName"],
        prefix = json["prefix"],
        suffix = json["suffix"],
        familyName = json["familyName"],
        company = json["company"],
        jobTitle = json["jobTitle"],
        number = json['number'],
        emails = json['emails'],
        id = json['id']?.toString(),
        firstletter = json['firstletter'],
        contactImage = json['contactImage'];

  Map<String, dynamic> toJson() => {
//        'id': id,
        'name': name,
        'img': img,
        "displayName": displayName,
        "givenName": givenName,
        "middleName": middleName,
        "prefix": prefix,
        "suffix": suffix,
        "familyName": familyName,
        "company": company,
        "emails": emails,
        "jobTitle": jobTitle,
        'number': number,
        'contactImage': contactImage,
//        'firstletter': firstletter,
//        'tagIndex': tagIndex,
//        'namePinyin': namePinyin,
//        'isShowSuspension': isShowSuspension
      };

  @override
  String getSuspensionTag() => tagIndex ?? "";

  @override
  String toString() => json.encode(this);
}
