// reminder_notification_checkbox.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReminderNotificationCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;

  const ReminderNotificationCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        'ส่งการแจ้งเตือนล่วงหน้า',
        style: GoogleFonts.kanit(
          fontSize: 14,
          color: const Color(0xFF1F2251),
        ),
      ),
      subtitle: Text(
        'ส่งการแจ้งเตือนให้ผู้ใช้ล่วงหน้า 1 วัน และ 1 ชั่วโมงก่อนการสัมภาษณ์',
        style: GoogleFonts.kanit(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      checkColor: Colors.white,
      activeColor: const Color(0xFFE53935),
    );
  }
}
