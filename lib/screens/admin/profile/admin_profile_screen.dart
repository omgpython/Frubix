import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frubix/controller/admin.dart';
import 'package:frubix/custom/admin_scaffold.dart';
import 'package:frubix/generated/assets.dart';
import 'package:frubix/generated/collections.dart';
import 'package:frubix/generated/pref_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../generated/routes.dart';

class AdminProfileScreen extends StatefulWidget {
  String index;
  AdminProfileScreen({super.key, required this.index});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final manager = PrefManager();

  String email = '', mobNo = '', name = '', pic = '', role = '';
  bool isLoading = true;

  @override
  void initState() {
    setData(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // int index = int.parse(widget.index);
    return Scaffold(
      body: AdminScaffold(
        context: context,
        index: 0,
        appBarTitle: 'Profile',
        appBarClick: () => setState(() {}),
        widgets: [
          Container(
            width: MediaQuery.of(context).size.width * .7,
            height: MediaQuery.of(context).size.height * .7,
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 50)],
            ),
            child:
                isLoading
                    ? Center(child: Lottie.asset(Assets.animLoading))
                    : Row(
                      spacing: 20,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              pic != 'NONE'
                                  ? CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: MemoryImage(
                                      base64Decode(pic),
                                    ),
                                  )
                                  : CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.blue.shade700,
                                    child: Text(
                                      name[0].toUpperCase(),
                                      style: GoogleFonts.rubik(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              SizedBox(height: 30),
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * .2,
                                child: FilledButton(
                                  onPressed: () {
                                    context.go(
                                      Routes.adminEditProfileScreen
                                          .replaceFirst(':index', widget.index),
                                    );
                                    // context.go(Routes.adminProductScreen);
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.blue.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(width: 5),
                                        Text('Edit Profile'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * .2,
                                child: FilledButton(
                                  onPressed: () {},
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.amber.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.vpn_key),
                                        SizedBox(width: 5),
                                        Text('Change Password'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * .2,
                                child: FilledButton(
                                  onPressed: () {
                                    _showAlertDialog(
                                      context: context,
                                      manager: manager,
                                    );
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.logout),
                                        SizedBox(width: 5),
                                        Text('Logout'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              spacing: 10,
                              children: [
                                Row(
                                  spacing: 12,
                                  children: [
                                    Text(
                                      'Name :',
                                      style: GoogleFonts.rubik(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        name,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.rubik(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 12,
                                  children: [
                                    Text(
                                      'Email :',
                                      style: GoogleFonts.rubik(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        email,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.rubik(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 12,
                                  children: [
                                    Text(
                                      'Contact Number :',
                                      style: GoogleFonts.rubik(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        mobNo,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.rubik(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 12,
                                  children: [
                                    Text(
                                      'Role :',
                                      style: GoogleFonts.rubik(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        role,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.rubik(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  Future<void> setData({required BuildContext context}) async {
    Map<String, dynamic> admin = await Admin.getAdminById(
      context: context,
      id: manager.getAdminId(),
    );
    pic = admin[ADMIN_PIC];
    email = admin[ADMIN_EMAIL];
    mobNo = admin[ADMIN_CONTACT];
    name = admin[ADMIN_NAME];
    role = admin[ADMIN_ROLE];

    setState(() {
      isLoading = false;
    });
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
}
