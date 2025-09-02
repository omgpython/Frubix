import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:frubix/custom/alert.dart';
import 'package:frubix/generated/collections.dart';
import 'package:go_router/go_router.dart';

import '../generated/routes.dart';

class Product {
  static Future<List<Map<String, dynamic>>> fetchCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection(CATEGORY_COLLECTION).get();

    return snapshot.docs.map((doc) {
      return {'id': doc.id, 'name': doc[CATEGORY_NAME]};
    }).toList();
  }

  static Future<void> addProduct({
    required BuildContext context,
    required String name,
    required int price,
    required String catId,
    required String unit,
    required String description,
    required String pic,
  }) async {
    await FirebaseFirestore.instance.collection(PRODUCT_COLLECTION).add({
      PRODUCT_NAME: name,
      PRODUCT_PRICE: price,
      PRODUCT_CATEGORY: catId,
      PRODUCT_UNIT: unit,
      PRODUCT_DESCRIPTION: description,
      PRODUCT_PIC: pic,
    });
    Alert(context: context, message: 'Product Added', type: 'success');
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
            context.pushReplacement(Routes.adminProductScreen);
            throw Exception('Category not found');
          }
        });
  }

  static Future<void> editProduct({
    required BuildContext context,
    required String id,
    required String name,
    required int price,
    required String catId,
    required String unit,
    required String description,
    required String pic,
  }) async {
    await FirebaseFirestore.instance
        .collection(PRODUCT_COLLECTION)
        .doc(id)
        .update({
          PRODUCT_NAME: name,
          PRODUCT_PRICE: price,
          PRODUCT_CATEGORY: catId,
          PRODUCT_UNIT: unit,
          PRODUCT_DESCRIPTION: description,
          PRODUCT_PIC: pic,
        });
    Alert(context: context, message: 'Product Updated', type: 'success');
  }

  static Future<void> deleteProduct({
    required BuildContext context,
    required String id,
  }) async {
    await FirebaseFirestore.instance
        .collection(PRODUCT_COLLECTION)
        .doc(id)
        .delete();
    Alert(context: context, message: 'Product Deleted', type: 'success');
  }
}
