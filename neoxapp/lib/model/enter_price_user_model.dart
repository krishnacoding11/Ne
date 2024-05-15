import 'package:azlistview/azlistview.dart';

class EnterPriceUserModel {
  int? success;
  String? message;
  List<UserData>? userData;

  EnterPriceUserModel({this.success, this.message, this.userData});

  EnterPriceUserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['UserData'] != null) {
      userData = <UserData>[];
      json['UserData'].forEach((v) {
        userData!.add(UserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    data['message'] = message;
    if (userData != null) {
      data['UserData'] = userData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserData extends ISuspensionBean {
  String? tagIndex;

  @override
  String getSuspensionTag() => tagIndex ?? "#";

  String? sId;
  String? mobileNumber;
  String? userImage;
  String? firstName;
  String? lastName;

  UserData({this.sId, this.mobileNumber, this.userImage, this.firstName, this.tagIndex, this.lastName});

  UserData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mobileNumber = json['MobileNumber'];
    userImage = json['user_image'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    tagIndex = json['first_name'] == null || json["first_name"].isEmpty ? "#" : json["first_name"].toString().substring(0, 1);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['MobileNumber'] = mobileNumber;
    data['user_image'] = userImage;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }
}
