import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../custom/alert.dart';
import '../generated/collections.dart';
import '../generated/routes.dart';

class Category {
  static Future<void> addCategory({
    required BuildContext context,
    required String name,
    required String pic,
  }) async {
    try {
      await FirebaseFirestore.instance.collection(CATEGORY_COLLECTION).add({
        CATEGORY_NAME: name,
        CATEGORY_PIC: pic,
      });
      Alert(context: context, message: 'Category Added', type: 'success');
    } catch (e) {
      Alert(context: context, message: e.toString(), type: 'error');
    }
  }

  static Future<void> deleteCategory({
    required BuildContext context,
    required String id,
  }) async {
    await FirebaseFirestore.instance
        .collection(CATEGORY_COLLECTION)
        .doc(id)
        .delete();
    Alert(context: context, message: 'Category Deleted', type: 'success');
  }

  static Future<Map<String, dynamic>> getCategoryById({
    required BuildContext context,
    required String id,
  }) {
    return FirebaseFirestore.instance
        .collection(CATEGORY_COLLECTION)
        .doc(id)
        .get()
        .then((doc) {
          if (doc.exists) {
            return doc.data() as Map<String, dynamic>;
          } else {
            context.pushReplacement(Routes.adminCategoryScreen);
            throw Exception('Category not found');
          }
        });
  }

  static Future<void> editCategory({
    required BuildContext context,
    required String id,
    required String name,
    required String pic,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(CATEGORY_COLLECTION)
          .doc(id)
          .update({CATEGORY_NAME: name, CATEGORY_PIC: pic});
      Alert(context: context, message: 'Category Updated', type: 'success');
    } catch (e) {
      Alert(context: context, message: e.toString(), type: 'error');
    }
  }
}
