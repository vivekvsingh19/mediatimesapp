import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black.withOpacity(0.9),
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/icon.png',
                width: 80,
                height: 80,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'The Media Times.Live',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 40),
          ListTile(
            leading: const Icon(LucideIcons.mail, color: Colors.white),
            title: const Text('Contact Us', style: TextStyle(color: Colors.white)),
            onTap: () {
              context.push('/contact-us');
            },
          ),
          Divider(color: Colors.grey[800]),
        ],
      ),
    );
  }
}
