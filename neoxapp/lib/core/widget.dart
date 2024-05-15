import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neoxapp/core/theme_color.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../presentation/widgets/custom_image_view.dart';
import 'constants.dart';

bool isMiniSize = false;

Widget getHorSpace(double verSpace) {
  return SizedBox(
    width: verSpace,
  );
}

double getHeight() {
  // return 75.h;
  return 75;
}

EdgeInsets getHeightPadding() {
  // return 75.h;
  return EdgeInsets.all(16);
}

EdgeInsetsGeometry getPadding({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  return getMarginOrPadding(
    all: all,
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  );
}

EdgeInsetsGeometry getMarginOrPadding({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  if (all != null) {
    left = all;
    top = all;
    right = all;
    bottom = all;
  }
  return EdgeInsets.only(
    left: left ?? 0,
    top: top ?? 0,
    right: right ?? 0,
    bottom: bottom ?? 0,
  );
}

Widget getSearchTextFiled({Color? fillColor, required TextEditingController textEditingController, var validator, required BuildContext context, required String hint, bool enable = true, Function(String)? onChanged, bool prefix = false, bool suffix = false, bool obscureText = false, String? suffixIcon, String? prefixIcon, Function? function, Color? suffixColor}) {
  Widget widget = TextFormField(
    textCapitalization: TextCapitalization.words,
    autocorrect: false,
    controller: textEditingController,
    autofocus: false,
    cursorColor: AppColors.fontColor,
    showCursor: true,
    enabled: enable,
    validator: validator,
    obscureText: obscureText,
    maxLines: 1,
    onChanged: onChanged,
    textAlign: TextAlign.start,
    textInputAction: TextInputAction.done,
    textAlignVertical: TextAlignVertical.center,
    style: TextStyle(color: AppColors.fontColor, fontWeight: FontWeight.w600, fontSize: 14, fontFamily: Constants.fontLato),
    decoration: InputDecoration(
        counterText: "",
        contentPadding: getHeightPadding(),
        isDense: true,
        prefixIconConstraints: BoxConstraints(minWidth: 45, maxWidth: 45),
        suffixIconConstraints: BoxConstraints(minWidth: 40, maxWidth: 40),
        prefixIcon: prefix
            ? Padding(
                padding: EdgeInsets.only(left: 16, right: 10),
                child: CustomImageView(
                  svgPath: "$prefixIcon",
                ),
              )
            : null,
        // suffixIconConstraints: BoxConstraints(minWidth: 30.h, maxWidth: 30.h),
        suffixIcon: suffix
            ? GestureDetector(
                onTap: () {
                  if (function != null) {
                    function();
                  }
                },
                child: Container(
                    child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: CustomImageView(
                    svgPath: "$suffixIcon",
                    color: !obscureText ? AppColors.primaryColor : AppColors.subFontColor,
                    height: 20,
                    width: 20,
                  ),
                )),
              )
            : null,
        // suffix: suffix
        //
        //
        //     ?Padding(
        //   padding:  EdgeInsets.zero,
        //   child: CustomImageView(
        //
        //     svgPath: "${Constants.assetPath}$suffix",
        //
        //
        //
        //   ),
        // )
        //     : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.redColor, width: 1)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.redColor, width: 1)),
        fillColor: fillColor ?? Color(0xffEBF0FF),
        filled: true,
        errorStyle: TextStyle(color: AppColors.redColor, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: Constants.fontLato),
        label: null,
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.getSubFontColor(context), fontWeight: FontWeight.w600, fontSize: 14, fontFamily: Constants.fontLato)),
  );
  return enable
      ? Container(
          // height: 48.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Color(0xffEBF0FF)),
          child: widget,
        )
      : InkWell(
          child: widget,
          onTap: () {
            if (function != null) {
              function();
            }
          },
        );
}

