import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frubix/controller/order.dart';
import 'package:frubix/custom/admin_scaffold.dart';
import 'package:frubix/generated/collections.dart';
import 'package:frubix/generated/pref_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../custom/alert.dart';
import '../../../generated/routes.dart';

class AdminAssignedOrderScreen extends StatefulWidget {
  const AdminAssignedOrderScreen({super.key});

  @override
  State<AdminAssignedOrderScreen> createState() =>
      _AdminAssignedOrderScreenState();
}

class _AdminAssignedOrderScreenState extends State<AdminAssignedOrderScreen> {
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
        index: 4,
        appBarTitle: 'Assigned Orders',
        appBarClick: () {
          setState(() {});
        },
        widgets: [
          SizedBox(height: 4),
          StreamBuilder(
            stream:
                FirebaseFirestore.instance
                    .collection(ORDER_COLLECTION)
                    .where(ORDER_STATUS, isEqualTo: 1)
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
                    'No Order Assigned',
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
                                              .replaceFirst(':index', '4'),
                                        );
                                      } else {
                                        Alert(
                                          context: context,
                                          message:
                                              'You are not allow to view order details',
                                          type: 'warning',
                                        );
                                      }
                                    },
                                    icon: Icon(Icons.visibility),
                                    color: Colors.blue,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (adminRole == 'Super Admin' ||
                                          adminRole == 'Admin') {
                                        _showAlertDialog(
                                          userId: data[ORDER_USER_ID],
                                          context: context,
                                          orderId: doc.id,
                                        );
                                      } else {
                                        Alert(
                                          context: context,
                                          message:
                                              'You are not allow to assign orders',
                                          type: 'warning',
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Mark Delivered',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
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

  void _showAlertDialog({
    required BuildContext context,
    required String orderId,
    required String userId,
  }) {
    showCupertinoDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState2) {
              return CupertinoAlertDialog(
                title: Text('Delivered?'),
                content: Text('Are you sure you want to mark as delivered?'),
                actions:
                    isLoading
                        ? [CupertinoActivityIndicator()]
                        : [
                          CupertinoDialogAction(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            child: Text('Sure'),
                            onPressed: () {
                              setState2(() {
                                isLoading = true;
                              });
                              Booking.completeOrder(
                                context: context,
                                id: orderId,
                                userId: userId,
                              ).then((value) {
                                setState2(() {
                                  isLoading = false;
                                  Navigator.of(context).pop();
                                });
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
              );
            },
          ),
    );
  }
}
