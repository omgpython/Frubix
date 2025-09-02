import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frubix/controller/category.dart';
import 'package:frubix/custom/admin_scaffold.dart';
import 'package:frubix/custom/alert.dart';
import 'package:frubix/generated/pref_manager.dart';
import 'package:frubix/generated/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../custom/image_picker.dart';

class AdminAddCategoryScreen extends StatefulWidget {
  const AdminAddCategoryScreen({super.key});

  @override
  State<AdminAddCategoryScreen> createState() => _AdminAddCategoryScreenState();
}

class _AdminAddCategoryScreenState extends State<AdminAddCategoryScreen> {
  String pic = 'NONE';
  bool isLoading = false;

  final _key = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  PrefManager manager = PrefManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminScaffold(
        context: context,
        index: 1,
        appBarTitle: 'Add Category',
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
            child: Form(
              key: _key,
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var picImg = await pickImage(context: context);
                          setState(() {
                            if (picImg != 'NONE') {
                              pic = picImg;
                            }
                          });
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              pic != 'NONE'
                                  ? MemoryImage(base64Decode(pic))
                                  : null,
                          child:
                              pic == 'NONE'
                                  ? Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 50,
                                    color: Colors.purpleAccent,
                                  )
                                  : null,
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
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    style: GoogleFonts.courierPrime(),
                    decoration: InputDecoration(
                      labelText: 'Category Name',
                      labelStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(
                        Icons.category_outlined,
                        color: Colors.purpleAccent,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (name) {
                      if (name!.trim().isEmpty) {
                        return '* required';
                      }
                      return null;
                    },
                  ),
                  Container(
                    width: double.infinity,
                    height: 35,
                    child:
                        isLoading
                            ? Center(child: CircularProgressIndicator())
                            : FilledButton(
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Colors.deepPurple,
                              ),
                              onPressed: () {
                                if (pic == 'NONE') {
                                  Alert(
                                    context: context,
                                    message: 'Please Select Photo',
                                    type: 'error',
                                  );
                                }
                                if (_key.currentState!.validate()) {
                                  if (pic != 'NONE') {
                                    if (manager.getAdminRole() == 'Admin' ||
                                        manager.getAdminRole() ==
                                            'Super Admin') {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      String name = _nameController.text.trim();

                                      Category.addCategory(
                                        context: context,
                                        name: name,
                                        pic: pic,
                                      ).then((value) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        context.pushReplacement(
                                          Routes.adminCategoryScreen,
                                        );
                                      });
                                    } else {
                                      Alert(
                                        context: context,
                                        message:
                                            'You are not allow to add category',
                                        type: 'Warning',
                                      );
                                    }
                                  }
                                }
                              },
                              child: Text('Save Category'),
                            ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
