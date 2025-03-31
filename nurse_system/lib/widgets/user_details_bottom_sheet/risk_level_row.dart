import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../pages/risk_level_page.dart';

class RiskLevelRow extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String userId;

  const RiskLevelRow({
    super.key,
    required this.userData,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            'คะแนนความเสี่ยง',
            style: GoogleFonts.kanit(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            children: [
              Text(
                userData['risk_level']?.toString() ?? 'ไม่ระบุ',
                style: GoogleFonts.kanit(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => RiskLevelPage(userId: userId),
                    barrierDismissible: true,
                  );
                },
                child: Text(
                  'ดูรายละเอียด',
                  style: GoogleFonts.kanit(
                    fontSize: 12,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}