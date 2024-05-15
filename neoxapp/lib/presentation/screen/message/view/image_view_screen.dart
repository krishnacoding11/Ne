import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:neoxapp/main.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewScreen extends StatefulWidget {
  final List<String>? imageList;

  const ImageViewScreen({Key? key, this.imageList}) : super(key: key);

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  PageController? pageController = PageController();
  TextEditingController chatTextController = TextEditingController();
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions.customChild(child: Container(constraints: const BoxConstraints(minHeight: 197, minWidth: 180, maxHeight: 300, maxWidth: 240), child: Image.file(File(widget.imageList?[index] ?? ""))), initialScale: PhotoViewComputedScale.contained, childSize: MediaQuery.of(context).size);
          },
          itemCount: widget.imageList?.length ?? 0,
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
        Positioned(
          top: 45,
          right: 10,
          child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.clear)),
        )
      ],
    );
  }
}
