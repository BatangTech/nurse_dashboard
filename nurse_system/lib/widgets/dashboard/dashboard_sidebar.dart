import 'package:flutter/material.dart';
import 'package:nurse_system/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nurse_system/widgets/dashboard/nav_item.dart';
import 'package:nurse_system/widgets/dashboard/sidebar_header.dart';

class DashboardSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onNavigation;

  const DashboardSidebar({
    Key? key,
    required this.selectedIndex,
    required this.onNavigation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: _buildSidebarContent(),
    );
  }

  Widget _buildSidebarContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SidebarHeader(),
        _buildWelcomeBox(),
        const SizedBox(height: 10),
        _buildMenuHeader('เมนูหลัก', Icons.apps),
        const SizedBox(height: 8),
        NavItem(
          icon: Icons.dashboard_rounded, 
          text: 'หน้าหลัก', 
          index: 0,
          selectedIndex: selectedIndex,
          onTap: onNavigation,
        ),
        NavItem(
          icon: Icons.person_outline_rounded, 
          text: 'ตารางข้อมูล', 
          index: 1,
          selectedIndex: selectedIndex,
          onTap: onNavigation,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Divider(height: 1, thickness: 1),
        ),
        _buildMenuHeader('การตั้งค่า', Icons.settings_outlined),
        const SizedBox(height: 8),
        NavItem(
          icon: Icons.settings, 
          text: 'ตั้งค่าระบบ', 
          index: -1,
          selectedIndex: selectedIndex,
          onTap: onNavigation,
          disabled: true,
        ),
        NavItem(
          icon: Icons.person, 
          text: 'โปรไฟล์', 
          index: -1,
          selectedIndex: selectedIndex,
          onTap: onNavigation,
          disabled: true,
        ),
        const Spacer(),
        const Divider(height: 1, thickness: 1, color: Color.fromARGB(255, 255, 255, 255)),
        NavItem(
          icon: Icons.logout_rounded, 
          text: 'ออกจากระบบ', 
          index: 2,
          selectedIndex: selectedIndex,
          onTap: onNavigation,
          isWarning: true,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildWelcomeBox() {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.primaryColor,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'ยินดีต้อนรับสู่ระบบบริหารจัดการข้อมูล',
              style: GoogleFonts.prompt(
                fontSize: 12,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primaryColor,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.prompt(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}