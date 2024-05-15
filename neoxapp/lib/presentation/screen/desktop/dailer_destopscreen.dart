import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/presentation/screen/caller/call_screen.dart';
import 'package:neoxapp/presentation/screen/dashboard/dialer/dialer_screen.dart';
import 'package:neoxapp/presentation/screen/dashboard/model/contact_info_model.dart';
import 'package:neoxapp/presentation/screen/desktop/desktopscreen.dart';
import 'package:sip_ua/sip_ua.dart';
import 'package:neoxapp/presentation/widgets/globle.dart' as globals;

class DailDesktopScreen extends StatefulWidget {
  const DailDesktopScreen({Key? key}) : super(key: key);

  @override
  State<DailDesktopScreen> createState() => _DailDesktopScreenState();
}

String desktopNumber = "";

class _DailDesktopScreenState extends State<DailDesktopScreen> {
  RxBool isSelectCall = false.obs;
  ContactInfo contactInfo = ContactInfo(number: [], name: "");
  SIPUAHelper helperObj = (globals.helper ?? SIPUAHelper());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: isSelectCall.stream,
          builder: (context, snapshot) {
            return Row(
              children: [
                SizedBox(
                    width: commonSizeForDesktop(context) ? 450 : MediaQuery.of(context).size.width,
                    child: DialerScreen(
                      callFunction: (contact) {
                        contactInfo = contact;
                        helperObj = (globals.helper ?? SIPUAHelper());
                        isSelectCall.value = true;
                      },
                    )),
                isSelectCall.value
                    ? Expanded(
                        child: CallScreen(
                          contactInfo: contactInfo,
                          calling: (contactInfo.number?.isEmpty ?? true) ? desktopNumber : contactInfo.number?[0].value,
                          callerName: (contactInfo.name.isEmpty ?? true) ? "Unknown" : contactInfo.name,
                          callObj: globals.callglobalObj,
                          callEndTap: () {
                            isSelectCall.value = false;
                          },
                        ),
                      )
                    : Expanded(
                        child: SizedBox(
                        height: double.infinity,
                        child: Center(
                            child: Image.asset(
                          "assets/images/No_Calls.png",
                          height: 300,
                        )),
                      ))
              ],
            );
          }),
    );
  }
}
