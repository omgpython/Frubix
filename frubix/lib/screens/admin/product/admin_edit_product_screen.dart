import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frubix/controller/product.dart';
import 'package:frubix/custom/admin_scaffold.dart';
import 'package:frubix/custom/alert.dart';
import 'package:frubix/generated/collections.dart';
import 'package:frubix/generated/pref_manager.dart';
import 'package:frubix/generated/routes.dart';
import 'package:frubix/generated/validation.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../custom/image_picker.dart';

class AdminEditProductScreen extends StatefulWidget {
  String id;
  AdminEditProductScreen({super.key, required this.id});

  @override
  State<AdminEditProductScreen> createState() => _AdminEditProductScreenState();
}

class _AdminEditProductScreenState extends State<AdminEditProductScreen> {
  String pic = 'NONE';
  String? catId;
  bool loading = false, isLoading = true;

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _unitController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _key = GlobalKey<FormState>();
  late Future<List<Map<String, dynamic>>> _categoriesFuture;
  PrefManager manager = PrefManager();

  @override
  void initState() {
    super.initState();
    _categoriesFuture = Product.fetchCategories().then((value) {
      setData();
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminScaffold(
        context: context,
        index: 2,
        appBarTitle: 'Edit Product',
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
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 12,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: _nameController,
                                    keyboardType: TextInputType.text,
                                    style: GoogleFonts.courierPrime(),
                                    decoration: InputDecoration(
                                      labelText: 'Product Name',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(
                                        Icons.store_outlined,
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
                                ),
                                Expanded(
                                  flex: 1,
                                  child: FutureBuilder(
                                    future: _categoriesFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      if (!snapshot.hasData) {
                                        return Text('No categories found');
                                      }
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }

                                      final categories = snapshot.data!;
                                      return FormField(
                                        validator: (value) {
                                          if (catId == null) {
                                            return '* Select category';
                                          }
                                          return null;
                                        },
                                        builder: (state) {
                                          return InputDecorator(
                                            decoration: InputDecoration(
                                              labelText: 'Category',
                                              prefixIcon: Icon(
                                                Icons.category_outlined,
                                                color: Colors.purpleAccent,
                                              ),
                                              border: OutlineInputBorder(),
                                              errorText: state.errorText,
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                value: catId,
                                                hint: Text('Select Category'),
                                                isDense: true,
                                                items:
                                                    categories.map((category) {
                                                      return DropdownMenuItem<
                                                        String
                                                      >(
                                                        value: category['id'],
                                                        child: Text(
                                                          category['name'],
                                                        ),
                                                      );
                                                    }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    catId = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 12,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: _priceController,
                                    keyboardType: TextInputType.number,
                                    style: GoogleFonts.courierPrime(),
                                    decoration: InputDecoration(
                                      labelText: 'Price',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(
                                        Icons.currency_rupee_outlined,
                                        color: Colors.purpleAccent,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (price) {
                                      return validatePrice(price: price);
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: _unitController,
                                    keyboardType: TextInputType.text,
                                    style: GoogleFonts.courierPrime(),
                                    decoration: InputDecoration(
                                      labelText: 'Unit',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: Icon(
                                        Icons.straighten_outlined,
                                        color: Colors.purpleAccent,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (unit) {
                                      if (unit!.trim().isEmpty) {
                                        return '* required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            TextFormField(
                              controller: _descriptionController,
                              keyboardType: TextInputType.text,
                              style: GoogleFonts.courierPrime(),
                              minLines: 2,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                labelStyle: TextStyle(color: Colors.grey),
                                prefixIcon: Icon(
                                  Icons.description_outlined,
                                  color: Colors.purpleAccent,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              validator: (desc) {
                                if (desc!.trim().isEmpty) {
                                  return '* required';
                                }
                                return null;
                              },
                            ),
                            Container(
                              width: double.infinity,
                              child:
                                  loading
                                      ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                      : FilledButton(
                                        style: FilledButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          backgroundColor: Colors.deepPurple,
                                        ),
                                        onPressed: () {
                                          if (pic == 'NONE') {
                                            Alert(
                                              context: context,
                                              message:
                                                  'Please select a product image',
                                              type: 'error',
                                            );
                                          }
                                          if (_key.currentState!.validate()) {
                                            if (pic != 'NONE') {
                                              if (manager.getAdminRole() ==
                                                      'Admin' ||
                                                  manager.getAdminRole() ==
                                                      'Super Admin') {
                                                setState(() {
                                                  loading = true;
                                                });
                                                String name =
                                                    _nameController.text.trim();
                                                int price = int.parse(
                                                  _priceController.text.trim(),
                                                );
                                                String unit =
                                                    _unitController.text
                                                        .trim()
                                                        .toUpperCase();
                                                String description =
                                                    _descriptionController.text
                                                        .trim();

                                                Product.editProduct(
                                                  context: context,
                                                  id: widget.id,
                                                  name: name,
                                                  price: price,
                                                  catId: catId!,
                                                  unit: unit,
                                                  description: description,
                                                  pic: pic,
                                                ).then((value) {
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                  context.pushReplacement(
                                                    Routes.adminProductScreen,
                                                  );
                                                });
                                              } else {
                                                Alert(
                                                  context: context,
                                                  message:
                                                      'You are not allow to add product',
                                                  type: 'error',
                                                );
                                              }
                                            }
                                          }
                                        },
                                        child: Text('Save Product Details'),
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
    Map<String, dynamic> product = await Product.getProductById(
      context: context,
      id: widget.id,
    );
    pic = product[PRODUCT_PIC];
    _nameController.text = product[PRODUCT_NAME];
    _priceController.text = product[PRODUCT_PRICE].toString();
    _unitController.text = product[PRODUCT_UNIT];
    _descriptionController.text = product[PRODUCT_DESCRIPTION];
    catId = product[PRODUCT_CATEGORY];
    setState(() {
      isLoading = false;
    });
  }
}
