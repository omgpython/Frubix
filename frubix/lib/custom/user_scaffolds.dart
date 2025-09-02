import 'package:advanced_salomon_bottom_bar/advanced_salomon_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../generated/pref_manager.dart';
import '../generated/routes.dart';

Widget UserBottomNavScaffold({
  required BuildContext context,
  required String appBarTitle,
  bool centerTitle = true,
  required int index,
  required Widget body,
}) {
  final PrefManager manager = PrefManager();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!manager.getUserLoginStatus()) {
      context.pushReplacement(Routes.userLoginScreen);
    }
  });

  return Scaffold(
    appBar: AppBar(
      title: Text(
        appBarTitle,
        style: GoogleFonts.rubik(fontWeight: FontWeight.bold),
      ),
      centerTitle: centerTitle,
      actions: [IconButton(icon: Icon(Icons.logout), onPressed: () {})],
    ),
    body: body,
    bottomNavigationBar: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -1),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: AdvancedSalomonBottomBar(
          currentIndex: index,
          onTap: (i) {
            switch (i) {
              case 0:
                context.pushReplacement(Routes.homeScreen);
                break;
              case 1:
                context.pushReplacement(Routes.userCartScreen);
                break;
              case 2:
                context.pushReplacement(Routes.userProfileScreen);
                break;
            }
          },
          curve: Curves.easeInOut,
          duration: Duration(milliseconds: 300),
          items: [
            AdvancedSalomonBottomBarItem(
              icon: Icon(Icons.home_outlined),
              title: Text('Home'),
              selectedColor: Colors.deepPurple,
              unselectedColor: Colors.grey,
            ),
            AdvancedSalomonBottomBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              title: Text('Cart'),
              selectedColor: Colors.deepPurple,
              unselectedColor: Colors.grey,
            ),
            AdvancedSalomonBottomBarItem(
              icon: Icon(Icons.person_outline),
              title: Text('Profile'),
              selectedColor: Colors.deepPurple,
              unselectedColor: Colors.grey,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget CustomScaffold({
  required BuildContext context,
  required String appBarTitle,
  bool centerTitle = true,
  required Widget body,
}) {
  PrefManager manager = PrefManager();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (manager.getUserLoginStatus() == false) {
      context.pushReplacement(Routes.userLoginScreen);
    }
  });

  return Scaffold(
    appBar: AppBar(
      title: Text(
        appBarTitle,
        style: GoogleFonts.rubik(fontWeight: FontWeight.bold),
      ),
      centerTitle: centerTitle,
    ),
    body: body,
  );
}
