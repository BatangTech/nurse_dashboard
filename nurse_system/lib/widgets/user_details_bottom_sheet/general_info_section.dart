import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'info_section.dart';
import 'info_row.dart';
import 'risk_level_row.dart';

class GeneralInfoSection extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String userId;
  final bool showRiskLevel;
  const GeneralInfoSection({
    super.key,
    required this.userData,
    required this.userId,
    this.showRiskLevel = true,
  });

  @override
  Widget build(BuildContext context) {
    return InfoSection(
      title: 'ข้อมูลทั่วไป',
      icon: Icons.analytics_outlined,
      children: [
        if (showRiskLevel) RiskLevelRow(userData: userData, userId: userId),
        InfoRow(label: 'สถานะ', value: userData['status'] ?? 'ไม่ระบุ'),
        InfoRow(
          label: 'วันที่ลงทะเบียน',
          value: userData['registrationDate'] != null
              ? DateFormat('dd/MM/yyyy')
                  .format((userData['registrationDate'] as Timestamp).toDate())
              : 'ไม่ระบุ',
        ),
        InfoRow(
          label: 'ครั้งสุดท้ายที่เข้าใช้งาน',
          value: userData['lastActive'] != null
              ? DateFormat('dd/MM/yyyy HH:mm')
                  .format((userData['lastActive'] as Timestamp).toDate())
              : 'ไม่ระบุ',
        ),
      ],
    );
  }
}
