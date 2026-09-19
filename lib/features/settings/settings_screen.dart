import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Toggle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dark Mode',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Switch(
                    value: isDarkMode,
                    onChanged: (_) {
                      ref.read(themeProvider.notifier).toggleTheme();
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Contact Us Section
            const Text(
              'Get in Touch',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'If you have any questions, feedback, or concerns about our news content, please feel free to reach out to us using the contact information below.',
              style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8)),
            ),
            const SizedBox(height: 32),
            _buildContactItem(
              context,
              icon: LucideIcons.globe,
              title: 'Website',
              subtitle: 'https://themediatimes.live',
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              context,
              icon: LucideIcons.mail,
              title: 'Email',
              subtitle: 'contact@themediatimes.live',
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
                  context,
                  icon: LucideIcons.instagram,
                  url: 'https://www.instagram.com/themediatimes.live?igsi=MW0xYWR5eDZzYzI0Mw==',
                ),
                const SizedBox(width: 16),
                _buildSocialIcon(
                  context,
                  icon: LucideIcons.twitter,
                  url: 'https://x.com/themediatimes_',
                ),
                const SizedBox(width: 16),
                _buildSocialIcon(
                  context,
                  icon: LucideIcons.youtube,
                  url: 'https://youtube.com/@themediatimes?si=h4-UkvSA1XE_1gUT',
                ),
                const SizedBox(width: 16),
                _buildSocialIcon(
                  context,
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

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: Theme.of(context).primaryColor),
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
                style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(BuildContext context, {required IconData icon, required String url}) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (e) {
          debugPrint('Could not launch $url');
        }
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Theme.of(context).primaryColor, size: 28),
      ),
    );
  }
}
