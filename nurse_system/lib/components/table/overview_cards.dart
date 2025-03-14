import 'package:flutter/material.dart';
import 'summary_card.dart';

class OverviewCards extends StatelessWidget {
  final int totalUsers;
  final int lowRiskUsers;
  final int highRiskUsers;

  const OverviewCards({
    super.key,
    required this.totalUsers,
    required this.lowRiskUsers,
    required this.highRiskUsers,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            title: "ผู้ใช้ทั้งหมด",
            value: totalUsers.toString(),
            icon: Icons.people_alt_rounded,
            color: const Color(0xFF6C63FF),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryCard(
            title: "Green Zone",
            value: lowRiskUsers.toString(),
            icon: Icons.shield_rounded,
            color: const Color(0xFF4CAF50),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryCard(
            title: "Red Zone",
            value: highRiskUsers.toString(),
            icon: Icons.warning_rounded,
            color: const Color(0xFFFF5252),
          ),
        ),
      ],
    );
  }
}