Widget getTextFiled({TextInputType? keyboardType, EdgeInsets? scrollPadding, Color? fillColor, required TextEditingController textEditingController, var validator, required BuildContext context, required String hint, bool enable = true, Function(String)? onChanged, bool prefix = false, bool suffix = false, bool obscureText = false, String? suffixIcon, String? prefixIcon, Function? function, Color? suffixColor}) {
  Widget widget = TextFormField(
    textCapitalization: TextCapitalization.words,
    autocorrect: false,
    controller: textEditingController,
    autofocus: false,
    cursorColor: AppColors.fontColor,
    showCursor: true,
    enabled: enable,
    validator: validator,
    scrollPadding: scrollPadding ?? EdgeInsets.all(20.0),
    obscureText: obscureText,
    maxLines: 1,
    onChanged: onChanged,
    textAlign: TextAlign.start,
    textInputAction: TextInputAction.done,
    keyboardType: keyboardType,
    textAlignVertical: TextAlignVertical.center,
    style: TextStyle(color: AppColors.fontColor, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: Constants.fontLato),
    decoration: InputDecoration(
        counterText: "",
        contentPadding: getHeightPadding(),
        isDense: true,
        prefixIconConstraints: BoxConstraints(minWidth: 45, maxWidth: 45),
        prefixIcon: prefix
            ? Padding(
                padding: EdgeInsets.only(left: 16, right: 10),
                child: CustomImageView(
                  svgPath: "$prefixIcon",
                ),
              )
            : null,
        // suffixIconConstraints: BoxConstraints(minWidth: 30.h, maxWidth: 30.h),
        suffixIcon: suffix
            ? GestureDetector(
                onTap: () {
                  if (function != null) {
                    function();
                  }
                },
                child: Container(
                    child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: CustomImageView(
                    svgPath: "$suffixIcon",
                    color: !obscureText ? AppColors.primaryColor : AppColors.subFontColor,
                  ),
                )),
              )
            : null,
        // suffix: suffix
        //
        //
        //     ?Padding(
        //   padding:  EdgeInsets.zero,
        //   child: CustomImageView(
        //
        //     svgPath: "${Constants.assetPath}$suffix",
        //
        //
        //
        //   ),
        // )
        //     : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: AppColors.redColor, width: 1)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: AppColors.redColor, width: 1)),
        fillColor: fillColor ?? AppColors.getSubCardColor(context),
        filled: true,
        errorStyle: TextStyle(color: AppColors.redColor, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: Constants.fontLato),
        label: null,
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.hintColor, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: Constants.fontLato)),
  );
  return enable
      ? Container(
          // height: 48.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: AppColors.getSubCardColor(context)),
          child: widget,
        )
      : InkWell(
          child: widget,
          onTap: () {
            if (function != null) {
              function();
            }
          },
        );
}

Widget getDialerTextFiled({
  required TextEditingController textEditingController,
  var validator,
  required BuildContext context,
  required String hint,
  bool enable = true,
  bool prefix = false,
  bool suffix = false,
  Function(String)? onChange,
  Widget? suffixIcon,
  String? prefixIcon,
  Function? function,
  double? fontSize,
  Color? suffixColor,
}) {
  Widget widget = TextFormField(
    textCapitalization: TextCapitalization.words,
    autocorrect: false,
    controller: textEditingController,
    autofocus: false,
    cursorColor: AppColors.fontColor,
    showCursor: true,
    readOnly: true,
    enabled: enable,
    validator: validator,
    maxLength: 14,
    onChanged: (value) => onChange,
    maxLines: 1,
    textAlign: TextAlign.center,
    textInputAction: TextInputAction.done,
    textAlignVertical: TextAlignVertical.center,
    onTap: () {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    style: TextStyle(color: AppColors.getFontColor(context), fontWeight: FontWeight.w400, fontSize: fontSize ?? 36, fontFamily: Constants.fontLato),
    decoration: InputDecoration(
        counterText: "",
        contentPadding: getHeightPadding(),
        isDense: true,
        prefixIconConstraints: BoxConstraints(minWidth: 45, maxWidth: 45),
        prefixIcon: prefix
            ? Padding(
                padding: EdgeInsets.only(left: 16, right: 10),
                child: CustomImageView(
                  svgPath: "$prefixIcon",
                ),
              )
            : null,
        // suffixIconConstraints: BoxConstraints(minWidth: 30.h, maxWidth: 30.h),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: AppColors.redColor, width: 1)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: AppColors.redColor, width: 1)),
        fillColor: Colors.transparent,
        filled: true,
        errorStyle: TextStyle(color: AppColors.redColor, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: Constants.fontLato),
        label: null,
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.hintColor, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: Constants.fontLato)),
  );
  return enable
      ? Container(
          // height: 48.h,
          child: widget,
        )
      : InkWell(
          child: widget,
          onTap: () {
            if (function != null) {
              function();
            }
          },
        );
}

