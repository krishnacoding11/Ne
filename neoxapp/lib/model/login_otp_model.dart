class LoginOtpModel {
  int? success;
  String? message;
  int? mobileNumber;
  String? emailAddress;
  int? oTP;

  LoginOtpModel({this.success, this.message, this.mobileNumber, this.emailAddress, this.oTP});

  LoginOtpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    mobileNumber = json['MobileNumber'];
    emailAddress = json['emailAddress'];
    oTP = json['OTP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = success;
    data['message'] = message;
    data['MobileNumber'] = mobileNumber;
    data['emailAddress'] = emailAddress;
    data['OTP'] = oTP;
    return data;
  }
}
