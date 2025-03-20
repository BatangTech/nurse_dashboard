// widgets/dashboard/dashboard_drawer.dart
import 'package:flutter/material.dart';
import 'package:nurse_system/widgets/dashboard/dashboard_sidebar.dart';

class DashboardDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onNavigation;

  const DashboardDrawer({
    Key? key,
    required this.selectedIndex,
    required this.onNavigation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: DashboardSidebar(
        selectedIndex: selectedIndex,
        onNavigation: onNavigation,
      ),
    );
  }
}