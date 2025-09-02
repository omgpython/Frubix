import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frubix/controller/cart.dart';
import 'package:frubix/custom/user_scaffolds.dart';
import 'package:frubix/generated/assets.dart';
import 'package:frubix/generated/pref_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../controller/product.dart';
import '../../../generated/collections.dart';

class ProductDetailScreen extends StatefulWidget {
  String id;
  ProductDetailScreen({super.key, required this.id});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String pic = 'NONE', name = '', price = '', unit = '', desc = '';
  bool isLoading = true, loading = false;

  final manager = PrefManager();

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      appBarTitle: 'Product Details',
      body:
          isLoading
              ? Center(child: Lottie.asset(Assets.animLoading))
              : Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .79,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 10,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.memory(
                                base64Decode(pic),
                                height: 250,
                                width: 250,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            name,
                            style: GoogleFonts.rubik(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 30),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Theme(
                                  data: ThemeData(
                                    dividerColor: Colors.transparent,
                                  ),
                                  child: ExpansionTile(
                                    initiallyExpanded: true,
                                    title: Text(
                                      'Weight :',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    children: [
                                      ListTile(
                                        title: Text(
                                          unit,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Theme(
                                  data: ThemeData(
                                    dividerColor: Colors.transparent,
                                  ),
                                  child: ExpansionTile(
                                    title: Text(
                                      'Description :',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    children: [
                                      ListTile(
                                        title: Text(
                                          desc,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        tileColor: Colors.deepPurple.shade50,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 1, color: Colors.grey.shade400),
                  Container(
                    height: MediaQuery.of(context).size.height * .09,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹ $price",
                            style: GoogleFonts.rubik(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          StreamBuilder(
                            stream:
                                FirebaseFirestore.instance
                                    .collection(CART_COLLECTION)
                                    .where(
                                      CART_USER_ID,
                                      isEqualTo: manager.getUserId(),
                                    )
                                    .where(
                                      CART_PRODUCT_ID,
                                      isEqualTo: widget.id,
                                    )
                                    .where(CART_STATUS, isEqualTo: false)
                                    .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.data!.docs.isEmpty) {
                                return Container(
                                  height: double.infinity,
                                  width: MediaQuery.of(context).size.width * .4,
                                  child: FilledButton(
                                    onPressed: () {
                                      Cart.addToCart(
                                        context: context,
                                        amount: int.parse(price),
                                        qty: 1,
                                        prodId: widget.id,
                                      );
                                    },
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.purple,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text('Add To Cart'),
                                  ),
                                );
                              }
                              final cart = snapshot.data!.docs.first;
                              return SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FilledButton(
                                      onPressed: () {
                                        if (cart[CART_QTY] == 1) {
                                          Cart.deleteCart(
                                            context: context,
                                            cartId: cart.id,
                                          ).then((value) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text('Item Removed'),
                                              ),
                                            );
                                          });
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        minimumSize: Size(40, 40),
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: Text(
                                        '-',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      cart[CART_QTY].toString(),
                                      style: GoogleFonts.rubik(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        if (cart[CART_QTY] == 5) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Cannot add more then 5',
                                              ),
                                            ),
                                          );
                                        } else {
                                          Cart.updateQty(
                                            context: context,
                                            cartId: cart.id,
                                            qty: cart[CART_QTY] + 1,
                                            amount: cart[CART_AMOUNT],
                                          ).then((value) {
                                            Fluttertoast.showToast(
                                              msg: 'Quantity increased',
                                            );
                                          });
                                        }
                                      },
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.purple,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        minimumSize: Size(40, 40),
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: Text(
                                        '+',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Future<void> setData() async {
    Map<String, dynamic> product = await Product.getProductById(
      context: context,
      id: widget.id,
    );
    pic = product[PRODUCT_PIC];
    name = product[PRODUCT_NAME];
    price = product[PRODUCT_PRICE].toString();
    unit = product[PRODUCT_UNIT];
    desc = product[PRODUCT_DESCRIPTION];
    setState(() {
      isLoading = false;
    });
  }
}
