import 'package:cubit_movie_app/utils/common_strings.dart';
import 'package:cubit_movie_app/utils/common_utils.dart';
import 'package:cubit_movie_app/utils/custom_bottom_navbar.dart';
import 'package:cubit_movie_app/view/categories/categories_screen.dart';
import 'package:cubit_movie_app/view/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: getBodyDashboard(),
      bottomNavigationBar: CustomBottomBar(
        selectedColorOpacity: 1,
        backgroundColor: CommonColors.greyColor.withOpacity(0.4),
        selectedItemColor: CommonColors.appThemeColor,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Image.asset(
              "${CommonPath.iconPath}/ic_home.png",
              height: size.height * numD04,
            ),
            title: const Text(
              "Home",
              style: TextStyle(color: Colors.white),
            ),
            selectedColor: CommonColors.appThemeColor,
          ),

          /// Category
          SalomonBottomBarItem(
            icon: Image.asset(
              "${CommonPath.iconPath}/ic_category.png",
              height: size.height * numD04,
            ),
            title: const Text(
              "Categories",
              style: TextStyle(color: Colors.white),
            ),
            selectedColor: CommonColors.appThemeColor,
          ),
        ],
      ),
    );
  }

  Widget getBodyDashboard() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return CategoriesScreen();
      default:
        return HomeScreen();
    }
  }
}
