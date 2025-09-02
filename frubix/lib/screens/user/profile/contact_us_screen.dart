import 'package:flutter/material.dart';
import 'package:frubix/custom/user_scaffolds.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      appBarTitle: 'Contact Us',
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get in Touch',
              style: GoogleFonts.rubik(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '📍 Address',
              style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Frubix HQ\nPlot 12, Sector 21\nNavi Mumbai, Maharashtra - 400706\nIndia',
              style: GoogleFonts.courierPrime(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '📞 Phone',
              style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6),
            Text(
              '+91 98765 43210\n+91 91234 56789',
              style: GoogleFonts.courierPrime(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '📧 Email',
              style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'support@frubix.in\ninfo@frubix.in',
              style: GoogleFonts.courierPrime(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '⏰ Working Hours',
              style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Monday - Saturday\n9:00 AM - 6:00 PM IST',
              style: GoogleFonts.courierPrime(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
