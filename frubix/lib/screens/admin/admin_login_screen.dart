import 'package:flutter/material.dart';
import 'package:frubix/controller/admin.dart';
import 'package:frubix/generated/pref_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../generated/validation.dart';

class AdminLoginScreen extends StatefulWidget {
  AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();
  PrefManager manager = PrefManager();

  String _email = "", _password = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    manager.logoutAdmin();
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.deepPurpleAccent, Colors.purple],
            ),
          ),
          child: Center(
            child: Container(
              height: 450,
              width: 450,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hello, Welcome To',
                        style: GoogleFonts.rubik(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Frubix'.toUpperCase(),
                        style: GoogleFonts.rubik(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                          letterSpacing: 5,
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
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
                        onSaved: (email) {
                          _email = email!;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        obscureText: _obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        style: GoogleFonts.courierPrime(),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.grey),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.purpleAccent,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.purpleAccent,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        validator: (password) {
                          return validatePassword(password: password);
                        },
                        onSaved: (password) {
                          _password = password!;
                        },
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        height: 40,
                        child:
                            isLoading
                                ? Center(child: CircularProgressIndicator())
                                : FilledButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      setState(() {
                                        isLoading = true;
                                      });
                                      Admin.adminLogin(
                                        context: context,
                                        email: _email.trim(),
                                        password: _password.trim(),
                                      );
                                    }
                                  },
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Colors.deepPurple,
                                  ),
                                  child: Text('Login'),
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
