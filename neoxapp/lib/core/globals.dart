import 'dart:convert';
import 'package:neoxapp/api/ApiServices.dart';
import 'package:neoxapp/presentation/screen/login/model/verify_model.dart';
import 'package:sip_ua/sip_ua.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

late IO.Socket socket;

// String token = "";
// bool isDeatilTab = false;
// List<Contact> contacts = [];

SIPUAHelper? helper;

Call? callglobalObj;
CallState? mycallstate;

// late AppDatabase db;
UserDetails getUserData() {
  var user = storage.read("user");
  if (user != null) {
    return UserDetails.fromJson(jsonDecode(user));
  }
  return UserDetails();
}
