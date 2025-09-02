import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frubix/custom/admin_scaffold.dart';
import 'package:frubix/generated/collections.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../generated/routes.dart';

class AdminUserScreen extends StatefulWidget {
  const AdminUserScreen({super.key});

  @override
  State<AdminUserScreen> createState() => _AdminUserScreenState();
}

class _AdminUserScreenState extends State<AdminUserScreen> {
  String query = '';
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminScaffold(
        context: context,
        index: 6,
        appBarTitle: 'Users',
        appBarClick: () => setState(() {}),
        widgets: [
          SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * .2,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Search Contact',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon:
                      query.trim().isNotEmpty
                          ? IconButton(
                            onPressed: () {
                              setState(() {
                                query = '';
                                controller.clear();
                              });
                            },
                            icon: Icon(Icons.delete_outline, color: Colors.red),
                          )
                          : null,
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    query = value.trim();
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          StreamBuilder(
            stream:
                query.trim().isEmpty
                    ? FirebaseFirestore.instance
                        .collection(USER_COLLECTION)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection(USER_COLLECTION)
                        .orderBy(USER_CONTACT)
                        .startAt([query])
                        .endAt(['$query\uf8ff'])
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
                    'No User Found',
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
                        'Name',
                        style: GoogleFonts.rubik(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Email',
                        style: GoogleFonts.rubik(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Contact',
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
                            DataCell(Text(data[USER_NAME])),
                            DataCell(Text(data[USER_EMAIL])),
                            DataCell(Text(data[USER_CONTACT])),
                            DataCell(
                              IconButton(
                                onPressed: () {
                                  context.go(
                                    Routes.adminUserOrdersScreen.replaceFirst(
                                      ':id',
                                      doc.id,
                                    ),
                                  );
                                },
                                icon: Icon(Icons.shopping_cart),
                                color: Colors.deepOrange,
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
}
