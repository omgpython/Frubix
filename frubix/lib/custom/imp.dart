// Future<String> pickImage({required BuildContext context}) async {
//   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//   if (pickedFile != null) {
//     return base64Encode(await pickedFile.readAsBytes());
//   } else {
//     Alert(context: context, message: 'No Image Selected', type: 'warning');
//     return 'NONE';
//   }
// }
