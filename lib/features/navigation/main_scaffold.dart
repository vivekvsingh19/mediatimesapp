import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lucide_icons/lucide_icons.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.95),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _calculateSelectedIndex(context),
          onTap: (int idx) => _onItemTapped(idx, context),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.bookmark), label: 'Bookmarks'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.mail), label: 'Contact Us'),
          ],
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/bookmarks')) {
      return 1;
    }
    if (location.startsWith('/contact-us')) {
      return 2;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/bookmarks');
        break;
      case 2:
        context.go('/contact-us');
        break;
    }
  }
}
