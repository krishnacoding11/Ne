import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sip_ua/sip_ua.dart';


SIPUAHelper? helper;

Call? callglobalObj;
CallState? mycallstate;

MediaStream? localStream;
MediaStream? remoteStream;

String globalCallerName = "";
String globalCallerNumber = "";

bool isStartedTime = false;

String mainUrl = "https://neoxadmin.celloip.com/";

String baseUri = "${mainUrl}nodejs/v1/";

String baseServer = "neoxadmin.celloip.com";
String socketUrl = "ws://neoxadmin.celloip.com:8808";
String baseSocketUrl = "$socketUrl?uid=";
