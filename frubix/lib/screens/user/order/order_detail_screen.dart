import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frubix/custom/stepper.dart';
import 'package:frubix/custom/user_scaffolds.dart';
import 'package:frubix/generated/assets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../controller/order.dart';
import '../../../custom/dashed_line.dart';
import '../../../generated/collections.dart';

class OrderDetailScreen extends StatefulWidget {
  String id;
  OrderDetailScreen({super.key, required this.id});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
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
    setData(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      appBarTitle: 'Order Details',
      body:
          isLoading
              ? Center(child: Lottie.asset(Assets.animLoading))
              : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    spacing: 20,
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
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
                      VerticalStepper(
                        currentStep: int.parse(orderStatus),
                        orderDate: orderDate,
                        deliveryBoyName: orderDeliveryBoy,
                        deliveryDate: orderDeliveryDate,
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Shipping Details',
                              style: GoogleFonts.rubik(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            DashedLine(),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name : ',
                                  style: GoogleFonts.courierPrime(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    orderUserName,
                                    overflow: TextOverflow.clip,
                                    style: GoogleFonts.courierPrime(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Contact : ',
                                  style: GoogleFonts.courierPrime(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    orderUserContact,
                                    overflow: TextOverflow.clip,
                                    style: GoogleFonts.courierPrime(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Address : ',
                                  style: GoogleFonts.courierPrime(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    orderAddress,
                                    overflow: TextOverflow.clip,
                                    style: GoogleFonts.courierPrime(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Visibility(
                              visible: orderAddressDigipin != 'N/A',
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Digi-Pin : ',
                                    style: GoogleFonts.courierPrime(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      orderAddressDigipin,
                                      overflow: TextOverflow.clip,
                                      style: GoogleFonts.courierPrime(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total ($orderPayMode) : ',
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
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
    );
  }

  Future<void> setData({required String id}) async {
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
      Fluttertoast.showToast(msg: 'Unable to get order !!!');
      log('Error in setData: $e', name: 'ORDER DATA SET ERROR');
    }
  }
}
