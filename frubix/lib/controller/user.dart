import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frubix/generated/collections.dart';
import 'package:go_router/go_router.dart';

import '../generated/notification_service.dart';
import '../generated/pref_manager.dart';
import '../generated/routes.dart';

class User {
  static PrefManager manager = PrefManager();

  static Future<void> addUser({
    required BuildContext context,
    required String name,
    required String email,
    required String contact,
    required String password,
  }) async {
    try {
      var emailData =
          await FirebaseFirestore.instance
              .collection(USER_COLLECTION)
              .where(USER_EMAIL, isEqualTo: email)
              .get();

      if (emailData.docs.isEmpty) {
        var contactData =
            await FirebaseFirestore.instance
                .collection(USER_COLLECTION)
                .where(USER_CONTACT, isEqualTo: contact)
                .get();

        if (contactData.docs.isEmpty) {
          await FirebaseFirestore.instance.collection(USER_COLLECTION).add({
            USER_NAME: name,
            USER_EMAIL: email,
            USER_CONTACT: contact,
            USER_PASSWORD: password,
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Account Created')));
          context.pop();
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Contact Already Exist')));
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Email Already Exist')));
      }
    } catch (e) {
      log(e.toString(), name: 'ADMIN ADD ERROR');
    }
  }

  static Future<void> userLogin({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final data =
        await FirebaseFirestore.instance
            .collection(USER_COLLECTION)
            .where(USER_EMAIL, isEqualTo: email)
            .where(USER_PASSWORD, isEqualTo: password)
            .limit(1)
            .get();

    if (data.docs.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid Email or Password')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login Success')));
      var user = data.docs.first;
      manager.saveUser(
        userId: user.id,
        contact: user[USER_CONTACT],
        name: user[USER_NAME],
      );

      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await FirebaseFirestore.instance.collection(FCM_COLLECTION).add({
          FCM_TOKEN: token,
          FCM_USER_ID: user.id,
        });
        log(token, name: 'FCM TOKEN');
      }
      await NotificationService.initialize();
      context.go(Routes.homeScreen);
    }
  }
}
