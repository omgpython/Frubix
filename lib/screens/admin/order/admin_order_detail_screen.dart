import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frubix/controller/order.dart';
import 'package:frubix/custom/admin_scaffold.dart';
import 'package:frubix/custom/alert.dart';
import 'package:frubix/custom/dashed_line.dart';
import 'package:frubix/generated/assets.dart';
import 'package:frubix/generated/collections.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AdminOrderDetailScreen extends StatefulWidget {
  String index, id;
  AdminOrderDetailScreen({super.key, required this.index, required this.id});

  @override
  State<AdminOrderDetailScreen> createState() => _AdminOrderDetailScreenState();
}

class _AdminOrderDetailScreenState extends State<AdminOrderDetailScreen> {
  bool isLoading = true;
  String orderAddress = '',
      orderAddressDigipin = '',
      orderDeliveryBoy = '',
      orderDeliveryCharges = '',
      orderDeliveryDate = '',
      orderHandlingCharges = '',
      orderDate = '',
      orderPayMode = '',
      orderStatus = '',
      orderSubTotal = '',
      orderTotal = '',
      orderUserContact = '',
      orderUserName = '';
  List<Map<String, dynamic>> productList = [];

  @override
  void initState() {
    setData(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminScaffold(
        context: context,
        index: int.parse(widget.index),
        appBarTitle: 'Order Details',
        appBarClick: () => setState(() {}),
        widgets: [
          Container(
            width: MediaQuery.of(context).size.width * .7,
            height: MediaQuery.of(context).size.height * .7,
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 50)],
            ),
            child:
                isLoading
                    ? Center(child: Lottie.asset(Assets.animLoading))
                    : Row(
                      spacing: 15,
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemCount: productList.length,
                            separatorBuilder:
                                (context, index) => SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final product = productList[index];
                              return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(
                                    base64Decode(product['product_pic']),
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                title: Text(
                                  product['product_name'],
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '₹ ${product['cart_amount']} X ${product['cart_qty']} = ${product['cart_total']}',
                                  style: GoogleFonts.courierPrime(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: Text(
                                  '(${product['product_unit']})',
                                  style: GoogleFonts.courierPrime(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Order Status : ',
                                      style: GoogleFonts.rubik(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color:
                                            orderStatus == '0'
                                                ? Colors.amber
                                                : orderStatus == '1'
                                                ? Colors.blue
                                                : Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          orderStatus == '0'
                                              ? 'Pending'
                                              : orderStatus == '1'
                                              ? 'Assigned'
                                              : 'Delivered',
                                          style: GoogleFonts.rubik(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Payment Mode : ',
                                      style: GoogleFonts.rubik(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color:
                                            orderPayMode == 'CASH'
                                                ? Colors.amber
                                                : Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          orderPayMode,
                                          style: GoogleFonts.rubik(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Customer Name : ',
                                      style: GoogleFonts.rubik(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        orderUserName,
                                        overflow: TextOverflow.clip,
                                        style: GoogleFonts.rubik(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Customer Contact : ',
                                      style: GoogleFonts.rubik(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        orderUserContact,
                                        overflow: TextOverflow.clip,
                                        style: GoogleFonts.rubik(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Address : ',
                                      style: GoogleFonts.rubik(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        orderAddress,
                                        overflow: TextOverflow.clip,
                                        style: GoogleFonts.rubik(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: orderAddressDigipin != 'N/A',
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Digi-Pin : ',
                                        style: GoogleFonts.rubik(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          orderAddressDigipin,
                                          overflow: TextOverflow.clip,
                                          style: GoogleFonts.rubik(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order Date : ',
                                      style: GoogleFonts.rubik(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        orderDate,
                                        overflow: TextOverflow.clip,
                                        style: GoogleFonts.rubik(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: orderDeliveryDate != 'N/A',
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Delivery Boy : ',
                                        style: GoogleFonts.rubik(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          orderDeliveryBoy,
                                          overflow: TextOverflow.clip,
                                          style: GoogleFonts.rubik(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: orderDeliveryDate != 'N/A',
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Delivery Boy : ',
                                        style: GoogleFonts.rubik(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          orderDeliveryDate,
                                          overflow: TextOverflow.clip,
                                          style: GoogleFonts.rubik(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Payment Summary',
                                        style: GoogleFonts.rubik(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      DashedLine(),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Sub-Total : ',
                                            style: GoogleFonts.courierPrime(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '$orderSubTotal ₹',
                                            overflow: TextOverflow.clip,
                                            style: GoogleFonts.courierPrime(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Handling Charges : ',
                                            style: GoogleFonts.courierPrime(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '$orderHandlingCharges ₹',
                                            overflow: TextOverflow.clip,
                                            style: GoogleFonts.courierPrime(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Delivery Charges : ',
                                            style: GoogleFonts.courierPrime(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '$orderDeliveryCharges ₹',
                                            overflow: TextOverflow.clip,
                                            style: GoogleFonts.courierPrime(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      DashedLine(),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total : ',
                                            style: GoogleFonts.courierPrime(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '$orderTotal ₹',
                                            overflow: TextOverflow.clip,
                                            style: GoogleFonts.courierPrime(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  Future<void> setData(String id) async {
    try {
      Map<String, dynamic> order = await Booking.getOrderById(
        context: context,
        id: id,
      );

      orderAddress = order[ORDER_ADDRESS] ?? 'Null';
      orderAddressDigipin = order[ORDER_ADDRESS_DIGIPIN] ?? 'Null';
      orderDeliveryBoy = order[ORDER_DELIVERY_BOY];
      orderDeliveryCharges = order[ORDER_DELIVERY_CHARGE].toString();
      orderDeliveryDate = order[ORDER_DELIVERY_DATE] ?? 'Null';
      orderHandlingCharges = order[ORDER_HANDLING_CHARGE].toString();
      orderPayMode = order[ORDER_PAY_MODE] ?? 'Null';
      orderSubTotal = order[ORDER_SUB_TOTAL].toString();
      orderUserContact = order[ORDER_USER_CONTACT] ?? 'Null';
      orderUserName = order[ORDER_USER_NAME] ?? 'Null';
      orderStatus = order[ORDER_STATUS].toString();
      orderDate = order[ORDER_DATE] ?? 'Null';
      orderTotal = order[ORDER_TOTAL].toString();

      List<Map<String, dynamic>> carts = await Booking.getCartByOrderId(
        context: context,
        orderId: order[CART_ORDER_ID],
      );

      productList = [];
      for (var cart in carts) {
        final productId = cart[CART_PRODUCT_ID].toString();

        final product = await Booking.getProductById(
          context: context,
          id: productId,
        );

        productList.add({
          'product_name': product[PRODUCT_NAME],
          'product_pic': product[PRODUCT_PIC],
          'product_unit': product[PRODUCT_UNIT],
          'product_price': product[PRODUCT_PRICE].toString(),
          'cart_qty': cart[CART_QTY].toString(),
          'cart_amount': cart[CART_AMOUNT].toString(),
          'cart_total': cart[CART_TOTAL_AMOUNT].toString(),
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      log('Error in setData: $e', name: 'ORDER DATA SET ERROR');
      Alert(context: context, message: 'Unable To Fetch Data', type: 'error');
    }
  }
}
