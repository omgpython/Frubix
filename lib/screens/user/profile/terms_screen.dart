import 'package:flutter/material.dart';
import 'package:frubix/custom/user_scaffolds.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      appBarTitle: 'Terms & Conditions',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildTermsSections(),
        ),
      ),
    );
  }

  List<Widget> _buildTermsSections() {
    final List<Map<String, String>> sections = [
      {
        'title': '1. Introduction',
        'content':
            'Welcome to Frubix! These Terms and Conditions govern your use of our mobile application and services. By accessing or using Frubix, you agree to be bound by these terms. If you disagree, please do not use our services.',
      },
      {
        'title': '2. Eligibility',
        'content':
            'You must be at least 18 years old and legally capable of entering into contracts to use Frubix. By using our app, you confirm that you meet these criteria.',
      },
      {
        'title': '3. Account Registration',
        'content':
            'To place orders and access personalized features, you must create an account. You agree to provide accurate and complete information during registration and keep your credentials confidential.',
      },
      {
        'title': '4. Ordering Products',
        'content':
            'All orders placed through Frubix are subject to acceptance and availability. We reserve the right to refuse or cancel orders at any time for reasons including product unavailability or errors in pricing.',
      },
      {
        'title': '5. Pricing and Payment',
        'content':
            'Prices listed on the app are subject to change without notice. Payment methods accepted include UPI, credit/debit cards, and digital wallets. Transactions are secured through third-party payment gateways.',
      },
      {
        'title': '6. Delivery',
        'content':
            'We strive to deliver your orders promptly within the estimated timeframe. Delivery times may vary due to unforeseen circumstances such as traffic or weather. You agree to provide accurate delivery details.',
      },
      {
        'title': '7. Refunds and Cancellations',
        'content':
            'Refund policies vary depending on the product and reason for return. You must notify customer support within 48 hours of receiving an order for any issues. Cancellations are subject to terms specified during the order process.',
      },
      {
        'title': '8. User Conduct',
        'content':
            'You agree not to misuse the app or services, including but not limited to posting offensive content, spamming, or attempting unauthorized access. Violations may lead to suspension or termination of your account.',
      },
      {
        'title': '9. Intellectual Property',
        'content':
            'All content, trademarks, logos, and software on Frubix are the property of Frubix or its licensors. You may not reproduce, distribute, or create derivative works without prior permission.',
      },
      {
        'title': '10. Privacy',
        'content':
            'Your privacy is important to us. Please refer to our Privacy Policy for information on how we collect, use, and protect your personal data.',
      },
      {
        'title': '11. Limitation of Liability',
        'content':
            'Frubix is not liable for any damages arising from the use or inability to use the app, including but not limited to loss of profits, data, or goodwill.',
      },
      {
        'title': '12. Indemnification',
        'content':
            'You agree to indemnify and hold harmless Frubix, its affiliates, and employees from any claims, damages, or expenses arising out of your violation of these Terms.',
      },
      {
        'title': '13. Modifications to Terms',
        'content':
            'We may update these Terms at any time. Continued use of the app after changes indicates your acceptance of the new terms. We recommend reviewing the Terms periodically.',
      },
      {
        'title': '14. Governing Law',
        'content':
            'These Terms are governed by the laws of India. Any disputes shall be resolved in the courts located in Mumbai, Maharashtra.',
      },
      {
        'title': '15. Contact Information',
        'content':
            'For any questions or concerns about these Terms, please contact us:\n\n📧 Email: support@frubix.in\n📞 Phone: +91 98765 43210\n🏢 Address: Frubix HQ, Mumbai, Maharashtra, India',
      },
      {
        'title': '16. Entire Agreement',
        'content':
            'These Terms constitute the entire agreement between you and Frubix regarding the use of the app and supersede any prior agreements.',
      },
      {
        'title': '17. Severability',
        'content':
            'If any provision of these Terms is found invalid or unenforceable, the remaining provisions shall continue in full force and effect.',
      },
      {
        'title': '18. Waiver',
        'content':
            'Failure to enforce any right or provision in these Terms shall not constitute a waiver of such right or provision.',
      },
      {
        'title': '19. Force Majeure',
        'content':
            'Frubix shall not be liable for failure or delay in performance due to causes beyond our reasonable control, including natural disasters, strikes, or internet outages.',
      },
      {
        'title': '20. User Feedback',
        'content':
            'Any feedback or suggestions you provide may be used by Frubix without obligation or compensation.',
      },
      {
        'title': '21. Termination',
        'content':
            'We may terminate or suspend your access to the app at any time without prior notice for violations of these Terms or for business reasons.',
      },
    ];

    return sections.map((section) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section['title']!,
              style: GoogleFonts.rubik(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              section['content']!,
              style: GoogleFonts.courierPrime(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
