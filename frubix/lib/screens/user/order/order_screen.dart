import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frubix/custom/user_scaffolds.dart';
import 'package:frubix/generated/collections.dart';
import 'package:frubix/generated/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../generated/assets.dart';
import '../../../generated/pref_manager.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final manager = PrefManager();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      appBarTitle: 'Orders',
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection(ORDER_COLLECTION)
                .where(ORDER_USER_ID, isEqualTo: manager.getUserId())
                .snapshots(),
        builder: (context, orderSnapshot) {
          if (orderSnapshot.hasError) {
            return Center(child: Text('Error: ${orderSnapshot.error}'));
          }

          if (orderSnapshot.connectionState == ConnectionState.waiting) {
            return Shimmer(
              duration: const Duration(seconds: 2),
              color: Colors.black,
              colorOpacity: 0,
              enabled: true,
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    title: Container(
                      height: 20,
                      width: 100,
                      color: Colors.grey.shade300,
                    ),
                    subtitle: Container(
                      height: 10,
                      width: 80,
                      color: Colors.grey.shade300,
                    ),
                  );
                },
              ),
            );
          }

          final orders = orderSnapshot.data!.docs;

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(Assets.animEmpty),
                  const SizedBox(height: 16),
                  const Text('No Orders'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final orderId = order[ORDER_ID];
              final orderDate = order[ORDER_DATE] ?? 'Unknown Date';

              return StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection(CART_COLLECTION)
                        .where(CART_ORDER_ID, isEqualTo: orderId)
                        .snapshots(),
                builder: (context, cartSnapshot) {
                  if (cartSnapshot.hasError || !cartSnapshot.hasData) {
                    return const SizedBox();
                  }

                  final cartItems = cartSnapshot.data!.docs;

                  if (cartItems.isEmpty) return const SizedBox();

                  final firstCart = cartItems[0].data() as Map<String, dynamic>;
                  final firstProductId = firstCart[CART_PRODUCT_ID];
                  final extraCount = cartItems.length - 1;

                  return StreamBuilder<DocumentSnapshot>(
                    stream:
                        FirebaseFirestore.instance
                            .collection(PRODUCT_COLLECTION)
                            .doc(firstProductId)
                            .snapshots(),
                    builder: (context, productSnapshot) {
                      if (productSnapshot.hasError ||
                          !productSnapshot.hasData ||
                          !productSnapshot.data!.exists) {
                        return const SizedBox();
                      }

                      final product =
                          productSnapshot.data!.data() as Map<String, dynamic>;
                      final productName = product[PRODUCT_NAME] ?? 'Unnamed';
                      final productPic = product[PRODUCT_PIC] ?? '';

                      return ListTile(
                        onTap: () {
                          context.push(
                            Routes.userOrderDetailsScreen.replaceFirst(
                              ':id',
                              orders[index].id,
                            ),
                          );
                        },
                        leading:
                            productPic.isNotEmpty
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    base64Decode(productPic),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                        title: Text(
                          extraCount > 0
                              ? '$productName + $extraCount more'
                              : productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.rubik(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          orderDate,
                          style: GoogleFonts.courierPrime(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: CircleAvatar(
                          radius: 5,
                          backgroundColor:
                              order[ORDER_STATUS] == 0
                                  ? Colors.amber
                                  : order[ORDER_STATUS] == 1
                                  ? Colors.blue
                                  : Colors.green,
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
