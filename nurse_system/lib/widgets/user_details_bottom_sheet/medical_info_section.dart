import 'package:flutter/material.dart';

import 'info_section.dart';
import 'info_row.dart';

class MedicalInfoSection extends StatelessWidget {
  final Map<String, dynamic> userData;

  const MedicalInfoSection({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return InfoSection(
      title: 'ข้อมูลเพิ่มเติม',
      icon: Icons.medical_information_outlined,
      children: [
        InfoRow(
          label: 'โรคประจำตัว',
          value: userData['medicalConditions'] ?? 'ไม่มี',
        ),
        InfoRow(
          label: 'ยาที่ใช้ประจำ',
          value: userData['medications'] ?? 'ไม่มี',
        ),
        InfoRow(
          label: 'แพทย์ผู้ดูแล',
          value: userData['physician'] ?? 'ไม่ระบุ',
        ),
        InfoRow(
          label: 'ผู้ติดต่อฉุกเฉิน',
          value: userData['emergencyContact'] ?? 'ไม่ระบุ',
        ),
      ],
    );
  }
}