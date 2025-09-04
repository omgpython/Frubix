import 'dart:async';
import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frubix/custom/user_scaffolds.dart';
import 'package:frubix/generated/assets.dart';
import 'package:frubix/generated/collections.dart';
import 'package:frubix/generated/notification_service.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../controller/cart.dart';
import '../../custom/dashed_line.dart';
import '../../generated/pref_manager.dart';
import '../../generated/routes.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _controller = PageController();
  final _node = FocusNode();
  final manager = PrefManager();

  final List<BannerModel> _banners = [
    BannerModel(imagePath: Assets.imagesBanner1, id: "1", boxFit: BoxFit.fill),
    BannerModel(imagePath: Assets.imagesBanner2, id: "2", boxFit: BoxFit.fill),
    BannerModel(imagePath: Assets.imagesBanner3, id: "3", boxFit: BoxFit.fill),
    BannerModel(imagePath: Assets.imagesBanner4, id: "4", boxFit: BoxFit.fill),
  ];

  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    requestNotificationPermission();
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _controller.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return UserBottomNavScaffold(
      context: context,
      appBarTitle: 'Home',
      index: 0,
      centerTitle: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner carousel
            BannerCarousel(
              banners: _banners,
              pageController: _controller,
              customizedIndicators: IndicatorModel.animation(
                width: 20,
                height: 5,
                spaceBetween: 2,
                widthAnimation: 50,
              ),
              height: 200,
              activeColor: Colors.purple,
              disableColor: Colors.grey,
              animation: true,
              borderRadius: 10,
              indicatorBottom: true,
            ),

            SizedBox(height: 20),
            // Categories Section
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: GoogleFonts.oswald(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
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
                                context.push(
                                  Routes.userCategoryWiseProductScreen
                                      .replaceFirst(':id', category.id),
                                );
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
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Products Section grouped by category
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection(CATEGORY_COLLECTION)
                        .snapshots(),
                builder: (context, categorySnapshot) {
                  if (categorySnapshot.hasError) {
                    return Center(
                      child: Text('Error: ${categorySnapshot.error}'),
                    );
                  }
                  if (!categorySnapshot.hasData) {
                    return Shimmer(
                      duration: Duration(seconds: 3),
                      interval: Duration(seconds: 0),
                      color: Colors.black,
                      colorOpacity: 0,
                      enabled: true,
                      direction: ShimmerDirection.fromLTRB(),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 20,
                                width: MediaQuery.of(context).size.width * .4,
                                color: Colors.grey.shade300,
                              ),
                              SizedBox(height: 10),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 4,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      mainAxisExtent: 230,
                                    ),
                                itemBuilder: (context, index) {
                                  return Card(
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
                                  );
                                },
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 10);
                        },
                        itemCount: 10,
                      ),
                    );
                  }

                  final categories = categorySnapshot.data!.docs;

                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: categories.length,
                    itemBuilder: (context, catIndex) {
                      final category = categories[catIndex];
                      final catId = category.id;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category[CATEGORY_NAME],
                            style: GoogleFonts.oswald(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          StreamBuilder<QuerySnapshot>(
                            stream:
                                FirebaseFirestore.instance
                                    .collection(PRODUCT_COLLECTION)
                                    .where(PRODUCT_CATEGORY, isEqualTo: catId)
                                    .snapshots(),
                            builder: (context, productSnapshot) {
                              if (productSnapshot.hasError) {
                                return Center(
                                  child: Text(
                                    'Error: ${productSnapshot.error}',
                                  ),
                                );
                              }

                              if (!productSnapshot.hasData) {
                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: 4,
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                              final displayCount =
                                  productData.length < 3 ? 1 : 3;

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: displayCount + 1,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: screenWidth > 600 ? 3 : 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      mainAxisExtent: 270,
                                    ),
                                itemBuilder: (context, index) {
                                  if (index == displayCount) {
                                    return GestureDetector(
                                      onTap: () {
                                        context.push(
                                          Routes.userCategoryWiseProductScreen
                                              .replaceFirst(':id', category.id),
                                        );
                                      },
                                      child: Card(
                                        color: Colors.deepPurple.shade50,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 40,
                                              color: Colors.deepPurple,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'See All',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepPurple,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  final product = productData[index];
                                  return GestureDetector(
                                    onTap: () {
                                      context.push(
                                        Routes.userProductDetailScreen
                                            .replaceFirst(':id', product.id),
                                      );
                                    },
                                    child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(12),
                                            ),
                                            child: Image.memory(
                                              base64Decode(
                                                product[PRODUCT_PIC],
                                              ),
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      GoogleFonts.courierPrime(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                SizedBox(height: 6),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        '₹${product[PRODUCT_PRICE]}',
                                                        style:
                                                            GoogleFonts.courierPrime(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors
                                                                      .green[800],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '👜 ${product[PRODUCT_UNIT]}',
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        style:
                                                            GoogleFonts.courierPrime(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors
                                                                      .grey[700],
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
                                                      .collection(
                                                        CART_COLLECTION,
                                                      )
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
                                                if (snapshot
                                                    .data!
                                                    .docs
                                                    .isEmpty) {
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
                                                      child: Text(
                                                        'Add To Cart',
                                                      ),
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
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 25,
                                                        height: 25,
                                                        child: FilledButton(
                                                          onPressed: () {
                                                            if (cart[CART_QTY] ==
                                                                1) {
                                                              Cart.deleteCart(
                                                                context:
                                                                    context,
                                                                cartId: cart.id,
                                                              );
                                                            } else {
                                                              Cart.updateQty(
                                                                context:
                                                                    context,
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
                                                            padding:
                                                                EdgeInsets.zero,
                                                          ),
                                                          child: Text(
                                                            '-',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        cart[CART_QTY]
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.rubik(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                      SizedBox(width: 8),
                                                      SizedBox(
                                                        width: 25,
                                                        height: 25,
                                                        child: FilledButton(
                                                          onPressed: () {
                                                            if (cart[CART_QTY] ==
                                                                5) {
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
                                                                context:
                                                                    context,
                                                                cartId: cart.id,
                                                                qty:
                                                                    cart[CART_QTY] +
                                                                    1,
                                                                amount:
                                                                    cart[CART_AMOUNT],
                                                              ).then((value) {
                                                                Fluttertoast.showToast(
                                                                  msg:
                                                                      'Quantity increased',
                                                                );
                                                              });
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
                                                            padding:
                                                                EdgeInsets.zero,
                                                          ),
                                                          child: Text(
                                                            '+',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
