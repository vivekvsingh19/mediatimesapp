import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/language_provider.dart';
import '../../core/constants/app_strings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(languageProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(AppStrings.get(currentLang, 'settings').toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.get(currentLang, 'language'),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: currentLang,
                  isExpanded: true,
                  icon: const Icon(LucideIcons.chevronDown),
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English', style: TextStyle(fontSize: 16))),
                    DropdownMenuItem(value: 'hi', child: Text('Hindi (हिंदी)', style: TextStyle(fontSize: 16))),
                    DropdownMenuItem(value: 'mr', child: Text('Marathi (मराठी)', style: TextStyle(fontSize: 16))),
                  ],
                  onChanged: (String? newLang) {
                    if (newLang != null) {
                      ref.read(languageProvider.notifier).setLanguage(newLang);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              AppStrings.get(currentLang, 'get_in_touch'),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.get(currentLang, 'contact_desc'),
              style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.8)),
            ),
            const SizedBox(height: 32),
            _buildContactItem(
              context,
              icon: LucideIcons.globe,
              title: AppStrings.get(currentLang, 'website'),
              subtitle: 'https://themediatimes.live',
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              context,
              icon: LucideIcons.mail,
              title: AppStrings.get(currentLang, 'email'),
              subtitle: 'contact@themediatimes.live',
            ),
            const SizedBox(height: 32),
            Text(
              AppStrings.get(currentLang, 'follow_us'),
              style: const TextStyle(
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
