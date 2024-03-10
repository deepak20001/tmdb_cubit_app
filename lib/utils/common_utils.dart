import 'package:flutter/material.dart';
import '../main.dart';

///:::::::::: COMMON COLORS ::::::::::///
class CommonColors {
  static const Color appThemeColor = Color(0xFF242A32);
  static const Color textformfieldColor = Color(0xFF3A3F47);
  static const Color whiteColor = Colors.white;
  static const Color greyColor = Colors.grey;
  static const Color redColor = Colors.red;
  static const Color transparentColor = Colors.transparent;
  static const Color orangeColor = Colors.orange;
}

///  :::::::::: Text Style :::::::::
class CommonTextStyle {
  static const String fontFamily = "Poppins";
}

///  :::::::::: IMAGE & ICONS PATHS :::::::::
class CommonPath {
  static String imagePath = "assets/images";
  static String iconPath = "assets/icons";
  static String itemImagePath = "https://image.tmdb.org/t/p/original";
  static String animationPath = "assets/animations";
}

///  :::::::::: Pref Keys :::::::::
class PreferenceKeys {
  static String isLoginKey = "isLoginKey";
  static String tokenKey = "tokenKey";
  static String headerKey = "Authorization";
}

///  :::::::::: Colorful Logger :::::::::
enum Logger {
  Black("30"),
  Red("31"),
  Green("32"),
  Yellow("33"),
  Blue("34"),
  Magenta("35"),
  Cyan("36"),
  White("37");

  final String code;
  const Logger(this.code);

  void log(dynamic text) =>
      print('\x1B[' + code + 'm' + text.toString() + '\x1B[0m');
}

void errorLog(dynamic text) => Logger.Red.log(text);
void successLog(dynamic text) => Logger.Green.log(text);
void printDataLog(dynamic text) => Logger.Yellow.log(text);
void testingLog(dynamic text) => Logger.White.log(text);

/// Routes Class
class Routes {
  static Routes instance = Routes();

  Future<dynamic> push(
      {required Widget widget, required BuildContext context}) {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => widget));
  }

  Future<dynamic> pushReplacement(
      {required Widget widget, required BuildContext context}) {
    return Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => widget));
  }

  Future<dynamic> pushAndRemoveUntil(
      {required Widget widget, required BuildContext context}) {
    return Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => widget), (route) => false);
  }
}
