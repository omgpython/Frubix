import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frubix/custom/admin_scaffold.dart';
import 'package:frubix/generated/collections.dart';
import 'package:frubix/generated/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controller/admin.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String query = '';
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminScaffold(
        context: context,
        index: 7,
        appBarTitle: 'Admins',
        appBarClick: () => setState(() {}),
        widgets: [
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
                        .collection(ADMIN_COLLECTION)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection(ADMIN_COLLECTION)
                        .orderBy(ADMIN_NAME)
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
                    'No Admin Found',
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
                        'Role',
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
                        final image = data[ADMIN_PIC];
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                (index++).toString(),
                                style: GoogleFonts.rubik(),
                              ),
                            ),
                            DataCell(
                              CircleAvatar(
                                child:
                                    image == 'NONE'
                                        ? Text(data[ADMIN_NAME][0])
                                        : ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: Image.memory(
                                            base64Decode(data[ADMIN_PIC]),
                                          ),
                                        ),
                              ),
                            ),
                            DataCell(
                              Text(
                                data[ADMIN_NAME],
                                style: GoogleFonts.rubik(),
                              ),
                            ),
                            DataCell(
                              Text(
                                data[ADMIN_EMAIL],
                                style: GoogleFonts.rubik(),
                              ),
                            ),
                            DataCell(
                              Text(
                                data[ADMIN_CONTACT],
                                style: GoogleFonts.rubik(),
                              ),
                            ),
                            DataCell(
                              Text(
                                data[ADMIN_ROLE],
                                style: GoogleFonts.rubik(),
                              ),
                            ),
                            DataCell(
                              Visibility(
                                visible: data[ADMIN_ROLE] != 'Super Admin',
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        context.go(
                                          Routes.editAdminScreen.replaceFirst(
                                            ':id',
                                            doc.id,
                                          ),
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
          context.pushReplacement(Routes.addAdminScreen);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void showAlertDialog({required String id}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Delete?'),
          content: Text('Are u sure want to delete admin?'),
          actions: [
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Delete'),
              onPressed: () {
                Admin.deleteAdmin(context: context, id: id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
