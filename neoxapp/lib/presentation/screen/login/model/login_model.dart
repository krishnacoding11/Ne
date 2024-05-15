// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  int success;
  String message;
  String mobileNumber;
  String emailAddress;
  int otp;

  LoginModel({
    required this.success,
    required this.message,
    required this.mobileNumber,
    required this.emailAddress,
    required this.otp,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        success: json["success"],
        message: json["message"],
        mobileNumber: json["MobileNumber"],
        emailAddress: json["emailAddress"],
        otp: json["OTP"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "MobileNumber": mobileNumber,
        "emailAddress": emailAddress,
        "OTP": otp,
      };
}
