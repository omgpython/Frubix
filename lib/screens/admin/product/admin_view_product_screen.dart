import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frubix/controller/category.dart';
import 'package:frubix/custom/admin_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controller/product.dart';
import '../../../generated/collections.dart';

class AdminViewProductScreen extends StatefulWidget {
  String id;
  AdminViewProductScreen({super.key, required this.id});

  @override
  State<AdminViewProductScreen> createState() => _AdminViewProductScreenState();
}

class _AdminViewProductScreenState extends State<AdminViewProductScreen> {
  String pic = 'NONE',
      name = '',
      price = '',
      unit = '',
      desc = '',
      catName = '';
  bool isLoading = true;

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
        index: 2,
        appBarTitle: 'Product Details',
        appBarClick: () => setState(() {}),
        widgets: [
          Container(
            width: MediaQuery.of(context).size.width * .7,
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
                    : Row(
                      spacing: 35,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.memory(
                              base64Decode(pic),
                              height: MediaQuery.of(context).size.height * .6,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              spacing: 12,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Product Name : ',
                                      style: GoogleFonts.rubik(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      name,
                                      style: GoogleFonts.rubik(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Product Price : ',
                                      style: GoogleFonts.rubik(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "$price ₹ / $unit",
                                      style: GoogleFonts.rubik(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Category Name : ',
                                      style: GoogleFonts.rubik(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      catName,
                                      style: GoogleFonts.rubik(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Description : ',
                                      style: GoogleFonts.rubik(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          .2,
                                      child: Text(
                                        desc,
                                        style: GoogleFonts.rubik(fontSize: 16),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
    Map<String, dynamic> category = await Category.getCategoryById(
      context: context,
      id: product[PRODUCT_CATEGORY],
    );
    pic = product[PRODUCT_PIC];
    name = product[PRODUCT_NAME];
    price = product[PRODUCT_PRICE].toString();
    unit = product[PRODUCT_UNIT];
    desc = product[PRODUCT_DESCRIPTION];
    catName = category[CATEGORY_NAME];
    setState(() {
      isLoading = false;
    });
  }
}
