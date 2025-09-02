import 'package:action_slider/action_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frubix/controller/order.dart';
import 'package:frubix/custom/dashed_line.dart';
import 'package:frubix/custom/stepper.dart';
import 'package:frubix/custom/user_scaffolds.dart';
import 'package:frubix/generated/assets.dart';
import 'package:frubix/generated/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../generated/collections.dart';
import '../../../generated/pref_manager.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final manager = PrefManager();
  ActionSliderController sliderController = ActionSliderController();
  bool isCash = true;
  int subTotal = 0, shipCharge = 0, handleCharge = 0, total = 0;

  late Razorpay _razorpay;

  @override
  void initState() {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      appBarTitle: 'Check Out',
      body: StreamBuilder(
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
            return Center(child: Lottie.asset(Assets.animLoading));
          }
          subTotal = 0;
          shipCharge = 0;
          handleCharge = 0;
          total = 0;
          for (var doc in snapshot.data!.docs) {
            var data = doc.data();
            subTotal += (data[CART_TOTAL_AMOUNT] as num).toInt();
          }
          shipCharge = subTotal > 499 ? 0 : (subTotal * 0.10).round();
          handleCharge =
              (subTotal + shipCharge) > 999
                  ? 30
                  : ((subTotal + shipCharge) * 0.03).round();
          total = subTotal + shipCharge + handleCharge;
          return Padding(
            padding: EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomStepper(currentStep: 2),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade100,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Shipping Details',
                          style: GoogleFonts.rubik(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        DashedLine(),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address : ',
                              style: GoogleFonts.courierPrime(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                manager.getAddress(),
                                overflow: TextOverflow.clip,
                                style: GoogleFonts.courierPrime(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Visibility(
                          visible: manager.getDigiPin().trim().isNotEmpty,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Digipin : ',
                                style: GoogleFonts.courierPrime(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  manager.getDigiPin(),
                                  overflow: TextOverflow.clip,
                                  style: GoogleFonts.courierPrime(
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
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade100,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Payment Mode',
                          style: GoogleFonts.rubik(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        DashedLine(),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isCash = true;
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                  color:
                                      isCash
                                          ? Colors.purple
                                          : Colors.grey.shade200,
                                  boxShadow:
                                      !isCash
                                          ? [
                                            BoxShadow(
                                              color: Colors.grey,
                                              spreadRadius: 2,
                                              blurRadius: 8,
                                            ),
                                          ]
                                          : [],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'CASH',
                                    style: GoogleFonts.courierPrime(
                                      color:
                                          isCash ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isCash = false;
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                  color:
                                      !isCash
                                          ? Colors.purple
                                          : Colors.grey.shade200,
                                  boxShadow:
                                      isCash
                                          ? [
                                            BoxShadow(
                                              color: Colors.grey,
                                              spreadRadius: 2,
                                              blurRadius: 8,
                                            ),
                                          ]
                                          : [],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'ONLINE',
                                    style: GoogleFonts.courierPrime(
                                      color:
                                          !isCash ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade100,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Payment Summary',
                          style: GoogleFonts.rubik(
                            fontSize: 18,
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
                              'Sub Total',
                              style: GoogleFonts.courierPrime(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$subTotal ₹',
                              style: GoogleFonts.courierPrime(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Handling Charges',
                              style: GoogleFonts.courierPrime(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$handleCharge ₹',
                              style: GoogleFonts.courierPrime(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delivery Charges',
                              style: GoogleFonts.courierPrime(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$shipCharge ₹',
                              style: GoogleFonts.courierPrime(
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
                              'Total',
                              style: GoogleFonts.courierPrime(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$total ₹',
                              style: GoogleFonts.courierPrime(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ActionSlider.standard(
                    controller: sliderController,
                    sliderBehavior: SliderBehavior.stretch,
                    backgroundColor: Colors.grey.shade100,
                    toggleColor: Colors.purple,
                    successIcon: Icon(Icons.check_rounded, color: Colors.white),
                    loadingIcon: CircularProgressIndicator(color: Colors.white),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                      ),
                    ],
                    icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                    action: (controller) async {
                      sliderController.loading();
                      if (isCash) {
                        await Booking.confirmOrder(
                          context: context,
                          subTotal: subTotal,
                          shipCharge: shipCharge,
                          handleCharge: handleCharge,
                          total: total,
                          payMode: 'CASH',
                        ).then((value) {
                          Fluttertoast.showToast(msg: 'Order Booked');
                          sliderController.success();
                          Future.delayed(Duration(seconds: 1));
                          sliderController.reset();
                          context.go(Routes.userSuccessScreen);
                        });
                      } else {
                        openCheckout();
                        sliderController.reset();
                      }
                    },
                    child: Text(
                      'Slide to confirm',
                      style: GoogleFonts.courierPrime(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_9OxKzClSORPlr4',
      'amount': total * 100,
      'name': 'Frubix',
      'description': 'Payment for Order',
      'prefill': {'contact': '9876543210', 'email': 'test@example.com'},
      'theme': {'color': '#9C27B0'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await Booking.confirmOrder(
      context: context,
      subTotal: subTotal,
      shipCharge: shipCharge,
      handleCharge: handleCharge,
      total: total,
      payMode: 'ONLINE',
    ).then((value) {
      Fluttertoast.showToast(msg: 'Order Booked');
      sliderController.success();
      Future.delayed(Duration(seconds: 1));
      sliderController.reset();
      context.go(Routes.userSuccessScreen);
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Payment Failed!")));
  }
}
