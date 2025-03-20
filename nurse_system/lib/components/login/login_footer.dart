import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginFooter extends StatelessWidget {
  final Color textColor;

  const LoginFooter({
    super.key,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "© 2025 NCDS. ลิขสิทธิ์ทั้งหมด",
        style: GoogleFonts.prompt(
          fontSize: 14,
          color: textColor.withOpacity(0.5),
        ),
      ),
    );
  }
}