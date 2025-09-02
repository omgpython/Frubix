import 'package:flutter/material.dart';
import 'package:frubix/custom/user_scaffolds.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      appBarTitle: 'Privacy Policy',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last Updated Text
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Last Updated: September 2, 2025',
                style: GoogleFonts.rubik(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
            // Privacy Policy Sections
            ..._buildPolicySections(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPolicySections() {
    final List<Map<String, String>> sections = [
      {
        'title': '1. Introduction',
        'content':
            'Welcome to Frubix! Your privacy is critically important to us. This Privacy Policy explains how Frubix ("we", "our", or "us") collects, uses, and shares your personal data when you use our mobile application and related services. By using Frubix, you agree to the practices outlined below.',
      },
      {
        'title': '2. Information We Collect',
        'content': '''
• Full name, email address, phone number\n
• Delivery address and pin code\n
• Payment information (e.g., UPI ID, card details — processed securely)\n
• Location data (to show nearby products and delivery tracking)\n
• Device information (model, OS, IP address)\n
• App usage data (products viewed, time spent, etc.)''',
      },
      {
        'title': '3. How We Use Your Data',
        'content': '''
• To process your orders and deliver them on time\n
• To send you real-time order status and notifications\n
• To improve our product offerings and app experience\n
• For customer support and query resolution\n
• For fraud detection and legal compliance''',
      },
      {
        'title': '4. Sharing Your Information',
        'content': '''
We may share your data with:\n
• Delivery partners for fulfilling your orders\n
• Payment gateways for processing transactions\n
• Third-party service providers (e.g., SMS, analytics)\n
We never sell your data to third parties.''',
      },
      {
        'title': '5. Legal Compliance',
        'content':
            'We may disclose your data if required under Indian law or in response to valid legal requests by public authorities (e.g., a court or government agency).',
      },
      {
        'title': '6. Cookies and Tracking Technologies',
        'content':
            'Frubix may use cookies, local storage, and analytics tools to enhance your experience and monitor app performance. These are standard industry practices.',
      },
      {
        'title': '7. Data Retention',
        'content':
            'We retain your personal data only as long as necessary to fulfill the purposes outlined in this policy or as required by law. You may request deletion of your account at any time.',
      },
      {
        'title': '8. Security Measures',
        'content':
            'We take data security seriously and implement industry-standard encryption and access controls to protect your personal information. Despite our efforts, no method of data transmission is 100% secure.',
      },
      {
        'title': '9. Your Rights',
        'content': '''
As an Indian user, you have the right to:\n
• Access the data we hold about you\n
• Correct incorrect or outdated information\n
• Request deletion of your data\n
• Opt-out of marketing communications''',
      },
      {
        'title': '10. Children’s Privacy',
        'content':
            'Our services are not directed to children under 13 years of age. We do not knowingly collect data from minors. If you believe we have data on a child, contact us immediately.',
      },
      {
        'title': '11. Changes to This Policy',
        'content':
            'We may update this Privacy Policy periodically to reflect changes in our practices or legal obligations. You will be notified via app update or in-app notification.',
      },
      {
        'title': '12. Data Storage Location',
        'content':
            'Your data may be stored on secure cloud servers located within India or in jurisdictions compliant with Indian data protection laws.',
      },
      {
        'title': '13. Third-Party Links',
        'content':
            'Our app may contain links to external websites or apps (e.g., payment gateways). We are not responsible for their privacy policies or practices.',
      },
      {
        'title': '14. Consent',
        'content':
            'By using Frubix, you consent to the collection and use of your personal information as described in this policy.',
      },
      {
        'title': '15. Contact Us',
        'content': '''
If you have any questions about this policy or your data:\n
📧 Email: support@frubix.in\n
📞 Phone: +91 98765 43210\n
🏢 Address: Frubix HQ, Mumbai, Maharashtra, India''',
      },
      {
        'title': '16. Grievance Redressal',
        'content': '''
As per the Information Technology Act, 2000 and its rules, the name and contact details of the Grievance Officer are:\n
Name: Rahul Verma\n
Email: grievance@frubix.in\n
Phone: +91 90123 45678''',
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
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
