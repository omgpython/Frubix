import 'package:flutter/material.dart';
import 'package:frubix/custom/user_scaffolds.dart';
import 'package:frubix/generated/pref_manager.dart';
import 'package:frubix/generated/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../custom/stepper.dart';
import '../../../generated/validation.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final houseNoController = TextEditingController();
  final streetController = TextEditingController();
  final landmarkController = TextEditingController();
  final areaController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final digiPinController = TextEditingController();

  final manager = PrefManager();
  final _key = GlobalKey<FormState>();

  bool isAddress = false;

  @override
  void initState() {
    houseNoController.text = manager.getHouseNo();
    streetController.text = manager.getStreet();
    landmarkController.text = manager.getLandmark();
    areaController.text = manager.getArea();
    cityController.text = manager.getCity();
    cityController.text = manager.getCity();
    stateController.text = manager.getState();
    pincodeController.text = manager.getPincode();
    digiPinController.text = manager.getDigiPin();
    if (houseNoController.text.isNotEmpty) {
      isAddress = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      appBarTitle: 'Address Details',
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                CustomStepper(currentStep: 1),
                SizedBox(height: 15),
                TextFormField(
                  controller: houseNoController,
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.courierPrime(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.house_outlined,
                      color: Colors.purple,
                    ),
                    labelText: 'House/Office No.',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return '* required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: streetController,
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.courierPrime(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.add_road, color: Colors.purple),
                    labelText: 'Street',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return '* required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: landmarkController,
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.courierPrime(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.temple_buddhist,
                      color: Colors.purple,
                    ),
                    labelText: 'Landmark (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: areaController,
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.courierPrime(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.map, color: Colors.purple),
                    labelText: 'Area',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return '* required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: cityController,
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.courierPrime(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_city, color: Colors.purple),
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return '* required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: stateController,
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.courierPrime(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_balance,
                      color: Colors.purple,
                    ),
                    labelText: 'State',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return '* required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: pincodeController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.courierPrime(),
                  maxLength: 6,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.location_on_outlined,
                      color: Colors.purple,
                    ),
                    labelText: 'Pincode',
                    counterText: '',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => validatePincode(pincode: value),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: digiPinController,
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.courierPrime(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.public, color: Colors.purple),
                    labelText: 'Digi-Pin (Optional)',
                    counterText: '',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 2),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: launchDigipinUrl,
                    child: Text(
                      'Know Your Digi-Pin >',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        manager
                            .saveAddress(
                              houseNo: houseNoController.text,
                              street: streetController.text,
                              landmark: landmarkController.text,
                              area: areaController.text,
                              city: cityController.text,
                              state: stateController.text,
                              pincode: pincodeController.text,
                              digiPin: digiPinController.text,
                            )
                            .then((value) {
                              context.push(Routes.userCheckOutScreen);
                            });
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Save Address & Continue'),
                  ),
                ),
                Visibility(
                  visible: isAddress,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New Address?',
                        style: GoogleFonts.courierPrime(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: clear,
                        child: Text(
                          'Clear',
                          style: GoogleFonts.courierPrime(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void clear() {
    houseNoController.clear();
    streetController.clear();
    landmarkController.clear();
    areaController.clear();
    cityController.clear();
    cityController.clear();
    stateController.clear();
    pincodeController.clear();
    digiPinController.clear();
    isAddress = false;
    setState(() {});
  }

  Future<void> launchDigipinUrl() async {
    final url = Uri.parse('https://dac.indiapost.gov.in/mydigipin/home/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
