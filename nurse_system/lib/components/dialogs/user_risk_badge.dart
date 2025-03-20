// user_risk_badge.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserRiskBadge extends StatelessWidget {
  const UserRiskBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'ความเสี่ยงสูง (แดง)',
        style: GoogleFonts.kanit(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFE53935),
        ),
      ),
    );
  }
}