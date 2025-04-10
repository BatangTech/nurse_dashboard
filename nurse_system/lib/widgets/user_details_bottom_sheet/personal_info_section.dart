import 'package:flutter/material.dart';
import 'info_section.dart';
import 'info_row.dart';

class PersonalInfoSection extends StatelessWidget {
  final Map userData;

  const PersonalInfoSection({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    String ncdsText = 'ไม่ระบุ';
    if (userData['ncds'] != null &&
        userData['ncds'] is List &&
        (userData['ncds'] as List).isNotEmpty) {
      ncdsText = (userData['ncds'] as List).join(', ');
    }

    return InfoSection(
      title: 'ข้อมูลส่วนตัว',
      icon: Icons.person_outline,
      children: [
        InfoRow(label: 'อีเมล', value: userData['email'] ?? 'ไม่ระบุ'),
        InfoRow(label: 'เบอร์โทรศัพท์', value: userData['phone'] ?? 'ไม่ระบุ'),
        InfoRow(label: 'โรคประจำตัว (NCDs)', value: ncdsText),
        InfoRow(label: 'เพศ', value: userData['gender'] ?? 'ไม่ระบุ'),
      ],
    );
  }
}
