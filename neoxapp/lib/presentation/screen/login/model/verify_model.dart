class VerifyModel {
  int? success;
  String? message;
  String? token;
  UserDetails? userDetails;

  VerifyModel({this.success, this.message, this.token, this.userDetails});

  VerifyModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    token = json['Token'];
    userDetails = json['UserDetails'] != null ? UserDetails.fromJson(json['UserDetails']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    data['message'] = message;
    data['Token'] = token;
    if (userDetails != null) {
      data['UserDetails'] = userDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  String? sId;
  String? eid;
  String? endpointNumber;
  String? emailAddress;
  String? mobileNumber;
  String? firstName;
  String? lastName;
  int? userType;

  UserDetails({this.sId, this.eid, this.endpointNumber, this.emailAddress, this.mobileNumber, this.firstName, this.lastName, this.userType});

  UserDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    eid = json['eid'];
    endpointNumber = json['endpointNumber'];
    emailAddress = json['emailAddress'];
    mobileNumber = json['MobileNumber'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['eid'] = eid;
    data['endpointNumber'] = endpointNumber;
    data['emailAddress'] = emailAddress;
    data['MobileNumber'] = mobileNumber;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['user_type'] = userType;
    return data;
  }
}
