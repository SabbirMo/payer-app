// lib/screens/donation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  static const String paypalEmail = 'kerryongg79@gmail.com';
  static const String paypalLink = 'https://www.paypal.com/paypalme/kerryongg79';
  static const String stripeLink = 'https://buy.stripe.com/donate';
  static const String payNowId = 'PAYNOW88';

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: $text', style: GoogleFonts.cinzel(color: Colors.black)),
        backgroundColor: const Color(0xFFD4A017),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(title: const Text('Support Us')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2A1F00), Color(0xFF0F0F20)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD4A017).withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  const Text('🙏', style: TextStyle(fontSize: 50)),
                  const SizedBox(height: 12),
                  Text('Support God\'s Work', style: GoogleFonts.cinzel(color: const Color(0xFFD4A017), fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Text(
                    '"Each of you should give what you have decided in your heart to give, not reluctantly or under compulsion, for God loves a cheerful giver."\n— 2 Corinthians 9:7',
                    style: GoogleFonts.cormorantGaramond(color: Colors.white70, fontSize: 15, fontStyle: FontStyle.italic, height: 1.6),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text('CHOOSE YOUR PAYMENT METHOD', style: GoogleFonts.cinzel(color: const Color(0xFFD4A017), fontSize: 11, letterSpacing: 2.5)),
            const SizedBox(height: 16),

            // PayPal Card
            _buildPaymentCard(
              context,
              emoji: '💙',
              title: 'PayPal',
              subtitle: 'Debit card, credit card, PayPal balance',
              color: const Color(0xFF003087),
              accentColor: const Color(0xFF009CDE),
              details: [
                _buildDetailRow(Icons.email_rounded, 'Email', paypalEmail, () => _copyToClipboard(context, paypalEmail)),
                _buildDetailRow(Icons.link_rounded, 'Link', 'paypal.me/kerryongg79', () => _launchURL(paypalLink)),
              ],
              onTap: () => _launchURL(paypalLink),
              buttonText: 'Donate via PayPal',
            ),
            const SizedBox(height: 14),

            // Stripe Card
            _buildPaymentCard(
              context,
              emoji: '💳',
              title: 'Stripe',
              subtitle: 'All major credit cards worldwide',
              color: const Color(0xFF635BFF),
              accentColor: const Color(0xFF7B73FF),
              details: [
                _buildDetailRow(Icons.credit_card_rounded, 'Accepts', 'Visa, Mastercard, Amex', null),
              ],
              onTap: () => _launchURL(stripeLink),
              buttonText: 'Donate via Credit Card',
            ),
            const SizedBox(height: 14),

            // PayNow Card
            _buildPaymentCard(
              context,
              emoji: '📱',
              title: 'PayNow',
              subtitle: 'Singapore & Malaysia instant transfer',
              color: const Color(0xFF1A5C2A),
              accentColor: const Color(0xFF2E7D32),
              details: [
                _buildDetailRow(Icons.tag_rounded, 'PayNow ID', payNowId, () => _copyToClipboard(context, payNowId)),
              ],
              onTap: () => _copyToClipboard(context, payNowId),
              buttonText: 'Copy PayNow ID',
            ),
            const SizedBox(height: 24),

            // Thank you message
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F0F20),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  const Text('💝', style: TextStyle(fontSize: 32)),
                  const SizedBox(height: 10),
                  Text('Every Gift Makes A Difference', style: GoogleFonts.cinzel(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(
                    'Your donation helps us:\n✝️ Maintain & update the app\n🌍 Reach more people worldwide\n👶 Create more content for families\n🙏 Keep the app FREE for everyone',
                    style: GoogleFonts.cormorantGaramond(color: Colors.white60, fontSize: 15, height: 1.7),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text('God bless you richly! 🙏', style: GoogleFonts.cinzel(color: const Color(0xFFD4A017), fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard(
    BuildContext context, {
    required String emoji,
    required String title,
    required String subtitle,
    required Color color,
    required Color accentColor,
    required List<Widget> details,
    required VoidCallback onTap,
    required String buttonText,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.2), const Color(0xFF0F0F20)]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.cinzel(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                    Text(subtitle, style: GoogleFonts.cormorantGaramond(color: Colors.white54, fontSize: 13, fontStyle: FontStyle.italic)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...details,
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(buttonText, style: GoogleFonts.cinzel(fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, VoidCallback? onCopy) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFD4A017), size: 16),
          const SizedBox(width: 8),
          Text('$label: ', style: GoogleFonts.cinzel(color: Colors.white54, fontSize: 11)),
          Expanded(child: Text(value, style: GoogleFonts.cinzel(color: Colors.white, fontSize: 11), overflow: TextOverflow.ellipsis)),
          if (onCopy != null)
            GestureDetector(
              onTap: onCopy,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFD4A017).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Text('Copy', style: GoogleFonts.cinzel(color: const Color(0xFFD4A017), fontSize: 10)),
              ),
            ),
        ],
      ),
    );
  }
}
