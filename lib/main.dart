import 'dart:async';
import 'package:cubit_movie_app/utils/common_utils.dart';
import 'package:cubit_movie_app/view/bottom_navbar/bottom_navbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: CommonTextStyle.fontFamily,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: CommonColors.appThemeColor)
            .copyWith(background: CommonColors.appThemeColor),
        appBarTheme: const AppBarTheme(
          backgroundColor: CommonColors.appThemeColor,
        ),
      ),
      home: const BottomNavBarScreen(),
    );
  }
}
