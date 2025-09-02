import 'package:flutter/material.dart';
import 'package:frubix/controller/user.dart';
import 'package:frubix/generated/validation.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscureText = true, loading = false;
  String _name = '', _email = '', _contact = '', _password = '';

  final _key = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormFieldState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _contactKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
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
                          'Start Your Journey with',
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          'Frubix'.toUpperCase(),
                          style: GoogleFonts.rubik(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                            letterSpacing: 5,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          key: _nameKey,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.courierPrime(),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.purple,
                            ),
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (name) {
                            _nameKey.currentState!.validate();
                          },
                          validator: (name) {
                            return validateName(name: name);
                          },
                          onSaved: (name) {
                            _name = name!;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          key: _emailKey,
                          keyboardType: TextInputType.emailAddress,
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
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          key: _contactKey,
                          style: GoogleFonts.courierPrime(),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              color: Colors.purple,
                            ),
                            labelText: 'Contact',
                            counterText: '',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (contact) {
                            _contactKey.currentState!.validate();
                          },
                          validator: (contact) {
                            return validateContact(contact: contact);
                          },
                          onSaved: (contact) {
                            _contact = contact!;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          obscureText: _obscureText,
                          key: _passwordKey,
                          keyboardType: TextInputType.visiblePassword,
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
                                        User.addUser(
                                          context: context,
                                          name: _name,
                                          email: _email,
                                          contact: _contact,
                                          password: _password,
                                        ).then((value) {
                                          setState(() {
                                            loading = false;
                                          });
                                        });
                                      }
                                    },
                                    child: Text('Register'.toUpperCase()),
                                  ),
                        ),
                        // SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?"),
                            TextButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: Text('Login Now'),
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
