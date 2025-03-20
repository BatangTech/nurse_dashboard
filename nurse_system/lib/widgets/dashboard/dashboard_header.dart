// widgets/dashboard/dashboard_header.dart
import 'package:flutter/material.dart';
import 'package:nurse_system/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardHeader extends StatelessWidget {
  final int selectedIndex;
  final String currentDate;

  const DashboardHeader({
    Key? key,
    required this.selectedIndex,
    required this.currentDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Row(
            children: [
              Icon(
                selectedIndex == 0 ? Icons.dashboard_rounded : Icons.person_outline_rounded,
                size: 18,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                selectedIndex == 0 ? 'หน้าหลัก' : 'ตารางข้อมูล',
                style: GoogleFonts.prompt(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          // แสดงวันที่ปัจจุบัน
          _buildDateDisplay(),
          const SizedBox(width: 12),
          // แสดงข้อมูลผู้ใช้
          _buildUserInfo(),
        ],
      ),
    );
  }

  Widget _buildDateDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today,
            size: 14,
            color: AppColors.primaryColor,
          ),
          const SizedBox(width: 6),
          Text(
            currentDate,
            style: GoogleFonts.prompt(
              fontSize: 12,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accentColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.accentColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                size: 16,
                color: AppColors.accentColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'ผู้ดูแลระบบ',
            style: GoogleFonts.prompt(
              fontSize: 13,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: AppColors.accentColor,
          ),
        ],
      ),
    );
  }
}