Widget getCustomFont(String text, double fontSize, Color fontColor, int maxLine, {TextOverflow overflow = TextOverflow.ellipsis, TextDecoration decoration = TextDecoration.none, FontWeight fontWeight = FontWeight.normal, TextAlign textAlign = TextAlign.start, bool isEmpty = false, String? fontFamily, double txtHeight = 1.5}) {
  if (isEmpty && text.isEmpty) {
    text = '-';
  }
  return AutoSizeText(
    text.capitalize(),
    overflow: overflow,
    style: TextStyle(decoration: decoration, fontSize: fontSize, fontStyle: FontStyle.normal, color: fontColor, fontFamily: fontFamily ?? Constants.fontLato, fontWeight: fontWeight),
    maxLines: maxLine,
    softWrap: true,
    textAlign: textAlign,
    minFontSize: 5,
    maxFontSize: 35,
  );
}

Widget getVerSpace(double verSpace) {
  return SizedBox(
    height: verSpace,
  );
}

Widget getMultilineCustomFont(String text, double fontSize, Color fontColor, {TextOverflow overflow = TextOverflow.ellipsis, TextDecoration decoration = TextDecoration.none, FontWeight fontWeight = FontWeight.normal, TextAlign textAlign = TextAlign.start, String? fontFamily, txtHeight = 1.1}) {
  return Text(
    text,
    style: TextStyle(
      decoration: decoration,
      fontSize: fontSize,
      fontStyle: FontStyle.normal,
      color: fontColor,
      fontFamily: fontFamily ?? Constants.fontLato,
      height: txtHeight,
      fontWeight: fontWeight,
    ),
    textAlign: textAlign,
  );
}

Widget getButton(BuildContext context, Color bgColor, String text, Color textColor, Function function, double fontSize, {bool isBorder = false, EdgeInsetsGeometry? insetsGeometry, borderColor = Colors.transparent, FontWeight weight = FontWeight.bold, bool isIcon = false, String? image, Color? imageColor, double? imageWidth, double? imageHeight, bool smallFont = false, bool isProcess = false, Color? color, double? buttonHeight, double? buttonWidth, List<BoxShadow> boxShadow = const [], EdgeInsetsGeometry? insetsGeometryPadding, BorderRadius? borderRadius, double? borderWidth}) {
  return Container(
    height: 48,
    width: double.infinity,
    margin: insetsGeometry,
    child: ElevatedButton(
      onPressed: () {
        function();
      },
      style: ElevatedButton.styleFrom(elevation: 0, padding: insetsGeometryPadding ?? EdgeInsets.zero, surfaceTintColor: bgColor, backgroundColor: bgColor, shape: RoundedRectangleBorder(borderRadius: borderRadius ?? BorderRadius.circular(6), side: isBorder ? BorderSide(color: borderColor, width: borderWidth!) : BorderSide(width: 0, color: Colors.transparent))),
      child: isProcess ? getProgressDialog(color: color ?? Colors.white) : getCustomFont(text, fontSize, textColor, 1, fontWeight: weight),
    ),
  );
}

getProgressDialog({Color? color, bool isCenter = true}) {
  return new Container(
      child: isCenter
          ? new Center(
              child: CupertinoActivityIndicator(
              color: color == null ? Colors.grey : color,
            ))
          : CupertinoActivityIndicator(
              color: color == null ? Colors.grey : color,
            ));
}

Widget getButtonWithIcon(BuildContext context, Color bgColor, String text, Color textColor, Function function, double fontSize, {bool isBorder = false, EdgeInsetsGeometry? insetsGeometry, borderColor = Colors.transparent, FontWeight weight = FontWeight.bold, bool isIcon = false, String? image, Color? imageColor, double? imageWidth, double? imageHeight, bool smallFont = false, bool isProcess = false, Color? color, double? buttonHeight, double? buttonWidth, List<BoxShadow> boxShadow = const [], EdgeInsetsGeometry? insetsGeometryPadding, BorderRadius? borderRadius, double borderWidth = 1}) {
  return Container(
    height: buttonHeight,
    width: buttonWidth,
    margin: insetsGeometry,
    child: ElevatedButton(
      onPressed: () {
        function();
      },
      style: ElevatedButton.styleFrom(elevation: 0, padding: insetsGeometryPadding, surfaceTintColor: bgColor, backgroundColor: bgColor, shape: RoundedRectangleBorder(borderRadius: borderRadius!, side: isBorder ? BorderSide(color: borderColor, width: borderWidth) : BorderSide(width: 0, color: Colors.transparent))),
      child: isProcess
          ? getProgressDialog(color: color ?? Colors.white)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImageView(
                  svgPath: "chat.svg",
                  height: 24,
                  width: 24,
                  color: AppColors.primaryColor,
                ),
                getHorSpace(8),
                // AutoSizeText(
                //
                //   text,
                //   style: TextStyle(
                //       fontSize: fontSize,
                //       color: textColor,
                //       fontWeight: weight,
                //       fontFamily: Constants.fontFamily),
                //   maxLines: 1,
                // )

                Expanded(child: getCustomFont(text, isMiniSize ? (fontSize / 1.2) : fontSize, textColor, 1, fontWeight: weight))
              ],
            ),
    ),
  );
}

