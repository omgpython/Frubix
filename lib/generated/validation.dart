String? validateEmail({required String? email}) {
  final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  if (email!.trim().isEmpty) {
    return '* required';
  } else if (!regex.hasMatch(email)) {
    return '* invalid email';
  } else {
    return null;
  }
}

String? validatePassword({required String? password}) {
  final regex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^a-zA-Z0-9]).{8,}$',
  );
  if (password!.trim().isEmpty) {
    return '* required';
  } else if (!regex.hasMatch(password)) {
    return '* invalid password';
  } else {
    return null;
  }
}

String? validateName({required String? name}) {
  final regex = RegExp(r'^[A-Za-z ]+$');
  if (name!.trim().isEmpty) {
    return '* required';
  } else if (!regex.hasMatch(name)) {
    return '* alphabets only';
  } else {
    return null;
  }
}

String? validateContact({required String? contact}) {
  final regex = RegExp(r'^[0-9]{10}$');
  if (contact!.trim().isEmpty) {
    return '* required';
  } else if (!regex.hasMatch(contact)) {
    return '* invalid';
  } else {
    return null;
  }
}

String? validatePrice({required String? price}) {
  final regex = RegExp(r'^[0-9]+$');
  if (price!.trim().isEmpty) {
    return '* required';
  } else if (int.parse(price) == 0 || !regex.hasMatch(price)) {
    return '* invalid price';
  } else {
    return null;
  }
}

String? validatePincode({required String? pincode}) {
  final regex = RegExp(r'^\d{6}$');
  if (pincode!.trim().isEmpty) {
    return '* required';
  } else if (!regex.hasMatch(pincode)) {
    return '* invalid pincode';
  } else {
    return null;
  }
}
