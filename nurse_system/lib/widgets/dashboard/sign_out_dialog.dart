import 'package:flutter/material.dart';
import 'package:nurse_system/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class SignOutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const SignOutDialog({
    Key? key,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'ยืนยันการออกจากระบบ',
        style: GoogleFonts.prompt(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'คุณต้องการออกจากระบบใช่หรือไม่?',
        style: GoogleFonts.prompt(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'ยกเลิก',
            style: GoogleFonts.prompt(
              color: Colors.black,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.redZoneColor,
          ),
          child: Text(
            'ยืนยัน',
            style: GoogleFonts.prompt(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}