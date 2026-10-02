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
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          AppStrings.get(currentLang, 'settings').toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(AppStrings.get(currentLang, 'settings')),
                
                _buildCard(
                  theme: theme,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(LucideIcons.languages, color: theme.primaryColor),
                    ),
                    title: Text(
                      AppStrings.get(currentLang, 'language'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: currentLang,
                          icon: const Icon(LucideIcons.chevronDown, size: 16),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                          items: const [
                            DropdownMenuItem(value: 'en', child: Text('English')),
                            DropdownMenuItem(value: 'hi', child: Text('Hindi')),
                            DropdownMenuItem(value: 'mr', child: Text('Marathi')),
                          ],
                          onChanged: (String? newLang) {
                            if (newLang != null) {
                              ref.read(languageProvider.notifier).setLanguage(newLang);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                _buildSectionHeader(AppStrings.get(currentLang, 'get_in_touch')),
                
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, left: 4.0),
                  child: Text(
                    AppStrings.get(currentLang, 'contact_desc'),
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                
                _buildCard(
                  theme: theme,
                  child: Column(
                    children: [
                      _buildContactTile(
                        context: context,
                        icon: LucideIcons.globe,
                        title: AppStrings.get(currentLang, 'website'),
                        subtitle: 'themediatimes.live',
                        url: 'https://themediatimes.live',
                      ),
                      const Divider(height: 1, indent: 64),
                      _buildContactTile(
                        context: context,
                        icon: LucideIcons.mail,
                        title: AppStrings.get(currentLang, 'email'),
                        subtitle: 'contact@themediatimes.live',
                        url: 'mailto:contact@themediatimes.live',
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                _buildSectionHeader(AppStrings.get(currentLang, 'follow_us')),
                
                _buildCard(
                  theme: theme,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSocialIcon(
                          context,
                          icon: LucideIcons.instagram,
                          url: 'https://www.instagram.com/themediatimes.live?igsi=MW0xYWR5eDZzYzI0Mw==',
                          color: const Color(0xFFE1306C),
                        ),
                        _buildSocialIcon(
                          context,
                          icon: LucideIcons.twitter,
                          url: 'https://x.com/themediatimes_',
                          color: const Color(0xFF1DA1F2),
                        ),
                        _buildSocialIcon(
                          context,
                          icon: LucideIcons.youtube,
                          url: 'https://youtube.com/@themediatimes?si=h4-UkvSA1XE_1gUT',
                          color: const Color(0xFFFF0000),
                        ),
                        _buildSocialIcon(
                          context,
                          icon: LucideIcons.linkedin,
                          url: 'https://www.linkedin.com/company/themediatimes/',
                          color: const Color(0xFF0A66C2),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCard({required ThemeData theme, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: child,
    );
  }

  Widget _buildContactTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String url,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: theme.primaryColor),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
        ),
      ),
      trailing: const Icon(LucideIcons.chevronRight, size: 18, color: Colors.grey),
      onTap: () async {
        final uri = Uri.parse(url);
        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (e) {
          debugPrint('Could not launch $url');
        }
      },
    );
  }

  Widget _buildSocialIcon(
    BuildContext context, {
    required IconData icon,
    required String url,
    required Color color,
  }) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (e) {
          debugPrint('Could not launch $url');
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: color, size: 26),
      ),
    );
  }
}
