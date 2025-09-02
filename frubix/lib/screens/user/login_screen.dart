import 'package:flutter/material.dart';
import 'package:frubix/controller/user.dart';
import 'package:frubix/generated/notification_service.dart';
import 'package:frubix/generated/routes.dart';
import 'package:frubix/generated/validation.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true, loading = false;
  String _email = '', _password = '';

  final _key = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    requestNotificationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: SingleChildScrollView(
                  child: Form(
                    key: _key,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Hello, Welcome To',
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
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
                        SizedBox(height: 20),
                        TextFormField(
                          key: _emailKey,
                          keyboardType: TextInputType.visiblePassword,
                          style: GoogleFonts.courierPrime(),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Colors.purple,
                            ),
                            labelText: 'E-Mail Address',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (email) {
                            _emailKey.currentState!.validate();
                          },
                          validator: (email) {
                            return validateEmail(email: email);
                          },
                          onSaved: (email) {
                            _email = email!;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          key: _passwordKey,
                          obscureText: _obscureText,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.courierPrime(),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Colors.purple,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.purple,
                              ),
                            ),
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (password) {
                            _passwordKey.currentState!.validate();
                          },
                          validator: (password) {
                            return validatePassword(password: password);
                          },
                          onSaved: (password) {
                            _password = password!;
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text('Forgot Password?'),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          height: 40,
                          child:
                              loading
                                  ? Center(child: CircularProgressIndicator())
                                  : FilledButton(
                                    style: FilledButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Colors.deepPurple,
                                    ),
                                    onPressed: () {
                                      if (_key.currentState!.validate()) {
                                        _key.currentState!.save();
                                        setState(() {
                                          loading = true;
                                        });
                                        User.userLogin(
                                          context: context,
                                          email: _email,
                                          password: _password,
                                        ).then((value) {
                                          setState(() {
                                            loading = false;
                                          });
                                        });
                                      }
                                    },
                                    child: Text('Login'.toUpperCase()),
                                  ),
                        ),
                        // SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                context.push(Routes.userRegisterScreen);
                              },
                              child: Text('Create Account'),
                            ),
                          ],
                        ),
                      ],
                    ),
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
