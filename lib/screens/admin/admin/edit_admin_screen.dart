import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frubix/controller/admin.dart';
import 'package:frubix/custom/admin_scaffold.dart';
import 'package:frubix/custom/image_picker.dart';
import 'package:frubix/generated/validation.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../generated/collections.dart';
import '../../../generated/routes.dart';

class EditAdminScreen extends StatefulWidget {
  String id;
  EditAdminScreen({super.key, required this.id});

  @override
  State<EditAdminScreen> createState() => _EditAdminScreenState();
}

class _EditAdminScreenState extends State<EditAdminScreen> {
  final _key = GlobalKey<FormState>();

  bool isLoading = true, loading = false;
  String role = 'Admin', pic = 'NONE';
  Map<String, dynamic> admin = {};

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminScaffold(
        context: context,
        index: 7,
        appBarTitle: 'Edit Admin',
        appBarClick: () => setState(() {}),
        widgets: [
          Container(
            width: MediaQuery.of(context).size.width * .5,
            height: MediaQuery.of(context).size.height * .7,
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 50)],
            ),
            child:
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                      child: Form(
                        key: _key,
                        child: Column(
                          spacing: 12,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    var picImg = await pickImage(
                                      context: context,
                                    );
                                    setState(() {
                                      if (picImg != 'NONE') {
                                        pic = picImg;
                                      }
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 50,
                                    child:
                                        pic == 'NONE'
                                            ? Icon(
                                              Icons.add_a_photo_outlined,
                                              size: 50,
                                              color: Colors.purpleAccent,
                                            )
                                            : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.memory(
                                                base64Decode(pic),
                                              ),
                                            ),
                                  ),
                                ),
                                Visibility(
                                  visible: pic != 'NONE',
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        pic = 'NONE';
                                      });
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 12,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _nameController,
                                    keyboardType: TextInputType.text,
                                    style: GoogleFonts.courierPrime(),
                                    decoration: InputDecoration(
                                      labelText: 'Name',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(
                                        Icons.person_outline,
                                        color: Colors.purpleAccent,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (name) {
                                      return validateName(name: name);
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Role',
                                      prefixIcon: Icon(
                                        Icons.admin_panel_settings_outlined,
                                        color: Colors.purpleAccent,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        value: role,
                                        isDense: true,
                                        items: [
                                          DropdownMenuItem(
                                            value: 'Admin',
                                            child: Text('Admin'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Viewer',
                                            child: Text('Viewer'),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            role = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 12,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: GoogleFonts.courierPrime(),
                                    decoration: InputDecoration(
                                      labelText: 'Email Address',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: Colors.purpleAccent,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (email) {
                                      return validateEmail(email: email);
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: _contactController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    style: GoogleFonts.courierPrime(),
                                    decoration: InputDecoration(
                                      labelText: 'Contact No.',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(
                                        Icons.call_outlined,
                                        color: Colors.purpleAccent,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (contact) {
                                      return validateContact(contact: contact);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              height: 35,
                              child:
                                  loading
                                      ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                      : FilledButton(
                                        onPressed: () {
                                          if (_key.currentState!.validate()) {
                                            setState(() {
                                              loading = true;
                                            });
                                            String name =
                                                _nameController.text.trim();
                                            String email =
                                                _emailController.text.trim();
                                            String contact =
                                                _contactController.text.trim();

                                            Admin.editAdmin(
                                              context: context,
                                              originalEmail: admin[ADMIN_EMAIL],
                                              originalContact:
                                                  admin[ADMIN_CONTACT],
                                              id: widget.id,
                                              name: name,
                                              email: email,
                                              contact: contact,
                                              role: role,
                                              pic: pic,
                                            ).then((value) {
                                              setState(() {
                                                loading = false;
                                              });
                                              context.pushReplacement(
                                                Routes.adminScreen,
                                              );
                                            });
                                          }
                                        },
                                        style: FilledButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          backgroundColor: Colors.deepPurple,
                                        ),
                                        child: Text('Save Admin Details'),
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Future<void> setData() async {
    admin = await Admin.getAdminById(context: context, id: widget.id);
    pic = admin[ADMIN_PIC];
    _nameController.text = admin[ADMIN_NAME];
    _emailController.text = admin[ADMIN_EMAIL];
    _contactController.text = admin[ADMIN_CONTACT];
    role = admin[ADMIN_ROLE];
    setState(() {
      isLoading = false;
    });
  }
}
