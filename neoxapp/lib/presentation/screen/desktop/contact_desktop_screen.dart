import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/presentation/screen/dashboard/contact/contact_screen.dart';
import 'package:neoxapp/presentation/screen/dashboard/model/contact_info_model.dart';
import 'package:neoxapp/presentation/screen/detail/detail_screen.dart';

class ContactDesktopScreen extends StatefulWidget {
  const ContactDesktopScreen({super.key});

  @override
  State<ContactDesktopScreen> createState() => _ContactDesktopScreenState();
}

class _ContactDesktopScreenState extends State<ContactDesktopScreen> {
  ContactInfo contactInfo = ContactInfo(number: [], name: "");
  RxInt selectPage = 0.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: selectPage.stream,
          builder: (context, snapshot) {
            return Row(
              children: [
                SizedBox(
                    width: 400,
                    child: ContactScreen(
                      contactInfoFunction: (contact) {
                        contactInfo = contact;
                        selectPage.value = 1;
                      },
                    )),
                Expanded(
                    child: selectPage.value == 1
                        ? DetailScreen(
                            contactInfo: contactInfo,
                          )
                        : SizedBox(
                            height: double.infinity,
                            child: Center(
                                child: Image.asset(
                              "assets/images/ContactsemptyImage.png",
                              height: 300,
                            )),
                          )),
              ],
            );
          }),
    );
  }
}
