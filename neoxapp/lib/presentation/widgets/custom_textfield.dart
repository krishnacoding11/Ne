import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neoxapp/core/theme_color.dart';

class CustomTextField extends StatelessWidget {
  final bool readOnly;
  final bool? showCursor;
  final FontWeight? fontWeight;
  final TextEditingController? controller;
  final int maxLine;
  // final Function(String)? onChanged;
  final TextInputType keyboardType;
  final Color? textColor;
  final double? fontSize;
  final int? maxLength;
  final double? radius;
  final bool enabled;
  final bool isPassword;
  final FocusNode? focusNode;
  final String? hintText;
  final Color? hintTextColor;
  final double? hintFontSize;
  final FontWeight? hintTextWeight;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BorderSide? borderSide;
  final Color? fillColor;
  final VoidCallback? onTap;
  final Color? enableColor;
  final Color? disabledColor;
  final Color? focusedColor;
  final Color? cursorColor;
  final EdgeInsetsGeometry? contentPadding;
  final OutlineInputBorder? enableBorder;
  final OutlineInputBorder? focasBorder;
  final Widget? prefixWidget;
  final TextCapitalization? textCapitalization;
  final ValueChanged<String>? onChanged; //onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? textInputFormatter;
  final TextInputAction? textInputAction;
  final bool? copy;
  final double? textFieldHeight;
  final double? height;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final Decoration? decoration;
  CustomTextField({
    Key? key,
    this.textInputFormatter,
    this.decoration,
    this.border,
    this.boxShadow,
    // this.onFieldSubmitted,
    this.fontWeight,
    this.borderSide,
    this.showCursor,
    this.onChanged,
    this.maxLine = 1,
    this.maxLength,
    this.radius,
    this.enableBorder,
    this.focasBorder,
    this.fontSize,
    this.fillColor,
    this.textColor,
    this.disabledColor,
    this.height,
    this.isPassword = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.hintText,
    this.hintTextColor,
    this.hintFontSize,
    this.hintTextWeight,
    this.textAlign,
    this.textAlignVertical,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.enableColor,
    this.focusedColor,
    this.cursorColor,
    this.controller,
    this.contentPadding,
    this.prefixWidget,
    this.copy = false,
    this.readOnly = false,
    this.textCapitalization,
    this.textInputAction,
    this.validator,
    this.textFieldHeight,
  }) : super(key: key);

  final ValueNotifier<bool> _isObscure = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isObscure,
      builder: (context, bool isObscure, _) {
        if (!isPassword) {
          isObscure = false;
        }
        return Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Container(
            height: height ?? 40,
            decoration: decoration ??
                BoxDecoration(
                  // boxShadow: [
                  //   BoxShadow(
                  //       color: AppColors.shadowColor,
                  //       blurRadius: 0,
                  //       spreadRadius: 0.0),
                  // ],
                  borderRadius: BorderRadius.circular(radius ?? 50.0),
                ),
            child: TextFormField(
              // onFieldSubmitted: onFieldSubmitted,
              showCursor: showCursor ?? true,
              textCapitalization: textCapitalization ?? TextCapitalization.none,
              readOnly: readOnly,
              style: TextStyle(
                color: textColor ?? AppColors.getFontColor(context),
                fontSize: fontSize ?? 12,
                fontWeight: fontWeight ?? FontWeight.w600,
              ),
              onTap: onTap,
              obscureText: isObscure,
              // enableInteractiveSelection: false,
              inputFormatters: textInputFormatter,
              textInputAction: textInputAction,
              obscuringCharacter: '*',
              onChanged: onChanged,
              controller: controller,
              maxLines: maxLine,
              maxLength: maxLength,
              keyboardType: keyboardType,
              focusNode: focusNode,
              textAlignVertical: textAlignVertical,
              cursorColor: cursorColor ?? AppColors.getFontColor(context),
              textAlign: textAlign ?? TextAlign.justify,
              enabled: enabled,
              validator: validator,
              toolbarOptions: ToolbarOptions(
                  copy: copy ?? false,
                  cut: copy ?? false,
                  paste: true, //copy ?? false,
                  selectAll: copy ?? false),
              // toolbarOptions: const ToolbarOptions(copy: false, cut: false, paste: false, selectAll: false),
              decoration: InputDecoration(
                errorMaxLines: 1,
                prefix: prefixWidget,
                // prefixIconConstraints:BoxConstraints(maxWidth: 53),
                contentPadding: EdgeInsets.all(8),
                isDense: true,

                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon == null && isPassword
                    ? IconButton(
                        icon: Icon(
                          isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _isObscure.value = !isObscure;
                        },
                      )
                    : suffixIcon,
                counterText: "",
                hintText: hintText,
                hintStyle: TextStyle(
                  color: hintTextColor ?? AppColors.getSubFontColor(context),
                  fontSize: hintFontSize ?? 12,
                  fontWeight: hintTextWeight ?? FontWeight.w500,
                ),
                filled: true,
                fillColor: fillColor ?? AppColors.getCardColor(context),
                disabledBorder: enableBorder ??
                    OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(radius ?? 50)),
                      borderSide: BorderSide.none,
                      // borderSide: BorderSide(color: disabledColor ?? Colors.transparent),
                    ),
                enabledBorder: enableBorder ??
                    OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(radius ?? 50)),
                      borderSide: borderSide ?? BorderSide(color: AppColors.getSubFontColor(context)),
                      // borderSide: BorderSide(color: enableColor ?? AppColors.textColor),
                    ),
                // border: InputBorder.none,
                border: enableBorder ??
                    OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(radius ?? 50)),
                      borderSide: BorderSide.none,
                      // borderSide: BorderSide(color: focusedColor ?? AppColors.textColor),
                    ),
                focusedBorder: focasBorder ??
                    OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(radius ?? 50)),
                      borderSide: BorderSide(color: AppColors.primaryColor),
                      // borderSide: BorderSide(color: focusedColor ?? AppColors.textColor),
                    ),
                // errorBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.all(Radius.circular(radius ?? 20)),
                //   borderSide: const BorderSide(color: Colors.red),
                // ),
              ),
            ),
          ),
        );
      },
    );
  }
}
