import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/model/enter_price_user_model.dart';
import 'package:neoxapp/presentation/screen/message/view/addGroupNameScreen.dart';
import 'package:neoxapp/presentation/screen/message/view/add_member_screen.dart';
import 'package:neoxapp/presentation/screen/message/view/create_group_screen.dart';
import 'package:neoxapp/presentation/screen/message/view/forworf_contect_screen.dart';
import 'package:neoxapp/presentation/screen/message/view/grop_message_screen.dart';
import 'package:neoxapp/presentation/screen/message/view/group_info_screen.dart';
import 'package:neoxapp/presentation/screen/message/view/main_group_info_screen.dart';
import 'package:neoxapp/presentation/screen/message/view/message_tab.dart';
import 'package:neoxapp/presentation/screen/message/view/new_chat_list_screen.dart';

import '../message/view/new_message_tab.dart';

class DesktopMessageScreen extends StatefulWidget {
  const DesktopMessageScreen({Key? key}) : super(key: key);

  @override
  State<DesktopMessageScreen> createState() => _DesktopMessageScreenState();
}

class _DesktopMessageScreenState extends State<DesktopMessageScreen> {
  RxInt selectMessage = 0.obs;
  RxInt selectPage = 0.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.subCardColor,
      body: Row(
        children: [
          SizedBox(
            width: 400,
            child: MessageScreen(
              mssageOnTap: (index) {
                selectPage.value = 0;
                selectMessage.value = index;
                selectPage.refresh();
              },
              newChatOnTap: () {
                selectPage.value = 1;
              },
            ),
          ),
          StreamBuilder(
              stream: selectPage.stream,
              builder: (context, snapshot) {
                return Expanded(
                    child: selectPage.value == 0
                        ? (selectMessage.value == 0
                            ? const NewMessageScreen()
                            : GroupMessageScreen(
                                forwordOnTap: () {
                                  selectPage.value = 6;
                                },
                                groupInfoOnTap: () {
                                  selectPage.value = 7;
                                },
                              ))
                        : selectPage.value == 1
                            ? NewChatListScreen(
                                nextOnTap: () {
                                  selectPage.value = 2;
                                },
                                backOnTap: () {
                                  selectPage.value = 0;
                                },
                                createGroupOnTap: () {
                                  selectPage.value = 4;
                                },
                              )
                            : selectPage.value == 2
                                ? AddGCreateGroupNameScreen(
                                    contactsSearchList: <UserData>[].obs,
                                    backOnTap: () {
                                      selectPage.value = 1;
                                    },
                                    nextOnTap: () {
                                      selectPage.value = 3;
                                    },
                                  )
                                : selectPage.value == 3
                                    ? MainGroupInfoScreen(
                                        backOnTap: () {
                                          selectPage.value = 2;
                                        },
                                        addMemberTap: () {
                                          selectPage.value = 8;
                                        },
                                      )
                                    : selectPage.value == 4
                                        ? CreateGroupListScreen(
                                            backOnTap: () {
                                              selectPage.value = 1;
                                            },
                                            nextOnTap: () {
                                              selectPage.value = 5;
                                            },
                                          )
                                        : selectPage.value == 5
                                            ? AddGCreateGroupNameScreen(
                                                contactsSearchList: <UserData>[].obs,
                                                backOnTap: () {
                                                  selectPage.value = 4;
                                                },
                                                nextOnTap: () {
                                                  selectPage.value = 3;
                                                },
                                              )
                                            : selectPage.value == 6
                                                ? ForwardContactScreenScreen(
                                                    backOnTap: () {
                                                      selectPage.value = 0;
                                                    },
                                                  )
                                                : selectPage.value == 7
                                                    ? GroupInfoScreen(
                                                        backOnTap: () {
                                                          selectPage.value = 0;
                                                        },
                                                        groupDetailModel: null,
                                                      )
                                                    : selectPage.value == 8
                                                        ? AddMemberScreen(
                                                            backOnTap: () {
                                                              selectPage.value = 3;
                                                            },
                                                          )
                                                        : const SizedBox());
              }),
        ],
      ),
    );
  }
}
