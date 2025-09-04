import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frubix/custom/user_scaffolds.dart';
import 'package:frubix/generated/assets.dart';
import 'package:frubix/generated/collections.dart';
import 'package:frubix/generated/pref_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../generated/routes.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final manager = PrefManager();

  @override
  Widget build(BuildContext context) {
    return UserBottomNavScaffold(
      context: context,
      appBarTitle: 'Profile',
      index: 2,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(Assets.imagesUser),
              ),
              SizedBox(height: 16),

              // User Info StreamBuilder
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance
                        .collection(USER_COLLECTION)
                        .where(
                          FieldPath.documentId,
                          isEqualTo: manager.getUserId(),
                        )
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Shimmer for loading state
                    return Shimmer(
                      duration: Duration(seconds: 2),
                      color: Colors.black,
                      colorOpacity: 0,
                      enabled: true,
                      child: Column(
                        children: [
                          Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width * .5,
                            color: Colors.grey.shade300,
                            margin: EdgeInsets.symmetric(vertical: 8),
                          ),
                          Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width * .5,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text("No user data found.");
                  }

                  final user = snapshot.data!.docs.first.data();

                  // User info rows directly in build
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_outline, color: Colors.purple),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              user[USER_NAME],
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email_outlined, color: Colors.purple),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              user[USER_EMAIL],
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: 24),

              // Edit Profile Button
              SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width * 0.5,
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Edit Profile'),
                ),
              ),

              SizedBox(height: 32),

              // Section titles and list tiles directly in build
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Account',
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              customListTile(
                leading: Icons.shopping_cart_outlined,
                title: 'My Orders',
                onTap: () {
                  context.push(Routes.userOrderScreen);
                },
              ),

              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Support',
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              customListTile(
                leading: Icons.support_agent,
                title: 'Contact Us',
                onTap: () {
                  context.push(Routes.userContactUsScreen);
                },
              ),
              customListTile(
                leading: Icons.help_outline,
                title: 'About Us',
                onTap: () {
                  context.push(Routes.userAboutUsScreen);
                },
              ),
              customListTile(
                leading: Icons.question_answer_outlined,
                title: 'FAQs',
                onTap: () {
                  context.push(Routes.userFaqScreen);
                },
              ),

              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Legal',
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              customListTile(
                leading: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {
                  context.push(Routes.userPrivacyPolicyScreen);
                },
              ),
              customListTile(
                leading: Icons.article_outlined,
                title: 'Terms & Conditions',
                onTap: () {
                  context.push(Routes.userTermsScreen);
                },
              ),

              SizedBox(height: 30),

              // Logout button
              customListTile(
                leading: Icons.logout,
                title: 'Logout',
                cardColor: Colors.red,
                iconColor: Colors.white,
                textColor: Colors.white,
                onTap: () {
                  showLogoutDialog(context: context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customListTile({
    required IconData leading,
    required String title,
    required Function() onTap,
    Color cardColor = Colors.white,
    Color iconColor = Colors.black,
    Color textColor = Colors.black,
  }) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 6),
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(leading, color: iconColor, size: 28),
        title: Text(
          title,
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: textColor,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, color: iconColor),
        onTap: onTap,
      ),
    );
  }

  void showLogoutDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              child: Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                manager.logoutUser().then(
                  (_) => context.pushReplacement(Routes.userLoginScreen),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
