import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:frubix/generated/pref_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../custom/alert.dart';
import '../custom/send_notification.dart';
import '../generated/collections.dart';
import '../generated/routes.dart';

class Booking {
  static final manager = PrefManager();

  static String getCurrentDateTime() {
    return DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());
  }

  static String generateOrderId() {
    final uuid = Uuid();
    return uuid.v1();
  }

  static Future<void> confirmOrder({
    required BuildContext context,
    required int subTotal,
    required int shipCharge,
    required int handleCharge,
    required int total,
    required String payMode,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final orderId = generateOrderId();
    await firestore
        .collection(ORDER_COLLECTION)
        .add({
          ORDER_ID: orderId,
          ORDER_USER_ID: manager.getUserId(),
          ORDER_USER_NAME: manager.getUserName(),
          ORDER_USER_CONTACT: manager.getUserContact(),
          ORDER_STATUS: 0,
          ORDER_DATE: getCurrentDateTime(),
          ORDER_DELIVERY_DATE: 'N/A',
          ORDER_SUB_TOTAL: subTotal,
          ORDER_DELIVERY_CHARGE: shipCharge,
          ORDER_HANDLING_CHARGE: handleCharge,
          ORDER_TOTAL: total,
          ORDER_PAY_MODE: payMode,
          ORDER_ADDRESS: manager.getAddress(),
          ORDER_ADDRESS_DIGIPIN:
              manager.getDigiPin().trim().isNotEmpty
                  ? manager.getDigiPin()
                  : 'N/A',
          ORDER_DELIVERY_BOY: 'N/A',
        })
        .then((value) async {
          WriteBatch batch = firestore.batch();
          final querySnapshot =
              await firestore
                  .collection(CART_COLLECTION)
                  .where(CART_USER_ID, isEqualTo: manager.getUserId())
                  .where(CART_STATUS, isEqualTo: false)
                  .get();

          for (var doc in querySnapshot.docs) {
            batch.update(doc.reference, {
              CART_STATUS: true,
              CART_ORDER_ID: orderId,
            });
          }
          await batch.commit();
          await sendNotifications(
            userId: manager.getUserId(),
            notificationTitle: "Order Confirmed ✅",
            notificationBody:
                "Your order has been successfully placed. We'll notify you once it's out for delivery.",
          );
        });
  }

  static Future<void> assignOrder({
    required BuildContext context,
    required String id,
    required String userId,
    required String deliveryBoy,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(ORDER_COLLECTION)
          .doc(id)
          .update({ORDER_DELIVERY_BOY: deliveryBoy, ORDER_STATUS: 1})
          .then((value) async {
            await sendNotifications(
              userId: userId,
              notificationTitle: 'Your Order is on the Way!',
              notificationBody:
                  '"$deliveryBoy" is heading out with your order now',
            );
            Alert(context: context, message: 'Order Assigned', type: 'success');
          });
    } catch (e) {
      log(e.toString(), name: 'ORDER ASSIGN ERROR');
      Alert(context: context, message: e.toString(), type: 'error');
    }
  }

  static Future<void> completeOrder({
    required BuildContext context,
    required String id,
    required String userId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(ORDER_COLLECTION)
          .doc(id)
          .update({ORDER_STATUS: 2, ORDER_DELIVERY_DATE: getCurrentDateTime()})
          .then((value) async {
            await sendNotifications(
              userId: userId,
              notificationTitle: 'Your Order Has Been Delivered! 🎉',
              notificationBody:
                  'Hey! Your order just landed at your doorstep. Enjoy it, and thank you for choosing us!',
            );
            Alert(context: context, message: 'Order Assigned', type: 'success');
          });
    } catch (e) {
      log(e.toString(), name: 'ORDER COMPLETE ERROR');
      Alert(context: context, message: e.toString(), type: 'error');
    }
  }

  static Future<Map<String, dynamic>> getOrderById({
    required BuildContext context,
    required String id,
  }) {
    return FirebaseFirestore.instance
        .collection(ORDER_COLLECTION)
        .doc(id)
        .get()
        .then((doc) {
          if (doc.exists) {
            return doc.data() as Map<String, dynamic>;
          } else {
            context.pushReplacement(Routes.dashboardScreen);
            throw Exception('Order not found');
          }
        });
  }

  static Future<List<Map<String, dynamic>>> getCartByOrderId({
    required BuildContext context,
    required String orderId,
  }) async {
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection(CART_COLLECTION)
            .where(CART_ORDER_ID, isEqualTo: orderId)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } else {
      context.pushReplacement(Routes.dashboardScreen);
      throw Exception('No cart items found for this order.');
    }
  }

  static Future<Map<String, dynamic>> getProductById({
    required BuildContext context,
    required String id,
  }) {
    return FirebaseFirestore.instance
        .collection(PRODUCT_COLLECTION)
        .doc(id)
        .get()
        .then((doc) {
          if (doc.exists) {
            return doc.data() as Map<String, dynamic>;
          } else {
            context.pushReplacement(Routes.dashboardScreen);
            throw Exception('Product not found');
          }
        });
  }
}
