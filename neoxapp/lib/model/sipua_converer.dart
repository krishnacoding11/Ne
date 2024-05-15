import 'package:neoxapp/presentation/widgets/globle.dart' as globals;
import 'package:json_annotation/json_annotation.dart';
import 'package:sip_ua/sip_ua.dart';

class SIPUAHelperConverter implements JsonConverter<SIPUAHelper, String> {
  const SIPUAHelperConverter();

  @override
  SIPUAHelper fromJson(String json) {
    SIPUAHelper value;
    try {
      print("sip converter ${json}");
      print("sip converter ${globals.helper}");
      if (json is SIPUAHelper) {
        value = json as SIPUAHelper;
        // Do something with myHelper
        print("sip converter##  ${value}");
        return value; //SIPUAHelper.fromJson(json);
      } else {
        print('ERROR ');
        // Handle the case where myVariable is not of type SIPUAHelper
      }
    } catch (e) {
      print('######## e #### $e');
    } finally {
      print('######## value finallyy #### ');
      value = SIPUAHelper();
    }
    return value; //SIPUAHelper.fromJson(json);
  }

  @override
  String toJson(SIPUAHelper helper) {
    // if (helper == null) {
    //   return null;
    // }
    return helper.toString();
  }
}
