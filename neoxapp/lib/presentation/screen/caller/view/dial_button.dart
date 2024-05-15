import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widget.dart';
import '../../../widgets/custom_image_view.dart';

class DialButton extends StatelessWidget {
  final String icon;
  final String title;
  final Function? function;
  final Color? color;
  final Color? iconColor;
  final double? size;

  DialButton(this.title, this.icon, {this.function, this.color, this.size, this.iconColor});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        if (function != null) {
          function!();
        }
      },
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: 78,
            alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color ?? Color(0xff6487ED)),
            child: CustomImageView(
              svgPath: icon,
              height: size ?? 28,
              color: iconColor ?? Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          getCustomFont(title, 14, Colors.white, 1, fontWeight: FontWeight.w400)
        ],
      ),
    );
  }
}
