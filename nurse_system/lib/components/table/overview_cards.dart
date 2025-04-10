import 'package:flutter/material.dart';
import 'summary_card.dart';

class OverviewCards extends StatelessWidget {
  final int totalUsers;
  final int lowRiskUsers;
  final int highRiskUsers;
  final String selectedType;
  final Function(String) onTypeSelected;

  const OverviewCards({
    super.key,
    required this.totalUsers,
    required this.lowRiskUsers,
    required this.highRiskUsers,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // หัวข้อสำหรับส่วนภาพรวม
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(
                Icons.dashboard_rounded,
                size: 20,
                color: Colors.grey[700],
              ),
              const SizedBox(width: 6),
              Text(
                "ภาพรวมผู้ใช้งาน",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
        
        // Cards row
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onTypeSelected('total'),
                child: SummaryCard(
                  title: "ผู้ใช้ทั้งหมด",
                  value: totalUsers.toString(),
                  icon: Icons.people_alt_rounded,
                  color: const Color(0xFF6C63FF),
                  isSelected: selectedType == 'total',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => onTypeSelected('low'),
                child: SummaryCard(
                  title: "Green Zone",
                  value: lowRiskUsers.toString(),
                  icon: Icons.shield_rounded,
                  color: const Color(0xFF4CAF50),
                  isSelected: selectedType == 'low',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => onTypeSelected('high'),
                child: SummaryCard(
                  title: "Red Zone",
                  value: highRiskUsers.toString(),
                  icon: Icons.warning_rounded,
                  color: const Color(0xFFFF5252),
                  isSelected: selectedType == 'high',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}