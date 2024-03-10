// ignore_for_file: must_be_immutable
import 'package:cubit_movie_app/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'common_strings.dart';

///:::::::::: COMMON TEXT ::::::::::///
class CommonText extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final String fontFamily;
  final Size size;
  final Color color;
  final bool isHashTag;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final TextDecoration decoration;
  final Color? decorationColor;
  final Color shadowColor;
  final double dx;
  final double dy;
  final double letterSpacing;
  final int? maxLine;
  final double topSpacing;
  final double bottomSpacing;
  final double leftSpacing;
  final double rightSpacing;

  const CommonText({
    super.key,
    required this.title,
    this.isHashTag = false,
    required this.fontSize,
    this.fontWeight = FontWeight.w400,
    this.color = CommonColors.whiteColor,
    this.textAlign = TextAlign.left,
    this.fontFamily = CommonTextStyle.fontFamily,
    this.overflow = TextOverflow.ellipsis,
    this.size = const Size(0, 0),
    this.letterSpacing = 0,
    this.decoration = TextDecoration.none,
    this.decorationColor,
    this.shadowColor = Colors.transparent,
    this.dx = 0,
    this.dy = 0,
    this.maxLine = 1,
    this.topSpacing = 0,
    this.bottomSpacing = 0,
    this.leftSpacing = 0,
    this.rightSpacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        shadows: [
          Shadow(color: shadowColor, offset: Offset(dx, dy)),
        ],
        letterSpacing: letterSpacing,
      ),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLine,
    );
  }
}

///:::::::::: COMMON TEXT FORM FIELD ::::::::::///
class CommonTextFormField extends StatelessWidget {
  final Size size;
  final Color? textColor;
  final Color? hintTextColor;
  final Color? fillColor;
  final double borderWidth;
  final String? labelText;
  final List<Map<String, dynamic>>? hashTag;
  final Function()? onTap;
  final Color borderColor;
  final Widget? prefixIcon;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final Widget? suffixIcon;
  final String? suffixText;
  final String hintText;
  final String errorText;
  final double textSize;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final bool showCounterText;
  final bool isRead;
  final bool isObscure;
  final bool isConstrains;
  final double borderRadius;
  final String? Function(String?)? validation;
  final TextEditingController? controller;
  final Function(String)? onChange;
  final Function(String)? onDetached;
  final Function()? onDetectedCompleted;
  final Function(String)? onDone;
  final bool isDetectable;
  final bool enabled;
  final bool autofocus;
  final TextCapitalization textCapitalization;

  const CommonTextFormField({
    super.key,
    required this.size,
    required this.hintText,
    this.controller,
    this.suffixIcon,
    this.suffixText,
    this.maxLines = 1,
    this.maxLength,
    this.hashTag,
    this.keyboardType,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixWidget,
    this.onDetached,
    this.onDetectedCompleted,
    this.onTap,
    this.validation,
    this.isDetectable = false,
    this.textSize = numD04,
    this.textColor,
    this.hintTextColor,
    this.fillColor,
    this.borderWidth = numD001,
    this.borderColor = Colors.transparent,
    this.errorText = '',
    this.isRead = false,
    this.showCounterText = false,
    this.isObscure = false,
    this.isConstrains = false,
    this.enabled = false,
    this.borderRadius = numD05,
    this.labelText,
    this.onChange,
    this.onDone,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: CommonColors.textformfieldColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        shadows: const [
          BoxShadow(
            color: CommonColors.whiteColor,
            blurRadius: 4,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: TextFormField(
        keyboardAppearance: Brightness.light,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofocus: autofocus,
        readOnly: isRead,
        onTap: onTap,
        maxLines: isObscure ? 1 : maxLines,
        maxLength: maxLength,
        cursorColor: CommonColors.whiteColor,
        textCapitalization: textCapitalization,
        /*  enableSuggestions: false,
        autocorrect: false, */
        obscureText: isObscure,
        keyboardType: keyboardType,
        onChanged: onChange,
        onFieldSubmitted: onDone,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: size.width * numD04,
          color: textColor ?? CommonColors.whiteColor,
        ),
        validator: validation,
        decoration: commonDecoration(showCounterText),
      ),
    );
  }

  InputDecoration commonDecoration(bool showCounterText) {
    return InputDecoration(
      isDense: true,
      counterText: showCounterText ? null : "",
      hintText: hintText,
      contentPadding: EdgeInsets.symmetric(
        horizontal: size.width * numD035,
        vertical: size.width * numD04,
      ),
      prefixIcon: prefixIcon,
      prefixIconConstraints: isConstrains
          ? const BoxConstraints(
              minWidth: 25,
              minHeight: 25,
            )
          : const BoxConstraints(
              minWidth: 50,
              minHeight: 50,
            ),
      prefix: prefixWidget,
      suffixIcon: suffixIcon,
      suffixText: suffixText,
      suffixStyle: const TextStyle(color: Colors.grey),
      suffix: suffixWidget,
      hintStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: size.width * numD035,
        color: hintTextColor ?? Colors.grey,
      ),
      labelText: labelText,
      labelStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: textSize,
        color: Colors.black,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      fillColor: fillColor ?? CommonColors.textformfieldColor,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: borderWidth, color: borderColor),
        borderRadius: BorderRadius.circular(80),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 1.0),
        borderRadius: BorderRadius.circular(80),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 0),
        borderRadius: BorderRadius.circular(80),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 1.0),
        borderRadius: BorderRadius.circular(80),
      ),
    );
  }
}

