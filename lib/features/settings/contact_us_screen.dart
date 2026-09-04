import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get in Touch',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'If you have any questions, feedback, or concerns about our news content, please feel free to reach out to us using the contact information below.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            _buildContactItem(
              icon: LucideIcons.mail,
              title: 'Email',
              subtitle: 'contact@themediatimes.com',
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              icon: LucideIcons.phone,
              title: 'Phone',
              subtitle: '+1 (555) 123-4567',
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              icon: LucideIcons.mapPin,
              title: 'Address',
              subtitle: '123 Media Times Blvd, Suite 100\nNews City, NY 10001\nUnited States',
            ),
            const SizedBox(height: 32),
            const Text(
              'Follow Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildSocialIcon(
                  icon: LucideIcons.instagram,
                  url: 'https://www.instagram.com/themediatimes.live?igsi=MW0xYWR5eDZzYzI0Mw==',
                ),
                const SizedBox(width: 16),
                _buildSocialIcon(
                  icon: LucideIcons.twitter,
                  url: 'https://x.com/themediatimes_',
                ),
                const SizedBox(width: 16),
                _buildSocialIcon(
                  icon: LucideIcons.youtube,
                  url: 'https://youtube.com/@themediatimes?si=h4-UkvSA1XE_1gUT',
                ),
                const SizedBox(width: 16),
                _buildSocialIcon(
                  icon: LucideIcons.linkedin,
                  url: 'https://www.linkedin.com/company/themediatimes/',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: Colors.blue),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon({required IconData icon, required String url}) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.blue, size: 28),
      ),
    );
  }
}
