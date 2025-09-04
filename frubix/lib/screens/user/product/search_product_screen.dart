import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frubix/custom/user_scaffolds.dart';
import 'package:frubix/generated/pref_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../controller/cart.dart';
import '../../../custom/dashed_line.dart';
import '../../../generated/collections.dart';
import '../../../generated/routes.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  String query = '';

  final manager = PrefManager();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      appBarTitle: 'Search Items',
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          spacing: 12,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            query.trim().isEmpty
                ? Container()
                : StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection(PRODUCT_COLLECTION)
                          .orderBy(PRODUCT_NAME)
                          .startAt([query])
                          .endAt(['$query\uf8ff'])
                          .snapshots(),
                  builder: (context, productSnapshot) {
                    if (productSnapshot.hasError) {
                      return Center(
                        child: Text('Error: ${productSnapshot.error}'),
                      );
                    }

                    if (!productSnapshot.hasData) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: 230,
                        ),
                        itemBuilder: (context, index) {
                          return Shimmer(
                            duration: Duration(seconds: 3),
                            interval: Duration(seconds: 0),
                            color: Colors.black,
                            colorOpacity: 0,
                            enabled: true,
                            direction: ShimmerDirection.fromLTRB(),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 12,
                                          width: 100,
                                          color: Colors.grey.shade300,
                                        ),
                                        SizedBox(height: 6),
                                        Container(
                                          height: 10,
                                          width: 60,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    final productData = productSnapshot.data!.docs;
                    final displayCount = productData.length < 3 ? 1 : 3;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: displayCount + 1,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 270,
                      ),
                      itemBuilder: (context, index) {
                        final product = productData[index];
                        return GestureDetector(
                          onTap: () {
                            context.push(
                              Routes.userProductDetailScreen.replaceFirst(
                                ':id',
                                product.id,
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Image.memory(
                                    base64Decode(product[PRODUCT_PIC]),
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product[PRODUCT_NAME],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.courierPrime(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '₹${product[PRODUCT_PRICE]}',
                                              style: GoogleFonts.courierPrime(
                                                fontSize: 16,
                                                color: Colors.green[800],
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '👜 ${product[PRODUCT_UNIT]}',
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.courierPrime(
                                                fontSize: 12,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: DashedLine(),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 12,
                                  ),
                                  child: StreamBuilder(
                                    stream:
                                        FirebaseFirestore.instance
                                            .collection(CART_COLLECTION)
                                            .where(
                                              CART_USER_ID,
                                              isEqualTo: manager.getUserId(),
                                            )
                                            .where(
                                              CART_PRODUCT_ID,
                                              isEqualTo: product.id,
                                            )
                                            .where(
                                              CART_STATUS,
                                              isEqualTo: false,
                                            )
                                            .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            'Error: ${snapshot.error}',
                                          ),
                                        );
                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: Container(
                                            height: 25,
                                            width: 25,

                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                      if (snapshot.data!.docs.isEmpty) {
                                        return Container(
                                          height: 25,
                                          width: double.infinity,
                                          child: FilledButton(
                                            onPressed: () {
                                              Cart.addToCart(
                                                context: context,
                                                amount: product[PRODUCT_PRICE],
                                                qty: 1,
                                                prodId: product.id,
                                              );
                                            },
                                            style: FilledButton.styleFrom(
                                              backgroundColor: Colors.purple,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            child: Text('Add To Cart'),
                                          ),
                                        );
                                      }
                                      final cart = snapshot.data!.docs.first;
                                      return Container(
                                        height: 25,
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                  backgroundColor:
                                                      Colors.purple,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5,
                                                        ),
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
                                                  backgroundColor:
                                                      Colors.purple,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5,
                                                        ),
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