/// Show Toast Message
Future<void> showToastMessage({
  required String message,
  required Color color,
}) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: color,
    textColor: Colors.white,
    fontSize: 14.0,
  );
}

/// ::::: Common App Bar :::::
AppBar commonAppBar({
  required Size size,
  required String appBarTitle,
  required bool showBackButton,
  required Function onTapBack,
}) {
  return AppBar(
    scrolledUnderElevation: 0.0,

    /// Back-button
    leading: Visibility(
      visible: showBackButton,
      child: IconButton(
        icon: Image(
          height: size.width * numD06,
          width: size.width * numD06,
          image: AssetImage(
            "${CommonPath.iconPath}/ic_back.png",
          ),
          color: CommonColors.whiteColor,
        ),
        onPressed: () {
          onTapBack();
        },
      ),
    ),

    /// Title
    title: CommonText(
        title: appBarTitle,
        fontSize: size.width * numD05,
        // color: CommonColors.themeColor,
        fontWeight: FontWeight.bold),
    centerTitle: true,
    automaticallyImplyLeading: false,
  );
}

/// ::::: Common BottomSheet Line :::::
Center bottomSheetLine(Size size) {
  return Center(
    child: Container(
      height: size.width * numD01,
      width: size.width * numD15,
      decoration: BoxDecoration(
        color: CommonColors.whiteColor,
        borderRadius: BorderRadius.circular(size.width * numD02),
      ),
      margin: EdgeInsets.only(bottom: size.width * numD05),
    ),
  );
}

/// ::::: Common Divider :::::
Widget commonDivider({Color color = Colors.grey}) {
  return Divider(
    color: color,
  );
}

/// ::::: Common Box Decoration :::::
BoxDecoration commonBoxDecoration({
  required Size size,
  Color borderColor = CommonColors.greyColor,
  double borderWidth = 1.0,
  double borderRadius = 0.0,
  Color boxShadowColor = CommonColors.greyColor,
  double boxShadowOpacity = 0.5,
  double blurRadius = 25.0,
}) {
  return BoxDecoration(
    border: Border.all(
      color: borderColor,
      width: borderWidth,
    ),
    borderRadius: BorderRadius.circular(size.width * borderRadius),
    boxShadow: [
      BoxShadow(
        color: boxShadowColor.withOpacity(boxShadowOpacity),
        blurRadius: blurRadius,
      ),
    ],
  );
}

/// ::::: Common Circular Progress Indicator :::::
Widget commonLoader({Color color = Colors.white}) {
  return const Center(
    child: SpinKitCircle(
      color: CommonColors.whiteColor,
      size: 50.0,
    ),
  );
}

/// Common Text button ::
Widget commonTextButton({
  required Function() onTap,
  required Size size,
  required String buttonText,
  double? radius,
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
}) {
  return TextButton(
      onPressed: () {
        onTap();
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
      ),
      child: CommonText(
        title: buttonText,
        fontSize: fontSize ?? size.width * numD03,
        fontWeight: fontWeight ?? FontWeight.w400,
        textAlign: TextAlign.center,
        color: color ?? CommonColors.whiteColor,
      ));
}

/// Common Shimmer Effect:
Widget commonShimmerEffect() {
  return Shimmer.fromColors(
    baseColor: CommonColors.appThemeColor.withOpacity(0.1),
    highlightColor: CommonColors.greyColor,
    child: Container(
      color: CommonColors.whiteColor,
    ),
  );
}

///:::::::::: COMMON DROP DOWN ::::::::::///
class CommonDropdown<T> extends StatelessWidget {
  final Size size;
  final List<T> items;
  final T? value;
  final String Function(T)? itemToString;
  final void Function(T?)? onChanged;
  final String hintText;

  const CommonDropdown({
    super.key,
    required this.size,
    required this.items,
    required this.value,
    required this.onChanged,
    this.itemToString,
    this.hintText = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CommonColors.whiteColor,
        borderRadius: BorderRadius.circular(size.width * numD015),
      ),
      child: DropdownButton<T>(
        isExpanded: true,
        value: value,
        onChanged: onChanged,
        style: TextStyle(
          fontFamily: CommonTextStyle.fontFamily,
          color: CommonColors.appThemeColor,
          fontSize: size.width * numD035,
        ),
        focusColor: CommonColors.whiteColor,
        dropdownColor: CommonColors.whiteColor,
        padding: EdgeInsets.only(left: size.width * numD03),
        items: items.map<DropdownMenuItem<T>>((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              itemToString != null ? itemToString!(item) : item.toString(),
              style: TextStyle(
                fontFamily: CommonTextStyle.fontFamily,
                color: CommonColors.appThemeColor,
                fontSize: size.width * numD035,
              ),
            ),
          );
        }).toList(),
        hint: Text(hintText),
      ),
    );
  }
}