Widget getIconButton(String image, double size, VoidCallback? onTap, {BoxConstraints? constraints, Color? color, Color? iconColor}) {
  return Container(
    constraints: constraints,
    child: IconButton(
      padding: EdgeInsets.zero,
      constraints: constraints,
      iconSize: 24,
      color: color,
      icon: CustomImageView(
        svgPath: image,
        height: size,
        width: size,
        color: iconColor,
      ),
      onPressed: onTap,
    ),
  );
}

Widget getDefaultTextFiledWithLabelDone(BuildContext context, String s, TextEditingController textEditingController, {bool withprefix = false, bool withSufix = false, bool minLines = false, EdgeInsetsGeometry margin = EdgeInsets.zero, bool isPass = false, bool isEnable = true, double? height, double? imageHeight, double imageWidth = 0, double suffixWidth = 0, Widget? image, Widget? suffiximage, Function? imagefunction, AlignmentGeometry alignmentGeometry = Alignment.centerLeft, List<TextInputFormatter>? inputFormatters, bool defFocus = false, FocusNode? focus1, TextInputType? keyboardType, FormFieldValidator<String>? validator, Color? labelColor, GestureTapCallback? onTap, int maxLines = 1, ValueChanged<String>? onChanged, ValueChanged<String>? onFieldSubmitted, TextInputAction textInputAction = TextInputAction.newline}) {
  // Color color = borderColor;

  return TextFormField(
    autocorrect: true,
    onChanged: onChanged,
    onTap: onTap,
    validator: validator,
    textCapitalization: TextCapitalization.sentences,
    keyboardType: keyboardType,
    enabled: isEnable,
    inputFormatters: inputFormatters,
    maxLines: maxLines,
    controller: textEditingController,
    obscuringCharacter: "*",
    textInputAction: textInputAction,
    focusNode: focus1,
    cursorColor: AppColors.fontColor,
    obscureText: isPass,
    onFieldSubmitted: (value) {
      if (onFieldSubmitted != null) {
        onFieldSubmitted(value);
      }
    },
    showCursor: true,
    autofocus: false,
    textAlign: TextAlign.start,
    textAlignVertical: TextAlignVertical.center,
    style: TextStyle(color: AppColors.fontColor, fontWeight: FontWeight.w400, fontSize: 16, fontFamily: Constants.fontFamily),
    decoration: InputDecoration(
        contentPadding: getPadding(left: 16, right: 16, top: 16),
        prefixIconConstraints: BoxConstraints(
          maxHeight: 50,
          minHeight: 50,
          maxWidth: imageWidth,
        ),
        prefixIcon: image,
        suffixIcon: suffiximage,
        suffixIconConstraints: BoxConstraints(
          maxHeight: 50,
          minHeight: 50,
          maxWidth: suffixWidth,
        ),
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.redColor, width: 1)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.redColor, width: 1)),
        errorStyle: TextStyle(color: AppColors.redColor, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: Constants.fontFamily),
        hintText: s,
        hintStyle: TextStyle(color: AppColors.subFontColor, fontWeight: FontWeight.w400, fontSize: 16, fontStyle: FontStyle.italic, fontFamily: Constants.fontFamily)),
  );
}

