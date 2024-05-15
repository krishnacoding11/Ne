import 'package:neoxapp/presentation/widgets/globle.dart';

class ApiConstants {
  // static String baseUrl = 'https://cluster-100.spotifone.com/api/apiv3/'; //personal
  // static String baseUrl = 'https://api.spotifone.com/'; //personal
  static String baseUrl = '${mainUrl}nxbackend/v1/';
  // static String baseUrl = 'http://192.168.1.16:8081/v1/';
  static String loginUrl = 'user/mobile/login';
  static String userContactList = 'user/contact/list';
  static String groupDetails = 'group/info/';
  // static String groupDetails = 'accessgroup/';
  static String verifyUrl = 'user/verify/login';
  static String logoutUrl = 'user/logout';
  static String linkUrlLogin = 'user/link/login';
  static String restoreUrl = 'user/restore/chat';
  static String uploadMultiMediaUrl = 'upload';
  static String groupInfoUrl = 'group/message/info/';
  //personal
  // static String baseUrl = 'https://api.spotifone.com/dev/'; //personal
  static String IsTokenVailid = 'IsTokenValid.php';
  static String sendOTP = 'SendSms.php';
  static String ValidSMS = 'ValidSms.php';
  static String Checkstatus = 'CheckStatus.php';
  static String SpotsData = 'getSpotsData.php';
  static String logout = 'Logout.php';
  static String Connection = 'Connection.php';
  static String Save_Number = 'SaveNumber.php';
  static String Call_History = 'GetCallHistory.php';
  static String GetNo = 'GetNumber.php';
  static String UploadDoc = 'UploadDocument.php';
  static String SendEmailConfig = 'SendEmailConfig.php';
  static String GetSipInfo = 'GetSipInformation.php';
  static String UpdateBilling = 'UpdateBilling.php';
  static String Coutry = 'ListCountries.php';
  static String BillingInfo = 'GetBillingInfo.php';
  static String ConferenceShowStatus = 'ConferenceShowStatus.php';
  static String ConferenceSetup = 'ConferenceSetup.php';
  static String ConferenceAddParticipant = 'ConferenceAddParticipant.php';
  static String ConferenceRemoveParticipant = 'ConferenceRemoveParticipant.php';
  static String ConferencePauseParticipant = 'ConferencePauseParticipant.php';
  static String UpdateValidateMarketing = 'UpdateValidateMarketing.php';
  static String UpdateValidateConditions = 'UpdateValidateConditions.php';
}

class ApiMethods {
  static String get = 'get';
  static String post = 'post';
  static String patch = 'patch';
  static String delete = 'delete';
}
