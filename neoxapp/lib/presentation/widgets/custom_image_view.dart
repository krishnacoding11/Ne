// ignore_for_file: must_be_immutable


import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
// //import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/theme_color.dart';

class CustomImageView extends StatelessWidget {
  ///[url] is required parameter for fetching network image
  String? url;

  ///[imagePath] is required parameter for showing png,jpg,etc image
  String? imagePath;

  ///[svgPath] is required parameter for showing svg image
  String? svgPath;

  ///[file] is required parameter for fetching image file
  File? file;

  double? height;
  double? width;
  Color? color;
  BoxFit? fit;
  bool isOval;
  Widget? errorWidget;
  final String placeHolder;
  Uint8List? memory;
  Alignment? alignment;
  VoidCallback? onTap;
  EdgeInsetsGeometry? margin;
  BorderRadius? radius;
  BoxBorder? border;
  bool isCache = false;

  ///a [CustomImageView] it can be used for showing any type of images
  /// it will shows the placeholder image if image is not found on network image
  CustomImageView({
    super.key,
    this.url,
    this.memory,
    this.imagePath,
    this.svgPath,
    this.file,
    this.height,
    this.width,
    this.errorWidget,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = 'assets/images/image_not_found.png',
    this.isOval = false,
    this.isCache = false,
  });

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildWidget(),
          )
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  ///build the image with border radius
  _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius!,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (svgPath != null && svgPath!.isNotEmpty) {
      return SizedBox(
        height: height,
        width: width,
        child: SvgPicture.asset(
          Constants.assetPath + svgPath!,
          height: height,
          width: width,
          fit: fit ?? BoxFit.contain,
          // ignore: deprecated_member_use
          color: color,
        ),
      );
    } else if (file != null && file!.path.isNotEmpty) {
      return Image.file(
        file!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
      );
    } else if (url != null && url!.isNotEmpty) {
      // print("urk==${url}");
      return isOval
          ? CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
              child: ClipOval(
                child: isCache
                    ? NonCacheNetworkImage(url!, errorWidget, height!, width!, fit!, placeHolder)
                    : Image.network(
                        url!,
                        height: height,
                        width: width,
                        fit: fit,
                        errorBuilder: (context, error, stackTrace) {
                          return errorWidget == null
                              ? Image.asset(
                                  placeHolder,
                                  height: height,
                                  width: width,
                                  fit: fit ?? BoxFit.cover,
                                )
                              : errorWidget!;
                        },
                      ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  url!,
                  height: height,
                  width: width,
                  fit: fit,
                  errorBuilder: (context, error, stackTrace) {
                    return errorWidget == null
                        ? Image.asset(
                            placeHolder,
                            height: height,
                            width: width,
                            fit: fit ?? BoxFit.cover,
                          )
                        : errorWidget!;
                  },
                ),
              ),
            );
    } else if (memory != null) {
      return isOval
          ? CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
              child: ClipOval(
                child: Image.memory(
                  memory!,
                  height: height,
                  width: width,
                  fit: fit,
                  errorBuilder: (context, error, stackTrace) {
                    return errorWidget == null
                        ? Image.asset(
                            placeHolder,
                            height: height,
                            width: width,
                            fit: fit ?? BoxFit.cover,
                          )
                        : errorWidget!;
                  },
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  (memory!),
                  height: height,
                  width: width,
                  fit: fit,
                  errorBuilder: (context, error, stackTrace) {
                    return errorWidget == null
                        ? Image.asset(
                            placeHolder,
                            height: height,
                            width: width,
                            fit: fit ?? BoxFit.cover,
                          )
                        : errorWidget!;
                  },
                ),
              ),
            );
    } else if (imagePath != null && imagePath!.isNotEmpty) {
      return Image.asset(
        imagePath!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
      );
    }
    return const SizedBox();
  }
}

class NonCacheNetworkImage extends StatelessWidget {
  const NonCacheNetworkImage(
    this.imageUrl,
    this.errorWidget,
    this.height,
    this.width,
    this.fit,
    this.placeHolder,
  );

  final String imageUrl;
  final Widget? errorWidget;
  final double height;
  final double width;

  final BoxFit fit;
  final String placeHolder;

  Future<Uint8List> getImageBytes() async {
    Response response = await get(Uri.parse(imageUrl));
    return response.bodyBytes;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: getImageBytes(),
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return ClipOval(
            child: Image.memory(
              (snapshot.data!),
              height: height,
              width: width,
              fit: fit,
              errorBuilder: (context, error, stackTrace) {
                return errorWidget == null
                    ? Image.asset(
                        placeHolder,
                        height: height,
                        width: width,
                        fit: fit,
                      )
                    : errorWidget!;
              },
            ),
          );
        return errorWidget == null
            ? Image.asset(
                placeHolder,
                height: height,
                width: width,
                fit: fit,
              )
            : errorWidget!;
      },
    );
  }
}
