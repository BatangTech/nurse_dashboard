// user_info_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'user_avatar.dart';
import 'user_risk_badge.dart';

class UserInfoCard extends StatelessWidget {
  final String userName;
  final String userEmail;

  const UserInfoCard({
    Key? key,
    required this.userName,
    required this.userEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE53935).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          UserAvatar(userName: userName),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: GoogleFonts.kanit(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1F2251),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  userEmail,
                  style: GoogleFonts.kanit(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 6),
                UserRiskBadge(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}