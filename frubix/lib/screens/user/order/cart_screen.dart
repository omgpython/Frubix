import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frubix/custom/user_scaffolds.dart';
import 'package:frubix/generated/pref_manager.dart';
import 'package:frubix/generated/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../controller/cart.dart';
import '../../../generated/assets.dart';
import '../../../generated/collections.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final manager = PrefManager();
  int total = 0;

  @override
  Widget build(BuildContext context) {
    return UserBottomNavScaffold(
      context: context,
      appBarTitle: 'Cart',
      index: 1,
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection(CART_COLLECTION)
                .where(CART_USER_ID, isEqualTo: manager.getUserId())
                .where(CART_STATUS, isEqualTo: false)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Lottie.asset(Assets.animLoading));
          }

          if (snapshot.data!.docs.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(Assets.animEmptyCart),
                Text(
                  'Cart is Empty !!!',
                  style: GoogleFonts.rubik(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          }

          final data = snapshot.data!.docs;

          // Calculate total for the banner
          int totalAmount = 0;
          for (var doc in data) {
            totalAmount += (doc[CART_TOTAL_AMOUNT] as num).toInt();
          }

          return Column(
            children: [
              // Free delivery banner
              if (totalAmount < 499)
                Container(
                  width: double.infinity,
                  color: Colors.orange.shade50,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.local_shipping, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Add ₹${499 - totalAmount} more for free delivery!',
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.orange.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  color: Colors.green.shade50,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '🎉 You’re eligible for free delivery!',
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Cart item list
              Expanded(
                child: ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final cart = data[index];
                    return StreamBuilder(
                      stream:
                          FirebaseFirestore.instance
                              .collection(PRODUCT_COLLECTION)
                              .doc(cart[CART_PRODUCT_ID])
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Shimmer(
                            duration: Duration(seconds: 3),
                            interval: Duration(seconds: 0),
                            color: Colors.black,
                            colorOpacity: 0,
                            enabled: true,
                            direction: ShimmerDirection.fromLTRB(),
                            child: ListTile(
                              leading: Container(
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              title: Container(
                                height: 12,
                                color: Colors.grey.shade300,
                              ),
                              subtitle: Container(
                                height: 12,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          );
                        }
                        final product = snapshot.data!.data();
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image.memory(
                              base64Decode(product![PRODUCT_PIC]),
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            product[PRODUCT_NAME],
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${cart[CART_AMOUNT]} X ${cart[CART_QTY]} = ${cart[CART_TOTAL_AMOUNT]}₹',
                            style: GoogleFonts.courierPrime(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 25,
                                height: 25,
                                child: FilledButton(
                                  onPressed: () {
                                    if (cart[CART_QTY] == 1) {
                                      Cart.deleteCart(
                                        context: context,
                                        cartId: cart.id,
                                      );
                                    } else {
                                      Cart.updateQty(
                                        context: context,
                                        cartId: cart.id,
                                        qty: cart[CART_QTY] - 1,
                                        amount: cart[CART_AMOUNT],
                                      );
                                    }
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                cart[CART_QTY].toString(),
                                style: GoogleFonts.rubik(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              SizedBox(
                                width: 25,
                                height: 25,
                                child: FilledButton(
                                  onPressed: () {
                                    if (cart[CART_QTY] == 5) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Cannot add more than 5',
                                          ),
                                        ),
                                      );
                                    } else {
                                      Cart.updateQty(
                                        context: context,
                                        cartId: cart.id,
                                        qty: cart[CART_QTY] + 1,
                                        amount: cart[CART_AMOUNT],
                                      );
                                    }
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Text(
                                    '+',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              Container(height: 1, color: Colors.grey),

              // Bottom total + Place Order
              Container(
                height: MediaQuery.of(context).size.width * .17,
                child: StreamBuilder(
                  stream:
                      FirebaseFirestore.instance
                          .collection(CART_COLLECTION)
                          .where(CART_USER_ID, isEqualTo: manager.getUserId())
                          .where(CART_STATUS, isEqualTo: false)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer(
                        duration: Duration(seconds: 3),
                        interval: Duration(seconds: 0),
                        color: Colors.black,
                        colorOpacity: 0,
                        enabled: true,
                        direction: ShimmerDirection.fromLTRB(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 24,
                              width: 100,
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              color: Colors.grey.shade200,
                            ),
                            Container(
                              height: double.infinity,
                              width: MediaQuery.of(context).size.width * .4,
                              margin: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    total = 0;
                    for (var doc in snapshot.data!.docs) {
                      var data = doc.data();
                      total += (data[CART_TOTAL_AMOUNT] as num).toInt();
                    }

                    return Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹ ${total.toString()}',
                            style: GoogleFonts.rubik(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            height: double.infinity,
                            width: MediaQuery.of(context).size.width * .4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FilledButton(
                              onPressed: () {
                                context.push(Routes.userAddressScreen);
                              },
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Colors.purple,
                              ),
                              child: Text('Place Order'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
