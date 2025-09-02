import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:frubix/generated/collections.dart';
import 'package:shared_preferences/shared_preferences.dart';

//ADMIN
final String SP_ADMIN_ID = 'admin_id';
final String SP_ADMIN_ROLE = 'admin_role';
final String SP_ADMIN_IS_LOGIN = 'admin_is_login';

//User
final String SP_USER_ID = 'user_id';
final String SP_USER_CONTACT = 'user_contact';
final String SP_USER_NAME = 'user_name';
final String SP_USER_IS_LOGIN = 'user_is_login';

//Address
final String SP_HOUSE_NO = 'house_no';
final String SP_STREET = 'street';
final String SP_LANDMARK = 'landmark';
final String SP_AREA = 'area';
final String SP_CITY = 'city';
final String SP_STATE = 'state';
final String SP_PINCODE = 'pincode';
final String SP_DIGI_PIN = 'digipin';

class PrefManager {
  static final _instance = PrefManager._internal();
  SharedPreferences? preferences;

  PrefManager._internal() {
    init();
  }
  factory PrefManager() {
    return _instance;
  }

  Future<void> init() async {
    preferences ??= await SharedPreferences.getInstance();
  }

  Future<void> saveAdmin({
    required String adminId,
    required String adminRole,
  }) async {
    await preferences!.setBool(SP_ADMIN_IS_LOGIN, true);
    await preferences!.setString(SP_ADMIN_ID, adminId);
    await preferences!.setString(SP_ADMIN_ROLE, adminRole);
  }

  Future<void> logoutAdmin() async {
    await preferences!.setBool(SP_ADMIN_IS_LOGIN, false);
    await preferences!.remove(SP_ADMIN_ID);
    await preferences!.remove(SP_ADMIN_ROLE);
  }

  String getAdminId() {
    return preferences!.getString(SP_ADMIN_ID) ?? '';
  }

  String getAdminRole() {
    return preferences!.getString(SP_ADMIN_ROLE) ?? '';
  }

  bool getAdminLoginStatus() {
    return preferences!.getBool(SP_ADMIN_IS_LOGIN) ?? false;
  }

  Future<void> saveUser({
    required String userId,
    required String contact,
    required String name,
  }) async {
    await preferences!.setBool(SP_USER_IS_LOGIN, true);
    await preferences!.setString(SP_USER_ID, userId);
    await preferences!.setString(SP_USER_NAME, name);
    await preferences!.setString(SP_USER_CONTACT, contact);
  }

  Future<void> logoutUser() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      final query =
          await FirebaseFirestore.instance
              .collection(FCM_COLLECTION)
              .where(FCM_TOKEN, isEqualTo: token)
              .limit(1)
              .get();

      for (final doc in query.docs) {
        await doc.reference.delete();
      }
    }
    await preferences!.setBool(SP_USER_IS_LOGIN, false);
    await preferences!.remove(SP_USER_ID);
    await preferences!.remove(SP_USER_CONTACT);
  }

  String getUserId() {
    return preferences!.getString(SP_USER_ID) ?? '';
  }

  String getUserContact() {
    return preferences!.getString(SP_USER_CONTACT) ?? '';
  }

  String getUserName() {
    return preferences!.getString(SP_USER_NAME) ?? '';
  }

  bool getUserLoginStatus() {
    return preferences!.getBool(SP_USER_IS_LOGIN) ?? false;
  }

  Future<void> saveAddress({
    required String houseNo,
    required String street,
    required String landmark,
    required String area,
    required String city,
    required String state,
    required String pincode,
    required String digiPin,
  }) async {
    try {
      await preferences!.setString(SP_HOUSE_NO, houseNo);
      await preferences!.setString(SP_STREET, street);
      await preferences!.setString(SP_LANDMARK, landmark);
      await preferences!.setString(SP_AREA, area);
      await preferences!.setString(SP_CITY, city);
      await preferences!.setString(SP_STATE, state);
      await preferences!.setString(SP_PINCODE, pincode);
      await preferences!.setString(SP_DIGI_PIN, digiPin);
    } catch (e) {
      log(e.toString(), name: 'ADDRESS SAVE ERROR');
    }
  }

  String getAddress() {
    if (getLandmark().trim().isEmpty) {
      return '${getHouseNo()}, ${getStreet()}, ${getArea()}, ${getCity()}, ${getState()} - ${getPincode()}';
    } else {
      return '${getHouseNo()}, ${getStreet()}, ${getLandmark()}, ${getArea()}, ${getCity()}, ${getState()} - ${getPincode()}';
    }
  }

  String getHouseNo() {
    return preferences!.getString(SP_HOUSE_NO) ?? '';
  }

  String getStreet() {
    return preferences!.getString(SP_STREET) ?? '';
  }

  String getLandmark() {
    return preferences!.getString(SP_LANDMARK) ?? '';
  }

  String getArea() {
    return preferences!.getString(SP_AREA) ?? '';
  }

  String getCity() {
    return preferences!.getString(SP_CITY) ?? '';
  }

  String getState() {
    return preferences!.getString(SP_STATE) ?? '';
  }

  String getPincode() {
    return preferences!.getString(SP_PINCODE) ?? '';
  }

  String getDigiPin() {
    return preferences!.getString(SP_DIGI_PIN) ?? '';
  }
}
