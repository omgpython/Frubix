import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frubix/custom/alert.dart';
import 'package:image_picker/image_picker.dart';

Future<String> pickImage({required BuildContext context}) async {
  try {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) {
      Alert(context: context, message: 'No Image Selected', type: 'warning');
      return 'NONE';
    }
    final Uint8List bytes = await pickedFile.readAsBytes();
    final String base64Str = base64Encode(bytes);
    if (base64Str.length > 1048576) {
      Alert(context: context, message: 'Image is too large', type: 'error');
      return 'NONE';
    }
    return base64Str;
  } catch (e) {
    Alert(context: context, message: 'Error: $e', type: 'error');
    return 'NONE';
  }
}
