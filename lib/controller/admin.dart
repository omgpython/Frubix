import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frubix/custom/alert.dart';
import 'package:frubix/generated/collections.dart';
import 'package:frubix/generated/pref_manager.dart';
import 'package:frubix/generated/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class Admin {
  static PrefManager manager = PrefManager();

  static Future<void> adminLogin({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final data =
        await FirebaseFirestore.instance
            .collection(ADMIN_COLLECTION)
            .where(ADMIN_EMAIL, isEqualTo: email)
            .where(ADMIN_PASSWORD, isEqualTo: password)
            .limit(1)
            .get();

    if (data.docs.isEmpty) {
      Alert(
        context: context,
        message: 'Invalid Email or Password',
        type: 'error',
      );
    } else {
      Alert(context: context, message: 'Login Success', type: 'success');
      var admin = data.docs.first;
      manager.saveAdmin(adminId: admin.id, adminRole: admin[ADMIN_ROLE]);
      context.go(Routes.dashboardScreen);
    }
  }

  static Future<Widget> getAdminPic() async {
    String pic = '';
    String id = manager.getAdminId();

    try {
      var data =
          await FirebaseFirestore.instance
              .collection(ADMIN_COLLECTION)
              .doc(id)
              .get();

      var admin = data.data() as Map<String, dynamic>;
      pic = admin[ADMIN_PIC] as String;

      if (pic != 'NONE') {
        return CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: MemoryImage(base64Decode(pic)),
        );
      } else {
        String name = admin[ADMIN_NAME] as String;
        return CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            name[0].toUpperCase(),
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        );
      }
    } catch (e) {
      return CircleAvatar(
        backgroundColor: Colors.grey,
        child: Icon(Icons.error),
      );
    }
  }

  static Future<void> addAdmin({
    required BuildContext context,
    required String name,
    required String email,
    required String contact,
    required String password,
    required String role,
    required String pic,
  }) async {
    try {
      var emailData =
          await FirebaseFirestore.instance
              .collection(ADMIN_COLLECTION)
              .where(ADMIN_EMAIL, isEqualTo: email)
              .get();

      if (emailData.docs.isEmpty) {
        var contactData =
            await FirebaseFirestore.instance
                .collection(ADMIN_COLLECTION)
                .where(ADMIN_CONTACT, isEqualTo: contact)
                .get();

        if (contactData.docs.isEmpty) {
          FirebaseFirestore.instance.collection(ADMIN_COLLECTION).add({
            ADMIN_NAME: name,
            ADMIN_EMAIL: email,
            ADMIN_CONTACT: contact,
            ADMIN_PASSWORD: password,
            ADMIN_ROLE: role,
            ADMIN_PIC: pic,
          });
          Alert(context: context, message: 'Admin Added', type: 'success');
        } else {
          Alert(
            context: context,
            message: 'Contact Already Exist',
            type: 'error',
          );
        }
      } else {
        Alert(context: context, message: 'Email Already Exist', type: 'error');
      }
    } catch (e) {
      log(e.toString(), name: 'ADMIN ADD ERROR');
    }
  }

  static Future<void> deleteAdmin({
    required BuildContext context,
    required String id,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(ADMIN_COLLECTION)
          .doc(id)
          .delete();
      Alert(context: context, message: 'Admin Deleted', type: 'Success');
    } catch (e) {
      log(e.toString(), name: 'ADMIN DELETE ERROR');
    }
  }

  static Future<Map<String, dynamic>> getAdminById({
    required BuildContext context,
    required String id,
  }) {
    return FirebaseFirestore.instance
        .collection(ADMIN_COLLECTION)
        .doc(id)
        .get()
        .then((doc) {
          if (doc.exists) {
            return doc.data() as Map<String, dynamic>;
          } else {
            context.pushReplacement(Routes.dashboardScreen);
            throw Exception('Admin not found');
          }
        });
  }

  static Future<void> editAdmin({
    required BuildContext context,
    required String originalEmail,
    required String originalContact,
    required String id,
    required String name,
    required String email,
    required String contact,
    required String role,
    required String pic,
  }) async {
    try {
      bool canProceed = true;

      // Check if email changed and is unique
      if (originalEmail != email) {
        var emailData =
            await FirebaseFirestore.instance
                .collection(ADMIN_COLLECTION)
                .where(ADMIN_EMAIL, isEqualTo: email)
                .get();

        if (emailData.docs.isNotEmpty) {
          canProceed = false;
          Alert(
            context: context,
            message: 'Email Already Exist',
            type: 'error',
          );
        }
      }

      // Check if contact changed and is unique
      if (canProceed && originalContact != contact) {
        var contactData =
            await FirebaseFirestore.instance
                .collection(ADMIN_COLLECTION)
                .where(ADMIN_CONTACT, isEqualTo: contact)
                .get();

        if (contactData.docs.isNotEmpty) {
          canProceed = false;
          Alert(
            context: context,
            message: 'Contact Already Exist',
            type: 'error',
          );
        }
      }

      // Update if no conflicts
      if (canProceed) {
        await FirebaseFirestore.instance
            .collection(ADMIN_COLLECTION)
            .doc(id)
            .update({
              ADMIN_NAME: name,
              ADMIN_EMAIL: email,
              ADMIN_CONTACT: contact,
              ADMIN_ROLE: role,
              ADMIN_PIC: pic,
            });

        Alert(context: context, message: 'Admin Updated', type: 'success');

        context.pushReplacement(Routes.adminScreen);
      }
    } catch (e) {
      log(e.toString(), name: 'ADMIN EDIT ERROR');
      Alert(
        context: context,
        message: 'Something went wrong. Please try again.',
        type: 'error',
      );
    }
  }

  static Future<void> editAdminProfile({
    required BuildContext context,
    required String originalEmail,
    required String originalContact,
    required String id,
    required String name,
    required String email,
    required String contact,
    required String pic,
  }) async {
    try {
      bool canProceed = true;

      // If email changed, check if new email exists
      if (originalEmail != email) {
        var emailData =
            await FirebaseFirestore.instance
                .collection(ADMIN_COLLECTION)
                .where(ADMIN_EMAIL, isEqualTo: email)
                .get();

        if (emailData.docs.isNotEmpty) {
          canProceed = false;
          Alert(
            context: context,
            message: 'Email already exists',
            type: 'error',
          );
        }
      }

      // If contact changed, check if new contact exists
      if (canProceed && originalContact != contact) {
        var contactData =
            await FirebaseFirestore.instance
                .collection(ADMIN_COLLECTION)
                .where(ADMIN_CONTACT, isEqualTo: contact)
                .get();

        if (contactData.docs.isNotEmpty) {
          canProceed = false;
          Alert(
            context: context,
            message: 'Contact already exists',
            type: 'error',
          );
        }
      }

      // If no conflict found, update profile
      if (canProceed) {
        await FirebaseFirestore.instance
            .collection(ADMIN_COLLECTION)
            .doc(id)
            .update({
              ADMIN_NAME: name,
              ADMIN_EMAIL: email,
              ADMIN_CONTACT: contact,
              ADMIN_PIC: pic,
            });

        Alert(context: context, message: 'Profile updated', type: 'success');
        context.go(Routes.dashboardScreen);
      }
    } catch (e) {
      log(e.toString(), name: 'ADMIN EDIT PROFILE ERROR');
      Alert(
        context: context,
        message: 'Something went wrong. Try again.',
        type: 'error',
      );
    }
  }
}
