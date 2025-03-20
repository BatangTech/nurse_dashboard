import 'package:flutter/material.dart';
import 'package:nurse_system/pages/dashboard_content.dart';
import 'package:nurse_system/pages/table_pages.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State createState() => _DashboardPageState();
}

class _DashboardPageState extends State {
  int _selectedIndex = 0;

  final List _pages = [
    const DashboardContent(),
    const TablePage(),
  ];

  void _handleNavigation(int index) {
    if (index == 2) {
      _handleSignOut();
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleSignOut() {
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 200,
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ADMIN NCDs',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                _buildNavItem(Icons.dashboard, 'Dashboard', 0),
                _buildNavItem(Icons.person_outline, 'table', 1),
                _buildNavItem(Icons.logout, 'Sign Out', 2),
              ],
            ),
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String text, int index) {
    final bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _handleNavigation(index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo[50] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.indigo : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.indigo : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
