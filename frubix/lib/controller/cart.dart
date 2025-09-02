import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frubix/generated/collections.dart';
import 'package:frubix/generated/pref_manager.dart';

class Cart {
  static final manager = PrefManager();

  static Future<void> addToCart({
    required BuildContext context,
    required int amount,
    required int qty,
    required String prodId,
  }) async {
    try {
      final userId = manager.getUserId();
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection(CART_COLLECTION)
              .where(CART_USER_ID, isEqualTo: userId)
              .where(CART_PRODUCT_ID, isEqualTo: prodId)
              .where(CART_STATUS, isEqualTo: false)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final existingQty = doc[CART_QTY] as int;
        final newQty = existingQty + qty;
        final newTotalAmount = amount * newQty;

        await FirebaseFirestore.instance
            .collection(CART_COLLECTION)
            .doc(doc.id)
            .update({CART_QTY: newQty, CART_TOTAL_AMOUNT: newTotalAmount});
      } else {
        await FirebaseFirestore.instance.collection(CART_COLLECTION).add({
          CART_AMOUNT: amount,
          CART_ORDER_ID: '',
          CART_PRODUCT_ID: prodId,
          CART_QTY: qty,
          CART_STATUS: false,
          CART_TOTAL_AMOUNT: amount * qty,
          CART_USER_ID: userId,
        });
      }
    } catch (e) {
      log(e.toString(), name: 'ADD TO CART ERROR');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something Went Wrong')));
    }
  }

  static Future<void> updateQty({
    required BuildContext context,
    required String cartId,
    required int qty,
    required int amount,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(CART_COLLECTION)
          .doc(cartId)
          .update({CART_QTY: qty, CART_TOTAL_AMOUNT: amount * qty});
    } catch (e) {
      log(e.toString(), name: 'UPDATE QTY ERROR');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something Went Wrong')));
    }
  }

  static Future<void> deleteCart({
    required BuildContext context,
    required String cartId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(CART_COLLECTION)
          .doc(cartId)
          .delete();
    } catch (e) {
      log(e.toString(), name: 'CART DELETE ERROR');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something Went Wrong')));
    }
  }
}
