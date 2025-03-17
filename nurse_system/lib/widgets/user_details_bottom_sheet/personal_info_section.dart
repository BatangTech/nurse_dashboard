import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'info_section.dart';
import 'info_row.dart';

class PersonalInfoSection extends StatelessWidget {
  final Map<String, dynamic> userData;

  const PersonalInfoSection({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return InfoSection(
      title: 'ข้อมูลส่วนตัว',
      icon: Icons.person_outline,
      children: [
        InfoRow(label: 'อีเมล', value: userData['email'] ?? 'ไม่ระบุ'),
        InfoRow(label: 'เบอร์โทรศัพท์', value: userData['phone'] ?? 'ไม่ระบุ'),
        InfoRow(
          label: 'วันเกิด',
          value: userData['birthdate'] != null
              ? DateFormat('dd/MM/yyyy').format(
                  (userData['birthdate'] as Timestamp).toDate())
              : 'ไม่ระบุ',
        ),
        InfoRow(label: 'เพศ', value: userData['gender'] ?? 'ไม่ระบุ'),
      ],
    );
  }
}