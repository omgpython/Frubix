import 'package:flutter/material.dart';
import 'package:frubix/custom/user_scaffolds.dart';
import 'package:google_fonts/google_fonts.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  final List<Map<String, String>> _faqs = const [
    {
      'q': 'What is Frubix?',
      'a':
          'Frubix is a quick commerce app delivering groceries and daily essentials in minutes.',
    },
    {
      'q': 'Where is Frubix available?',
      'a':
          'Frubix currently serves major Indian cities including Mumbai, Delhi, Bengaluru, and Pune.',
    },
    {
      'q': 'What are your delivery hours?',
      'a':
          'Our deliveries are available between 6 AM and 11 PM, 7 days a week.',
    },
    {
      'q': 'Is there a delivery fee?',
      'a':
          'Delivery is free on orders above ₹299. For smaller orders, a nominal fee may apply.',
    },
    {
      'q': 'What is the average delivery time?',
      'a':
          'Most orders are delivered within 10 to 20 minutes depending on your location.',
    },
    {
      'q': 'Can I schedule a delivery?',
      'a':
          'Currently, scheduled deliveries are not supported. All orders are delivered instantly.',
    },
    {
      'q': 'How do I track my order?',
      'a': 'You can track your order live through the Frubix app.',
    },
    {
      'q': 'What payment methods are accepted?',
      'a':
          'We accept UPI, credit/debit cards, net banking, and popular wallets.',
    },
    {
      'q': 'Can I return products?',
      'a':
          'Returns are accepted only for damaged or expired products reported within 24 hours.',
    },
    {
      'q': 'How do I report a missing item?',
      'a':
          'Use the support section in the app to report any issues with your order.',
    },
    {
      'q': 'Do you support cash on delivery?',
      'a': 'No, we currently only support prepaid online payment methods.',
    },
    {
      'q': 'Can I cancel my order?',
      'a': 'Orders can be cancelled within 2 minutes of placing them.',
    },
    {
      'q': 'Are there discounts or offers?',
      'a': 'Yes! Check the "Offers" section in the app regularly.',
    },
    {
      'q': 'How do I contact customer care?',
      'a': 'You can reach out via the "Contact Us" section in the app.',
    },
    {
      'q': 'What if I get a damaged product?',
      'a':
          'Report it with a photo through the app within 24 hours for a refund or replacement.',
    },
    {
      'q': 'Do you deliver in rural areas?',
      'a': 'Currently, Frubix operates in urban and semi-urban areas only.',
    },
    {
      'q': 'How do I update my address?',
      'a':
          'Go to Profile > Addresses to manage or update your saved locations.',
    },
    {
      'q': 'Can I save favorite items?',
      'a': 'Yes, you can add items to your wishlist for easy access later.',
    },
    {
      'q': 'How do I change my phone number?',
      'a': 'Contact support to request a phone number update.',
    },
    {
      'q': 'Are there late-night deliveries?',
      'a': 'Delivery ends by 11 PM. No late-night service available currently.',
    },
    {
      'q': 'Is there a Frubix subscription?',
      'a':
          'A subscription plan is under development and will be announced soon.',
    },
    {
      'q': 'Can I use Frubix on desktop?',
      'a': 'Currently, Frubix is a mobile-only platform for Android and iOS.',
    },
    {
      'q': 'Do you deliver alcohol or tobacco?',
      'a': 'No, we strictly do not deliver alcohol or tobacco products.',
    },
    {
      'q': 'Can I reorder past purchases?',
      'a': 'Yes, visit "Order History" to quickly reorder previous items.',
    },
    {
      'q': 'Is there a minimum order value?',
      'a':
          'No minimum order value. However, delivery charges apply below ₹299.',
    },
    {
      'q': 'Is my data safe with Frubix?',
      'a': 'Yes, we follow strict data privacy and security standards.',
    },
    {
      'q': 'Do you have a referral program?',
      'a':
          'Yes, invite friends and earn credits. Check "Refer & Earn" in the app.',
    },
    {
      'q': 'How do I delete my account?',
      'a': 'Contact customer care to request account deletion.',
    },
    {
      'q': 'How do I know if an item is in stock?',
      'a': 'Out-of-stock items are marked clearly in the app.',
    },
    {
      'q': 'Are all products fresh?',
      'a': 'We ensure high-quality, fresh products with daily quality checks.',
    },
    {
      'q': 'Can I give delivery instructions?',
      'a': 'Yes, add instructions during checkout under "Delivery Notes".',
    },
    {
      'q': 'Do you deliver during holidays?',
      'a': 'Yes, we operate during most public holidays with limited hours.',
    },
    {
      'q': 'How do I apply a coupon?',
      'a': 'Apply coupons during checkout under "Apply Promo Code".',
    },
    {
      'q': 'Do you offer B2B or bulk orders?',
      'a': 'Currently not, but we’re exploring B2B solutions.',
    },
    {
      'q': 'How can I join the Frubix delivery team?',
      'a': 'Visit the Careers section or contact us to apply.',
    },
    {
      'q': 'What is your return policy?',
      'a': 'We accept returns for eligible issues reported within 24 hours.',
    },
    {
      'q': 'Do you provide GST invoices?',
      'a': 'Yes, you can download GST invoices from the order details page.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      appBarTitle: 'FAQs',
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _faqs.length,
        itemBuilder: (context, index) {
          final faq = _faqs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.zero,
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ), // No internal divider
                child: ExpansionTile(
                  childrenPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  title: Text(
                    faq['q']!,
                    style: GoogleFonts.rubik(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    Text(
                      faq['a']!,
                      style: GoogleFonts.courierPrime(
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
