import 'package:flutter/material.dart';
import 'package:frubix/custom/user_scaffolds.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      appBarTitle: 'About Us',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Frubix!',
              style: GoogleFonts.rubik(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Frubix is your trusted quick commerce partner, bringing fresh groceries, daily essentials, and household items right to your doorstep in minutes.',
              style: GoogleFonts.courierPrime(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            Text(
              '🚀 Our Mission',
              style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'To redefine the way India shops for essentials by offering instant deliveries, unbeatable convenience, and quality products — all powered by technology.',
              style: GoogleFonts.courierPrime(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              '📦 What We Offer',
              style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '• Fresh fruits & vegetables\n'
              '• Dairy & bakery products\n'
              '• Packaged foods\n'
              '• Household & personal care\n'
              '• Instant delivery within 10–20 minutes',
              style: GoogleFonts.courierPrime(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              '🌍 Why Frubix?',
              style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'We’re building a smarter supply chain with hyperlocal warehouses and smart logistics to make everyday shopping effortless for millions across India.',
              style: GoogleFonts.courierPrime(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Text(
              '📫 Contact Us',
              style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Email: support@frubix.in\nPhone: +91 98765 43210\nWebsite: www.frubix.in',
              style: GoogleFonts.courierPrime(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