//bgbg başla
Widget getDefaultTextFiledWithLabel(BuildContext context, String s, TextEditingController textEditingController, {bool withprefix = false, bool withSufix = false, bool minLines = false, EdgeInsetsGeometry margin = EdgeInsets.zero, bool isPass = false, bool isEnable = true, double? height, double? imageHeight, double imageWidth = 0, double suffixWidth = 0, Widget? image, Widget? suffiximage, Function? imagefunction, AlignmentGeometry alignmentGeometry = Alignment.centerLeft, List<TextInputFormatter>? inputFormatters, bool defFocus = false, FocusNode? focus1, TextInputType? keyboardType, FormFieldValidator<String>? validator, Color? labelColor, GestureTapCallback? onTap, int maxLines = 1, ValueChanged<String>? onChanged, ValueChanged<String>? onFieldSubmitted, TextInputAction textInputAction = TextInputAction.next}) {
  // Color color = borderColor;

  return TextFormField(
    autocorrect: true,
    textCapitalization: TextCapitalization.words,
    onChanged: onChanged,
    onTap: onTap,
    validator: validator,
    keyboardType: keyboardType,
    enabled: isEnable,
    inputFormatters: inputFormatters,
    maxLines: maxLines,
    controller: textEditingController,
    obscuringCharacter: "*",
    textInputAction: textInputAction,
    focusNode: focus1,
    cursorColor: AppColors.fontColor,
    obscureText: isPass,
    onFieldSubmitted: (value) {
      if (onFieldSubmitted != null) {
        onFieldSubmitted(value);
      }
    },
    showCursor: true,
    autofocus: false,
    textAlign: TextAlign.start,
    textAlignVertical: TextAlignVertical.center,
    style: TextStyle(color: AppColors.fontColor, fontWeight: FontWeight.w400, fontSize: 16, fontFamily: Constants.fontFamily),
    decoration: InputDecoration(
        contentPadding: getPadding(left: 16, right: 16, top: 16),
        prefixIconConstraints: BoxConstraints(
          maxHeight: 50,
          minHeight: 50,
          maxWidth: imageWidth,
        ),
        prefixIcon: image,
        suffixIcon: suffiximage,
        suffixIconConstraints: BoxConstraints(
          maxHeight: 50,
          minHeight: 50,
          maxWidth: suffixWidth,
        ),
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.transparent, width: 0)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.redColor, width: 1)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.redColor, width: 1)),
        errorStyle: TextStyle(color: AppColors.redColor, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: Constants.fontFamily),
        hintText: s,
        hintStyle: TextStyle(color: AppColors.subFontColor, fontWeight: FontWeight.w400, fontSize: 16, fontFamily: Constants.fontFamily)),
  );
}

Widget getNoteTextFiledWithLabel(BuildContext context, String s, TextEditingController textEditingController, {bool withprefix = false, bool withSufix = false, bool minLines = false, EdgeInsetsGeometry margin = EdgeInsets.zero, bool isPass = false, bool isEnable = true, double? height, double? imageHeight, double imageWidth = 0, double suffixWidth = 0, Widget? image, Widget? suffiximage, Function? imagefunction, AlignmentGeometry alignmentGeometry = Alignment.centerLeft, List<TextInputFormatter>? inputFormatters, bool defFocus = false, FocusNode? focus1, TextInputType? keyboardType, FormFieldValidator<String>? validator, Color? labelColor, GestureTapCallback? onTap, int maxLines = 1, ValueChanged<String>? onChanged, ValueChanged<String>? onFieldSubmitted, TextInputAction textInputAction = TextInputAction.done}) {
  // Color color = borderColor;

  return TextFormField(
    autocorrect: true,
    textCapitalization: TextCapitalization.words,
    onChanged: onChanged,
    onTap: onTap,
    validator: validator,
    keyboardType: keyboardType,
    enabled: isEnable,
    inputFormatters: inputFormatters,
    maxLines: maxLines,
    controller: textEditingController,
    obscuringCharacter: "*",
    textInputAction: textInputAction,
    focusNode: focus1,
    cursorColor: AppColors.fontColor,
    obscureText: isPass,
    onFieldSubmitted: (value) {
      if (onFieldSubmitted != null) {
        onFieldSubmitted(value);
      }
    },
    showCursor: true,
    autofocus: false,
    textAlign: TextAlign.start,
    textAlignVertical: TextAlignVertical.center,
    style: TextStyle(color: AppColors.fontColor, fontWeight: FontWeight.w400, fontSize: 16, fontFamily: Constants.fontFamily),
    decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        prefixIconConstraints: BoxConstraints(
          maxHeight: 50,
          minHeight: 50,
          maxWidth: imageWidth,
        ),
        prefixIcon: image,
        suffixIcon: suffiximage,
        suffixIconConstraints: BoxConstraints(
          maxHeight: 50,
          minHeight: 50,
          maxWidth: suffixWidth,
        ),
        isDense: true,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        errorStyle: TextStyle(color: AppColors.redColor, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: Constants.fontFamily),
        hintText: s,
        hintStyle: TextStyle(color: AppColors.subFontColor, fontWeight: FontWeight.w400, fontSize: 16, fontFamily: Constants.fontFamily)),
  );
}

extension StringExtensions on String {
  String capitalize() {
    if (this.length > 0) {
      return "${this[0].toUpperCase()}${this.substring(1)}";
    } else {
      return this;
    }
  }
}
