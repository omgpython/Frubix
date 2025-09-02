import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frubix/custom/admin_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controller/order.dart';
import '../../../custom/alert.dart';
import '../../../generated/collections.dart';
import '../../../generated/pref_manager.dart';
import '../../../generated/routes.dart';

class AdminUserOrdersScreen extends StatefulWidget {
  String id;
  AdminUserOrdersScreen({super.key, required this.id});

  @override
  State<AdminUserOrdersScreen> createState() => _AdminUserOrdersScreenState();
}

class _AdminUserOrdersScreenState extends State<AdminUserOrdersScreen>
    with SingleTickerProviderStateMixin {
  final manager = PrefManager();
  bool isLoading = false;
  late TabController _tabController;
  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          currentTabIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String adminRole = manager.getAdminRole();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: AdminScaffold(
          context: context,
          index: 6,
          appBarTitle: 'Users Orders',
          appBarClick: () => setState(() {}),
          widgets: [
            TabBar(
              controller: _tabController,
              labelColor: Colors.deepPurple,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.deepPurple,
              tabs: [
                Tab(text: 'Pending'),
                Tab(text: 'Assigned'),
                Tab(text: 'Delivered'),
              ],
            ),
            SizedBox(height: 8),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection(ORDER_COLLECTION)
                      .where(ORDER_USER_ID, isEqualTo: widget.id)
                      .where(ORDER_STATUS, isEqualTo: currentTabIndex)
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
                      'No Order Found',
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
                          'Payment',
                          style: GoogleFonts.rubik(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Status',
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
                                Text(
                                  data[ORDER_STATUS] == 0
                                      ? 'Pending'
                                      : data[ORDER_STATUS] == 1
                                      ? 'Assigned'
                                      : 'Delivered',
                                  style: TextStyle(
                                    color:
                                        data[ORDER_STATUS] == 0
                                            ? Colors.amber
                                            : data[ORDER_STATUS] == 1
                                            ? Colors.blue
                                            : Colors.green,
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        context.go(
                                          Routes.adminOrderDetailScreen
                                              .replaceFirst(':id', doc.id)
                                              .replaceFirst(':index', '6'),
                                        );
                                      },
                                      icon: Icon(Icons.visibility),
                                      color: Colors.blue,
                                    ),
                                    if (data[ORDER_STATUS] == 0)
                                      _buildAssignButton(
                                        data,
                                        doc.id,
                                        adminRole,
                                      ),
                                    if (data[ORDER_STATUS] == 1)
                                      _buildDeliverButton(
                                        data,
                                        doc.id,
                                        adminRole,
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
      ),
    );
  }

  Widget _buildAssignButton(
    Map<String, dynamic> data,
    String docId,
    String adminRole,
  ) {
    return GestureDetector(
      onTap: () {
        if (adminRole == 'Super Admin' || adminRole == 'Admin') {
          showAssignDialog(id: docId, userId: data[ORDER_USER_ID]);
        } else {
          Alert(
            context: context,
            message: 'You are not allowed to assign orders',
            type: 'warning',
          );
        }
      },
      child: Container(
        width: 100,
        height: 40,
        margin: EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            'Assign',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildDeliverButton(
    Map<String, dynamic> data,
    String docId,
    String adminRole,
  ) {
    return GestureDetector(
      onTap: () {
        if (adminRole == 'Super Admin' || adminRole == 'Admin') {
          _showMarkDeliveredAlertDialog(
            userId: data[ORDER_USER_ID],
            context: context,
            orderId: docId,
          );
        } else {
          Alert(
            context: context,
            message: 'You are not allowed to mark orders as delivered',
            type: 'warning',
          );
        }
      },
      child: Container(
        width: 120,
        height: 40,
        margin: EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            'Mark Delivered',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
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

  void _showMarkDeliveredAlertDialog({
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
                            },
                          ),
                        ],
              );
            },
          ),
    );
  }
}
