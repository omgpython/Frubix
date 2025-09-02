import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frubix/controller/order.dart';
import 'package:frubix/custom/admin_scaffold.dart';
import 'package:frubix/generated/collections.dart';
import 'package:frubix/generated/pref_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../custom/alert.dart';
import '../../../generated/routes.dart';

class AdminCompletedOrderScreen extends StatefulWidget {
  const AdminCompletedOrderScreen({super.key});

  @override
  State<AdminCompletedOrderScreen> createState() =>
      _AdminCompletedOrderScreenState();
}

class _AdminCompletedOrderScreenState extends State<AdminCompletedOrderScreen> {
  String query = '';
  final controller = TextEditingController();
  final manager = PrefManager();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    String adminRole = manager.getAdminRole();
    return Scaffold(
      body: AdminScaffold(
        context: context,
        index: 5,
        appBarTitle: 'Completed Orders',
        appBarClick: () {
          setState(() {});
        },
        widgets: [
          SizedBox(height: 4),
          StreamBuilder(
            stream:
                FirebaseFirestore.instance
                    .collection(ORDER_COLLECTION)
                    .where(ORDER_STATUS, isEqualTo: 2)
                    .snapshots(),

            builder: (context, snapshot) {
              int index = 1;
              if (snapshot.hasError) {
                return Text('Error : ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final doc = snapshot.data!.docs;

              if (doc.isEmpty) {
                return Center(
                  child: Text(
                    'No Order Completed',
                    style: GoogleFonts.rubik(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              return ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * .7,
                ),
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text(
                        '#',
                        style: GoogleFonts.rubik(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Order Date',
                        style: GoogleFonts.rubik(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Name',
                        style: GoogleFonts.rubik(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Total',
                        style: GoogleFonts.rubik(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Payment Mode',
                        style: GoogleFonts.rubik(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Actions',
                        style: GoogleFonts.rubik(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows:
                      doc.map((doc) {
                        final data = doc.data();
                        return DataRow(
                          cells: [
                            DataCell(Text((index++).toString())),
                            DataCell(Text(data[ORDER_DATE])),
                            DataCell(Text(data[ORDER_USER_NAME] ?? '')),
                            DataCell(Text(data[ORDER_TOTAL].toString())),
                            DataCell(Text(data[ORDER_PAY_MODE])),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (adminRole == 'Super Admin' ||
                                          adminRole == 'Admin') {
                                        context.go(
                                          Routes.adminOrderDetailScreen
                                              .replaceFirst(':id', doc.id)
                                              .replaceFirst(':index', '5'),
                                        );
                                      } else {
                                        Alert(
                                          context: context,
                                          message:
                                              'You are not allow to access order data',
                                          type: 'warning',
                                        );
                                      }
                                    },
                                    icon: Icon(Icons.visibility),
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void showAssignDialog({required String id, required String userId}) {
    final key = GlobalKey<FormState>();
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: MediaQuery.of(context).size.height * .4,
            width: MediaQuery.of(context).size.width * .3,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: StatefulBuilder(
              builder: (context, setState2) {
                return Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Form(
                    key: key,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Delivery Boy Name',
                          ),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return '* required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          height: 40,
                          child:
                              isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : FilledButton(
                                    onPressed: () {
                                      if (key.currentState!.validate()) {
                                        setState2(() {
                                          isLoading = true;
                                        });
                                        Booking.assignOrder(
                                          context: context,
                                          id: id,
                                          userId: userId,
                                          deliveryBoy: controller.text.trim(),
                                        ).then((value) {
                                          setState2(() {
                                            isLoading = false;
                                          });
                                          context.pop();
                                        });
                                      }
                                    },
                                    style: FilledButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Colors.deepPurple,
                                    ),
                                    child: Text('Assign'),
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
