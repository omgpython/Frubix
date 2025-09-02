import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frubix/controller/admin.dart';
import 'package:frubix/custom/alert.dart';
import 'package:frubix/generated/pref_manager.dart';
import 'package:frubix/generated/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../generated/assets.dart';

bool expanded = true;

Widget AdminScaffold({
  required BuildContext context,
  required int index,
  required String appBarTitle,
  required Function() appBarClick,
  required List<Widget> widgets,
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
}) {
  PrefManager manager = PrefManager();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (manager.getAdminLoginStatus() == false) {
      context.go(Routes.adminLoginScreen);
    }
  });
  String adminRole = manager.getAdminRole();
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade900,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: NavigationRail(
          useIndicator: true,
          indicatorColor: Colors.amber.shade400,
          extended: expanded,
          backgroundColor: Colors.transparent,
          selectedIconTheme: IconThemeData(
            size: 28,
            color: Colors.blueGrey.shade900,
          ),
          unselectedIconTheme: IconThemeData(color: Colors.white70),
          selectedLabelTextStyle: GoogleFonts.rubik(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
          unselectedLabelTextStyle: GoogleFonts.rubik(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.white70,
          ),
          onDestinationSelected: (index) {
            switch (index) {
              case 0:
                context.pushReplacement(Routes.dashboardScreen);
                break;
              case 1:
                context.pushReplacement(Routes.adminCategoryScreen);
                break;
              case 2:
                context.pushReplacement(Routes.adminProductScreen);
                break;
              case 3:
                context.pushReplacement(Routes.adminPendingOrderScreen);
                break;
              case 4:
                context.pushReplacement(Routes.adminAssignedOrderScreen);
                break;
              case 5:
                context.pushReplacement(Routes.adminCompletedOrderScreen);
                break;
              case 6:
                if (adminRole == 'Super Admin' || adminRole == 'Admin') {
                  context.pushReplacement(Routes.adminUserScreen);
                } else {
                  Alert(
                    context: context,
                    message: 'You are not allow to access user data',
                    type: 'warning',
                  );
                }
                break;
              case 7:
                context.pushReplacement(Routes.adminScreen);
                break;
            }
          },
          leading: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      Assets.imagesFrubixLogoWithoutBackground,
                      height: 50,
                      width: 40,
                      fit: BoxFit.fill,
                    ),
                    // FlutterLogo(size: 40),
                    if (expanded) ...[
                      SizedBox(width: 10),
                      Text(
                        'FRUBIX',
                        style: GoogleFonts.rubik(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          destinations: [
            NavigationRailDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: Text('Dashboard'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.category_outlined),
              selectedIcon: Icon(Icons.category),
              label: Text('Category'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.store_outlined),
              selectedIcon: Icon(Icons.store),
              label: Text('Products'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.watch_later_outlined),
              selectedIcon: Icon(Icons.watch_later),
              label: Text('Pending Orders'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.assignment_ind_outlined),
              selectedIcon: Icon(Icons.assignment_ind),
              label: Text('Assigned Order'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.check_circle_outline),
              selectedIcon: Icon(Icons.check_circle),
              label: Text('Completed Order'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.groups_outlined),
              selectedIcon: Icon(Icons.groups),
              label: Text('Users'),
            ),
            if (adminRole == 'Super Admin')
              NavigationRailDestination(
                icon: Icon(Icons.security),
                label: Text('Admins'),
              ),
          ],
          trailing: Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  expanded
                      ? InkWell(
                        onTap: () {
                          _showAlertDialog(context: context, manager: manager);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 20,
                          children: [
                            Icon(Icons.logout, color: Colors.white70),
                            Text(
                              "Logout",
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 70),
                          ],
                        ),
                      )
                      : IconButton(
                        onPressed: () {
                          _showAlertDialog(context: context, manager: manager);
                        },
                        icon: Icon(Icons.logout, color: Colors.white70),
                      ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          selectedIndex: index,
        ),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        expanded = !expanded;
                        appBarClick();
                      },
                    ),
                    Text(
                      appBarTitle,
                      maxLines: 1,
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (appBarTitle != 'Profile') {
                          context.go(
                            Routes.adminProfileScreen.replaceFirst(
                              ':index',
                              index.toString(),
                            ),
                          );
                        }
                      },
                      child: FutureBuilder<Widget>(
                        future: Admin.getAdminPic(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircleAvatar(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return CircleAvatar(child: Icon(Icons.error));
                          } else {
                            return snapshot.data!;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: mainAxisAlignment,
                      crossAxisAlignment: crossAxisAlignment,
                      children: widgets,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

void _showAlertDialog({
  required BuildContext context,
  required PrefManager manager,
}) {
  showCupertinoDialog(
    context: context,
    builder:
        (context) => CupertinoAlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                manager.logoutAdmin();
                context.pushReplacement(Routes.adminLoginScreen);
              },
            ),
          ],
        ),
  );
}
