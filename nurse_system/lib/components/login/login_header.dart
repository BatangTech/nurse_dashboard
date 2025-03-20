import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nurse_system/constants/styles.dart';


class LoginHeader extends StatelessWidget {
  final Color textColor;

  const LoginHeader({
    super.key,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppStyles.primaryColor.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Image.asset(
                'assets/images/robot.png',
                height: 70,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "ระบบผู้ดูแล NCDS",
            style: GoogleFonts.prompt(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: textColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "กรุณาลงชื่อเข้าใช้เพื่อดำเนินการต่อ",
            style: GoogleFonts.prompt(
              fontSize: 16,
              color: textColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}