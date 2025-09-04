import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frubix/custom/user_scaffolds.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../controller/cart.dart';
import '../../../custom/dashed_line.dart';
import '../../../generated/collections.dart';
import '../../../generated/pref_manager.dart';
import '../../../generated/routes.dart';

class CategoryWiseProductScreen extends StatefulWidget {
  String id;
  CategoryWiseProductScreen({super.key, required this.id});

  @override
  State<CategoryWiseProductScreen> createState() =>
      _CategoryWiseProductScreenState();
}

class _CategoryWiseProductScreenState extends State<CategoryWiseProductScreen> {
  late String selectedCategory;

  final manager = PrefManager();

  @override
  void initState() {
    selectedCategory = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      appBarTitle: 'Products',
      actions: [
        StreamBuilder(
          stream:
              FirebaseFirestore.instance
                  .collection(CART_COLLECTION)
                  .where(CART_USER_ID, isEqualTo: manager.getUserId())
                  .where(CART_STATUS, isEqualTo: false)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CupertinoActivityIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Cart is empty')));
                },
                icon: Badge(
                  label: Text('0'),
                  child: Icon(Icons.shopping_cart_outlined),
                ),
              );
            }

            int count = snapshot.data!.docs.length;
            return IconButton(
              onPressed: () {
                context.push(Routes.userCartScreen);
              },
              icon: Badge(
                label: Text(count.toString()),
                child: Icon(Icons.shopping_cart_outlined),
              ),
            );
          },
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection(CATEGORY_COLLECTION)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 120,
                    child: ListView.separated(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (_, __) => SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        return Shimmer(
                          duration: Duration(seconds: 3),
                          interval: Duration(seconds: 0),
                          color: Colors.black,
                          colorOpacity: 0,
                          enabled: true,
                          direction: ShimmerDirection.fromLTRB(),
                          child: Column(
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                height: 12,
                                width: 80,
                                color: Colors.grey.shade300,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }

                final categories = snapshot.data!.docs;

                return SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final category = categories[index];

                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedCategory = category.id;
                          });
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                base64Decode(category[CATEGORY_PIC]),
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 6),
                            SizedBox(
                              width: 80,
                              child: Text(
                                category[CATEGORY_NAME],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.courierPrime(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.5),
                                color:
                                    selectedCategory == category.id
                                        ? Colors.purple
                                        : Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection(CATEGORY_COLLECTION)
                              .where(
                                FieldPath.documentId,
                                isEqualTo: selectedCategory,
                              )
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Shimmer(
                              duration: Duration(seconds: 3),
                              interval: Duration(seconds: 0),
                              color: Colors.black,
                              colorOpacity: 0,
                              enabled: true,
                              direction: ShimmerDirection.fromLTRB(),
                              child: Container(
                                height: 20,
                                width: 120,
                                color: Colors.grey.shade300,
                                margin: EdgeInsets.only(bottom: 10),
                              ),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Text('Category not found');
                        }

                        final categoryDoc = snapshot.data!.docs.first;
                        final categoryName = categoryDoc[CATEGORY_NAME];

                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            categoryName,
                            style: GoogleFonts.oswald(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection(PRODUCT_COLLECTION)
                              .where(
                                PRODUCT_CATEGORY,
                                isEqualTo: selectedCategory,
                              )
                              .snapshots(),
                      builder: (context, productSnapshot) {
                        if (productSnapshot.hasError) {
                          return Center(
                            child: Text('Error: ${productSnapshot.error}'),
                          );
                        }

                        if (!productSnapshot.hasData) {
                          return GridView.builder(
                            itemCount: 4,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: productData.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                                                  style:
                                                      GoogleFonts.courierPrime(
                                                        fontSize: 16,
                                                        color:
                                                            Colors.green[800],
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '👜 ${product[PRODUCT_UNIT]}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      GoogleFonts.courierPrime(
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
                                                  isEqualTo:
                                                      manager.getUserId(),
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

                                                child:
                                                    CircularProgressIndicator(),
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
                                                    amount:
                                                        product[PRODUCT_PRICE],
                                                    qty: 1,
                                                    prodId: product.id,
                                                  );
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
                                                ),
                                                child: Text('Add To Cart'),
                                              ),
                                            );
                                          }
                                          final cart =
                                              snapshot.data!.docs.first;
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
                                                          qty:
                                                              cart[CART_QTY] -
                                                              1,
                                                          amount:
                                                              cart[CART_AMOUNT],
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
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                          qty:
                                                              cart[CART_QTY] +
                                                              1,
                                                          amount:
                                                              cart[CART_AMOUNT],
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
                                                        fontWeight:
                                                            FontWeight.bold,
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
            ),
          ],
        ),
      ),
    );
  }
}
