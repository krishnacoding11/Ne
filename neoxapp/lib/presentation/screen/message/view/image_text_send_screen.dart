import 'dart:io';
import 'dart:math';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/generated/l10n.dart';
import 'package:neoxapp/main.dart';
import 'package:neoxapp/presentation/widgets/custom_image_view.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:mime/mime.dart';
import '../../../../core/globals.dart';
import '../../../controller/chat_controller.dart';
import '../../../controller/message_controller.dart';
import '../../../controller/new_message_controller.dart';
import '../../../controller/new_socket_controller.dart';
import '../../login/model/verify_model.dart';

class ImageTextSendScreen extends StatefulWidget {
  final List<File>? sendFileList;
  const ImageTextSendScreen({Key? key, this.sendFileList}) : super(key: key);

  @override
  State<ImageTextSendScreen> createState() => _ImageTextSendScreenState();
}

class _ImageTextSendScreenState extends State<ImageTextSendScreen> {
  PageController? pageController = PageController();
  TextEditingController chatTextController = TextEditingController();
  ScrollController scrollController = ScrollController();
  ChatController chatController = Get.find();
  NewMessagesController controller = Get.find();
  NewSocketController newSocketController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: themeController.isDarkMode ? AppColors.color1F222A : AppColors.colorFFFFFF,
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   backgroundColor: themeController.isDarkMode ? AppColors.color1F222A : AppColors.colorFFFFFF,
        //   actions: [
        //     IconButton(
        //         onPressed: () {
        //           Get.back();
        //         },
        //         icon: Icon(Icons.clear))
        //   ],
        // ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: PhotoViewGallery.builder(
                          scrollPhysics: const BouncingScrollPhysics(),
                          builder: (BuildContext context, int index) {
                            return PhotoViewGalleryPageOptions.customChild(
                              child: Image.file(widget.sendFileList?[index] ?? File("")),
                              initialScale: PhotoViewComputedScale.contained,
                            );
                          },
                          itemCount: widget.sendFileList?.length ?? 0,
                          loadingBuilder: (context, event) => Center(
                            child: Container(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          backgroundDecoration: BoxDecoration(
                            color: themeController.isDarkMode ? AppColors.color1F222A : AppColors.colorFFFFFF,
                          ),

                          pageController: pageController,
                          // onPageChanged: (value) {
                          //   selectIndex?.value = value;
                          // },
                        ),
                      ),
                      Positioned(
                        top: 50,
                        right: 10,
                        child: IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.clear)),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 50),
                    // decoration: BoxDecoration(
                    //   color: AppColors.getCardColor(context),
                    //   boxShadow: <BoxShadow>[
                    //     BoxShadow(
                    //       color: Colors.black26,
                    //       blurRadius: 15.0,
                    //       offset: Offset(0.0, 0.75),
                    //     )
                    //   ],
                    // ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: AutoSizeTextField(
                        showCursor: false,
                        style: TextStyle(color: AppColors.color1F222A),
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: themeController.isDarkMode ? AppColors.darkPrimaryColor : AppColors.primaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          hintText: S.of(context).addCaption,
                          hintStyle: TextStyle(
                            color: AppColors.hintColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          filled: true,
                          fillColor: AppColors.subFont1,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(5),
                            child: InkWell(
                              onTap: () async {
                                bool isGroup = controller.sideBarData?.isGroup == 1;
                                UserDetails userDetails = await getUserData();
                                var id = (Random().nextInt(900000000) + 100000000).toString();
                                print("path 1 ${controller.sideBarData!.sId}");

                                String? m1 = lookupMimeType(widget.sendFileList![0].path)?.split("/")[0];
                                String? m2 = lookupMimeType(widget.sendFileList![0].path.toString())?.split("/")[1];
                                chatController.insertData(id, isGroup ? 1 : 0, controller.sideBarData!.sId, controller.chatController.text, null, 0, 1, null, null, widget.sendFileList![0].path.toString(), chatTextController.text, () async {
                                  ();
                                }, firstName: userDetails.firstName ?? "", lastName: userDetails.lastName ?? "");
                                MessageController messageController = Get.find();
                                await messageController.getMessegeData();

                                messageController.update();

                                if (newSocketController.function != null) {
                                  newSocketController.function!();
                                }
                                Get.back();

                                //
                                if (widget.sendFileList?[0] != null) {
                                  chatController.uploadMultimediaApiCall(widget.sendFileList![0].path.toString(), widget.sendFileList![0].path.toString(), m1, m2, (data) async {
                                    if (lookupMimeType(data["originalName"])?.split("/")[0] == "image") {
                                      chatController.updateData(id, isGroup ? 1 : 0, controller.sideBarData!.sId, data["url"], null, 0, 1, null, null, widget.sendFileList![0].path.toString(), () async {
                                        ();
                                      }, firstName: userDetails.firstName ?? "", lastName: userDetails.lastName ?? "");
                                      newSocketController.send_message(id, isGroup ? 1 : 0, controller.sideBarData!.sId, data["url"], isGroup ? controller.sideBarData!.sId : null, 0, 1, null, null, widget.sendFileList![0].path.toString(), chatTextController.text, () async {
                                        ();
                                      }, firstName: userDetails.firstName ?? "", lastName: userDetails.lastName ?? "");
                                    }
                                  });
                                }
                              },
                              child: Container(
                                  // height: 45,
                                  //   width: 45,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.primaryColor),
                                  child: CustomImageView(svgPath: 'sendicon.svg', onTap: null, height: 17)),
                            ),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8),
                            child: CustomImageView(svgPath: 'cameraImage.svg', onTap: null, height: 25),
                          ),
                        ),

                        controller: chatTextController,
                        onTap: () {
                          scrollUp();
                          setState(() {});
                        },
                        onChanged: (value) {
                          // print('value $value');
                          // value = newMessagesController.scrollController
                          //     .animateTo(
                          //       newMessagesController.scrollController.position.maxScrollExtent +
                          //           10.h5,
                          //       duration: const Duration(milliseconds: 300),
                          //       curve: Curves.easeOut,
                          //     )
                          //     .toString();
                          // setState(() {});
                        },

                        // prefixIcon: Padding(
                        //   padding: const EdgeInsets.all(8),
                        //   child: CustomImageView(svgPath: 'other_otion_image.svg', onTap: null, height: 25.h),
                        // ),
                      ).marginSymmetric(horizontal: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void scrollUp() {
    print("new message controller scroll");
    final position = scrollController.position.maxScrollExtent + 40;
    scrollController.jumpTo(position);

    setState(() {});
  }
}
