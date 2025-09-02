import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frubix/custom/admin_scaffold.dart';
import 'package:frubix/generated/collections.dart';
import 'package:frubix/generated/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controller/product.dart';

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({super.key});

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  String query = '';
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminScaffold(
        context: context,
        index: 2,
        appBarTitle: 'Products',
        appBarClick: () => setState(() {}),
        widgets: [
          SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * .2,
              child: TextField(
                controller: controller,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Search',
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
                        .collection(PRODUCT_COLLECTION)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection(PRODUCT_COLLECTION)
                        .orderBy(PRODUCT_NAME)
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
                    'No Product Found',
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
                        'Pic',
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
                        'Price',
                        style: GoogleFonts.rubik(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Unit',
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
                            DataCell(
                              CircleAvatar(
                                backgroundImage: MemoryImage(
                                  base64Decode(data[PRODUCT_PIC]),
                                ),
                              ),
                            ),
                            DataCell(Text(data[PRODUCT_NAME])),
                            DataCell(Text(data[PRODUCT_PRICE].toString())),
                            DataCell(Text(data[PRODUCT_UNIT])),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      context.go(
                                        Routes.adminViewProductScreen
                                            .replaceFirst(':id', doc.id),
                                      );
                                    },
                                    icon: Icon(Icons.visibility),
                                    color: Colors.blue,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.go(
                                        Routes.adminEditProductScreen
                                            .replaceFirst(':id', doc.id),
                                      );
                                    },
                                    icon: Icon(Icons.edit),
                                    color: Colors.green,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showAlertDialog(id: doc.id);
                                    },
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushReplacement(Routes.adminAddProductScreen);
        },
        backgroundColor: Colors.blueGrey.shade900,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void showAlertDialog({required String id}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Delete?'),
          content: Text('Are u sure want to delete category?'),
          actions: [
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Product.deleteProduct(context: context, id: id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
